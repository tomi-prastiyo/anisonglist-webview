import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service responsible for monitoring and checking network connectivity.
class NetworkChecker {
  NetworkChecker({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Checks if the device currently has active network connectivity.
  Future<bool> hasConnection() async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    return _isOnline(results);
  }

  /// Broadcast stream emitting true when connected, false when disconnected.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isOnline);
  }

  /// Single internal helper to determine online status from connectivity results.
  bool _isOnline(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any(
      (ConnectivityResult result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );
  }
}

