import 'package:flutter_test/flutter_test.dart';
import 'package:anisonglist_webview/core/utils/url_handler.dart';

void main() {
  group('UrlHandler Tests', () {
    test('Correctly identifies internal AniSongList URLs', () {
      expect(
        UrlHandler.isInternalUri(Uri.parse('https://anisonglist.com/')),
        isTrue,
      );
      expect(
        UrlHandler.isInternalUri(Uri.parse('https://www.anisonglist.com/search')),
        isTrue,
      );
      expect(
        UrlHandler.isInternalUri(Uri.parse('https://db.anisonglist.com/storage')),
        isTrue,
      );
    });

    test('Correctly identifies auxiliary and initialization URIs', () {
      expect(
        UrlHandler.isInternalUri(Uri.parse('about:blank')),
        isTrue,
      );
      expect(
        UrlHandler.isInternalUri(Uri.parse('https://challenges.cloudflare.com/turnstile/v0/api.js')),
        isTrue,
      );
    });

    test('Correctly identifies non-internal external URLs', () {
      expect(
        UrlHandler.isInternalUri(Uri.parse('https://google.com')),
        isFalse,
      );
      expect(
        UrlHandler.isInternalUri(Uri.parse('https://anilist.co/anime/1')),
        isFalse,
      );
      expect(
        UrlHandler.isInternalUri(Uri.parse('mailto:support@anisonglist.com')),
        isFalse,
      );
      expect(
        UrlHandler.isInternalUri(Uri.parse('tel:123456789')),
        isFalse,
      );
    });
  });
}
