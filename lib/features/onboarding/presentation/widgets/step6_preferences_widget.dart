import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

/// Step 6 — Exercise Preferences
///
/// Collects preferred exercise time (time picker), session duration (10–120 min),
/// and weekly frequency (1–7 days).
class Step6PreferencesWidget extends StatefulWidget {
  const Step6PreferencesWidget({
    super.key,
    required this.profile,
    required this.onDataChanged,
  });

  final OnboardingProfileEntity? profile;
  final ValueChanged<OnboardingProfileEntity> onDataChanged;

  @override
  State<Step6PreferencesWidget> createState() => Step6PreferencesWidgetState();
}

class Step6PreferencesWidgetState extends State<Step6PreferencesWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _durationController;
  late final TextEditingController _frequencyController;
  late final TextEditingController _timeController;
  late TimeOfDay _preferredTime;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    // Parse stored time string (HH:mm) or default to 08:00
    _preferredTime = _parseTime(p?.preferredExerciseTime ?? '08:00');

    _timeController = TextEditingController(
      text: _formatTime(_preferredTime),
    );
    _durationController = TextEditingController(
      text: (p != null && p.sessionDurationMinutes > 0)
          ? p.sessionDurationMinutes.toString()
          : '',
    );
    _frequencyController = TextEditingController(
      text: (p != null && p.weeklyFrequencyTarget > 0)
          ? p.weeklyFrequencyTarget.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    _durationController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 8, minute: 0);
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _preferredTime,
    );
    if (picked != null) {
      setState(() {
        _preferredTime = picked;
        _timeController.text = _formatTime(picked);
      });
      _notify();
    }
  }

  void _notify() {
    final duration = int.tryParse(_durationController.text) ?? 0;
    final frequency = int.tryParse(_frequencyController.text) ?? 0;
    final p = widget.profile;
    final updated = (p ?? _defaultProfile()).copyWith(
      preferredExerciseTime: _formatTime(_preferredTime),
      sessionDurationMinutes: duration,
      weeklyFrequencyTarget: frequency,
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
          // ── Preferred exercise time ──────────────────────────────────────
          Text('Preferred exercise time', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickTime,
            child: AbsorbPointer(
              child: TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Select time',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Session duration ─────────────────────────────────────────────
          Text('Session duration', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Enter duration',
              suffixText: 'minutes',
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter session duration';
              }
              final mins = int.tryParse(value);
              if (mins == null || mins < 10 || mins > 120) {
                return 'Duration must be between 10 and 120 minutes';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // ── Weekly frequency ─────────────────────────────────────────────
          Text('Weekly frequency', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: _frequencyController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Enter frequency',
              suffixText: 'days per week',
            ),
            onChanged: (_) => _notify(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter weekly frequency';
              }
              final days = int.tryParse(value);
              if (days == null || days < 1 || days > 7) {
                return 'Frequency must be between 1 and 7 days per week';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
