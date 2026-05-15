import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import 'profile_state.dart';

export 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const ProfileState.loading());

  Future<void> loadProfile(String userId) async {
    emit(const ProfileState.loading());
    final result = await _getProfileUseCase(GetProfileParams(userId: userId));
    result.fold(
      (failure) => emit(ProfileState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  Future<bool> updateProfile(UserEntity user) async {
    final result = await _updateProfileUseCase(user);
    return result.fold(
      (failure) {
        emit(ProfileState.error(failure.when(
          server: (msg, _) => msg,
          cache: (msg) => msg,
          validation: (msg, _) => msg,
          unexpected: (msg) => msg,
        )));
        return false;
      },
      (_) {
        emit(ProfileState.loaded(user));
        return true;
      },
    );
  }
}
