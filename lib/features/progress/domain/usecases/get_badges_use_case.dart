import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/badge_entity.dart';
import '../repositories/progress_repository.dart';

/// Returns all [BadgeEntity] entries for the given user.
@injectable
class GetBadgesUseCase extends UseCase<List<BadgeEntity>, String> {
  final ProgressRepository _repository;

  GetBadgesUseCase(this._repository);

  @override
  Future<Either<Failure, List<BadgeEntity>>> call(String userId) =>
      _repository.getBadges(userId);
}
