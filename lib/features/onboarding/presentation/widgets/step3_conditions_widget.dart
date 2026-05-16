import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 3 — Health Conditions
///
/// Multi-select CheckboxListTile for health condition categories.
/// Keys stored in the profile are always English (locale-independent).
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
  // Internal English keys — stored in the profile, locale-independent.
  static const _keyMusculoskeletal = 'Musculoskeletal';
  static const _keyCirculatory = 'Circulatory';
  static const _keyRespiratory = 'Respiratory';
  static const _keyNeurological = 'Neurological';
  static const _keyOther = 'Other';

  static const _conditionKeys = [
    _keyMusculoskeletal,
    _keyCirculatory,
    _keyRespiratory,
    _keyNeurological,
    _keyOther,
  ];

  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.profile?.healthConditions ?? []);
  }

  void _toggle(String key, bool? checked) {
    setState(() {
      if (checked == true) {
        _selected.add(key);
      } else {
        _selected.remove(key);
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

  /// Returns the localized label for a condition key.
  String _label(String key, AppLocalizations l10n) => switch (key) {
        _keyMusculoskeletal => l10n.onboardingStep3Musculoskeletal,
        _keyCirculatory => l10n.onboardingStep3Circulatory,
        _keyRespiratory => l10n.onboardingStep3Respiratory,
        _keyNeurological => l10n.onboardingStep3Neurological,
        _ => l10n.onboardingStep3Other,
      };

  /// Returns the localized subtitle for a condition key (empty = no subtitle).
  String _subtitle(String key, AppLocalizations l10n) => switch (key) {
        _keyMusculoskeletal => l10n.onboardingStep3MusculoskeletalSub,
        _keyCirculatory => l10n.onboardingStep3CirculatorySub,
        _keyRespiratory => l10n.onboardingStep3RespiratorySub,
        _keyNeurological => l10n.onboardingStep3NeurologicalSub,
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep3Question,
          style: AppTextStyles.bodySemiBold,
        ),
        Text(
          l10n.onboardingStep3SelectAll,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ..._conditionKeys.map((key) {
          final subtitle = _subtitle(key, l10n);
          return CheckboxListTile(
            title: Text(_label(key, l10n), style: AppTextStyles.body),
            subtitle: subtitle.isNotEmpty
                ? Text(
                    subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  )
                : null,
            value: _selected.contains(key),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) => _toggle(key, checked),
          );
        }),
      ],
    );
  }
}
