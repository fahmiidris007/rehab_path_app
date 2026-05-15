// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyContactJsonModel _$EmergencyContactJsonModelFromJson(
        Map<String, dynamic> json) =>
    EmergencyContactJsonModel(
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$EmergencyContactJsonModelToJson(
        EmergencyContactJsonModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'relationship': instance.relationship,
      'phoneNumber': instance.phoneNumber,
    };
