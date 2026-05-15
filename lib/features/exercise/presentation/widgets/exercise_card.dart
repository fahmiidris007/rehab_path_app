import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// A card widget displaying a summary of an [ExerciseEntity].
///
/// Shows the exercise name, category chip, difficulty indicator (1–3 filled
/// circles), and duration in minutes. Tapping the card calls [onTap].
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  final ExerciseEntity exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 0,
      color: AppColors.surfaceWhite,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise name
                    Text(
                      exercise.name,
                      style: AppTextStyles.bodySemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Category chip
                    _CategoryChip(category: exercise.category),
                    const SizedBox(height: 8),
                    // Difficulty + duration row
                    Row(
                      children: [
                        _DifficultyIndicator(difficulty: exercise.difficulty),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(exercise.durationSeconds / 60).ceil()} min',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category chip ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final ExerciseCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blueLightBorder,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      ),
      child: Text(
        _categoryLabel(category),
        style: AppTextStyles.body.copyWith(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static String _categoryLabel(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.warmUp:
        return 'Warm Up';
      case ExerciseCategory.balanceTraining:
        return 'Balance Training';
      case ExerciseCategory.strengthTraining:
        return 'Strength Training';
      case ExerciseCategory.enduranceAerobic:
        return 'Endurance / Aerobic';
      case ExerciseCategory.taiChi:
        return 'Tai Chi';
      case ExerciseCategory.walkingProgram:
        return 'Walking Program';
      case ExerciseCategory.gettingUpFromFloor:
        return 'Getting Up From Floor';
      case ExerciseCategory.coolDown:
        return 'Cool Down';
    }
  }
}

// ── Difficulty indicator ──────────────────────────────────────────────────────

/// Renders 1–3 filled circles to represent exercise difficulty.
class _DifficultyIndicator extends StatelessWidget {
  const _DifficultyIndicator({required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    const maxDots = 3;
    final filled = difficulty.clamp(1, maxDots);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxDots, (index) {
        final isFilled = index < filled;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? AppColors.accent : AppColors.neutralGray,
            ),
          ),
        );
      }),
    );
  }
}
