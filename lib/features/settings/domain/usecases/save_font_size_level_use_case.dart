import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/settings_repository.dart';

@injectable
class SaveFontSizeLevelUseCase extends UseCase<Unit, FontSizeLevel> {
  final SettingsRepository _repository;

  SaveFontSizeLevelUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(FontSizeLevel params) =>
      _repository.saveFontSizeLevel(params);
}
