import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
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
  String? _currentUserId;

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

  void startExercise(ExerciseEntity exercise, {required String userId}) {
    _currentUserId = userId;
    _currentSessionId =
        'session_${userId}_${DateTime.now().microsecondsSinceEpoch}';
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
          // Fire-and-forget: Timer.periodic callback cannot be async cleanly.
          // _persistAndEmitSaved will cancel any residual timer and emit
          // saving → saved/error states.
          unawaited(_persistAndEmitSaved(exercise));
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

  /// Public alias for [pause], invoked when the host app reports a
  /// lifecycle transition to paused/inactive (R12.2).
  Future<void> onAppPaused() async => pause();

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

  Future<void> skip() async {
    _timer?.cancel();
    if (state is PlayerPlaying || state is PlayerPaused) {
      final exercise = state is PlayerPlaying
          ? (state as PlayerPlaying).exercise
          : (state as PlayerPaused).exercise;
      await _persistAndEmitSaved(exercise);
    }
  }

  Future<void> _persistAndEmitSaved(ExerciseEntity exercise) async {
    _timer?.cancel();
    emit(const PlayerState.saving());
    final session = ExerciseSessionEntity(
      id: _currentSessionId ??
          'session_${_currentUserId ?? 'unknown'}_${DateTime.now().microsecondsSinceEpoch}',
      exerciseId: exercise.id,
      userId: _currentUserId ?? '',
      completedAt: DateTime.now(),
      bodyCondition: BodyCondition.standing,
      supportUsed: SupportUsed.noSupport,
    );
    final result =
        await _saveSessionUseCase(SaveExerciseSessionParams(session));
    result.fold(
      (failure) => emit(PlayerState.error(_messageOf(failure))),
      (_) {
        _currentSessionId = null;
        emit(const PlayerState.saved());
      },
    );
  }

  String _messageOf(Failure failure) => failure.when(
        server: (m, _) => m,
        cache: (m) => m,
        validation: (m, _) => m,
        unexpected: (m) => m,
      );

  @Deprecated('Use auto-save flow; see task 13.1')
  Future<void> submitSelfReport({
    required String userId,
    required ExerciseEntity exercise,
    required BodyCondition bodyCondition,
    required SupportUsed supportUsed,
  }) async {
    _currentUserId ??= userId;
    await _persistAndEmitSaved(exercise);
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
