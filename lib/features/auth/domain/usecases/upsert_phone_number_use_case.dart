import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpsertPhoneNumberParams extends Equatable {
  final String userId;
  final String phoneNumber;

  const UpsertPhoneNumberParams({
    required this.userId,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [userId, phoneNumber];
}

@injectable
class UpsertPhoneNumberUseCase
    extends UseCase<UserEntity, UpsertPhoneNumberParams> {
  final AuthRepository _repository;

  UpsertPhoneNumberUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpsertPhoneNumberParams params) =>
      _repository.upsertPhoneNumber(params.userId, params.phoneNumber);
}
