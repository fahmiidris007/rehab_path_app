import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/settings_repository.dart';

@injectable
class GetFontSizeLevelUseCase extends UseCase<FontSizeLevel, NoParams> {
  final SettingsRepository _repository;

  GetFontSizeLevelUseCase(this._repository);

  @override
  Future<Either<Failure, FontSizeLevel>> call(NoParams params) =>
      _repository.getFontSizeLevel();
}
