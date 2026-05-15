import 'package:freezed_annotation/freezed_annotation.dart';

part 'motivational_message_entity.freezed.dart';

@freezed
class MotivationalMessageEntity with _$MotivationalMessageEntity {
  const factory MotivationalMessageEntity({
    required String id,
    required String textEn,
    required String textId,
    required String category,
  }) = _MotivationalMessageEntity;
}
