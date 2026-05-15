import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_contact_entity.freezed.dart';

@freezed
class EmergencyContactEntity with _$EmergencyContactEntity {
  const factory EmergencyContactEntity({
    required String name,
    required String relationship,
    required String phoneNumber,
  }) = _EmergencyContactEntity;
}
