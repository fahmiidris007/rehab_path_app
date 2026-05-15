import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/settings_repository.dart';

class SaveNotificationsEnabledParams extends Equatable {
  final bool enabled;

  const SaveNotificationsEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

@injectable
class SaveNotificationsEnabledUseCase
    extends UseCase<Unit, SaveNotificationsEnabledParams> {
  final SettingsRepository _repository;

  SaveNotificationsEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SaveNotificationsEnabledParams params) =>
      _repository.saveNotificationsEnabled(params.enabled);
}
