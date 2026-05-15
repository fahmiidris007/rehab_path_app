import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/onboarding_profile_entity.dart';
import '../../domain/enums/app_enums.dart';

part 'onboarding_profile_json_model.g.dart';

@JsonSerializable()
class OnboardingProfileJsonModel {
  final int age;
  final String gender;
  final int fallsInLastYear;
  final List<String> healthConditions;
  final bool usesWalkingAid;
  final int fearOfFallingScore;
  final String preferredExerciseTime;
  final int sessionDurationMinutes;
  final int weeklyFrequencyTarget;
  final String outcomeGoal;
  final String behaviouralGoal;
  final String programLevel;
  final int? lastCompletedStep;

  const OnboardingProfileJsonModel({
    required this.age,
    required this.gender,
    required this.fallsInLastYear,
    required this.healthConditions,
    required this.usesWalkingAid,
    required this.fearOfFallingScore,
    required this.preferredExerciseTime,
    required this.sessionDurationMinutes,
    required this.weeklyFrequencyTarget,
    required this.outcomeGoal,
    required this.behaviouralGoal,
    required this.programLevel,
    this.lastCompletedStep,
  });

  factory OnboardingProfileJsonModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingProfileJsonModelToJson(this);

  OnboardingProfileEntity toEntity() {
    return OnboardingProfileEntity(
      age: age,
      gender: gender,
      fallsInLastYear: fallsInLastYear,
      healthConditions: healthConditions,
      usesWalkingAid: usesWalkingAid,
      fearOfFallingScore: fearOfFallingScore,
      preferredExerciseTime: preferredExerciseTime,
      sessionDurationMinutes: sessionDurationMinutes,
      weeklyFrequencyTarget: weeklyFrequencyTarget,
      outcomeGoal: outcomeGoal,
      behaviouralGoal: behaviouralGoal,
      programLevel: ProgramLevel.values.firstWhere(
        (e) => e.name == programLevel,
        orElse: () => ProgramLevel.beginner,
      ),
      lastCompletedStep: lastCompletedStep,
    );
  }
}
