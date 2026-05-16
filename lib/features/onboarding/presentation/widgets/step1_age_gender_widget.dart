import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 1 — Age & Gender
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

  // Internal key used to store the selected gender — always English so data
  // is locale-independent in storage.
  static const _keyMale = 'Male';
  static const _keyFemale = 'Female';

  static const _genderKeys = [
    _keyMale,
    _keyFemale,
  ];

  String _gender = _keyMale;

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

  bool validate() => _formKey.currentState?.validate() ?? false;

  /// Maps an internal English key to its localized display label.
  String _genderLabel(String key, AppLocalizations l10n) {
    return switch (key) {
      _keyMale => l10n.onboardingStep1GenderMale,
      _keyFemale => l10n.onboardingStep1GenderFemale,
      _ => l10n.onboardingStep1GenderMale,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingStep1AgeLabel, style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: l10n.onboardingStep1AgeHint,
              suffixText: l10n.onboardingStep1AgeSuffix,
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.onboardingStep1AgeRequired;
              }
              final age = int.tryParse(value);
              if (age == null || age < 18 || age > 120) {
                return l10n.onboardingStep1AgeRange;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.onboardingStep1GenderLabel, style: AppTextStyles.bodySemiBold),
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
              children: _genderKeys
                  .map(
                    (key) => RadioListTile<String>(
                      title: Text(
                        _genderLabel(key, l10n),
                        style: AppTextStyles.body,
                      ),
                      value: key,
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
