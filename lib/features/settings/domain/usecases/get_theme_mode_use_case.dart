import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/settings_repository.dart';

@injectable
class GetThemeModeUseCase extends UseCase<AppThemeMode, NoParams> {
  final SettingsRepository _repository;

  GetThemeModeUseCase(this._repository);

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) =>
      _repository.getThemeMode();
}
