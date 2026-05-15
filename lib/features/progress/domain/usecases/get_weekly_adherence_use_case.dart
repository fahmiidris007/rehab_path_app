import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/progress_repository.dart';

class GetWeeklyAdherenceParams extends Equatable {
  /// The Monday (or any day) that marks the start of the week to query.
  final DateTime weekStart;

  /// The number of sessions scheduled for the week.
  /// Defaults to 7 (one per day).
  final int scheduledSessions;

  const GetWeeklyAdherenceParams({
    required this.weekStart,
    this.scheduledSessions = 7,
  });

  @override
  List<Object?> get props => [weekStart, scheduledSessions];
}

/// Returns a weekly adherence ratio in the range [0.0, 1.0].
///
/// Adherence = completedSessions / max(scheduledSessions, 1), clamped to 1.0.
@injectable
class GetWeeklyAdherenceUseCase
    extends UseCase<double, GetWeeklyAdherenceParams> {
  final ProgressRepository _repository;

  GetWeeklyAdherenceUseCase(this._repository);

  @override
  Future<Either<Failure, double>> call(
      GetWeeklyAdherenceParams params) async {
    final result = await _repository.getSessionsForWeek(params.weekStart);
    return result.map((sessions) {
      final completed = sessions.length;
      final scheduled = params.scheduledSessions < 1 ? 1 : params.scheduledSessions;
      return (completed / scheduled).clamp(0.0, 1.0);
    });
  }
}
