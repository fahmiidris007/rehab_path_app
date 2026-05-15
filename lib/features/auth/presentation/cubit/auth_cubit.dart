import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/get_session_use_case.dart';
import '../../domain/usecases/create_guest_session_use_case.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final CreateGuestSessionUseCase _createGuestSessionUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getSessionUseCase,
    this._createGuestSessionUseCase,
  ) : super(const AuthState.initial());

  Future<void> checkSession() async {
    emit(const AuthState.loading());
    final result = await _getSessionUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) {
        if (user == null) {
          emit(const AuthState.unauthenticated());
        } else if (user.id == 'guest') {
          emit(const AuthState.guest());
        } else {
          emit(AuthState.authenticated(user));
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
      (user) => emit(AuthState.authenticated(user)),
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
      (user) => emit(AuthState.authenticated(user)),
    );
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
