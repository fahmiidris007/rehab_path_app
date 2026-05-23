import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../domain/repositories/biometric_credential_repository.dart';
import '../../domain/usecases/check_biometric_availability_use_case.dart';
import '../../domain/usecases/clear_biometric_credentials_use_case.dart';
import '../../domain/usecases/create_guest_session_use_case.dart';
import '../../domain/usecases/get_session_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/restore_biometric_credentials_use_case.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final CreateGuestSessionUseCase _createGuestSessionUseCase;
  final SharedPreferencesDataSource _prefsDataSource;
  final CheckBiometricAvailabilityUseCase _checkBiometricUseCase;
  final RestoreBiometricCredentialsUseCase _restoreBiometricUseCase;
  final ClearBiometricCredentialsUseCase _clearBiometricUseCase;

  /// Broadcast channel used by [LoginPage] to populate the phone and password
  /// text controllers immediately after a successful biometric restore so the
  /// user does not have to retype anything (R3.5).
  final StreamController<({String phoneNumber, String password})>
      _autofillController =
      StreamController<({String phoneNumber, String password})>.broadcast();

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getSessionUseCase,
    this._createGuestSessionUseCase,
    this._prefsDataSource,
    this._checkBiometricUseCase,
    this._restoreBiometricUseCase,
    this._clearBiometricUseCase,
  ) : super(const AuthState.initial());

  /// Stream of `(phoneNumber, password)` records pushed whenever a biometric
  /// restore succeeds. Subscribers (e.g. `LoginPage`) should populate their
  /// text controllers without further user interaction.
  Stream<({String phoneNumber, String password})> get autofillStream =>
      _autofillController.stream;

  Future<void> checkSession() async {
    emit(const AuthState.loading());
    final result = await _getSessionUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) {
        if (user == null) {
          // No session token at all — brand new user, show welcome screen.
          emit(const AuthState.unauthenticated());
        } else if (user.id == 'guest') {
          // Guest sessions are not persisted across launches.
          // Treat as unauthenticated so the welcome screen is shown.
          emit(const AuthState.unauthenticated());
        } else {
          // A real previous session exists — require the user to log in again.
          // Show the login screen directly (skip the welcome carousel).
          emit(const AuthState.requiresLogin());
        }
      },
    );
  }

  Future<void> loginWithPhone(String phoneNumber, String password) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(
      LoginParams(phoneNumber: phoneNumber, password: password),
    );
    result.fold(
      (failure) => emit(AuthState.error(_messageOf(failure))),
      (user) {
        // Login: check if onboarding was previously completed.
        final onboardingDone =
            _prefsDataSource.getBool(PrefKeys.onboardingComplete) ?? false;
        if (onboardingDone) {
          emit(AuthState.authenticated(user));
        } else {
          emit(AuthState.needsOnboarding(user));
        }
      },
    );
  }

  Future<void> registerWithPhone(
    String name,
    String phoneNumber,
    String password,
  ) async {
    emit(const AuthState.loading());
    final result = await _registerUseCase(
      RegisterParams(name: name, phoneNumber: phoneNumber, password: password),
    );
    result.fold(
      (failure) => emit(AuthState.error(_messageOf(failure))),
      // Registration succeeded — user must now log in manually.
      // No session is created here.
      (_) => emit(const AuthState.registrationSuccess()),
    );
  }

  /// Drives the biometric login state machine described in design.md
  /// "Aliran Login Biometrik".
  ///
  /// The [reason] string is passed straight through to the OS prompt and must
  /// be a localized copy supplied by the caller (the cubit cannot resolve
  /// `AppLocalizations` without a `BuildContext`).
  Future<void> requestBiometricLogin({required String reason}) async {
    final statusResult = await _checkBiometricUseCase(const NoParams());
    await statusResult.fold(
      (failure) async =>
          emit(AuthState.biometricFailed(_messageOf(failure))),
      (status) async {
        switch (status) {
          case BiometricStatus.unavailable:
            emit(const AuthState.biometricUnavailable());
            return;
          case BiometricStatus.disabled:
            emit(const AuthState.biometricNotEnabled());
            return;
          case BiometricStatus.ready:
            emit(const AuthState.biometricRestoring());
            final restoreResult = await _restoreBiometricUseCase(
              RestoreBiometricCredentialsParams(reason: reason),
            );
            await restoreResult.fold(
              (failure) async {
                // OS prompt failure — do NOT clear credentials per design.md.
                emit(AuthState.biometricFailed(_messageOf(failure)));
              },
              (creds) async {
                // Push autofill so the login form populates instantly (R3.5).
                _autofillController.add(creds);
                // Replay the standard login pipeline (R3.8).
                final loginResult = await _loginUseCase(
                  LoginParams(
                    phoneNumber: creds.phoneNumber,
                    password: creds.password,
                  ),
                );
                await loginResult.fold(
                  (failure) async {
                    // Stored credentials no longer match — clear and force
                    // a fresh login (R3.7).
                    await _clearBiometricUseCase(const NoParams());
                    emit(const AuthState.error('authBiometricSessionExpired'));
                  },
                  (user) async {
                    final onboardingDone = _prefsDataSource
                            .getBool(PrefKeys.onboardingComplete) ??
                        false;
                    emit(onboardingDone
                        ? AuthState.authenticated(user)
                        : AuthState.needsOnboarding(user));
                  },
                );
              },
            );
            return;
        }
      },
    );
  }

  /// Called by [OnboardingPage] when the user finishes the questionnaire.
  /// Transitions from [AuthNeedsOnboarding] to [AuthAuthenticated].
  void completeOnboarding() {
    if (state is AuthNeedsOnboarding) {
      final user = (state as AuthNeedsOnboarding).user;
      emit(AuthState.authenticated(user));
    }
  }

  Future<void> logout() async {
    // Honor the optional `biometricKeepAfterLogout` flag (R4.7). Out-of-scope
    // for the first iteration — flag declared in PrefKeys but not yet exposed
    // in the UI. Default behavior: clear biometric credentials.
    final keepBiometric =
        _prefsDataSource.getBool(PrefKeys.biometricKeepAfterLogout) ?? false;
    if (!keepBiometric) {
      await _clearBiometricUseCase(const NoParams());
    }
    await _logoutUseCase(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  Future<void> continueAsGuest() async {
    emit(const AuthState.loading());
    final result = await _createGuestSessionUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthState.error(_messageOf(failure))),
      (_) => emit(const AuthState.guest()),
    );
  }

  /// Maps a [Failure] union onto its localized message key.
  String _messageOf(Failure failure) => failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      );

  @override
  Future<void> close() {
    _autofillController.close();
    return super.close();
  }
}
