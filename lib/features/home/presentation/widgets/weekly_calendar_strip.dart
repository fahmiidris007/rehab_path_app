import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';

/// A 7-day calendar strip (Mon–Sun) that highlights completed days.
///
/// The current day is outlined; completed days are filled with
/// [AppColors.primary].
class WeeklyCalendarStrip extends StatelessWidget {
  const WeeklyCalendarStrip({
    required this.completedDays,
    super.key,
  });

  /// List of dates on which the user completed at least one exercise session.
  final List<DateTime> completedDays;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // Find the Monday of the current week.
    final monday = today.subtract(Duration(days: today.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = monday.add(Duration(days: index));
        final isToday = _isSameDay(day, today);
        final isCompleted =
            completedDays.any((d) => _isSameDay(d, day));

        return _DayCell(
          label: _dayLabels[index],
          dayNumber: day.day,
          isToday: isToday,
          isCompleted: isCompleted,
        );
      }),
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.dayNumber,
    required this.isToday,
    required this.isCompleted,
  });

  final String label;
  final int dayNumber;
  final bool isToday;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        isCompleted ? AppColors.primary : Colors.transparent;
    final Color textColor = isCompleted
        ? AppColors.textOnPrimary
        : isToday
            ? AppColors.primary
            : AppColors.textSecondary;
    final Border? border = isToday && !isCompleted
        ? Border.all(color: AppColors.primary, width: 2)
        : null;

    return Container(
      width: AppDimensions.minTouchTarget,
      height: AppDimensions.minTouchTarget,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: border,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: textColor,
              fontSize: 12,
              height: 1.2,
            ),
          ),
          Text(
            '$dayNumber',
            style: AppTextStyles.bodySemiBold.copyWith(
              color: textColor,
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
