import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/exercise_entity.dart';

part 'player_state.freezed.dart';

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState.idle(ExerciseEntity exercise) = PlayerIdle;
  const factory PlayerState.playing({
    required ExerciseEntity exercise,
    required int remainingSeconds,
  }) = PlayerPlaying;
  const factory PlayerState.paused({
    required ExerciseEntity exercise,
    required int remainingSeconds,
  }) = PlayerPaused;
  const factory PlayerState.selfReport(ExerciseEntity exercise) =
      PlayerSelfReport;
  const factory PlayerState.saving() = PlayerSaving;
  const factory PlayerState.saved() = PlayerSaved;
  const factory PlayerState.error(String message) = PlayerError;
}
