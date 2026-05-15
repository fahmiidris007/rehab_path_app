import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';
import '../repositories/progress_repository.dart';

/// Returns all [FallEventEntity] entries for the month containing [month].
@injectable
class GetFallEventsForMonthUseCase
    extends UseCase<List<FallEventEntity>, DateTime> {
  final ProgressRepository _repository;

  GetFallEventsForMonthUseCase(this._repository);

  @override
  Future<Either<Failure, List<FallEventEntity>>> call(DateTime month) =>
      _repository.getFallEventsForMonth(month);
}
