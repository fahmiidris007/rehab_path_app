import 'package:flutter/material.dart';
import 'package:rehab_path_app/app/theme/app_colors.dart';
import 'package:rehab_path_app/app/theme/app_text_styles.dart';

/// A non-dismissible banner shown to guest (unauthenticated) users.
///
/// Styled like a [MaterialBanner] but implemented as a plain widget so it can
/// be embedded anywhere in the layout without requiring a [ScaffoldMessenger].
/// There is intentionally no close/dismiss button.
class GuestBanner extends StatelessWidget {
  const GuestBanner({
    super.key,
    required this.message,
    this.onRegisterTap,
  });

  /// The message to display inside the banner.
  final String message;

  /// Optional callback invoked when the user taps the "Register" button.
  /// When null, no action button is shown.
  final VoidCallback? onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.accent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.accentDark,
              ),
            ),
          ),
          if (onRegisterTap != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRegisterTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Register',
                style: AppTextStyles.bodySemiBold.copyWith(
                  color: AppColors.accentDark,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
