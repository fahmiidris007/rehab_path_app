import 'package:freezed_annotation/freezed_annotation.dart';

part 'fall_event_entity.freezed.dart';

@freezed
class FallEventEntity with _$FallEventEntity {
  const factory FallEventEntity({
    required String id,
    required String userId,
    required DateTime date,
  }) = _FallEventEntity;
}
