import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_option_card.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 4 — Walking Aid
///
/// Boolean question: "Do you use a walking aid?" with Yes/No option cards.
class Step4WalkingAidWidget extends StatefulWidget {
  const Step4WalkingAidWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step4WalkingAidWidget> createState() => _Step4WalkingAidWidgetState();
}

class _Step4WalkingAidWidgetState extends State<Step4WalkingAidWidget> {
  bool? _usesWalkingAid;

  @override
  void initState() {
    super.initState();
    _usesWalkingAid = widget.profile?.usesWalkingAid;
  }

  void _select(bool value) {
    setState(() => _usesWalkingAid = value);
    final p = widget.profile;
    final updated = (p ?? _defaultProfile()).copyWith(usesWalkingAid: value);
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
          'Do you use a walking aid?',
          style: AppTextStyles.bodySemiBold,
        ),
        const SizedBox(height: 24),
        AppOptionCard(
          label: 'Yes',
          isSelected: _usesWalkingAid == true,
          onTap: () => _select(true),
        ),
        const SizedBox(height: 12),
        AppOptionCard(
          label: 'No',
          isSelected: _usesWalkingAid == false,
          onTap: () => _select(false),
        ),
      ],
    );
  }
}
