import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

/// Centralized utility for validating and routing URLs.
class UrlHandler {
  UrlHandler._();

  /// Determines whether the given URI belongs to the internal AniSongList domain.
  static bool isInternalUri(Uri uri) {
    if (!uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      return false;
    }

    final String host = uri.host.toLowerCase();
    return AppConfig.internalHosts.any(
      (String internalHost) =>
          host == internalHost || host.endsWith('.$internalHost'),
    );
  }

  /// Attempts to launch an external URI (such as external website, mailto, tel).
  ///
  /// Returns `true` if launched successfully, `false` otherwise.
  static Future<bool> launchExternalUri(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (_) {
      // Fallback: silently ignore launch errors to keep app resilient
    }
    return false;
  }
}

