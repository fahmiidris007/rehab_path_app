import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/exercise_entity.dart';

part 'exercise_state.freezed.dart';

@freezed
sealed class ExerciseState with _$ExerciseState {
  const factory ExerciseState.loading() = ExerciseLoading;
  const factory ExerciseState.loaded(List<ExerciseEntity> exercises) =
      ExerciseLoaded;
  const factory ExerciseState.error(String message) = ExerciseError;
}
