import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class SaveExerciseSessionUseCase
    implements UseCase<Unit, SaveExerciseSessionParams> {
  const SaveExerciseSessionUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveExerciseSessionParams params) {
    return _repository.saveSession(params.session);
  }
}

class SaveExerciseSessionParams extends Equatable {
  const SaveExerciseSessionParams(this.session);

  final ExerciseSessionEntity session;

  @override
  List<Object?> get props => [session];
}
