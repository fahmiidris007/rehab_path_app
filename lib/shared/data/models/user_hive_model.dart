import 'package:hive/hive.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/enums/app_enums.dart';
import 'emergency_contact_hive_model.dart';
import 'onboarding_profile_hive_model.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  int age;

  @HiveField(4)
  String gender;

  @HiveField(5)
  String programLevel;

  @HiveField(6)
  List<String> healthConditions;

  @HiveField(7)
  List<EmergencyContactHiveModel> emergencyContacts;

  @HiveField(8)
  String? avatarPath;

  @HiveField(9)
  OnboardingProfileHiveModel? onboardingProfile;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.programLevel,
    required this.healthConditions,
    required this.emergencyContacts,
    this.avatarPath,
    this.onboardingProfile,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      age: age,
      gender: gender,
      programLevel: ProgramLevel.values.firstWhere(
        (e) => e.name == programLevel,
        orElse: () => ProgramLevel.beginner,
      ),
      healthConditions: healthConditions,
      emergencyContacts:
          emergencyContacts.map((c) => c.toEntity()).toList(),
      avatarPath: avatarPath,
      onboardingProfile: onboardingProfile?.toEntity(),
    );
  }

  static UserHiveModel fromEntity(UserEntity entity) {
    return UserHiveModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      age: entity.age,
      gender: entity.gender,
      programLevel: entity.programLevel.name,
      healthConditions: entity.healthConditions,
      emergencyContacts: entity.emergencyContacts
          .map(EmergencyContactHiveModel.fromEntity)
          .toList(),
      avatarPath: entity.avatarPath,
      onboardingProfile: entity.onboardingProfile != null
          ? OnboardingProfileHiveModel.fromEntity(entity.onboardingProfile!)
          : null,
    );
  }
}
