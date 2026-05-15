// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_score_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceScoreJsonModel _$BalanceScoreJsonModelFromJson(
        Map<String, dynamic> json) =>
    BalanceScoreJsonModel(
      date: json['date'] as String,
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$BalanceScoreJsonModelToJson(
        BalanceScoreJsonModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'score': instance.score,
    };
