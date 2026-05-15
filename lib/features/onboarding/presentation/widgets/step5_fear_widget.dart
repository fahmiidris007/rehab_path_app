import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 5 — Fear of Falling Scale
///
/// 1–5 scale with descriptive labels for each level.
class Step5FearWidget extends StatefulWidget {
  const Step5FearWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step5FearWidget> createState() => _Step5FearWidgetState();
}

class _Step5FearWidgetState extends State<Step5FearWidget> {
  late int _score;

  static const _descriptions = {
    1: 'Not at all concerned',
    2: 'Slightly concerned',
    3: 'Moderately concerned',
    4: 'Very concerned',
    5: 'Extremely concerned',
  };

  @override
  void initState() {
    super.initState();
    _score = widget.profile?.fearOfFallingScore ?? 0;
  }

  void _select(int score) {
    setState(() => _score = score);
    final p = widget.profile;
    final updated =
        (p ?? _defaultProfile()).copyWith(fearOfFallingScore: score);
    widget.onDataChanged(updated);
  }

  OnboardingProfileEntity _defaultProfile() => const OnboardingProfileEntity(
        age: 0,
        gender: '',
        fallsInLastYear: 0,
        healthConditions: [],
        usesWalkingAid: false,
        fearOfFallingScore: 1,
        preferredExerciseTime: '08:00',
        sessionDurationMinutes: 30,
        weeklyFrequencyTarget: 3,
        outcomeGoal: '',
        behaviouralGoal: '',
        programLevel: ProgramLevel.beginner,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How concerned are you about falling?',
          style: AppTextStyles.bodySemiBold,
        ),
        const SizedBox(height: 24),
        ...List.generate(5, (i) {
          final level = i + 1;
          final isSelected = _score == level;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FearLevelButton(
              level: level,
              description: _descriptions[level]!,
              isSelected: isSelected,
              onTap: () => _select(level),
            ),
          );
        }),
      ],
    );
  }
}

class _FearLevelButton extends StatelessWidget {
  const _FearLevelButton({
    required this.level,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final int level;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A00609B),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.surfaceWhite
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: AppTextStyles.bodySemiBold.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                description,
                style: AppTextStyles.body.copyWith(
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
