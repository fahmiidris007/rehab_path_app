import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, Unit>> scheduleDailyReminder(String time);
  Future<Either<Failure, Unit>> cancelDailyReminder();
  Future<Either<Failure, Unit>> scheduleStreakMilestone(int streakDays);
  Future<Either<Failure, Unit>> scheduleReEngagement(String time);
  Future<Either<Failure, Unit>> scheduleWeeklySummary(double adherenceRate);
  Future<Either<Failure, bool>> requestPermission();
}
