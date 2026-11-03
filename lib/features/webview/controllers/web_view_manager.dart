import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/url_handler.dart';

/// Callbacks contract for WebView lifecycle and state updates.
abstract class WebViewCallbacks {
  void onLoadingProgress(double progress);
  void onPageStarted(String url);
  void onPageFinished(String url);
  void onErrorOccurred(String description);
}

/// Manages initialization, platform configurations, and interactions for the WebView.
class WebViewManager {
  WebViewManager({required this.callbacks}) {
    _initializeController();
  }

  final WebViewCallbacks callbacks;
  late final WebViewController controller;

  void _initializeController() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController webController =
        WebViewController.fromPlatformCreationParams(params);

    webController
      ..setJavaScriptMode(
        AppConfig.enableJavaScript
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled,
      )
      ..setBackgroundColor(AppConfig.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            callbacks.onLoadingProgress(progress / 100.0);
          },
          onPageStarted: (String url) {
            callbacks.onPageStarted(url);
          },
          onPageFinished: (String url) {
            callbacks.onPageFinished(url);
          },
          onWebResourceError: (WebResourceError error) {
            // Filter out minor sub-resource errors, surface primary domain failures
            if (error.isForMainFrame ?? true) {
              callbacks.onErrorOccurred(error.description);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final Uri uri = Uri.parse(request.url);

            if (UrlHandler.isInternalUri(uri)) {
              return NavigationDecision.navigate;
            }

            // Route external links out to native browser/apps
            UrlHandler.launchExternalUri(uri);
            return NavigationDecision.prevent;
          },
        ),
      );

    // Apply platform-specific media playback optimizations
    if (webController.platform is AndroidWebViewController) {
      final AndroidWebViewController androidController =
          webController.platform as AndroidWebViewController;

      androidController.setMediaPlaybackRequiresUserGesture(
        AppConfig.mediaPlaybackRequiresUserGesture,
      );
    }

    controller = webController;
  }

  /// Loads the primary AniSongList application URL.
  Future<void> loadInitialPage() async {
    await controller.loadRequest(Uri.parse(AppConfig.initialUrl));
  }

  /// Determines whether the webview history can navigate back.
  Future<bool> canGoBack() => controller.canGoBack();

  /// Navigates back in the webview history.
  Future<void> goBack() => controller.goBack();

  /// Reloads the current page.
  Future<void> reload() => controller.reload();
}

