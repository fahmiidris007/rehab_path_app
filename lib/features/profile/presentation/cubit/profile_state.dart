import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/user_entity.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = ProfileLoading;
  const factory ProfileState.loaded(UserEntity user) = ProfileLoaded;
  const factory ProfileState.error(String message) = ProfileError;
}
