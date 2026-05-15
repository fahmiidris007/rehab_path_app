import 'package:hive/hive.dart';

import '../../domain/entities/fall_event_entity.dart';

part 'fall_event_hive_model.g.dart';

@HiveType(typeId: 4)
class FallEventHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime date;

  FallEventHiveModel({
    required this.id,
    required this.userId,
    required this.date,
  });

  FallEventEntity toEntity() {
    return FallEventEntity(
      id: id,
      userId: userId,
      date: date,
    );
  }

  static FallEventHiveModel fromEntity(FallEventEntity entity) {
    return FallEventHiveModel(
      id: entity.id,
      userId: entity.userId,
      date: entity.date,
    );
  }
}
