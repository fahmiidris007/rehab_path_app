import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_score_point.freezed.dart';

@freezed
class BalanceScorePoint with _$BalanceScorePoint {
  const factory BalanceScorePoint({
    required DateTime date,
    required int score,
  }) = _BalanceScorePoint;
}
