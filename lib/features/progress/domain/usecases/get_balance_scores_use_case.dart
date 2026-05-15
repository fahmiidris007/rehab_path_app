import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/balance_score_point.dart';
import '../repositories/progress_repository.dart';

/// Returns the list of [BalanceScorePoint] entries for the given user.
@injectable
class GetBalanceScoresUseCase
    extends UseCase<List<BalanceScorePoint>, String> {
  final ProgressRepository _repository;

  GetBalanceScoresUseCase(this._repository);

  @override
  Future<Either<Failure, List<BalanceScorePoint>>> call(String userId) =>
      _repository.getBalanceScores(userId);
}
