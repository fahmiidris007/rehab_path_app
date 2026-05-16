import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';

/// A horizontal row of three stat chips: total minutes, total sessions, and
/// streak days.
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({
    required this.totalMinutes,
    required this.totalSessions,
    required this.streakDays,
    super.key,
  });

  final int totalMinutes;
  final int totalSessions;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            value: '$totalMinutes',
            label: l10n.homeStatMinutes,
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: AppDimensions.cardGap),
        Expanded(
          child: _StatChip(
            value: '$totalSessions',
            label: l10n.homeStatSessions,
            icon: Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: AppDimensions.cardGap),
        Expanded(
          child: _StatChip(
            value: '$streakDays',
            label: l10n.homeStatDayStreak,
            icon: Icons.local_fire_department_outlined,
            iconColor: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.bodySemiBold
                .copyWith(color: AppColors.textPrimary),
          ),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
