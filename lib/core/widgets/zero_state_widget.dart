import 'package:flutter/material.dart';
import 'package:laman_lansia/app/theme/app_colors.dart';
import 'package:laman_lansia/app/theme/app_text_styles.dart';

/// A centered empty-state widget shown when a list or screen has no content.
///
/// Displays an optional icon, a required title, an optional subtitle, and an
/// optional action widget (e.g. a button to trigger a primary action).
class ZeroStateWidget extends StatelessWidget {
  const ZeroStateWidget({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  /// Optional icon displayed at the top of the column. Constrained to 64 × 64 dp.
  final Widget? icon;

  /// Primary heading text.
  final String title;

  /// Secondary descriptive text shown below the title.
  final String? subtitle;

  /// Optional action widget (e.g. a button) shown at the bottom.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              SizedBox(
                width: 64,
                height: 64,
                child: icon,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: AppTextStyles.h3Section.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
