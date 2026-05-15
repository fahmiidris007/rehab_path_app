import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/motivational_message_entity.dart';

part 'message_json_model.g.dart';

@JsonSerializable()
class MessageJsonModel {
  final String id;
  final String textEn;
  final String textId;
  final String category;

  const MessageJsonModel({
    required this.id,
    required this.textEn,
    required this.textId,
    required this.category,
  });

  factory MessageJsonModel.fromJson(Map<String, dynamic> json) =>
      _$MessageJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageJsonModelToJson(this);

  MotivationalMessageEntity toEntity() {
    return MotivationalMessageEntity(
      id: id,
      textEn: textEn,
      textId: textId,
      category: category,
    );
  }
}
