import 'package:flutter/material.dart';
import 'package:teman_lansia/app/theme/app_colors.dart';
import 'package:teman_lansia/app/theme/app_text_styles.dart';
import 'package:teman_lansia/l10n/app_localizations.dart';

/// A non-dismissible banner shown to guest (unauthenticated) users.
class GuestBanner extends StatelessWidget {
  const GuestBanner({
    super.key,
    required this.message,
    this.onRegisterTap,
  });

  final String message;
  final VoidCallback? onRegisterTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                l10n.guestBannerRegister,
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
