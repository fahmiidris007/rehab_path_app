import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/dummy_data_source.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../../domain/repositories/message_repository.dart';

@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final DummyDataSource _dummyDataSource;
  final Logger _logger;

  MessageRepositoryImpl(this._dummyDataSource, this._logger);

  @override
  Future<Either<Failure, MotivationalMessageEntity>> getRandomMessage() async {
    try {
      final messages = await _dummyDataSource.loadMessages();
      if (messages.isEmpty) {
        return const Left(Failure.cache(message: 'No messages available'));
      }
      final index = DateTime.now().millisecondsSinceEpoch % messages.length;
      return Right(messages[index]);
    } catch (e, st) {
      _logger.e('GetRandomMessage failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
