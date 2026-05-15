import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/use_case.dart';
import '../../domain/usecases/get_all_exercises_use_case.dart';
import 'exercise_state.dart';

@injectable
class ExerciseCubit extends Cubit<ExerciseState> {
  final GetAllExercisesUseCase _getAllExercisesUseCase;

  ExerciseCubit(this._getAllExercisesUseCase)
      : super(const ExerciseState.loading());

  Future<void> loadExercises() async {
    emit(const ExerciseState.loading());
    final result = await _getAllExercisesUseCase(const NoParams());
    result.fold(
      (failure) => emit(ExerciseState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      (exercises) => emit(ExerciseState.loaded(exercises)),
    );
  }
}
