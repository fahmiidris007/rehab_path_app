import 'package:hive/hive.dart';

part 'scheduled_exercise_set_hive_model.g.dart';

/// Persistent cache of the deterministic schedule produced by
/// `ScheduleSeedGenerator` for a given `(userId, localDate)` pair.
///
/// Because the schedule is a pure function of `(userId, date)`, this Hive
/// record is purely an optimization (cache) — never the source of truth.
/// If the adapter fails to register, the schedule can always be recomputed.
@HiveType(typeId: 11)
class ScheduledExerciseSetHiveModel extends HiveObject {
  @HiveField(0)
  String userId;

  /// Local midnight for the day the schedule belongs to.
  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<String> exerciseIds;

  ScheduledExerciseSetHiveModel({
    required this.userId,
    required this.date,
    required this.exerciseIds,
  });
}
