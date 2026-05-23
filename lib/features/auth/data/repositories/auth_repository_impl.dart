import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/phone_number_normalizer.dart';
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
    String phoneNumber,
    String password,
  ) async {
    try {
      final normalized = PhoneNumberNormalizer.normalize(phoneNumber);

      // Linear scan over Hive users — dataset is small (offline-first seeds).
      final users = _hiveDataSource.getAllUsers();
      UserHiveModel? match;
      for (final u in users) {
        if (u.phoneNumber == normalized && u.phoneNumber.isNotEmpty) {
          match = u;
          break;
        }
      }

      if (match == null) {
        // Detect legacy records (pre-migration users without a phone number)
        // so we can prompt the user to add one before they can sign in again.
        final legacy = users
            .where((u) => u.phoneNumber.isEmpty)
            .firstOrNull;
        if (legacy != null) {
          _logger.w('Legacy user without phoneNumber: ${legacy.id}');
          return const Left(
            Failure.cache(message: 'authLegacyAccountNeedsPhone'),
          );
        }
        // Uniform credential failure for both wrong-phone and wrong-password.
        return const Left(
          Failure.cache(message: 'authInvalidCredentials'),
        );
      }

      // Dummy auth: any password is accepted for a matching phone number.
      // The "uniform failure" message above is what matters for R1.5; an
      // actual password column on UserHiveModel is intentionally out of
      // scope for this offline-first iteration. `password` is intentionally
      // unused.

      // Store session.
      await _prefsDataSource.setString(
        PrefKeys.sessionToken,
        'token_${match.id}',
      );
      await _prefsDataSource.setString(PrefKeys.sessionUserId, match.id);
      await _prefsDataSource.setBool(PrefKeys.isGuest, false);
      return Right(match.toEntity());
    } catch (e, st) {
      _logger.e('Login failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final normalized = PhoneNumberNormalizer.normalize(phoneNumber);

      final existing = _hiveDataSource
          .getAllUsers()
          .where((u) => u.phoneNumber == normalized && u.phoneNumber.isNotEmpty)
          .firstOrNull;
      if (existing != null) {
        return const Left(
          Failure.validation(
            field: 'phoneNumber',
            message: 'authPhoneAlreadyTaken',
          ),
        );
      }

      // Password is intentionally not persisted in this offline-first dummy
      // auth; biometric and login flows assume any password is accepted for
      // the matching phone. `password` is intentionally unused here.

      final id = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final newUser = UserHiveModel(
        id: id,
        name: name,
        phoneNumber: normalized,
        email: '',
        age: 0,
        gender: '',
        programLevel: 'beginner',
        healthConditions: [],
        emergencyContacts: [],
      );
      await _hiveDataSource.saveUser(newUser);
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
        return const Right(
          UserEntity(
            id: 'guest',
            name: 'Guest',
            phoneNumber: '',
            age: 0,
            gender: '',
            programLevel: ProgramLevel.beginner,
            healthConditions: [],
            emergencyContacts: [],
          ),
        );
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
      await _prefsDataSource.setString(PrefKeys.sessionToken, 'guest_token');
      await _prefsDataSource.setString(PrefKeys.sessionUserId, 'guest');
      await _prefsDataSource.setBool(PrefKeys.isGuest, true);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('CreateGuestSession failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPhoneNumberTaken(String phoneNumber) async {
    try {
      final normalized = PhoneNumberNormalizer.normalize(phoneNumber);
      final taken = _hiveDataSource
          .getAllUsers()
          .any((u) => u.phoneNumber == normalized && u.phoneNumber.isNotEmpty);
      return Right(taken);
    } catch (e, st) {
      _logger.e('isPhoneNumberTaken failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> upsertPhoneNumber(
    String userId,
    String phoneNumber,
  ) async {
    try {
      final normalized = PhoneNumberNormalizer.normalize(phoneNumber);

      if (!PhoneNumberNormalizer.isValidE164(normalized)) {
        return const Left(
          Failure.validation(
            field: 'phoneNumber',
            message: 'authPhoneInvalid',
          ),
        );
      }

      final users = _hiveDataSource.getAllUsers();
      final ownedByOther = users.any(
        (u) =>
            u.id != userId &&
            u.phoneNumber == normalized &&
            u.phoneNumber.isNotEmpty,
      );
      if (ownedByOther) {
        return const Left(
          Failure.validation(
            field: 'phoneNumber',
            message: 'authPhoneAlreadyTaken',
          ),
        );
      }

      final current = _hiveDataSource.getUser(userId);
      if (current == null) {
        return const Left(Failure.cache(message: 'authUserNotFound'));
      }

      current.phoneNumber = normalized;
      await _hiveDataSource.saveUser(current);
      return Right(current.toEntity());
    } catch (e, st) {
      _logger.e('upsertPhoneNumber failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
