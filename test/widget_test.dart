import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anisonglist_webview/core/config/app_config.dart';
import 'package:anisonglist_webview/features/webview/presentation/widgets/error_view.dart';
import 'package:anisonglist_webview/features/webview/presentation/widgets/loading_indicator.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('LoadingIndicator renders progress correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(progress: 0.5),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('ErrorView displays custom messages and triggers callback',
        (WidgetTester tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              onRetry: () => retryPressed = true,
              title: 'Custom Error',
              subtitle: 'Check network',
            ),
          ),
        ),
      );

      expect(find.text('Custom Error'), findsOneWidget);
      expect(find.text('Check network'), findsOneWidget);
      expect(find.text(AppConfig.retryButtonText), findsOneWidget);

      await tester.tap(find.text(AppConfig.retryButtonText));
      await tester.pump();

      expect(retryPressed, isTrue);
    });
  });
}
