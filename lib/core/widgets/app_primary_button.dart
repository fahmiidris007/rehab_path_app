import 'package:flutter/material.dart';
import 'package:rehab_path_app/app/theme/app_colors.dart';
import 'package:rehab_path_app/app/theme/app_dimensions.dart';
import 'package:rehab_path_app/app/theme/app_text_styles.dart';

/// A full-width primary action button with the app's brand colour.
///
/// Shows a [CircularProgressIndicator.adaptive] when [isLoading] is true.
/// Renders in a disabled/reduced-opacity state when [onPressed] is null.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  /// Button label text.
  final String label;

  /// Callback invoked on tap. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// When `true`, replaces the label with an adaptive progress indicator.
  final bool isLoading;

  /// Optional leading icon displayed before the label.
  final Widget? icon;

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
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
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
                                AppColors.textOnPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (icon != null) ...[
                                icon!,
                                const SizedBox(width: 8),
                              ],
                              Text(
                                label,
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.textOnPrimary,
                                  fontSize: 16
                                ),
                              ),
                            ],
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
