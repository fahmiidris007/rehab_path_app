import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/settings_repository.dart';

@injectable
class SaveLocaleUseCase extends UseCase<Unit, AppLocale> {
  final SettingsRepository _repository;

  SaveLocaleUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AppLocale params) =>
      _repository.saveLocale(params);
}
