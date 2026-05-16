import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/emergency_contact_entity.dart';

part 'sos_state.freezed.dart';

@freezed
sealed class SosState with _$SosState {
  const factory SosState.loading() = SosLoading;
  const factory SosState.loaded(List<EmergencyContactEntity> contacts) = SosLoaded;
  const factory SosState.saving(List<EmergencyContactEntity> contacts) = SosSaving;
  const factory SosState.error(String message) = SosError;
  const factory SosState.callNotSupported() = SosCallNotSupported;
}
