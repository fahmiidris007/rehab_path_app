import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/domain/entities/badge_entity.dart';
import '../../../../shared/domain/entities/balance_score_point.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';
import '../../domain/usecases/check_and_award_badges_use_case.dart';
import '../../domain/usecases/get_badges_use_case.dart';
import '../../domain/usecases/get_balance_scores_use_case.dart';
import '../../domain/usecases/get_fall_events_for_month_use_case.dart';
import '../../domain/usecases/get_monthly_adherence_use_case.dart';
import '../../domain/usecases/get_weekly_adherence_use_case.dart';
import '../../domain/usecases/log_fall_event_use_case.dart';
import '../../domain/usecases/remove_fall_event_use_case.dart';
import 'progress_state.dart';

@injectable
class ProgressCubit extends Cubit<ProgressState> {
  final GetWeeklyAdherenceUseCase _weeklyAdherenceUseCase;
  final GetMonthlyAdherenceUseCase _monthlyAdherenceUseCase;
  final GetBalanceScoresUseCase _balanceScoresUseCase;
  final LogFallEventUseCase _logFallUseCase;
  final RemoveFallEventUseCase _removeFallUseCase;
  final GetFallEventsForMonthUseCase _fallEventsUseCase;
  final GetBadgesUseCase _badgesUseCase;
  final CheckAndAwardBadgesUseCase _checkBadgesUseCase;

  ProgressCubit(
    this._weeklyAdherenceUseCase,
    this._monthlyAdherenceUseCase,
    this._balanceScoresUseCase,
    this._logFallUseCase,
    this._removeFallUseCase,
    this._fallEventsUseCase,
    this._badgesUseCase,
    this._checkBadgesUseCase,
  ) : super(const ProgressState.loading());

  Future<void> loadProgress(String userId) async {
    emit(const ProgressState.loading());
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      final results = await Future.wait([
        _weeklyAdherenceUseCase(GetWeeklyAdherenceParams(weekStart: weekStart)),
        _monthlyAdherenceUseCase(GetMonthlyAdherenceParams(month: now)),
        _balanceScoresUseCase(userId),
        _fallEventsUseCase(now),
        _badgesUseCase(userId),
      ]);

      final weeklyRate =
          results[0].fold((_) => 0.0, (v) => v as double);
      final monthlyRate =
          results[1].fold((_) => 0.0, (v) => v as double);
      final balanceScores = results[2]
          .fold((_) => <BalanceScorePoint>[], (v) => v as List<BalanceScorePoint>);
      final fallEvents = results[3]
          .fold((_) => <FallEventEntity>[], (v) => v as List<FallEventEntity>);
      final badges = results[4]
          .fold((_) => <BadgeEntity>[], (v) => v as List<BadgeEntity>);

      // Compute worked muscle groups for this week
      final workedGroups = _computeWorkedMuscleGroups([]);

      emit(ProgressState.loaded(ProgressViewData(
        weeklyAdherenceRate: weeklyRate,
        monthlyAdherenceRate: monthlyRate,
        balanceScores: balanceScores,
        fallEventsThisMonth: fallEvents,
        badges: badges,
        recentSessions: [],
        workedMuscleGroups: workedGroups,
      )));
    } catch (e) {
      emit(ProgressState.error(e.toString()));
    }
  }

  Future<void> logFall(String userId, DateTime date) async {
    final event = FallEventEntity(
      id: 'fall_${date.millisecondsSinceEpoch}',
      userId: userId,
      date: date,
    );
    final result = await _logFallUseCase(event);
    result.fold(
      (failure) => null, // show error in UI
      (_) => loadProgress(userId),
    );
  }

  Future<void> removeFall(String userId, String eventId) async {
    final result = await _removeFallUseCase(eventId);
    result.fold(
      (failure) => null,
      (_) => loadProgress(userId),
    );
  }

  Future<void> checkAndAwardBadges(String userId) async {
    await _checkBadgesUseCase(userId);
    // Reload to reflect newly awarded badges
    await loadProgress(userId);
  }

  Set<String> _computeWorkedMuscleGroups(
      List<ExerciseSessionEntity> sessions) {
    // Placeholder — will be populated with actual category-to-muscle mapping
    return {};
  }
}
