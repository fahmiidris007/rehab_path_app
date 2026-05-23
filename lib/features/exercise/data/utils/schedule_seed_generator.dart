/// Deterministic seed generator for daily exercise schedule selection.
///
/// Backs the "Aliran Pemilihan Jadwal Deterministik" flow described in
/// `.kiro/specs/app-flow-adjustments/design.md`:
///
/// 1. `ExerciseRepositoryImpl.getScheduleForDate(userId, date)` derives a
///    stable integer seed from `(userId, local-midnight epoch ms)` via
///    [ScheduleSeedGenerator.seed].
/// 2. That seed is fed into `Random(seed)` to drive the partition-and-pick
///    strategy over the user's program-level catalogue (1 warm-up, body
///    items, 1 cool-down).
/// 3. Because the seed is a pure function of `(userId, date)`, the chosen
///    schedule is reproducible on the same date and varies across distinct
///    dates — which is what powers the persistent cache in `scheduleBox`
///    and lets the date selector swap days without losing determinism.
class ScheduleSeedGenerator {
  ScheduleSeedGenerator._();

  /// Deterministic seed derived from (`userId`, local-midnight epoch ms).
  ///
  /// Used by `ExerciseRepositoryImpl.getScheduleForDate` to seed `Random()`
  /// so schedule selection is reproducible per `(userId, date)` and varies
  /// across distinct dates.
  ///
  /// [localDate] is normalized to local midnight before hashing, so any
  /// time-of-day component on the same calendar day yields the same seed.
  static int seed(String userId, DateTime localDate) {
    final dayKey = DateTime(localDate.year, localDate.month, localDate.day)
        .millisecondsSinceEpoch;
    return Object.hash(userId, dayKey);
  }
}
