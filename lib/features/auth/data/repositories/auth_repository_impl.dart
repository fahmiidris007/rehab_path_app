import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../../../shared/data/models/user_hive_model.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final HiveDataSource _hiveDataSource;
  final SharedPreferencesDataSource _prefsDataSource;
  final Logger _logger;

  AuthRepositoryImpl(this._hiveDataSource, this._prefsDataSource, this._logger);

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      // Find user in Hive by email (dummy auth — any password accepted for matching email)
      final users = _hiveDataSource.getAllUsers();
      final match = users
          .where((u) => u.email.toLowerCase() == email.toLowerCase())
          .firstOrNull;
      if (match == null) {
        return Left(
            Failure.validation(message: 'No account found with that email.'));
      }
      // Store session
      await _prefsDataSource.setString(
          PrefKeys.sessionToken, 'token_${match.id}');
      await _prefsDataSource.setString(PrefKeys.sessionUserId, match.id);
      await _prefsDataSource.setBool(PrefKeys.isGuest, false);
      return Right(match.toEntity());
    } catch (e, st) {
      _logger.e('Login failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String name, String email, String password) async {
    try {
      // Check if email already exists
      final existing = _hiveDataSource
          .getAllUsers()
          .where((u) => u.email.toLowerCase() == email.toLowerCase())
          .firstOrNull;
      if (existing != null) {
        return Left(Failure.validation(
            message: 'An account with this email already exists.'));
      }
      // Create new user
      final id = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final newUser = UserHiveModel(
        id: id,
        name: name,
        email: email,
        age: 0,
        gender: '',
        programLevel: 'beginner',
        healthConditions: [],
        emergencyContacts: [],
      );
      await _hiveDataSource.saveUser(newUser);
      // Store session
      await _prefsDataSource.setString(PrefKeys.sessionToken, 'token_$id');
      await _prefsDataSource.setString(PrefKeys.sessionUserId, id);
      await _prefsDataSource.setBool(PrefKeys.isGuest, false);
      return Right(newUser.toEntity());
    } catch (e, st) {
      _logger.e('Register failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _prefsDataSource.remove(PrefKeys.sessionToken);
      await _prefsDataSource.remove(PrefKeys.sessionUserId);
      await _prefsDataSource.remove(PrefKeys.isGuest);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('Logout failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getSession() async {
    try {
      final token = _prefsDataSource.getString(PrefKeys.sessionToken);
      if (token == null) return const Right(null);
      final userId = _prefsDataSource.getString(PrefKeys.sessionUserId);
      if (userId == null) return const Right(null);
      final isGuest = _prefsDataSource.getBool(PrefKeys.isGuest) ?? false;
      if (isGuest) {
        // Return a guest user entity
        return Right(const UserEntity(
          id: 'guest',
          name: 'Guest',
          email: '',
          age: 0,
          gender: '',
          programLevel: ProgramLevel.beginner,
          healthConditions: [],
          emergencyContacts: [],
        ));
      }
      final user = _hiveDataSource.getUser(userId);
      return Right(user?.toEntity());
    } catch (e, st) {
      _logger.e('GetSession failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createGuestSession() async {
    try {
      await _prefsDataSource.setString(
          PrefKeys.sessionToken, 'guest_token');
      await _prefsDataSource.setString(PrefKeys.sessionUserId, 'guest');
      await _prefsDataSource.setBool(PrefKeys.isGuest, true);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('CreateGuestSession failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }
}
