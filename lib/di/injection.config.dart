// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:rehab_path_app/app/app_module.dart' as _i828;
import 'package:rehab_path_app/app/cubit/app_cubit.dart' as _i768;
import 'package:rehab_path_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i434;
import 'package:rehab_path_app/features/auth/domain/repositories/auth_repository.dart'
    as _i9;
import 'package:rehab_path_app/features/auth/domain/usecases/create_guest_session_use_case.dart'
    as _i310;
import 'package:rehab_path_app/features/auth/domain/usecases/get_session_use_case.dart'
    as _i1056;
import 'package:rehab_path_app/features/auth/domain/usecases/login_use_case.dart'
    as _i457;
import 'package:rehab_path_app/features/auth/domain/usecases/logout_use_case.dart'
    as _i134;
import 'package:rehab_path_app/features/auth/domain/usecases/register_use_case.dart'
    as _i569;
import 'package:rehab_path_app/features/auth/presentation/cubit/auth_cubit.dart'
    as _i761;
import 'package:rehab_path_app/features/exercise/data/repositories/exercise_repository_impl.dart'
    as _i169;
import 'package:rehab_path_app/features/exercise/domain/repositories/exercise_repository.dart'
    as _i8;
import 'package:rehab_path_app/features/exercise/domain/usecases/delete_partial_session_use_case.dart'
    as _i535;
import 'package:rehab_path_app/features/exercise/domain/usecases/get_all_exercises_use_case.dart'
    as _i30;
import 'package:rehab_path_app/features/exercise/domain/usecases/get_exercise_by_id_use_case.dart'
    as _i716;
import 'package:rehab_path_app/features/exercise/domain/usecases/get_exercises_by_level_use_case.dart'
    as _i774;
import 'package:rehab_path_app/features/exercise/domain/usecases/get_today_schedule_use_case.dart'
    as _i510;
import 'package:rehab_path_app/features/exercise/domain/usecases/save_exercise_session_use_case.dart'
    as _i277;
import 'package:rehab_path_app/features/exercise/presentation/cubit/exercise_cubit.dart'
    as _i938;
import 'package:rehab_path_app/features/exercise/presentation/cubit/exercise_player_cubit.dart'
    as _i565;
import 'package:rehab_path_app/features/home/data/repositories/message_repository_impl.dart'
    as _i576;
import 'package:rehab_path_app/features/home/domain/repositories/message_repository.dart'
    as _i84;
import 'package:rehab_path_app/features/home/domain/usecases/get_random_message_use_case.dart'
    as _i467;
import 'package:rehab_path_app/features/home/domain/usecases/get_streak_use_case.dart'
    as _i484;
import 'package:rehab_path_app/features/home/domain/usecases/get_today_schedule_use_case.dart'
    as _i547;
import 'package:rehab_path_app/features/home/presentation/cubit/home_cubit.dart'
    as _i343;
import 'package:rehab_path_app/features/notifications/data/repositories/notification_repository_impl.dart'
    as _i111;
import 'package:rehab_path_app/features/notifications/domain/repositories/notification_repository.dart'
    as _i183;
import 'package:rehab_path_app/features/notifications/domain/usecases/cancel_daily_reminder_use_case.dart'
    as _i186;
import 'package:rehab_path_app/features/notifications/domain/usecases/check_streak_milestone_use_case.dart'
    as _i130;
import 'package:rehab_path_app/features/notifications/domain/usecases/request_notification_permission_use_case.dart'
    as _i242;
import 'package:rehab_path_app/features/notifications/domain/usecases/schedule_daily_reminder_use_case.dart'
    as _i321;
import 'package:rehab_path_app/features/notifications/domain/usecases/schedule_re_engagement_use_case.dart'
    as _i770;
import 'package:rehab_path_app/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i971;
import 'package:rehab_path_app/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i955;
import 'package:rehab_path_app/features/onboarding/domain/usecases/compute_program_level_use_case.dart'
    as _i1017;
import 'package:rehab_path_app/features/onboarding/domain/usecases/get_partial_onboarding_use_case.dart'
    as _i465;
import 'package:rehab_path_app/features/onboarding/domain/usecases/save_onboarding_profile_use_case.dart'
    as _i561;
import 'package:rehab_path_app/features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i489;
import 'package:rehab_path_app/features/profile/data/repositories/profile_repository_impl.dart'
    as _i57;
