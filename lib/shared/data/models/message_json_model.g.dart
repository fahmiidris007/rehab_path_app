// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageJsonModel _$MessageJsonModelFromJson(Map<String, dynamic> json) =>
    MessageJsonModel(
      id: json['id'] as String,
      textEn: json['textEn'] as String,
      textId: json['textId'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$MessageJsonModelToJson(MessageJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textEn': instance.textEn,
      'textId': instance.textId,
      'category': instance.category,
    };
