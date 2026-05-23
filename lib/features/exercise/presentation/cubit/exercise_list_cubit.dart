import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/usecases/get_all_exercises_use_case.dart';
import '../../domain/usecases/get_today_schedule_use_case.dart';
import 'exercise_list_state.dart';

@injectable
class ExerciseListCubit extends Cubit<ExerciseListState> {
  ExerciseListCubit(
    this._getTodayScheduleUseCase,
    this._getAllExercisesUseCase,
  ) : super(const ExerciseListState.loading());

  final GetTodayScheduleUseCase _getTodayScheduleUseCase;
  final GetAllExercisesUseCase _getAllExercisesUseCase;

  Future<void> loadInitial(String userId) => _loadTodaySchedule(userId);

  Future<void> switchToTodayMode(String userId) => _loadTodaySchedule(userId);

  Future<void> switchToAllMode() async {
    emit(const ExerciseListState.loading());
    final result = await _getAllExercisesUseCase(const NoParams());
    result.fold(
      (failure) => emit(ExerciseListState.error(_messageFor(failure))),
      (exercises) =>
          emit(ExerciseListState.allMode(allExercises: exercises)),
    );
  }

  Future<void> _loadTodaySchedule(String userId) async {
    emit(const ExerciseListState.loading());
    final result =
        await _getTodayScheduleUseCase(GetTodayScheduleParams(userId));
    result.fold(
      (failure) => emit(ExerciseListState.error(_messageFor(failure))),
      (schedule) =>
          emit(ExerciseListState.todayMode(todaySchedule: schedule)),
    );
  }

  String _messageFor(Failure failure) => failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      );
}
