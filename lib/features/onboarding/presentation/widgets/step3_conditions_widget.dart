import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 3 — Health Conditions
///
/// Multi-select CheckboxListTile for 5 health condition categories.
class Step3ConditionsWidget extends StatefulWidget {
  const Step3ConditionsWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step3ConditionsWidget> createState() => _Step3ConditionsWidgetState();
}

class _Step3ConditionsWidgetState extends State<Step3ConditionsWidget> {
  static const _conditions = [
    _Condition('Musculoskeletal', 'Joint/bone problems'),
    _Condition('Circulatory', 'Heart/blood pressure'),
    _Condition('Respiratory', 'Breathing problems'),
    _Condition('Neurological', 'Nerve/brain conditions'),
    _Condition('Other', ''),
  ];

  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.profile?.healthConditions ?? []);
  }

  void _toggle(String condition, bool? checked) {
    setState(() {
      if (checked == true) {
        _selected.add(condition);
      } else {
        _selected.remove(condition);
      }
    });
    _notify();
  }

  void _notify() {
    final p = widget.profile;
    final updated = (p ?? _defaultProfile()).copyWith(
      healthConditions: _selected.toList(),
    );
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
          'Do you have any of the following health conditions?',
          style: AppTextStyles.bodySemiBold,
        ),
        Text(
          'Select all that apply',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ..._conditions.map((c) {
          final isChecked = _selected.contains(c.key);
          return CheckboxListTile(
            title: Text(c.key, style: AppTextStyles.body),
            subtitle: c.subtitle.isNotEmpty
                ? Text(
                    c.subtitle,
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.textSecondary, fontSize: 14),
                  )
                : null,
            value: isChecked,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) => _toggle(c.key, checked),
          );
        }),
      ],
    );
  }
}

class _Condition {
  final String key;
  final String subtitle;
  const _Condition(this.key, this.subtitle);
}
