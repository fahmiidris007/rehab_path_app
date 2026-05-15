// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseJsonModel _$ExerciseJsonModelFromJson(Map<String, dynamic> json) =>
    ExerciseJsonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      difficulty: (json['difficulty'] as num).toInt(),
      safetyTips: (json['safetyTips'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imagePath: json['imagePath'] as String,
      recommendedLevel: json['recommendedLevel'] as String?,
    );

Map<String, dynamic> _$ExerciseJsonModelToJson(ExerciseJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'steps': instance.steps,
      'durationSeconds': instance.durationSeconds,
      'sets': instance.sets,
      'reps': instance.reps,
      'difficulty': instance.difficulty,
      'safetyTips': instance.safetyTips,
      'imagePath': instance.imagePath,
      'recommendedLevel': instance.recommendedLevel,
    };
