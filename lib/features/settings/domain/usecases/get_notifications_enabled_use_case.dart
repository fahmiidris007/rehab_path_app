import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/settings_repository.dart';

@injectable
class GetNotificationsEnabledUseCase extends UseCase<bool, NoParams> {
  final SettingsRepository _repository;

  GetNotificationsEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.getNotificationsEnabled();
}
