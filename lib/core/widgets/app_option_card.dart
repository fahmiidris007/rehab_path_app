import 'package:flutter/material.dart';
import 'package:laman_lansia/app/theme/app_colors.dart';
import 'package:laman_lansia/app/theme/app_dimensions.dart';
import 'package:laman_lansia/app/theme/app_text_styles.dart';

/// A tappable option card used for selection lists.
///
/// Background: white ([AppColors.surfaceWhite])
/// Border: 1px [AppColors.border], radius 12dp
/// When [isSelected] is true the border becomes 2px [AppColors.primary].
class AppOptionCard extends StatelessWidget {
  const AppOptionCard({
    super.key,
    required this.label,
    this.trailingIcon,
    this.onTap,
    this.isSelected = false,
  });

  /// The label text displayed in the card.
  final String label;

  /// Optional widget shown on the trailing (right) side.
  final Widget? trailingIcon;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// When true, the border is highlighted with [AppColors.primary] at 2px width.
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primary : AppColors.border;
    final borderWidth = isSelected ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A00609B),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.h3Section.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon!,
          ],
        ),
      ),
    );
  }
}
