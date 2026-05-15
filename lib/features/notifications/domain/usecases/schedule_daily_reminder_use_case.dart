import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/notification_repository.dart';

class ScheduleDailyReminderParams extends Equatable {
  /// Time in HH:mm format (e.g. "08:30").
  final String time;

  const ScheduleDailyReminderParams({required this.time});

  @override
  List<Object?> get props => [time];
}

@injectable
class ScheduleDailyReminderUseCase
    extends UseCase<Unit, ScheduleDailyReminderParams> {
  final NotificationRepository _repository;

  ScheduleDailyReminderUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ScheduleDailyReminderParams params) =>
      _repository.scheduleDailyReminder(params.time);
}
