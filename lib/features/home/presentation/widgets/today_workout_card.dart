import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';

/// Card summarising today's workout: exercise count, total duration, and a
/// "Start Exercise" call-to-action button.
class TodayWorkoutCard extends StatelessWidget {
  const TodayWorkoutCard({
    required this.exerciseCount,
    required this.totalMinutes,
    required this.onStartPressed,
    super.key,
  });

  /// Number of exercises scheduled for today.
  final int exerciseCount;

  /// Total duration of today's exercises in minutes.
  final int totalMinutes;

  /// Callback invoked when the user taps "Start Exercise".
  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.cardInnerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Workout",
            style: AppTextStyles.h3Section
                .copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatItem(
                icon: Icons.fitness_center,
                value: '$exerciseCount',
                label: exerciseCount == 1 ? 'Exercise' : 'Exercises',
              ),
              const SizedBox(width: 24),
              _StatItem(
                icon: Icons.timer_outlined,
                value: '$totalMinutes',
                label: 'Minutes',
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'Start Exercise',
            onPressed: onStartPressed,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.textPrimary),
              ),
              TextSpan(
                text: ' $label',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
