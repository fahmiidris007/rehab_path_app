import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutUseCase extends UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.logout();
}
