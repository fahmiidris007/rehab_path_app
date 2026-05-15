import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/usecases/delete_partial_session_use_case.dart';
import '../../domain/usecases/save_exercise_session_use_case.dart';
import 'player_state.dart';

@injectable
class ExercisePlayerCubit extends Cubit<PlayerState> {
  final SaveExerciseSessionUseCase _saveSessionUseCase;
  final DeletePartialSessionUseCase _deletePartialSessionUseCase;

  Timer? _timer;
  String? _currentSessionId;

  ExercisePlayerCubit(
    this._saveSessionUseCase,
    this._deletePartialSessionUseCase,
  ) : super(const PlayerState.idle(ExerciseEntity(
          id: '',
          name: '',
          category: ExerciseCategory.warmUp,
          description: '',
          steps: [],
          durationSeconds: 0,
          sets: 0,
          reps: 0,
          difficulty: 1,
          safetyTips: [],
          imagePath: '',
        )));

  void startExercise(ExerciseEntity exercise) {
    _currentSessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    emit(PlayerState.playing(
      exercise: exercise,
      remainingSeconds: exercise.durationSeconds,
    ));
    _startTimer(exercise);
  }

  void _startTimer(ExerciseEntity exercise) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is PlayerPlaying) {
        final current = state as PlayerPlaying;
        if (current.remainingSeconds <= 1) {
          timer.cancel();
          emit(PlayerState.selfReport(exercise));
        } else {
          emit(PlayerState.playing(
            exercise: exercise,
            remainingSeconds: current.remainingSeconds - 1,
          ));
        }
      }
    });
  }

  void pause() {
    if (state is PlayerPlaying) {
      _timer?.cancel();
      final current = state as PlayerPlaying;
      emit(PlayerState.paused(
        exercise: current.exercise,
        remainingSeconds: current.remainingSeconds,
      ));
    }
  }

  void resume() {
    if (state is PlayerPaused) {
      final current = state as PlayerPaused;
      emit(PlayerState.playing(
        exercise: current.exercise,
        remainingSeconds: current.remainingSeconds,
      ));
      _startTimer(current.exercise);
    }
  }

  void skip() {
    _timer?.cancel();
    if (state is PlayerPlaying || state is PlayerPaused) {
      final exercise = state is PlayerPlaying
          ? (state as PlayerPlaying).exercise
          : (state as PlayerPaused).exercise;
      emit(PlayerState.selfReport(exercise));
    }
  }

  Future<void> submitSelfReport({
    required String userId,
    required ExerciseEntity exercise,
    required BodyCondition bodyCondition,
    required SupportUsed supportUsed,
  }) async {
    emit(const PlayerState.saving());
    final session = ExerciseSessionEntity(
      id: _currentSessionId ??
          'session_${DateTime.now().millisecondsSinceEpoch}',
      exerciseId: exercise.id,
      userId: userId,
      completedAt: DateTime.now(),
      bodyCondition: bodyCondition,
      supportUsed: supportUsed,
    );
    final result =
        await _saveSessionUseCase(SaveExerciseSessionParams(session));
    result.fold(
      (failure) => emit(PlayerState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      (_) {
        _currentSessionId = null;
        emit(const PlayerState.saved());
      },
    );
  }

  Future<void> cancelSession() async {
    _timer?.cancel();
    if (_currentSessionId != null) {
      await _deletePartialSessionUseCase(
          DeletePartialSessionParams(_currentSessionId!));
      _currentSessionId = null;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
