import 'package:hive/hive.dart';

import '../../domain/entities/emergency_contact_entity.dart';

part 'emergency_contact_hive_model.g.dart';

@HiveType(typeId: 1)
class EmergencyContactHiveModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String relationship;

  @HiveField(2)
  String phoneNumber;

  EmergencyContactHiveModel({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
  });

  EmergencyContactEntity toEntity() {
    return EmergencyContactEntity(
      name: name,
      relationship: relationship,
      phoneNumber: phoneNumber,
    );
  }

  static EmergencyContactHiveModel fromEntity(EmergencyContactEntity entity) {
    return EmergencyContactHiveModel(
      name: entity.name,
      relationship: entity.relationship,
      phoneNumber: entity.phoneNumber,
    );
  }
}
