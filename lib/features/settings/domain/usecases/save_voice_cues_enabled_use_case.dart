import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/settings_repository.dart';

class SaveVoiceCuesEnabledParams extends Equatable {
  final bool enabled;

  const SaveVoiceCuesEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

@injectable
class SaveVoiceCuesEnabledUseCase
    extends UseCase<Unit, SaveVoiceCuesEnabledParams> {
  final SettingsRepository _repository;

  SaveVoiceCuesEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SaveVoiceCuesEnabledParams params) =>
      _repository.saveVoiceCuesEnabled(params.enabled);
}
