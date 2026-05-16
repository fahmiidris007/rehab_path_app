import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_motivational_card.dart';
import '../../../../core/widgets/app_progress_ring.dart';
import '../../../../core/widgets/app_streak_badge.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../core/widgets/guest_banner.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/exercise_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_stats_row.dart';
import '../widgets/today_workout_card.dart';
import '../widgets/weekly_calendar_strip.dart';

/// The main home dashboard screen.
///
/// Provides [HomeCubit] via [BlocProvider], loads dashboard data on init
/// using the current user from [AuthCubit], and renders the full dashboard
/// layout once data is available.
///
/// Because [HomeCubit] is `@injectable` (not a singleton), a fresh instance
/// is created every time this page is pushed/replaced, ensuring the dashboard
/// always shows up-to-date data after returning from the exercise player.
class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _cubit.loadDashboard(authState.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>.value(
      value: _cubit,
      child: const _HomeDashboardView(),
    );
  }
}
class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeLoading() => Scaffold(
              body: AppLoadingWidget(label: l10n.loadingDashboard),
            ),          HomeError(:final message) => Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: AppErrorWidget(
                    message: message,
                    onRetry: () {
                      final authState = context.read<AuthCubit>().state;
                      if (authState is AuthAuthenticated) {
                        context
                            .read<HomeCubit>()
                            .loadDashboard(authState.user);
                      }
                    },
                  ),
                ),
              ),
            ),
          HomeLoaded(:final data) => _LoadedDashboard(data: data),
        };
      },
    );
  }
}

class _LoadedDashboard extends StatelessWidget {
  const _LoadedDashboard({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthCubit>().state;
    final isGuest = authState is AuthGuest;

    // Locale-aware motivational message text.
    final appLocale = context.watch<AppCubit>().state.locale;
    final messageText = appLocale == AppLocale.id
        ? data.motivationalMessage.textId
        : data.motivationalMessage.textEn;

    // First name only.
    final firstName = data.user.name.split(' ').first;

    // Progress percentage.
    final hasSchedule = data.todaySchedule.isNotEmpty;
    final progressPercent = hasSchedule
        ? (data.completedToday / data.todaySchedule.length).clamp(0.0, 1.0)
        : 0.0;

    // Total duration of TODAY's scheduled exercises in minutes (for TodayWorkoutCard).
    final todayTotalMinutes = data.todaySchedule.fold<int>(
      0,
      (sum, e) => sum + (e.durationSeconds / 60).ceil(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppTopAppBar(
            title: l10n.appName,
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.emergency, color: AppColors.error),
              //   onPressed: () => context.pushNamed(RouteNames.sos),
              //   tooltip: 'SOS',
              //   style: IconButton.styleFrom(
              //     minimumSize: const Size(56, 56),
              //   ),
              // ),
              AppStreakBadge(
                streakDays: data.streakDays,
                label: l10n.homeStatDayStreak,
              ),
              const SizedBox(width: 8),
              // User avatar
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                    style: AppTextStyles.bodySemiBold
                        .copyWith(color: AppColors.textOnPrimary),
                  ),
                ),
              ),
            ],
          ),
          if (isGuest)
            GuestBanner(
              message: l10n.homeGuestBannerMessage,
              onRegisterTap: () => context.pushNamed(RouteNames.register),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Greeting ──────────────────────────────────────────
                  GreetingHeader(firstName: firstName),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // ── Motivational card ─────────────────────────────────
                  AppMotivationalCard(message: messageText),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // ── Progress ring / zero state ────────────────────────
                  if (hasSchedule) ...[
                    Center(
                      child: AppProgressRing(
                        percentage: progressPercent,
                        label: l10n.homeDone,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),

                    // ── Today's workout card ──────────────────────────
                    TodayWorkoutCard(
                      exerciseCount: data.todaySchedule.length,
                      completedCount: data.completedToday,
                      totalMinutes: todayTotalMinutes,
                      onStartPressed: () {
                        final cubit = context.read<HomeCubit>();
                        if (!cubit.canNavigate) return;
                        cubit.startNavigation();

                        // Navigate to the next incomplete exercise, or the
                        // first one if all are done (restart scenario).
                        final nextExercise = cubit.getNextIncompleteExercise();
                        if (nextExercise != null) {
                          context.goNamed(
                            RouteNames.exerciseDetail,
                            pathParameters: {'id': nextExercise.id},
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),
                  ] else ...[
                    ZeroStateWidget(
                      icon: const Icon(
                        Icons.event_available_outlined,
                        color: AppColors.textDisabled,
                        size: 64,
                      ),
                      title: l10n.homeNoExercisesToday,
                      subtitle: l10n.homeRestDayMessage,
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),
                  ],

                  // ── Quick stats ───────────────────────────────────────
                  QuickStatsRow(
                    totalMinutes: data.totalMinutes,
                    totalSessions: data.totalSessions,
                    streakDays: data.streakDays,
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // ── Weekly calendar strip ─────────────────────────────
                  WeeklyCalendarStrip(
                    completedDays: data.completedDaysThisWeek,
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // ── Recommended section ───────────────────────────────
                  Text(
                    l10n.homeRecommendedFor,
                    style: AppTextStyles.h3Section
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppDimensions.cardGap),

                  if (data.recommendedExercises.isEmpty)
                    Text(
                      l10n.homeNoRecommendations,
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.textSecondary),
                    )
                  else
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.recommendedExercises.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppDimensions.cardGap),
                        itemBuilder: (context, index) {
                          final exercise =
                              data.recommendedExercises[index];
                          return ExerciseCard(
                            exercise: exercise,
                            onTap: () => context.goNamed(
                              RouteNames.exerciseDetail,
                              pathParameters: {'id': exercise.id},
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
