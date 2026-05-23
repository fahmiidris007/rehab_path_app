// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserJsonModel _$UserJsonModelFromJson(Map<String, dynamic> json) =>
    UserJsonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      programLevel: json['programLevel'] as String,
      healthConditions: (json['healthConditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      emergencyContacts: (json['emergencyContacts'] as List<dynamic>)
          .map((e) =>
              EmergencyContactJsonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatarPath: json['avatarPath'] as String?,
      onboardingProfile: json['onboardingProfile'] == null
          ? null
          : OnboardingProfileJsonModel.fromJson(
              json['onboardingProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserJsonModelToJson(UserJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'age': instance.age,
      'gender': instance.gender,
      'programLevel': instance.programLevel,
      'healthConditions': instance.healthConditions,
      'avatarPath': instance.avatarPath,
      'emergencyContacts':
          instance.emergencyContacts.map((e) => e.toJson()).toList(),
      'onboardingProfile': instance.onboardingProfile?.toJson(),
    };
