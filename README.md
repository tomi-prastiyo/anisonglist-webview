# AniSongList WebView

A dedicated, high-performance WebView application for [AniSongList](https://anisonglist.com/), built with Flutter. It delivers an optimized mobile and cross-platform experience for exploring, searching, and rating anime opening and ending themes.

## Features

- **Media & Audio/Video Playback**: Hardware acceleration enabled with inline media playback and unrestricted JavaScript execution for seamless media streaming.
- **Centralized Configuration**: All endpoints, feature flags, constants, colors, and string resources are consolidated in [`AppConfig`](lib/core/config/app_config.dart) to eliminate hardcoding.
- **Strict DRY Architecture**: Reusable utilities and controllers ensure zero duplicate functions across the codebase.
- **Smart Navigation Handling**:
  - Android system back button traverses web navigation history before prompting exit.
  - Double-tap back threshold prevents accidental app closures.
  - External link interception routes non-AniSongList links to external native applications or browsers.
- **Network Resilience & Error Handling**:
  - Real-time connectivity monitoring via `connectivity_plus`.
  - Elegant offline error view with automated and manual retry triggers.
  - Pull-to-refresh integration.
  - Sleek top progress indicator reflecting page loading status.

## Project Structure

```
anisonglist-webview/
├── android/                         # Android platform configuration & permissions
├── ios/                             # iOS platform configuration & ATS rules
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart      # Centralized settings, endpoints, and constants
│   │   ├── network/
│   │   │   └── network_checker.dart # Network monitoring service
│   │   └── utils/
│   │       └── url_handler.dart     # URL routing and external intent handler
│   ├── features/
│   │   └── webview/
│   │       ├── controllers/
│   │       │   └── web_view_manager.dart # WebView lifecycle and configuration manager
│   │       └── presentation/
│   │           ├── screens/
│   │           │   └── web_view_screen.dart # Main screen with back gesture & reload logic
│   │           └── widgets/
│   │               ├── error_view.dart       # Offline / error state widget
│   │               └── loading_indicator.dart# Linear loading progress indicator
│   └── main.dart                    # Application entry point
├── test/                            # Unit and widget test suite
└── pubspec.yaml                     # Project dependencies
```

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.16.0 or higher)
- Android SDK (API 21+) / Xcode (for iOS)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/tomi-prastiyo/anisonglist-webview.git
   cd anisonglist-webview
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

### Running Tests and Linting
- **Static Analysis**:
  ```bash
  flutter analyze
  ```
- **Unit and Widget Tests**:
  ```bash
  flutter test
  ```
