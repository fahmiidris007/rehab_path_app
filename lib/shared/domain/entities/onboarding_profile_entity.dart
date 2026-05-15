import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'onboarding_profile_entity.freezed.dart';

@freezed
class OnboardingProfileEntity with _$OnboardingProfileEntity {
  const factory OnboardingProfileEntity({
    required int age,
    required String gender,
    required int fallsInLastYear,
    required List<String> healthConditions,
    required bool usesWalkingAid,
    required int fearOfFallingScore,
    required String preferredExerciseTime,
    required int sessionDurationMinutes,
    required int weeklyFrequencyTarget,
    required String outcomeGoal,
    required String behaviouralGoal,
    required ProgramLevel programLevel,
    int? lastCompletedStep,
  }) = _OnboardingProfileEntity;
}
