import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
  /// Emitted after login when the user has not yet completed onboarding.
  const factory AuthState.needsOnboarding(UserEntity user) = AuthNeedsOnboarding;
  /// Emitted after a successful registration — user must now log in.
  const factory AuthState.registrationSuccess() = AuthRegistrationSuccess;
  const factory AuthState.guest() = AuthGuest;
  /// No session at all — first-time user, show welcome screen.
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  /// Had a previous session but requires re-login — show login screen directly.
  const factory AuthState.requiresLogin() = AuthRequiresLogin;
  const factory AuthState.error(String message) = AuthError;
}
