import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';
import '../repositories/progress_repository.dart';

/// Persists a new [FallEventEntity] via the repository.
@injectable
class LogFallEventUseCase extends UseCase<Unit, FallEventEntity> {
  final ProgressRepository _repository;

  LogFallEventUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(FallEventEntity event) =>
      _repository.logFallEvent(event);
}
