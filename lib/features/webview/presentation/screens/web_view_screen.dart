import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_checker.dart';
import '../../controllers/web_view_manager.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';

/// Primary screen hosting the AniSongList WebView.
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    this.networkChecker,
  });

  final NetworkChecker? networkChecker;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen>
    implements WebViewCallbacks {
  late final WebViewManager _webViewManager;
  late final NetworkChecker _networkChecker;
  StreamSubscription<bool>? _networkSubscription;

  double _loadingProgress = 0.0;
  bool _hasError = false;
  String _errorMessage = '';
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _networkChecker = widget.networkChecker ?? NetworkChecker();
    _webViewManager = WebViewManager(callbacks: this);

    _listenToNetworkStatus();
    _initiateInitialLoad();
  }

  void _listenToNetworkStatus() {
    _networkSubscription =
        _networkChecker.onConnectivityChanged.listen((bool isConnected) {
      if (isConnected && _hasError) {
        _handleRetry();
      }
    });
  }

  Future<void> _initiateInitialLoad() async {
    final bool isOnline = await _networkChecker.hasConnection();
    if (!isOnline) {
      setState(() {
        _hasError = true;
        _errorMessage = AppConfig.offlineSubtitle;
      });
      return;
    }

    await _webViewManager.loadInitialPage();
  }

  @override
  void onLoadingProgress(double progress) {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
      });
    }
  }

  @override
  void onPageStarted(String url) {
    if (mounted && _hasError) {
      setState(() {
        _hasError = false;
      });
    }
  }

  @override
  void onPageFinished(String url) {
    if (mounted) {
      setState(() {
        _loadingProgress = 1.0;
      });
    }
  }

  @override
  void onErrorOccurred(String description) {
    if (mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = description.isNotEmpty
            ? description
            : AppConfig.genericErrorMessage;
      });
    }
  }

  Future<void> _handleRetry() async {
    setState(() {
      _hasError = false;
      _loadingProgress = 0.1;
    });

    final bool isOnline = await _networkChecker.hasConnection();
    if (isOnline) {
      await _webViewManager.reload();
    } else {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = AppConfig.offlineSubtitle;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _webViewManager.reload();
  }

  void _handleBackNavigation(bool didPop) async {
    if (didPop) return;

    final bool canNavigateBack = await _webViewManager.canGoBack();
    if (canNavigateBack) {
      await _webViewManager.goBack();
      return;
    }

    final DateTime now = DateTime.now();
    final bool isWithinThreshold = _lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < AppConfig.backExitThreshold;

    if (isWithinThreshold) {
      await SystemNavigator.pop();
    } else {
      _lastBackPressTime = now;
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConfig.backToExitPrompt),
            duration: AppConfig.backExitThreshold,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        _handleBackNavigation(didPop);
      },
      child: Scaffold(
        backgroundColor: AppConfig.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              if (!_hasError)
                AppConfig.enablePullToRefresh
                    ? RefreshIndicator(
                        color: AppConfig.primaryColor,
                        backgroundColor: AppConfig.surfaceColor,
                        onRefresh: _handleRefresh,
                        child: WebViewWidget(
                          controller: _webViewManager.controller,
                        ),
                      )
                    : WebViewWidget(
                        controller: _webViewManager.controller,
                      ),
              if (_hasError)
                ErrorView(
                  onRetry: _handleRetry,
                  subtitle: _errorMessage,
                ),
              LoadingIndicator(progress: _loadingProgress),
            ],
          ),
        ),
      ),
    );
  }
}

