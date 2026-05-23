import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

/// Capability state of biometric login on the current device + user account.
///
/// Drives the `AuthCubit.requestBiometricLogin` state machine described in
/// design.md "Aliran Login Biometrik" / "Modul_Biometric":
///
/// - [unavailable]: device has no sensor or no enrolled biometric. The OS
///   prompt MUST NOT be shown; UI emits `AuthBiometricUnavailable`.
/// - [disabled]: biometric hardware is available but the user has not
///   enabled biometric login from Settings (`biometric_enabled == false`).
///   UI emits `AuthBiometricNotEnabled`.
/// - [ready]: biometric is available and enabled — the OS prompt may be
///   invoked and stored credentials may be restored.
enum BiometricStatus {
  /// Device has no biometric sensor or no enrolled biometric.
  unavailable,

  /// Hardware available, but the user has not enabled biometric login.
  disabled,

  /// Hardware available and biometric login is enabled in Settings.
  ready,
}

/// Contract for the biometric credential subsystem (Modul_Biometric).
///
/// Implementations wrap `local_auth` for OS-level authentication and
/// `flutter_secure_storage` for persisting the credentials used to
/// auto-fill the login form on a successful biometric prompt.
///
/// Validates: Requirements 3.2, 3.3, 3.4, 4.4, 4.6, 4.8.
abstract class BiometricCredentialRepository {
  /// Reports the combined hardware + user-preference status.
  ///
  /// Inspects whether the device can check biometrics and has at least one
  /// enrolled factor, then layers the user-controlled `biometric_enabled`
  /// flag from SharedPreferences on top to produce a [BiometricStatus].
  /// Never invokes the OS prompt.
  Future<Either<Failure, BiometricStatus>> getStatus();

  /// Triggers the OS biometric prompt with the given localized [reason]
  /// (e.g. `l10n.authBiometricReason`).
  ///
  /// Returns `Right(true)` on a successful biometric match, `Right(false)`
  /// when the user cancels or the prompt fails without a system error, and
  /// `Left(Failure)` for unexpected platform errors. Stored credentials are
  /// not touched by this call.
  Future<Either<Failure, bool>> authenticate({required String reason});

  /// Persists the credentials used to auto-fill the login form after a
  /// successful biometric prompt.
  ///
  /// Per R4.4, [phoneNumber] and [password] MUST be written to distinct
  /// secure-storage keys (`biometric_phone` and `biometric_password`).
  /// Implementations MUST NOT use Hive or SharedPreferences for these
  /// credential values (R4.8).
  Future<Either<Failure, Unit>> storeCredentials({
    required String phoneNumber,
    required String password,
  });

  /// Reads the previously stored credential pair as a Dart 3 record.
  ///
  /// Returns `Left(Failure)` when either key is missing or secure storage
  /// fails. Callers SHOULD invoke [authenticate] first; reading without a
  /// prior successful prompt is a contract violation but the repository
  /// itself does not enforce it.
  Future<Either<Failure, ({String phoneNumber, String password})>>
      readCredentials();

  /// Removes both credential keys from secure storage and sets the
  /// `biometric_enabled` flag to `false`.
  ///
  /// Per R4.6 this MUST NOT trigger an OS biometric prompt — disabling is
  /// a destructive, prompt-free operation invoked from Settings or after
  /// a `biometric_session_expired` recovery (R3.7).
  Future<Either<Failure, Unit>> clearCredentials();
}
