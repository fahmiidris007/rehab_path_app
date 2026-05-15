import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/settings_repository.dart';

@injectable
class SaveThemeModeUseCase extends UseCase<Unit, AppThemeMode> {
  final SettingsRepository _repository;

  SaveThemeModeUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AppThemeMode params) =>
      _repository.saveThemeMode(params);
}
