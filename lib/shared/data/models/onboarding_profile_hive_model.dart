import 'package:hive/hive.dart';

import '../../domain/entities/onboarding_profile_entity.dart';
import '../../domain/enums/app_enums.dart';

part 'onboarding_profile_hive_model.g.dart';

@HiveType(typeId: 2)
class OnboardingProfileHiveModel extends HiveObject {
  @HiveField(0)
  int age;

  @HiveField(1)
  String gender;

  @HiveField(2)
  int fallsInLastYear;

  @HiveField(3)
  List<String> healthConditions;

  @HiveField(4)
  bool usesWalkingAid;

  @HiveField(5)
  int fearOfFallingScore;

  @HiveField(6)
  String preferredExerciseTime;

  @HiveField(7)
  int sessionDurationMinutes;

  @HiveField(8)
  int weeklyFrequencyTarget;

  @HiveField(9)
  String outcomeGoal;

  @HiveField(10)
  String behaviouralGoal;

  @HiveField(11)
  String programLevel;

  @HiveField(12)
  int? lastCompletedStep;

  OnboardingProfileHiveModel({
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

  static OnboardingProfileHiveModel fromEntity(
    OnboardingProfileEntity entity,
  ) {
    return OnboardingProfileHiveModel(
      age: entity.age,
      gender: entity.gender,
      fallsInLastYear: entity.fallsInLastYear,
      healthConditions: entity.healthConditions,
      usesWalkingAid: entity.usesWalkingAid,
      fearOfFallingScore: entity.fearOfFallingScore,
      preferredExerciseTime: entity.preferredExerciseTime,
      sessionDurationMinutes: entity.sessionDurationMinutes,
      weeklyFrequencyTarget: entity.weeklyFrequencyTarget,
      outcomeGoal: entity.outcomeGoal,
      behaviouralGoal: entity.behaviouralGoal,
      programLevel: entity.programLevel.name,
      lastCompletedStep: entity.lastCompletedStep,
    );
  }
}
