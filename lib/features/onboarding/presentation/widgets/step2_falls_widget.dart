import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 2 — Falls History
class Step2FallsWidget extends StatefulWidget {
  const Step2FallsWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step2FallsWidget> createState() => Step2FallsWidgetState();
}

class Step2FallsWidgetState extends State<Step2FallsWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fallsController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _fallsController = TextEditingController(
      text: (p != null && p.fallsInLastYear > 0)
          ? p.fallsInLastYear.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _fallsController.dispose();
    super.dispose();
  }

  void _notify() {
    final falls = int.tryParse(_fallsController.text) ?? 0;
    final p = widget.profile;
    final updated = (p ?? _defaultProfile()).copyWith(fallsInLastYear: falls);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingStep2Question,
            style: AppTextStyles.bodySemiBold,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fallsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: l10n.onboardingStep2Hint,
              suffixText: l10n.onboardingStep2Suffix,
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.onboardingStep2Required;
              }
              final falls = int.tryParse(value);
              if (falls == null || falls < 0) {
                return l10n.onboardingStep2Invalid;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
