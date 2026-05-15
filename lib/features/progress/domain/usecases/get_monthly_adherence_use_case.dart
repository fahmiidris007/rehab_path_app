import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/progress_repository.dart';

class GetMonthlyAdherenceParams extends Equatable {
  /// Any date within the target month (year + month are used).
  final DateTime month;

  /// The number of sessions scheduled for the month.
  /// Defaults to the number of days in the given month.
  final int? scheduledSessions;

  const GetMonthlyAdherenceParams({
    required this.month,
    this.scheduledSessions,
  });

  @override
  List<Object?> get props => [month, scheduledSessions];
}

/// Returns a monthly adherence ratio in the range [0.0, 1.0].
///
/// Adherence = completedSessions / max(scheduledSessions, 1), clamped to 1.0.
@injectable
class GetMonthlyAdherenceUseCase
    extends UseCase<double, GetMonthlyAdherenceParams> {
  final ProgressRepository _repository;

  GetMonthlyAdherenceUseCase(this._repository);

  @override
  Future<Either<Failure, double>> call(
      GetMonthlyAdherenceParams params) async {
    final result = await _repository.getSessionsForMonth(params.month);
    return result.map((sessions) {
      final completed = sessions.length;
      final daysInMonth =
          DateTime(params.month.year, params.month.month + 1, 0).day;
      final scheduled =
          (params.scheduledSessions ?? daysInMonth) < 1 ? 1 : (params.scheduledSessions ?? daysInMonth);
      return (completed / scheduled).clamp(0.0, 1.0);
    });
  }
}
