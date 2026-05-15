import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/progress_repository.dart';

/// Removes a fall event identified by [eventId].
@injectable
class RemoveFallEventUseCase extends UseCase<Unit, String> {
  final ProgressRepository _repository;

  RemoveFallEventUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String eventId) =>
      _repository.removeFallEvent(eventId);
}
