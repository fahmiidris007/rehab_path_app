import 'package:flutter/material.dart';
import 'package:laman_lansia/app/theme/app_colors.dart';
import 'package:laman_lansia/app/theme/app_dimensions.dart';
import 'package:laman_lansia/app/theme/app_text_styles.dart';

/// A pill-shaped badge that displays a streak count with a flame emoji.
///
/// Background: [AppColors.accent] (#FFA454)
/// Shape: pill (border radius 9999dp)
/// Text: [AppTextStyles.bodySemiBold] in [AppColors.accentDark] (#713B00)
class AppStreakBadge extends StatelessWidget {
  const AppStreakBadge({
    super.key,
    required this.streakDays,
    required this.label,
  });

  /// The number of streak days to display.
  final int streakDays;

  /// The label shown after the count, e.g. "Day Streak".
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        '🔥 $streakDays $label',
        style: AppTextStyles.bodySemiBold.copyWith(
          color: AppColors.accentDark,
        ),
      ),
    );
  }
}
