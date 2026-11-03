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
        UrlHandler.isInternalUri(Uri.parse('https://sub.anisonglist.com/song/123')),
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

