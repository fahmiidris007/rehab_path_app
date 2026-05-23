import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/exercise_entity.dart';

part 'exercise_list_state.freezed.dart';

@freezed
sealed class ExerciseListState with _$ExerciseListState {
  const factory ExerciseListState.loading() = ExerciseListLoading;
  const factory ExerciseListState.todayMode({
    required List<ExerciseEntity> todaySchedule,
  }) = ExerciseListTodayMode;
  const factory ExerciseListState.allMode({
    required List<ExerciseEntity> allExercises,
  }) = ExerciseListAllMode;
  const factory ExerciseListState.error(String message) = ExerciseListError;
}
