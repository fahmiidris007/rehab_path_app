import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/notification_repository.dart';

class CheckStreakMilestoneParams extends Equatable {
  final int streakDays;

  const CheckStreakMilestoneParams({required this.streakDays});

  @override
  List<Object?> get props => [streakDays];
}

@injectable
class CheckStreakMilestoneUseCase
    extends UseCase<Unit, CheckStreakMilestoneParams> {
  final NotificationRepository _repository;

  CheckStreakMilestoneUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(CheckStreakMilestoneParams params) =>
      _repository.scheduleStreakMilestone(params.streakDays);
}
