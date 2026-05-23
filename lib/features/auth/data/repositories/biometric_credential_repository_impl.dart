import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../domain/repositories/biometric_credential_repository.dart';

/// Concrete implementation of [BiometricCredentialRepository].
///
/// Wraps `local_auth` for OS-level biometric prompts and
/// `flutter_secure_storage` for persisting the `(phoneNumber, password)`
/// pair used to auto-fill the login form. The `biometric_enabled` flag
/// lives in SharedPreferences via [SharedPreferencesDataSource]; no Hive
/// access is performed for credential keys (R4.8).
///
/// Validates: Requirements 3.2, 3.3, 3.4, 4.4, 4.6, 4.8.
@LazySingleton(as: BiometricCredentialRepository)
class BiometricCredentialRepositoryImpl
    implements BiometricCredentialRepository {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferencesDataSource _prefsDataSource;
  final Logger _logger;

  BiometricCredentialRepositoryImpl(
    this._localAuth,
    this._secureStorage,
    this._prefsDataSource,
    this._logger,
  );

  /// Distinct secure-storage key for the stored phone number (R4.4).
  static const _kPhoneKey = 'biometric_phone';

  /// Distinct secure-storage key for the stored password (R4.4).
  static const _kPasswordKey = 'biometric_password';

  @override
  Future<Either<Failure, BiometricStatus>> getStatus() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final available = await _localAuth.getAvailableBiometrics();
      if (!canCheck || available.isEmpty) {
        return const Right(BiometricStatus.unavailable);
      }
      final enabled =
          _prefsDataSource.getBool(PrefKeys.biometricEnabled) ?? false;
      return Right(
        enabled ? BiometricStatus.ready : BiometricStatus.disabled,
      );
    } catch (e, st) {
      _logger.w('BiometricCredentialRepository.getStatus failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticate({required String reason}) async {
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return Right(ok);
    } on PlatformException catch (e, st) {
      _logger.w(
        'BiometricCredentialRepository.authenticate platform error',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.unexpected(message: e.toString()));
    } catch (e, st) {
      _logger.w(
        'BiometricCredentialRepository.authenticate failed',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> storeCredentials({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      await _secureStorage.write(key: _kPhoneKey, value: phoneNumber);
      await _secureStorage.write(key: _kPasswordKey, value: password);
      await _prefsDataSource.setBool(PrefKeys.biometricEnabled, true);
      return const Right(unit);
    } catch (e, st) {
      _logger.w(
        'BiometricCredentialRepository.storeCredentials failed',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({String phoneNumber, String password})>>
      readCredentials() async {
    try {
      final phone = await _secureStorage.read(key: _kPhoneKey);
      final pass = await _secureStorage.read(key: _kPasswordKey);
      if (phone == null || pass == null) {
        return const Left(
          Failure.cache(message: 'authBiometricSessionExpired'),
        );
      }
      return Right((phoneNumber: phone, password: pass));
    } catch (e, st) {
      _logger.w(
        'BiometricCredentialRepository.readCredentials failed',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCredentials() async {
    try {
      await _secureStorage.delete(key: _kPhoneKey);
      await _secureStorage.delete(key: _kPasswordKey);
      await _prefsDataSource.setBool(PrefKeys.biometricEnabled, false);
      return const Right(unit);
    } catch (e, st) {
      _logger.w(
        'BiometricCredentialRepository.clearCredentials failed',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.unexpected(message: e.toString()));
    }
  }
}
