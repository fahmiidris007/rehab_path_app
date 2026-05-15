// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramJsonModel _$ProgramJsonModelFromJson(Map<String, dynamic> json) =>
    ProgramJsonModel(
      level: json['level'] as String,
      weeklySchedule: (json['weeklySchedule'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$ProgramJsonModelToJson(ProgramJsonModel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'weeklySchedule': instance.weeklySchedule,
    };
