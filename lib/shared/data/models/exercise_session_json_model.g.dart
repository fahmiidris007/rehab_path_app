// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_session_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseSessionJsonModel _$ExerciseSessionJsonModelFromJson(
        Map<String, dynamic> json) =>
    ExerciseSessionJsonModel(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      userId: json['userId'] as String,
      completedAt: json['completedAt'] as String,
      bodyCondition: json['bodyCondition'] as String,
      supportUsed: json['supportUsed'] as String,
    );

Map<String, dynamic> _$ExerciseSessionJsonModelToJson(
        ExerciseSessionJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exerciseId': instance.exerciseId,
      'userId': instance.userId,
      'completedAt': instance.completedAt,
      'bodyCondition': instance.bodyCondition,
      'supportUsed': instance.supportUsed,
    };
