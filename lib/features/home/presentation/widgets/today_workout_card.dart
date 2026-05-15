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
    this.completedCount = 0,
    super.key,
  });

  /// Number of exercises scheduled for today.
  final int exerciseCount;

  /// Number of exercises completed today.
  final int completedCount;

  /// Total duration of today's exercises in minutes.
  final int totalMinutes;

  /// Callback invoked when the user taps the action button.
  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final allDone = completedCount >= exerciseCount && exerciseCount > 0;
    final inProgress = completedCount > 0 && !allDone;
    final remaining = (exerciseCount - completedCount).clamp(0, exerciseCount);

    final buttonLabel = allDone
        ? 'All Done Today 🎉'
        : inProgress
            ? 'Continue ($remaining left)'
            : 'Start Exercise';

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.fitness_center,
                value: '$exerciseCount',
                label: exerciseCount == 1 ? 'Exercise' : 'Exercises',
              ),
              _StatItem(
                icon: Icons.timer_outlined,
                value: '$totalMinutes',
                label: 'Minutes',
              ),
              if (completedCount > 0) ...[
                _StatItem(
                  icon: Icons.check_circle_outline,
                  value: '$completedCount',
                  label: 'Done',
                  iconColor: AppColors.success,
                ),
              ],
            ],
          ),
          if (exerciseCount > 0) ...[
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              child: LinearProgressIndicator(
                value: (completedCount / exerciseCount).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.neutralGray,
                valueColor: AlwaysStoppedAnimation<Color>(
                  allDone ? AppColors.success : AppColors.accent,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: buttonLabel,
            onPressed: allDone ? null : onStartPressed,
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
    this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor ?? AppColors.primary, size: 16),
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.textPrimary, fontSize: 16),
              ),
              TextSpan(
                text: ' $label',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
