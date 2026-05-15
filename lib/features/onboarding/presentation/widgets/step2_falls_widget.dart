import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 2 — Falls History
///
/// Collects the number of falls in the last 12 months (non-negative integer).
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

  /// Validates and returns true if the form is valid.
  bool validate() => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How many times have you fallen in the last 12 months?',
            style: AppTextStyles.bodySemiBold,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fallsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Enter number of falls',
              suffixText: 'times',
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of falls (enter 0 if none)';
              }
              final falls = int.tryParse(value);
              if (falls == null || falls < 0) {
                return 'Please enter a valid number (0 or more)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
