import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 7 — Goals
class Step7GoalsWidget extends StatefulWidget {
  const Step7GoalsWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step7GoalsWidget> createState() => Step7GoalsWidgetState();
}

class Step7GoalsWidgetState extends State<Step7GoalsWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _outcomeController;
  late final TextEditingController _behaviouralController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _outcomeController = TextEditingController(text: p?.outcomeGoal ?? '');
    _behaviouralController =
        TextEditingController(text: p?.behaviouralGoal ?? '');
  }

  @override
  void dispose() {
    _outcomeController.dispose();
    _behaviouralController.dispose();
    super.dispose();
  }

  void _notify() {
    final p = widget.profile;
    final updated = (p ?? _defaultProfile()).copyWith(
      outcomeGoal: _outcomeController.text,
      behaviouralGoal: _behaviouralController.text,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Outcome goal ─────────────────────────────────────────────────
          Text(l10n.onboardingStep7OutcomeLabel, style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: _outcomeController,
            maxLength: 500,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: l10n.onboardingStep7OutcomeHint,
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.onboardingStep7OutcomeRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // ── Behavioural goal ─────────────────────────────────────────────
          Text(l10n.onboardingStep7BehaviouralLabel, style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: _behaviouralController,
            maxLength: 500,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: l10n.onboardingStep7BehaviouralHint,
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.onboardingStep7BehaviouralRequired;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
