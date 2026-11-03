import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

/// Centralized utility for validating and routing URLs.
class UrlHandler {
  UrlHandler._();

  /// Determines whether the given URI belongs to the internal AniSongList domain
  /// or essential auxiliary services (e.g., Turnstile challenge, blank init frame).
  static bool isInternalUri(Uri uri) {
    final String urlString = uri.toString().toLowerCase();

    // Allow blank initialization frames and internal data URIs
    if (urlString == 'about:blank' ||
        urlString.startsWith('data:') ||
        urlString.startsWith('blob:')) {
      return true;
    }

    if (!uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      return false;
    }

    final String host = uri.host.toLowerCase();
    if (host.isEmpty) {
      return false;
    }

    // Check internal domains
    final bool isDirectInternal = AppConfig.internalHosts.any(
      (String internalHost) =>
          host == internalHost || host.endsWith('.$internalHost'),
    );
    if (isDirectInternal) return true;

    // Check auxiliary infrastructure domains (e.g. Cloudflare Turnstile)
    return AppConfig.auxiliaryAllowedHosts.any(
      (String auxHost) => host == auxHost || host.endsWith('.$auxHost'),
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
