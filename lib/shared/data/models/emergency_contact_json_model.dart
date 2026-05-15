import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/emergency_contact_entity.dart';

part 'emergency_contact_json_model.g.dart';

@JsonSerializable()
class EmergencyContactJsonModel {
  final String name;
  final String relationship;
  final String phoneNumber;

  const EmergencyContactJsonModel({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
  });

  factory EmergencyContactJsonModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactJsonModelToJson(this);

  EmergencyContactEntity toEntity() {
    return EmergencyContactEntity(
      name: name,
      relationship: relationship,
      phoneNumber: phoneNumber,
    );
  }
}
