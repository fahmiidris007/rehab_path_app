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
  /// Deprecated as of task 13.1: the player now auto-saves on timer-zero
  /// or skip rather than transitioning through a self-report sheet. The
  /// case is retained in the union for type-compatibility with existing
  /// pattern matches; new code SHOULD NOT emit this state.
  @Deprecated('Auto-save replaces self-report; see task 13.1')
  const factory PlayerState.selfReport(ExerciseEntity exercise) =
      PlayerSelfReport;
  const factory PlayerState.saving() = PlayerSaving;
  const factory PlayerState.saved() = PlayerSaved;
  const factory PlayerState.error(String message) = PlayerError;
}
