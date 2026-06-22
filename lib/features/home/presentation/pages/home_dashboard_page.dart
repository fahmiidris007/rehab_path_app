import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_motivational_card.dart';
import '../../../../core/widgets/app_outline_button.dart';
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
import '../widgets/date_selector.dart';
import '../widgets/exercise_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/today_workout_card.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
      _maybeRecommendBiometric();
    });
  }

  void _load() {
    if (!mounted) return;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _cubit.loadDashboard(authState.user);
    }
  }

  /// After a password-based login, recommend enabling biometric login if the
  /// device supports it but the user has not turned it on yet. Shows at most
  /// once per session and never again once the user opts out (handled by
  /// [AuthCubit.shouldRecommendBiometric]).
  Future<void> _maybeRecommendBiometric() async {
    final authCubit = context.read<AuthCubit>();
    // Only relevant for a real authenticated account — guests have no
    // credentials to store for biometric login.
    if (authCubit.state is! AuthAuthenticated) return;
    final shouldShow = await authCubit.shouldRecommendBiometric();
    if (!shouldShow || !mounted) return;
    await _showBiometricRecommendationDialog(authCubit);
  }

  Future<void> _showBiometricRecommendationDialog(AuthCubit authCubit) async {
    final l10n = AppLocalizations.of(context)!;
    var dontShowAgain = false;

    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text(l10n.dashboardBiometricPromptTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardBiometricPromptMessage,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: dontShowAgain,
                    onChanged: (v) =>
                        setLocalState(() => dontShowAgain = v ?? false),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primary,
                    title: Text(
                      l10n.dashboardBiometricPromptDontShowAgain,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(l10n.dashboardBiometricPromptConfirm),
                ),
              ],
            );
          },
        );
      },
    );

    // Persist the opt-out regardless of which button was pressed: tapping
    // Cancel with "don't show again" checked must suppress the popup even
    // though biometric is still disabled.
    if (dontShowAgain) {
      await authCubit.dismissBiometricRecommendation();
    }

    if (goToSettings == true && mounted) {
      context.pushNamed(RouteNames.settings);
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
          ),
          HomeError(:final message) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                child: AppErrorWidget(
                  message: message,
                  onRetry: () {
                    final authState = context.read<AuthCubit>().state;
                    if (authState is AuthAuthenticated) {
                      context.read<HomeCubit>().loadDashboard(authState.user);
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

    // View-mode flags (R9.2–R9.6).
    final isViewMode = data.isViewingPastOrFutureDate;
    final isFutureDate =
        isViewMode && data.selectedDate.isAfter(data.todayLocal);

    // Progress percentage. While in view-mode the ring reflects the
    // selected date via `progressRingPercent`; otherwise use today's
    // schedule completion fraction.
    final hasSchedule = data.todaySchedule.isNotEmpty;
    final progressPercent = isViewMode
        ? (data.progressRingPercent / 100).clamp(0.0, 1.0)
        : hasSchedule
        ? (data.completedToday / data.todaySchedule.length).clamp(0.0, 1.0)
        : 0.0;

    // Total duration of TODAY's scheduled exercises in minutes (for TodayWorkoutCard).
    final todayTotalMinutes = data.todaySchedule.fold<int>(
      0,
      (sum, e) => sum + (e.durationSeconds / 60).ceil(),
    );

    // Monday of the week containing the currently selected date.
    final selectedWeekday = data.selectedDate.weekday; // 1 = Monday
    final weekStart = DateTime(
      data.selectedDate.year,
      data.selectedDate.month,
      data.selectedDate.day,
    ).subtract(Duration(days: selectedWeekday - 1));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppTopAppBar(
            title: l10n.appName,
            actions: [
              // AppStreakBadge(
              //   streakDays: data.streakDays,
              //   label: l10n.homeStatDayStreak,
              // ),
              // const SizedBox(width: 8),
              // User avatar
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                    style: AppTextStyles.bodySemiBold.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // ── Greeting ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GreetingHeader(firstName: firstName),
                  ),
                  const SizedBox(height: 12),

                  // ── Motivational card ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppMotivationalCard(message: messageText),
                  ),
                  const SizedBox(height: 16),

                  // ── Progress ring / zero state ────────────────────────
                  if (hasSchedule || isViewMode) ...[
                    Center(
                      child: Column(
                        children: [
                          AppProgressRing(
                            percentage: progressPercent,
                            label: l10n.homeDone,
                          ),
                          if (isFutureDate) ...[
                            const SizedBox(height: 8),
                            Text(
                              l10n.dashboardNotYetStarted,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Today's workout card ──────────────────────────
                    // R9.5: Start button is disabled (onStartPressed null)
                    // when viewing a non-today date; tooltip provides a
                    // localized accessibility hint explaining why.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _MaybeTooltip(
                        message: isViewMode
                            ? l10n.dashboardStartOnlyToday
                            : null,
                        child: TodayWorkoutCard(
                          exerciseCount: data.todaySchedule.length,
                          completedCount: data.completedToday,
                          totalMinutes: todayTotalMinutes,
                          onStartPressed: isViewMode
                              ? null
                              : () {
                                  final cubit = context.read<HomeCubit>();
                                  if (!cubit.canNavigate) return;
                                  cubit.startNavigation();

                                  // Navigate to the next incomplete exercise, or
                                  // the first one if all are done (restart).
                                  // final nextExercise = cubit
                                  //     .getNextIncompleteExercise();
                                  // if (nextExercise != null) {
                                  //   context.goNamed(
                                  //     RouteNames.exerciseDetail,
                                  //     pathParameters: {'id': nextExercise.id},
                                  //   );
                                  // }
                                  context.goNamed(RouteNames.exerciseList);
                                },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ZeroStateWidget(
                        icon: const Icon(
                          Icons.event_available_outlined,
                          color: AppColors.textDisabled,
                          size: 64,
                        ),
                        title: l10n.homeNoExercisesToday,
                        subtitle: l10n.homeRestDayMessage,
                      ),
                    ),
                  ],

                  // ── Date selector (replaces WeeklyCalendarStrip) ──────
                  DateSelector(
                    selectedDate: data.selectedDate,
                    todayLocal: data.todayLocal,
                    weekStart: weekStart,
                    onDateSelected: (date) =>
                        context.read<HomeCubit>().selectDate(date),
                    onPrevWeek: () {
                      final newWeekStart = weekStart.subtract(
                        const Duration(days: 7),
                      );
                      context.read<HomeCubit>().selectDate(newWeekStart);
                    },
                    onNextWeek: () {
                      final newWeekStart = weekStart.add(
                        const Duration(days: 7),
                      );
                      context.read<HomeCubit>().selectDate(newWeekStart);
                    },
                  ),

                  // ── View-mode banner ─────────────────────────────────
                  if (isViewMode) ...[
                    const SizedBox(height: AppDimensions.cardGap),
                    _ViewingDateBanner(selectedDate: data.selectedDate),
                  ],
                  const SizedBox(height: AppDimensions.sectionGap),

                  // ── Recommended section ───────────────────────────────
                  // Text(
                  //   l10n.homeRecommendedFor,
                  //   style: AppTextStyles.h3Section
                  //       .copyWith(color: AppColors.textPrimary),
                  // ),
                  // const SizedBox(height: AppDimensions.cardGap),

                  // if (data.recommendedExercises.isEmpty)
                  //   Text(
                  //     l10n.homeNoRecommendations,
                  //     style: AppTextStyles.body
                  //         .copyWith(color: AppColors.textSecondary),
                  //   )
                  // else
                  //   SizedBox(
                  //     height: 240,
                  //     child: ListView.separated(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: data.recommendedExercises.length,
                  //       separatorBuilder: (_, __) =>
                  //           const SizedBox(width: AppDimensions.cardGap),
                  //       itemBuilder: (context, index) {
                  //         final exercise =
                  //             data.recommendedExercises[index];
                  //         return ExerciseCard(
                  //           exercise: exercise,
                  //           onTap: () => context.goNamed(
                  //             RouteNames.exerciseDetail,
                  //             pathParameters: {'id': exercise.id},
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
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

/// Banner shown above the dashboard content when the user is viewing a date
/// other than today. Displays the formatted selected date and provides a
/// "Back to today" button that resets the dashboard view-mode.
class _ViewingDateBanner extends StatelessWidget {
  const _ViewingDateBanner({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formattedDate = DateFormat.MMMEd(locale).format(selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.dashboardViewingDate(formattedDate),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          AppOutlineButton(
            label: l10n.dashboardBackToToday,
            onPressed: () => context.read<HomeCubit>().resetToToday(),
          ),
        ],
      ),
    );
  }
}

/// Wraps [child] in a [Tooltip] when [message] is non-null, otherwise
/// returns the child as-is. Avoids attaching an empty tooltip to widgets
/// (which would still consume long-press semantics).
class _MaybeTooltip extends StatelessWidget {
  const _MaybeTooltip({required this.message, required this.child});

  final String? message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (message == null) return child;
    return Tooltip(message: message!, child: child);
  }
}
