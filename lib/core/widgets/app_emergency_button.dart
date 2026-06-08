import 'package:flutter/material.dart';
import 'package:teman_lansia/app/theme/app_colors.dart';
import 'package:teman_lansia/app/theme/app_dimensions.dart';
import 'package:teman_lansia/app/theme/app_text_styles.dart';

/// A full-width emergency action button styled with the error/danger colour.
///
/// Use this button exclusively for critical, irreversible, or emergency
/// actions (e.g. "Call Emergency Services").
class AppEmergencyButton extends StatelessWidget {
  const AppEmergencyButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// Button label text.
  final String label;

  /// Callback invoked on tap.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppDimensions.recTouchTarget,
        minHeight: AppDimensions.recTouchTarget,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33BA1A1A),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: AppDimensions.primaryButtonH,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
