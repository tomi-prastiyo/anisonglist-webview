import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';

/// Linear progress bar that indicates WebView loading progress.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    required this.progress,
  });

  /// Progress value between 0.0 and 1.0.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final bool isVisible = progress > 0.0 && progress < 1.0;

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: isVisible
          ? LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppConfig.progressIndicatorColor,
              ),
              minHeight: 3.0,
            )
          : const SizedBox.shrink(),
    );
  }
}

