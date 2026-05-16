import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../features/profile/domain/usecases/get_profile_use_case.dart';
import '../../../../features/profile/domain/usecases/update_profile_use_case.dart';
import '../../../../shared/domain/entities/emergency_contact_entity.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import 'sos_state.dart';

@injectable
class SosCubit extends Cubit<SosState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  UserEntity? _currentUser;

  SosCubit(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const SosState.loading());

  Future<void> loadContacts(String userId) async {
    emit(const SosState.loading());
    final result = await _getProfileUseCase(GetProfileParams(userId: userId));
    result.fold(
      (failure) => emit(SosState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        validation: (msg, _) => msg,
        unexpected: (msg) => msg,
      ))),
      (user) {
        _currentUser = user;
        emit(SosState.loaded(user.emergencyContacts));
      },
    );
  }

  Future<void> callContact(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      emit(const SosState.callNotSupported());
    }
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    // Normalise: strip non-digit chars, ensure leading '+'
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final normalised = digits.startsWith('+') ? digits : '+$digits';
    final uri = Uri.parse('https://wa.me/$normalised');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      emit(const SosState.callNotSupported());
    }
  }

  Future<void> addContact(EmergencyContactEntity contact) async {
    final user = _currentUser;
    if (user == null) return;

    final currentContacts = _currentContacts;
    final updated = [...currentContacts, contact];
    emit(SosState.saving(updated));

    final newUser = user.copyWith(emergencyContacts: updated);
    final result = await _updateProfileUseCase(newUser);
    result.fold(
      (failure) => emit(SosState.loaded(currentContacts)),
      (_) {
        _currentUser = newUser;
        emit(SosState.loaded(updated));
      },
    );
  }

  Future<void> updateContact(int index, EmergencyContactEntity contact) async {
    final user = _currentUser;
    if (user == null) return;

    final currentContacts = _currentContacts;
    final updated = List<EmergencyContactEntity>.from(currentContacts)
      ..[index] = contact;
    emit(SosState.saving(updated));

    final newUser = user.copyWith(emergencyContacts: updated);
    final result = await _updateProfileUseCase(newUser);
    result.fold(
      (failure) => emit(SosState.loaded(currentContacts)),
      (_) {
        _currentUser = newUser;
        emit(SosState.loaded(updated));
      },
    );
  }

  Future<void> deleteContact(int index) async {
    final user = _currentUser;
    if (user == null) return;

    final currentContacts = _currentContacts;
    final updated = List<EmergencyContactEntity>.from(currentContacts)
      ..removeAt(index);
    emit(SosState.saving(updated));

    final newUser = user.copyWith(emergencyContacts: updated);
    final result = await _updateProfileUseCase(newUser);
    result.fold(
      (failure) => emit(SosState.loaded(currentContacts)),
      (_) {
        _currentUser = newUser;
        emit(SosState.loaded(updated));
      },
    );
  }

  List<EmergencyContactEntity> get _currentContacts {
    return switch (state) {
      SosLoaded(:final contacts) => contacts,
      SosSaving(:final contacts) => contacts,
      _ => _currentUser?.emergencyContacts ?? [],
    };
  }
}
