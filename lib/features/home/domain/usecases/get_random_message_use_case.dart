import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../repositories/message_repository.dart';

@injectable
class GetRandomMessageUseCase
    extends UseCase<MotivationalMessageEntity, NoParams> {
  final MessageRepository _repository;

  GetRandomMessageUseCase(this._repository);

  @override
  Future<Either<Failure, MotivationalMessageEntity>> call(NoParams params) =>
      _repository.getRandomMessage();
}
