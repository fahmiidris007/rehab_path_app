import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 1 — Age & Gender
///
/// Collects the user's age (18–120) and gender via a radio group.
class Step1AgeGenderWidget extends StatefulWidget {
  const Step1AgeGenderWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step1AgeGenderWidget> createState() => Step1AgeGenderWidgetState();
}

class Step1AgeGenderWidgetState extends State<Step1AgeGenderWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ageController;
  String _gender = 'Prefer not to say';

  static const _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _ageController = TextEditingController(
      text: (p != null && p.age > 0) ? p.age.toString() : '',
    );
    if (p != null && p.gender.isNotEmpty) {
      _gender = p.gender;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _notify() {
    final age = int.tryParse(_ageController.text) ?? 0;
    final p = widget.profile;
    final updated = (p ?? _defaultProfile()).copyWith(
      age: age,
      gender: _gender,
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

  /// Validates and returns true if the form is valid.
  bool validate() => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Age', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Enter your age',
              suffixText: 'years',
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              final age = int.tryParse(value);
              if (age == null || age < 18 || age > 120) {
                return 'Age must be between 18 and 120';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text('Gender', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          RadioGroup<String>(
            groupValue: _gender,
            onChanged: (value) {
              if (value != null) {
                setState(() => _gender = value);
                _notify();
              }
            },
            child: Column(
              children: _genderOptions
                  .map(
                    (option) => RadioListTile<String>(
                      title: Text(option, style: AppTextStyles.body),
                      value: option,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
