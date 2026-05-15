import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class DeletePartialSessionUseCase
    implements UseCase<Unit, DeletePartialSessionParams> {
  const DeletePartialSessionUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeletePartialSessionParams params) {
    return _repository.deletePartialSession(params.sessionId);
  }
}

class DeletePartialSessionParams extends Equatable {
  const DeletePartialSessionParams(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}
