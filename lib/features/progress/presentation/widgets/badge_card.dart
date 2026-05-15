import 'package:flutter/material.dart';
import 'package:rehab_path_app/app/theme/app_colors.dart';
import 'package:rehab_path_app/app/theme/app_dimensions.dart';
import 'package:rehab_path_app/app/theme/app_text_styles.dart';

/// A card widget that displays a badge with its earned/unearned state.
///
/// Earned badges show [Icons.emoji_events] on an [AppColors.accent] background.
/// Unearned badges show [Icons.lock_outline] on an [AppColors.neutralGray] background.
class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.name,
    required this.isEarned,
  });

  /// The display name of the badge.
  final String name;

  /// Whether the badge has been earned by the user.
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isEarned ? AppColors.accent : AppColors.neutralGray;
    final iconColor =
        isEarned ? AppColors.surfaceWhite : AppColors.textDisabled;
    final icon = isEarned ? Icons.emoji_events : Icons.lock_outline;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: isEarned ? AppColors.accentDark.withValues(alpha: 0.3) : AppColors.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: AppTextStyles.body.copyWith(
              fontSize: 11,
              color: isEarned ? AppColors.surfaceWhite : AppColors.textDisabled,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
