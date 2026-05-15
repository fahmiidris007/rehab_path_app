import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/progress_data_entity.dart';
import 'balance_score_json_model.dart';
import 'exercise_session_json_model.dart';

part 'progress_json_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProgressJsonModel {
  final String userId;
  final List<ExerciseSessionJsonModel> sessions;
  final List<BalanceScoreJsonModel> balanceScores;

  const ProgressJsonModel({
    required this.userId,
    required this.sessions,
    required this.balanceScores,
  });

  factory ProgressJsonModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressJsonModelToJson(this);

  ProgressDataEntity toEntity() {
    return ProgressDataEntity(
      userId: userId,
      sessions: sessions.map((e) => e.toEntity()).toList(),
      balanceScores: balanceScores.map((e) => e.toEntity()).toList(),
    );
  }
}
