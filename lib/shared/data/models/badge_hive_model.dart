import 'package:hive/hive.dart';

import '../../domain/entities/badge_entity.dart';

part 'badge_hive_model.g.dart';

@HiveType(typeId: 5)
class BadgeHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String iconPath;

  @HiveField(3)
  String unlockCondition;

  @HiveField(4)
  bool isEarned;

  @HiveField(5)
  DateTime? earnedAt;

  BadgeHiveModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.unlockCondition,
    required this.isEarned,
    this.earnedAt,
  });

  BadgeEntity toEntity() {
    return BadgeEntity(
      id: id,
      name: name,
      iconPath: iconPath,
      unlockCondition: unlockCondition,
      isEarned: isEarned,
      earnedAt: earnedAt,
    );
  }

  static BadgeHiveModel fromEntity(BadgeEntity entity) {
    return BadgeHiveModel(
      id: entity.id,
      name: entity.name,
      iconPath: entity.iconPath,
      unlockCondition: entity.unlockCondition,
      isEarned: entity.isEarned,
      earnedAt: entity.earnedAt,
    );
  }
}
