import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// A compact card showing an exercise's name, category, difficulty, and
/// duration. Intended for use in a horizontal scroll list.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    required this.exercise,
    required this.onTap,
    super.key,
  });

  final ExerciseEntity exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final durationMinutes = (exercise.durationSeconds / 60).ceil();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        child: AppCard(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Placeholder image area
              Container(
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                child: const Center(
                  child: Icon(
                    Icons.fitness_center,
                    color: AppColors.textDisabled,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                exercise.name,
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _categoryLabel(exercise.category),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _DifficultyDots(difficulty: exercise.difficulty),
                  const Spacer(),
                  Icon(
                    Icons.timer_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${durationMinutes}m',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(ExerciseCategory category) {
    return switch (category) {
      ExerciseCategory.warmUp => 'Warm Up',
      ExerciseCategory.balanceTraining => 'Balance Training',
      ExerciseCategory.strengthTraining => 'Strength Training',
      ExerciseCategory.enduranceAerobic => 'Endurance / Aerobic',
      ExerciseCategory.taiChi => 'Tai Chi',
      ExerciseCategory.walkingProgram => 'Walking Program',
      ExerciseCategory.gettingUpFromFloor => 'Getting Up From Floor',
      ExerciseCategory.coolDown => 'Cool Down',
    };
  }
}

/// Three dots indicating difficulty level (1–3 filled).
class _DifficultyDots extends StatelessWidget {
  const _DifficultyDots({required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = i < difficulty.clamp(1, 3);
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.accent : AppColors.neutralGray,
          ),
        );
      }),
    );
  }
}
