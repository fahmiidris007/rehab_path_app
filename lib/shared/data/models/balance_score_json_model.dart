import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/balance_score_point.dart';

part 'balance_score_json_model.g.dart';

@JsonSerializable()
class BalanceScoreJsonModel {
  final String date;
  final int score;

  const BalanceScoreJsonModel({
    required this.date,
    required this.score,
  });

  factory BalanceScoreJsonModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceScoreJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceScoreJsonModelToJson(this);

  BalanceScorePoint toEntity() {
    return BalanceScorePoint(
      date: DateTime.parse(date),
      score: score,
    );
  }
}
