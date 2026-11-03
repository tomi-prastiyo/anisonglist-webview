import 'package:flutter/material.dart';

/// Centralized application configuration.
///
/// Keeps all constants, URLs, feature flags, styling tokens, and localized
/// string resources in one place to eliminate hardcoding throughout the codebase.
class AppConfig {
  AppConfig._();

  // Application Metadata
  static const String appName = 'AniSongList';
  static const String appVersion = '1.0.0';

  // Network & Web Endpoints
  static const String initialUrl = 'https://anisonglist.com/';

  /// Internal hostnames that belong directly to AniSongList.
  static const List<String> internalHosts = <String>[
    'anisonglist.com',
    'www.anisonglist.com',
    'db.anisonglist.com',
  ];

  /// Auxiliary trusted hostnames required for infrastructure (e.g., Cloudflare Turnstile).
  static const List<String> auxiliaryAllowedHosts = <String>[
    'challenges.cloudflare.com',
    'cloudflare.com',
    'turnstile',
  ];

  /// Modern Mobile Chrome User-Agent to ensure Cloudflare Turnstile and Netlify
  /// render cleanly without being flagged by Android WebView bot-detection rules.
  static const String customUserAgent =
      'Mozilla/5.0 (Linux; Android 14; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.127 Mobile Safari/537.36';

  // WebView Feature Flags
  static const bool enableJavaScript = true;
  static const bool enableDomStorage = true;
  static const bool mediaPlaybackRequiresUserGesture = false;

  // Navigation & Timeouts
  static const Duration backExitThreshold = Duration(seconds: 2);
  static const Duration splashDuration = Duration(milliseconds: 600);

  // Localization & UI Text Resources
  static const String offlineTitle = 'Connection Lost';
  static const String offlineSubtitle =
      'Unable to connect to AniSongList. Please check your internet connection.';
  static const String retryButtonText = 'Retry';
  static const String backToExitPrompt = 'Press back again to exit';
  static const String genericErrorMessage =
      'Something went wrong while loading the page.';

  // Theme Styling & Palette
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFFA29BFE);
  static const Color backgroundColor = Color(0xFF181824);
  static const Color surfaceColor = Color(0xFF232334);
  static const Color textPrimaryColor = Color(0xFFF5F6FA);
  static const Color textSecondaryColor = Color(0xFFA4B0BE);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color progressIndicatorColor = Color(0xFF00CEC9);
}
