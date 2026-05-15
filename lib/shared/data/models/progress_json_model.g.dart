// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressJsonModel _$ProgressJsonModelFromJson(Map<String, dynamic> json) =>
    ProgressJsonModel(
      userId: json['userId'] as String,
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) =>
              ExerciseSessionJsonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      balanceScores: (json['balanceScores'] as List<dynamic>)
          .map((e) => BalanceScoreJsonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProgressJsonModelToJson(ProgressJsonModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sessions': instance.sessions.map((e) => e.toJson()).toList(),
      'balanceScores': instance.balanceScores.map((e) => e.toJson()).toList(),
    };
