import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../domain/repositories/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final FlutterLocalNotificationsPlugin _plugin;
  final SharedPreferencesDataSource _prefsDataSource;
  final Logger _logger;

  static const int _dailyReminderId = 1;
  static const int _reEngagementId = 2;
  static const int _weeklySummaryId = 3;

  NotificationRepositoryImpl(
    this._plugin,
    this._prefsDataSource,
    this._logger,
  );

  @override
  Future<Either<Failure, Unit>> scheduleDailyReminder(String time) async {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        _dailyReminderId,
        'Time to Exercise!',
        'Your daily rehabilitation session is ready. Keep up the great work!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'rehab_path_reminders',
            'Exercise Reminders',
            channelDescription:
                'Daily exercise reminders and progress updates',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      return const Right(unit);
    } catch (e, st) {
      _logger.e('ScheduleDailyReminder failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelDailyReminder() async {
    try {
      await _plugin.cancel(_dailyReminderId);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('CancelDailyReminder failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleStreakMilestone(int streakDays) async {
    try {
      final flagKey = _milestoneKey(streakDays);
      if (flagKey == null) return const Right(unit);

      final alreadySent = _prefsDataSource.getBool(flagKey) ?? false;
      if (alreadySent) return const Right(unit);

      await _plugin.show(
        4 * 10 + streakDays, // unique ID per milestone
        'Streak Milestone!',
        'Amazing! You have kept a $streakDays-day exercise streak. Keep it up!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'rehab_path_reminders',
            'Exercise Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      await _prefsDataSource.setBool(flagKey, true);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('ScheduleStreakMilestone failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleReEngagement(String time) async {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        _reEngagementId,
        'We Miss You!',
        'It has been a while since your last session. Come back and continue your progress!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'rehab_path_reminders',
            'Exercise Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return const Right(unit);
    } catch (e, st) {
      _logger.e('ScheduleReEngagement failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleWeeklySummary(
    double adherenceRate,
  ) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      // Schedule for next Monday at 09:00
      final daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
      final nextMonday = now.add(
        Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday),
      );
      final scheduledDate = tz.TZDateTime(
        tz.local,
        nextMonday.year,
        nextMonday.month,
        nextMonday.day,
        9,
        0,
      );

      final ratePercent = (adherenceRate * 100).round();
      await _plugin.zonedSchedule(
        _weeklySummaryId,
        'Weekly Summary',
        'You completed $ratePercent% of your exercises this week. Great effort!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'rehab_path_reminders',
            'Exercise Reminders',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      return const Right(unit);
    } catch (e, st) {
      _logger.e('ScheduleWeeklySummary failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      bool granted = false;
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        granted =
            await androidImpl.requestNotificationsPermission() ?? false;
      }
      final iosImpl = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl != null) {
        granted = await iosImpl.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
      return Right(granted);
    } catch (e, st) {
      _logger.e('RequestPermission failed', error: e, stackTrace: st);
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  String? _milestoneKey(int days) {
    switch (days) {
      case 3:
        return PrefKeys.streakMilestone3;
      case 7:
        return PrefKeys.streakMilestone7;
      case 14:
        return PrefKeys.streakMilestone14;
      case 30:
        return PrefKeys.streakMilestone30;
      default:
        return null;
    }
  }
}
