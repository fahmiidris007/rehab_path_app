import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/settings_repository.dart';

@injectable
class GetLocaleUseCase extends UseCase<AppLocale, NoParams> {
  final SettingsRepository _repository;

  GetLocaleUseCase(this._repository);

  @override
  Future<Either<Failure, AppLocale>> call(NoParams params) =>
      _repository.getLocale();
}
