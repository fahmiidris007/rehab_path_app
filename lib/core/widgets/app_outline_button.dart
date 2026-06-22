import 'package:flutter/material.dart';
import 'package:laman_lansia/app/theme/app_colors.dart';
import 'package:laman_lansia/app/theme/app_dimensions.dart';
import 'package:laman_lansia/app/theme/app_text_styles.dart';

/// A full-width outlined (ghost) button with a 2 dp primary-colour border.
///
/// Shows a [CircularProgressIndicator.adaptive] when [isLoading] is true.
/// Renders in a disabled/reduced-opacity state when [onPressed] is null.
class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Button label text.
  final String label;

  /// Callback invoked on tap. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// When `true`, replaces the label with an adaptive progress indicator.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppDimensions.recTouchTarget,
          minHeight: AppDimensions.recTouchTarget,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: SizedBox(
            height: AppDimensions.primaryButtonH,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled || isLoading ? null : onPressed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : Text(
                            label,
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
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
