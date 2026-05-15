import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/notification_repository.dart';

@injectable
class RequestNotificationPermissionUseCase extends UseCase<bool, NoParams> {
  final NotificationRepository _repository;

  RequestNotificationPermissionUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.requestPermission();
}
