import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';

abstract class MessageRepository {
  Future<Either<Failure, MotivationalMessageEntity>> getRandomMessage();
}
