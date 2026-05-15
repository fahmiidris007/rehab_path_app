import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/data/models/user_hive_model.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final HiveDataSource _hiveDataSource;
  final Logger _logger;

  ProfileRepositoryImpl(this._hiveDataSource, this._logger);

  @override
  Future<Either<Failure, UserEntity>> getProfile(String userId) async {
    try {
      final user = _hiveDataSource.getUser(userId);
      if (user == null) {
        return Left(Failure.cache(message: 'User not found: $userId'));
      }
      return Right(user.toEntity());
    } catch (e, st) {
      _logger.e('GetProfile failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(UserEntity user) async {
    try {
      await _hiveDataSource.saveUser(UserHiveModel.fromEntity(user));
      return const Right(unit);
    } catch (e, st) {
      _logger.e('UpdateProfile failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