import 'package:rehab_path_app/features/profile/domain/repositories/profile_repository.dart'
    as _i448;
import 'package:rehab_path_app/features/profile/domain/usecases/get_profile_use_case.dart'
    as _i852;
import 'package:rehab_path_app/features/profile/domain/usecases/update_profile_use_case.dart'
    as _i695;
import 'package:rehab_path_app/features/profile/presentation/cubit/profile_cubit.dart'
    as _i667;
import 'package:rehab_path_app/features/progress/data/repositories/progress_repository_impl.dart'
    as _i588;
import 'package:rehab_path_app/features/progress/domain/repositories/progress_repository.dart'
    as _i190;
import 'package:rehab_path_app/features/progress/domain/usecases/check_and_award_badges_use_case.dart'
    as _i145;
import 'package:rehab_path_app/features/progress/domain/usecases/get_badges_use_case.dart'
    as _i969;
import 'package:rehab_path_app/features/progress/domain/usecases/get_balance_scores_use_case.dart'
    as _i246;
import 'package:rehab_path_app/features/progress/domain/usecases/get_fall_events_for_month_use_case.dart'
    as _i617;
import 'package:rehab_path_app/features/progress/domain/usecases/get_monthly_adherence_use_case.dart'
    as _i528;
import 'package:rehab_path_app/features/progress/domain/usecases/get_streak_use_case.dart'
    as _i342;
import 'package:rehab_path_app/features/progress/domain/usecases/get_weekly_adherence_use_case.dart'
    as _i725;
import 'package:rehab_path_app/features/progress/domain/usecases/log_fall_event_use_case.dart'
    as _i1018;
import 'package:rehab_path_app/features/progress/domain/usecases/remove_fall_event_use_case.dart'
    as _i639;
import 'package:rehab_path_app/features/progress/presentation/cubit/progress_cubit.dart'
    as _i414;
import 'package:rehab_path_app/features/settings/data/repositories/settings_repository_impl.dart'
    as _i141;
import 'package:rehab_path_app/features/settings/domain/repositories/settings_repository.dart'
    as _i400;
import 'package:rehab_path_app/features/settings/domain/usecases/get_font_size_level_use_case.dart'
    as _i133;
import 'package:rehab_path_app/features/settings/domain/usecases/get_locale_use_case.dart'
    as _i46;
import 'package:rehab_path_app/features/settings/domain/usecases/get_notifications_enabled_use_case.dart'
    as _i460;
import 'package:rehab_path_app/features/settings/domain/usecases/get_theme_mode_use_case.dart'
    as _i682;
import 'package:rehab_path_app/features/settings/domain/usecases/get_voice_cues_enabled_use_case.dart'
    as _i656;
import 'package:rehab_path_app/features/settings/domain/usecases/save_font_size_level_use_case.dart'
    as _i801;
import 'package:rehab_path_app/features/settings/domain/usecases/save_locale_use_case.dart'
    as _i598;
import 'package:rehab_path_app/features/settings/domain/usecases/save_notifications_enabled_use_case.dart'
    as _i587;
import 'package:rehab_path_app/features/settings/domain/usecases/save_theme_mode_use_case.dart'
    as _i40;
import 'package:rehab_path_app/features/settings/domain/usecases/save_voice_cues_enabled_use_case.dart'
    as _i299;
import 'package:rehab_path_app/features/settings/presentation/cubit/settings_cubit.dart'
    as _i866;
import 'package:rehab_path_app/features/sos/presentation/cubit/sos_cubit.dart'
    as _i37;
import 'package:rehab_path_app/shared/data/datasources/dummy_data_source.dart'
    as _i912;
import 'package:rehab_path_app/shared/data/datasources/hive_data_source.dart'
    as _i217;
import 'package:rehab_path_app/shared/data/datasources/shared_preferences_data_source.dart'
    as _i153;
