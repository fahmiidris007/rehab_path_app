import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';
import 'emergency_contact_entity.dart';
import 'onboarding_profile_entity.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String email,
    required int age,
    required String gender,
    required ProgramLevel programLevel,
    required List<String> healthConditions,
    required List<EmergencyContactEntity> emergencyContacts,
    String? avatarPath,
    OnboardingProfileEntity? onboardingProfile,
  }) = _UserEntity;
}
