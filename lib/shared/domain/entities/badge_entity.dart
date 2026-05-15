import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_entity.freezed.dart';

@freezed
class BadgeEntity with _$BadgeEntity {
  const factory BadgeEntity({
    required String id,
    required String name,
    required String iconPath,
    required String unlockCondition,
    required bool isEarned,
    DateTime? earnedAt,
  }) = _BadgeEntity;
}
