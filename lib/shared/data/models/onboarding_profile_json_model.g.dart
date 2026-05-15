// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_profile_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingProfileJsonModel _$OnboardingProfileJsonModelFromJson(
        Map<String, dynamic> json) =>
    OnboardingProfileJsonModel(
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      fallsInLastYear: (json['fallsInLastYear'] as num).toInt(),
      healthConditions: (json['healthConditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      usesWalkingAid: json['usesWalkingAid'] as bool,
      fearOfFallingScore: (json['fearOfFallingScore'] as num).toInt(),
      preferredExerciseTime: json['preferredExerciseTime'] as String,
      sessionDurationMinutes: (json['sessionDurationMinutes'] as num).toInt(),
      weeklyFrequencyTarget: (json['weeklyFrequencyTarget'] as num).toInt(),
      outcomeGoal: json['outcomeGoal'] as String,
      behaviouralGoal: json['behaviouralGoal'] as String,
      programLevel: json['programLevel'] as String,
      lastCompletedStep: (json['lastCompletedStep'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OnboardingProfileJsonModelToJson(
        OnboardingProfileJsonModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'gender': instance.gender,
      'fallsInLastYear': instance.fallsInLastYear,
      'healthConditions': instance.healthConditions,
      'usesWalkingAid': instance.usesWalkingAid,
      'fearOfFallingScore': instance.fearOfFallingScore,
      'preferredExerciseTime': instance.preferredExerciseTime,
      'sessionDurationMinutes': instance.sessionDurationMinutes,
      'weeklyFrequencyTarget': instance.weeklyFrequencyTarget,
      'outcomeGoal': instance.outcomeGoal,
      'behaviouralGoal': instance.behaviouralGoal,
      'programLevel': instance.programLevel,
      'lastCompletedStep': instance.lastCompletedStep,
    };
