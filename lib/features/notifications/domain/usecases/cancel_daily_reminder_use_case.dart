import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/notification_repository.dart';

@injectable
class CancelDailyReminderUseCase extends UseCase<Unit, NoParams> {
  final NotificationRepository _repository;

  CancelDailyReminderUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.cancelDailyReminder();
}
