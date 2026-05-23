import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
    String phoneNumber,
    String password,
  );
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phoneNumber,
    required String password,
  });
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, UserEntity?>> getSession();
  Future<Either<Failure, Unit>> createGuestSession();
  Future<Either<Failure, bool>> isPhoneNumberTaken(String phoneNumber);
  Future<Either<Failure, UserEntity>> upsertPhoneNumber(
    String userId,
    String phoneNumber,
  );
}
