import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/app_config.dart';
import 'features/webview/presentation/screens/web_view_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure modern, immersive system UI overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConfig.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const AniSongListApp());
}

/// Root widget of the AniSongList WebView application.
class AniSongListApp extends StatelessWidget {
  const AniSongListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConfig.backgroundColor,
        primaryColor: AppConfig.primaryColor,
        colorScheme: const ColorScheme.dark(
          primary: AppConfig.primaryColor,
          secondary: AppConfig.secondaryColor,
          surface: AppConfig.surfaceColor,
        ),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}
