import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../../../core/constants/pref_keys.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/get_session_use_case.dart';
import '../../domain/usecases/create_guest_session_use_case.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final CreateGuestSessionUseCase _createGuestSessionUseCase;
  final SharedPreferencesDataSource _prefsDataSource;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getSessionUseCase,
    this._createGuestSessionUseCase,
    this._prefsDataSource,
  ) : super(const AuthState.initial());

  Future<void> checkSession() async {
    emit(const AuthState.loading());
    final result = await _getSessionUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) {
        if (user == null) {
          // No session token at all — brand new user, show welcome screen.
          emit(const AuthState.unauthenticated());
        } else {
          // A previous session exists — require the user to log in again.
          // Show the login screen directly (skip the welcome carousel).
          emit(const AuthState.requiresLogin());
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result =
        await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
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

  Future<void> register(String name, String email, String password) async {
    emit(const AuthState.loading());
    final result = await _registerUseCase(
        RegisterParams(name: name, email: email, password: password));
    result.fold(
      (failure) => emit(AuthState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      // Registration succeeded — user must now log in manually.
      // No session is created here.
      (_) => emit(const AuthState.registrationSuccess()),
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
    await _logoutUseCase(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  Future<void> continueAsGuest() async {
    emit(const AuthState.loading());
    final result = await _createGuestSessionUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      (_) => emit(const AuthState.guest()),
    );
  }
}
