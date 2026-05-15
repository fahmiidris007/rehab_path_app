import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
  /// Emitted after a successful registration — user is authenticated but
  /// has not yet completed the onboarding questionnaire.
  const factory AuthState.needsOnboarding(UserEntity user) = AuthNeedsOnboarding;
  const factory AuthState.guest() = AuthGuest;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}
