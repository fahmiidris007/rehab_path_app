import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/enums/app_enums.dart';
import 'emergency_contact_json_model.dart';
import 'onboarding_profile_json_model.dart';

part 'user_json_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserJsonModel {
  final String id;
  final String name;
  @JsonKey(defaultValue: '')
  final String phoneNumber;
  final String email;
  final int age;
  final String gender;
  final String programLevel;
  final List<String> healthConditions;
  final String? avatarPath;
  final List<EmergencyContactJsonModel> emergencyContacts;
  final OnboardingProfileJsonModel? onboardingProfile;

  const UserJsonModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.age,
    required this.gender,
    required this.programLevel,
    required this.healthConditions,
    required this.emergencyContacts,
    this.avatarPath,
    this.onboardingProfile,
  });

  factory UserJsonModel.fromJson(Map<String, dynamic> json) =>
      _$UserJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserJsonModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      email: email.isEmpty ? null : email,
      age: age,
      gender: gender,
      programLevel: ProgramLevel.values.firstWhere(
        (e) => e.name == programLevel,
        orElse: () => ProgramLevel.beginner,
      ),
      healthConditions: healthConditions,
      avatarPath: avatarPath,
      emergencyContacts:
          emergencyContacts.map((e) => e.toEntity()).toList(),
      onboardingProfile: onboardingProfile?.toEntity(),
    );
  }
}
