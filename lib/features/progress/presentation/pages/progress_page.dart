import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../shared/domain/entities/balance_score_point.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import '../widgets/badge_card.dart';

/// The Progress tab page.
///
/// Provides [ProgressCubit] via [BlocProvider], loads progress data on init
/// using the current user ID from [AuthCubit], and renders five sections:
/// 1. Adherence Charts
/// 2. Balance Score Trend
/// 3. Falls Diary
/// 4. Achievements
/// 5. Body Areas Worked
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late final ProgressCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProgressCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    final authState = context.read<AuthCubit>().state;
    final userId = switch (authState) {
      AuthAuthenticated(:final user) => user.id,
      _ => 'guest',
    };
    _cubit.loadProgress(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProgressCubit>.value(
      value: _cubit,
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Progress',
          style: AppTextStyles.h2AppBar.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          return switch (state) {
            ProgressLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProgressError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ProgressLoaded(:final data) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                  vertical: AppDimensions.sectionGap / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AdherenceSection(
                      weeklyRate: data.weeklyAdherenceRate,
                      monthlyRate: data.monthlyAdherenceRate,
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),
                    _BalanceScoreSection(scores: data.balanceScores),
                    const SizedBox(height: AppDimensions.sectionGap),
                    _FallsDiarySection(
                      fallEvents: data.fallEventsThisMonth,
                    ),
                    const SizedBox(height: AppDimensions.sectionGap),
                    _AchievementsSection(badges: data.badges),
                    const SizedBox(height: AppDimensions.sectionGap),
                    _BodyAreasSection(
                        muscleGroups: data.workedMuscleGroups),
                    const SizedBox(height: AppDimensions.sectionGap),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}

// ── Section 1: Adherence Charts ───────────────────────────────────────────────

class _AdherenceSection extends StatelessWidget {
  const _AdherenceSection({
    required this.weeklyRate,
    required this.monthlyRate,
  });

  final double weeklyRate;
  final double monthlyRate;

  @override
  Widget build(BuildContext context) {
    final hasData = weeklyRate > 0 || monthlyRate > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Adherence', style: AppTextStyles.h3Section),
        const SizedBox(height: AppDimensions.cardGap),
        AppCard(
          child: hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This Week', style: AppTextStyles.bodySemiBold),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: _AdherenceBarChart(
                        label: 'Weekly',
                        value: weeklyRate,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('This Month', style: AppTextStyles.bodySemiBold),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: _AdherenceBarChart(
                        label: 'Monthly',
                        value: monthlyRate,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                )
              : const ZeroStateWidget(
                  title: 'No data yet',
                  subtitle: 'Complete exercises to see your progress.',
                ),
        ),
      ],
    );
  }
}

class _AdherenceBarChart extends StatelessWidget {
  const _AdherenceBarChart({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: pct.toDouble(),
                color: color,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                '$pct%',
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 25,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppColors.border.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

// ── Section 2: Balance Score Trend ────────────────────────────────────────────

class _BalanceScoreSection extends StatelessWidget {
  const _BalanceScoreSection({required this.scores});

  final List<BalanceScorePoint> scores;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Balance Score Trend', style: AppTextStyles.h3Section),
        const SizedBox(height: AppDimensions.cardGap),
        AppCard(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: scores.isEmpty
              ? const ZeroStateWidget(
                  title: 'No balance data yet',
                  subtitle:
                      'Complete balance assessments to track your trend.',
                )
              : SizedBox(
                  height: 200,
                  child: _BalanceLineChart(scores: scores),
                ),
        ),
      ],
    );
  }
}

class _BalanceLineChart extends StatelessWidget {
  const _BalanceLineChart({required this.scores});

  final List<BalanceScorePoint> scores;

  @override
  Widget build(BuildContext context) {
    // Sort by date ascending
    final sorted = [...scores]
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = sorted.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.score.toDouble());
    }).toList();

    final dateLabels = sorted
        .map((s) => DateFormat('MM/dd').format(s.date))
        .toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 56,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 14,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppColors.border.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.8), width: 1),
            left: BorderSide(
                color: AppColors.border.withValues(alpha: 0.8), width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= dateLabels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    dateLabels[idx],
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 14,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, pct, bar, idx) =>
                  FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: AppColors.surfaceWhite,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section 3: Falls Diary ────────────────────────────────────────────────────

class _FallsDiarySection extends StatefulWidget {
  const _FallsDiarySection({required this.fallEvents});

  final List<FallEventEntity> fallEvents;

  @override
  State<_FallsDiarySection> createState() => _FallsDiarySectionState();
}

class _FallsDiarySectionState extends State<_FallsDiarySection> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  Set<DateTime> get _fallDates {
    return widget.fallEvents
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();
  }

  bool _isFallDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _fallDates.contains(normalized);
  }

  void _onDaySelected(BuildContext context, DateTime selectedDay,
      DateTime focusedDay) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tapped = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    // Future dates have no effect
    if (tapped.isAfter(today)) return;

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final authState = context.read<AuthCubit>().state;
    final userId = switch (authState) {
      AuthAuthenticated(:final user) => user.id,
      _ => 'guest',
    };

    final cubit = context.read<ProgressCubit>();
    if (_isFallDay(selectedDay)) {
      // Find the event ID and remove it
      final event = widget.fallEvents.firstWhere(
        (e) =>
            DateTime(e.date.year, e.date.month, e.date.day) == tapped,
      );
      cubit.removeFall(userId, event.id);
    } else {
      cubit.logFall(userId, selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Falls Diary', style: AppTextStyles.h3Section),
        const SizedBox(height: AppDimensions.cardGap),
        AppCard(
          padding: const EdgeInsets.all(8),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) =>
                _onDaySelected(context, selected, focused),
            onPageChanged: (focused) {
              setState(() => _focusedDay = focused);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              todayTextStyle:
                  const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle:
                  const TextStyle(color: AppColors.surfaceWhite),
              markerDecoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppTextStyles.bodySemiBold
                  .copyWith(color: AppColors.textPrimary),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_isFallDay(day)) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Fall recorded — tap to remove',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Section 4: Achievements ───────────────────────────────────────────────────

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection({required this.badges});

  final List<dynamic> badges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: AppTextStyles.h3Section),
        const SizedBox(height: AppDimensions.cardGap),
        badges.isEmpty
            ? AppCard(
                child: const ZeroStateWidget(
                  title: 'No badges yet',
                  subtitle: 'Keep exercising to earn your first badge!',
                ),
              )
            : GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppDimensions.cardGap,
                mainAxisSpacing: AppDimensions.cardGap,
                childAspectRatio: 0.85,
                children: badges.map((badge) {
                  return BadgeCard(
                    name: badge.name as String,
                    isEarned: badge.isEarned as bool,
                  );
                }).toList(),
              ),
      ],
    );
  }
}

// ── Section 5: Body Areas Worked ─────────────────────────────────────────────

class _BodyAreasSection extends StatelessWidget {
  const _BodyAreasSection({required this.muscleGroups});

  final Set<String> muscleGroups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Body Areas Worked This Week', style: AppTextStyles.h3Section),
        const SizedBox(height: AppDimensions.cardGap),
        AppCard(
          child: muscleGroups.isEmpty
              ? const ZeroStateWidget(
                  title: 'No areas tracked yet',
                  subtitle:
                      'Complete exercises this week to see which muscle groups you\'ve worked.',
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: muscleGroups.map((group) {
                    return Chip(
                      label: Text(
                        group,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      backgroundColor: AppColors.blueLightBorder,
                      side: const BorderSide(
                          color: AppColors.primary, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusPill),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
