import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

/// Horizontal progress bar with pill shape.
///
/// [progress] must be in the range 0.0–1.0.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress,
  }) : assert(progress >= 0.0 && progress <= 1.0,
            'progress must be between 0.0 and 1.0');

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.progressBarH,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        child: Stack(
          children: [
            // Background track
            Container(
              decoration: const BoxDecoration(
                color: AppColors.neutralGray,
              ),
            ),
            // Fill
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusPill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
