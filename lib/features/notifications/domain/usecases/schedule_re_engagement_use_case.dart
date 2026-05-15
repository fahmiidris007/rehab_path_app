import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/notification_repository.dart';

class ScheduleReEngagementParams extends Equatable {
  /// Time in HH:mm format (e.g. "09:00").
  final String time;

  const ScheduleReEngagementParams({required this.time});

  @override
  List<Object?> get props => [time];
}

@injectable
class ScheduleReEngagementUseCase
    extends UseCase<Unit, ScheduleReEngagementParams> {
  final NotificationRepository _repository;

  ScheduleReEngagementUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ScheduleReEngagementParams params) =>
      _repository.scheduleReEngagement(params.time);
}