import 'package:rehab_path_app/shared/data/seeding/data_seeder.dart' as _i217;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i974.Logger>(() => appModule.logger);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
        () => appModule.flutterLocalNotificationsPlugin);
    gh.lazySingleton<_i912.DummyDataSource>(() => _i912.DummyDataSource());
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.userBox,
      instanceName: 'userBox',
    );
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.sessionBox,
      instanceName: 'sessionBox',
    );
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.fallEventBox,
      instanceName: 'fallEventBox',
    );
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.settingsBox,
      instanceName: 'settingsBox',
    );
    gh.lazySingleton<_i153.SharedPreferencesDataSource>(
        () => _i153.SharedPreferencesDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.notificationBox,
      instanceName: 'notificationBox',
    );
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.badgeBox,
      instanceName: 'badgeBox',
    );
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => appModule.onboardingBox,
      instanceName: 'onboardingBox',
    );
    gh.lazySingleton<_i183.NotificationRepository>(
        () => _i111.NotificationRepositoryImpl(
              gh<_i163.FlutterLocalNotificationsPlugin>(),
              gh<_i153.SharedPreferencesDataSource>(),
              gh<_i974.Logger>(),
            ));
    gh.lazySingleton<_i84.MessageRepository>(() => _i576.MessageRepositoryImpl(
          gh<_i912.DummyDataSource>(),
          gh<_i974.Logger>(),
        ));
    gh.lazySingleton<_i217.HiveDataSource>(() => _i217.HiveDataSource(
          gh<_i979.Box<dynamic>>(instanceName: 'userBox'),
          gh<_i979.Box<dynamic>>(instanceName: 'sessionBox'),
          gh<_i979.Box<dynamic>>(instanceName: 'fallEventBox'),
          gh<_i979.Box<dynamic>>(instanceName: 'badgeBox'),
          gh<_i979.Box<dynamic>>(instanceName: 'onboardingBox'),
          gh<_i979.Box<dynamic>>(instanceName: 'settingsBox'),
          gh<_i979.Box<dynamic>>(instanceName: 'notificationBox'),
        ));
    gh.lazySingleton<_i400.SettingsRepository>(
        () => _i141.SettingsRepositoryImpl(
              gh<_i153.SharedPreferencesDataSource>(),
              gh<_i974.Logger>(),
            ));
    gh.lazySingleton<_i8.ExerciseRepository>(() => _i169.ExerciseRepositoryImpl(
          gh<_i912.DummyDataSource>(),
          gh<_i217.HiveDataSource>(),
          gh<_i974.Logger>(),
        ));
    gh.lazySingleton<_i9.AuthRepository>(() => _i434.AuthRepositoryImpl(
          gh<_i217.HiveDataSource>(),
          gh<_i153.SharedPreferencesDataSource>(),
          gh<_i974.Logger>(),
        ));
    gh.lazySingleton<_i955.OnboardingRepository>(
        () => _i971.OnboardingRepositoryImpl(
              gh<_i217.HiveDataSource>(),
              gh<_i153.SharedPreferencesDataSource>(),
              gh<_i974.Logger>(),
            ));
    gh.lazySingleton<_i1017.ComputeProgramLevelUseCase>(() =>
        _i1017.ComputeProgramLevelUseCase(gh<_i955.OnboardingRepository>()));
    gh.lazySingleton<_i465.GetPartialOnboardingUseCase>(() =>
        _i465.GetPartialOnboardingUseCase(gh<_i955.OnboardingRepository>()));
    gh.lazySingleton<_i561.SaveOnboardingProfileUseCase>(() =>
        _i561.SaveOnboardingProfileUseCase(gh<_i955.OnboardingRepository>()));
    gh.lazySingleton<_i448.ProfileRepository>(() => _i57.ProfileRepositoryImpl(
          gh<_i217.HiveDataSource>(),
          gh<_i974.Logger>(),
        ));
    gh.factory<_i133.GetFontSizeLevelUseCase>(
        () => _i133.GetFontSizeLevelUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i46.GetLocaleUseCase>(
        () => _i46.GetLocaleUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i460.GetNotificationsEnabledUseCase>(() =>
        _i460.GetNotificationsEnabledUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i682.GetThemeModeUseCase>(
        () => _i682.GetThemeModeUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i801.SaveFontSizeLevelUseCase>(
        () => _i801.SaveFontSizeLevelUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i598.SaveLocaleUseCase>(
        () => _i598.SaveLocaleUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i587.SaveNotificationsEnabledUseCase>(() =>
        _i587.SaveNotificationsEnabledUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i40.SaveThemeModeUseCase>(
        () => _i40.SaveThemeModeUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i656.GetVoiceCuesEnabledUseCase>(
        () => _i656.GetVoiceCuesEnabledUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i299.SaveVoiceCuesEnabledUseCase>(() =>
        _i299.SaveVoiceCuesEnabledUseCase(gh<_i400.SettingsRepository>()));
    gh.factory<_i310.CreateGuestSessionUseCase>(
        () => _i310.CreateGuestSessionUseCase(gh<_i9.AuthRepository>()));
    gh.factory<_i1056.GetSessionUseCase>(
        () => _i1056.GetSessionUseCase(gh<_i9.AuthRepository>()));
    gh.factory<_i457.LoginUseCase>(
        () => _i457.LoginUseCase(gh<_i9.AuthRepository>()));
    gh.factory<_i134.LogoutUseCase>(
        () => _i134.LogoutUseCase(gh<_i9.AuthRepository>()));
    gh.factory<_i569.RegisterUseCase>(
        () => _i569.RegisterUseCase(gh<_i9.AuthRepository>()));
    gh.factory<_i186.CancelDailyReminderUseCase>(() =>
        _i186.CancelDailyReminderUseCase(gh<_i183.NotificationRepository>()));
    gh.factory<_i130.CheckStreakMilestoneUseCase>(() =>
        _i130.CheckStreakMilestoneUseCase(gh<_i183.NotificationRepository>()));
    gh.factory<_i242.RequestNotificationPermissionUseCase>(() =>
        _i242.RequestNotificationPermissionUseCase(
            gh<_i183.NotificationRepository>()));
    gh.factory<_i321.ScheduleDailyReminderUseCase>(() =>
        _i321.ScheduleDailyReminderUseCase(gh<_i183.NotificationRepository>()));
    gh.factory<_i770.ScheduleReEngagementUseCase>(() =>
        _i770.ScheduleReEngagementUseCase(gh<_i183.NotificationRepository>()));
    gh.lazySingleton<_i190.ProgressRepository>(
        () => _i588.ProgressRepositoryImpl(
              gh<_i217.HiveDataSource>(),
              gh<_i912.DummyDataSource>(),
              gh<_i974.Logger>(),
            ));
    gh.factory<_i467.GetRandomMessageUseCase>(
        () => _i467.GetRandomMessageUseCase(gh<_i84.MessageRepository>()));
    gh.lazySingleton<_i217.DataSeeder>(() => _i217.DataSeeder(
          gh<_i912.DummyDataSource>(),
          gh<_i217.HiveDataSource>(),
          gh<_i153.SharedPreferencesDataSource>(),
          gh<_i974.Logger>(),
        ));
    gh.factory<_i484.GetStreakUseCase>(
        () => _i484.GetStreakUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i969.GetBadgesUseCase>(
        () => _i969.GetBadgesUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i246.GetBalanceScoresUseCase>(
        () => _i246.GetBalanceScoresUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i617.GetFallEventsForMonthUseCase>(() =>
        _i617.GetFallEventsForMonthUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i528.GetMonthlyAdherenceUseCase>(
        () => _i528.GetMonthlyAdherenceUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i342.GetStreakUseCase>(
        () => _i342.GetStreakUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i725.GetWeeklyAdherenceUseCase>(
        () => _i725.GetWeeklyAdherenceUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i1018.LogFallEventUseCase>(
        () => _i1018.LogFallEventUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i639.RemoveFallEventUseCase>(
        () => _i639.RemoveFallEventUseCase(gh<_i190.ProgressRepository>()));
    gh.factory<_i866.SettingsCubit>(() => _i866.SettingsCubit(
          gh<_i682.GetThemeModeUseCase>(),
          gh<_i40.SaveThemeModeUseCase>(),
          gh<_i46.GetLocaleUseCase>(),
          gh<_i598.SaveLocaleUseCase>(),
          gh<_i133.GetFontSizeLevelUseCase>(),
          gh<_i801.SaveFontSizeLevelUseCase>(),
          gh<_i460.GetNotificationsEnabledUseCase>(),
          gh<_i587.SaveNotificationsEnabledUseCase>(),
          gh<_i242.RequestNotificationPermissionUseCase>(),
          gh<_i656.GetVoiceCuesEnabledUseCase>(),
          gh<_i299.SaveVoiceCuesEnabledUseCase>(),
          gh<_i768.AppCubit>(),
        ));
    gh.factory<_i489.OnboardingCubit>(() => _i489.OnboardingCubit(
          gh<_i561.SaveOnboardingProfileUseCase>(),
          gh<_i465.GetPartialOnboardingUseCase>(),
          gh<_i1017.ComputeProgramLevelUseCase>(),
        ));
    gh.factory<_i547.GetTodayScheduleUseCase>(
        () => _i547.GetTodayScheduleUseCase(gh<_i8.ExerciseRepository>()));
    gh.lazySingleton<_i535.DeletePartialSessionUseCase>(
        () => _i535.DeletePartialSessionUseCase(gh<_i8.ExerciseRepository>()));
    gh.lazySingleton<_i30.GetAllExercisesUseCase>(
        () => _i30.GetAllExercisesUseCase(gh<_i8.ExerciseRepository>()));
    gh.lazySingleton<_i774.GetExercisesByLevelUseCase>(
        () => _i774.GetExercisesByLevelUseCase(gh<_i8.ExerciseRepository>()));
    gh.lazySingleton<_i716.GetExerciseByIdUseCase>(
        () => _i716.GetExerciseByIdUseCase(gh<_i8.ExerciseRepository>()));
    gh.lazySingleton<_i510.GetTodayScheduleUseCase>(
        () => _i510.GetTodayScheduleUseCase(gh<_i8.ExerciseRepository>()));
    gh.lazySingleton<_i277.SaveExerciseSessionUseCase>(
        () => _i277.SaveExerciseSessionUseCase(gh<_i8.ExerciseRepository>()));
    gh.factory<_i852.GetProfileUseCase>(
        () => _i852.GetProfileUseCase(gh<_i448.ProfileRepository>()));
    gh.factory<_i695.UpdateProfileUseCase>(
        () => _i695.UpdateProfileUseCase(gh<_i448.ProfileRepository>()));
    gh.factory<_i667.ProfileCubit>(() => _i667.ProfileCubit(
          gh<_i852.GetProfileUseCase>(),
          gh<_i695.UpdateProfileUseCase>(),
        ));
    gh.lazySingleton<_i761.AuthCubit>(() => _i761.AuthCubit(
          gh<_i457.LoginUseCase>(),
          gh<_i569.RegisterUseCase>(),
          gh<_i134.LogoutUseCase>(),
          gh<_i1056.GetSessionUseCase>(),
          gh<_i310.CreateGuestSessionUseCase>(),
          gh<_i153.SharedPreferencesDataSource>(),
        ));
    gh.factory<_i565.ExercisePlayerCubit>(() => _i565.ExercisePlayerCubit(
          gh<_i277.SaveExerciseSessionUseCase>(),
          gh<_i535.DeletePartialSessionUseCase>(),
        ));
    gh.lazySingleton<_i343.HomeCubit>(() => _i343.HomeCubit(
          gh<_i467.GetRandomMessageUseCase>(),
          gh<_i484.GetStreakUseCase>(),
          gh<_i547.GetTodayScheduleUseCase>(),
          gh<_i774.GetExercisesByLevelUseCase>(),
          gh<_i217.HiveDataSource>(),
        ));
    gh.factory<_i145.CheckAndAwardBadgesUseCase>(
        () => _i145.CheckAndAwardBadgesUseCase(
              gh<_i190.ProgressRepository>(),
              gh<_i342.GetStreakUseCase>(),
            ));
    gh.factory<_i938.ExerciseCubit>(
        () => _i938.ExerciseCubit(gh<_i30.GetAllExercisesUseCase>()));
    gh.factory<_i37.SosCubit>(
        () => _i37.SosCubit(gh<_i852.GetProfileUseCase>()));
    gh.lazySingleton<_i414.ProgressCubit>(() => _i414.ProgressCubit(
          gh<_i725.GetWeeklyAdherenceUseCase>(),
          gh<_i528.GetMonthlyAdherenceUseCase>(),
          gh<_i246.GetBalanceScoresUseCase>(),
          gh<_i1018.LogFallEventUseCase>(),
          gh<_i639.RemoveFallEventUseCase>(),
          gh<_i617.GetFallEventsForMonthUseCase>(),
          gh<_i969.GetBadgesUseCase>(),
          gh<_i145.CheckAndAwardBadgesUseCase>(),
        ));
    return this;
  }
}

class _$AppModule extends _i828.AppModule {}
