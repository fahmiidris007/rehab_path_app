import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// A horizontal, week-scoped date selector for the home dashboard.
///
/// Renders 7 day cells (Mon–Sun) derived from [weekStart] together with
/// previous/next-week navigation buttons. Tapping a cell calls
/// [onDateSelected] without performing any navigation, so the parent
/// can drive read-only "view-mode" rendering of the dashboard.
///
/// Highlight rules:
/// - The cell whose date equals [todayLocal] is rendered with an accent
///   border.
/// - The cell whose date equals [selectedDate] is rendered with a filled
///   accent background.
/// - Other cells are rendered plain.
///
/// Future-dated cells (date after [todayLocal]) remain tappable; the parent
/// is responsible for showing read-only / "not yet started" affordances.
class DateSelector extends StatelessWidget {
  const DateSelector({
    required this.selectedDate,
    required this.todayLocal,
    required this.weekStart,
    required this.onDateSelected,
    required this.onPrevWeek,
    required this.onNextWeek,
    super.key,
  });

  /// The date currently selected by the user.
  final DateTime selectedDate;

  /// Today's date in the device's local timezone, normalized to midnight.
  final DateTime todayLocal;

  /// The Monday of the week being displayed, normalized to midnight.
  final DateTime weekStart;

  /// Called when the user taps a day cell.
  final ValueChanged<DateTime> onDateSelected;

  /// Called when the user taps the previous-week chevron.
  final VoidCallback onPrevWeek;

  /// Called when the user taps the next-week chevron.
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final weekdayFormat = DateFormat.E(locale);
    final accessibleFormat = DateFormat.MMMEd(locale);

    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          label: l10n.dashboardDateSelectorPrev,
          button: true,
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: l10n.dashboardDateSelectorPrev,
            onPressed: onPrevWeek,
          ),
        ),
        ...List.generate(7, (index) {
          final date = _normalize(weekStart).add(Duration(days: index));
          final isToday = _isSameDay(date, todayLocal);
          final isSelected = _isSameDay(date, selectedDate);
          final dayLabel = weekdayFormat.format(date).characters.first;
          final semanticsLabel = accessibleFormat.format(date);

          return Expanded(
            child: _DayCell(
              date: date,
              dayLabel: dayLabel,
              semanticsLabel: semanticsLabel,
              isToday: isToday,
              isSelected: isSelected,
              onTap: () => onDateSelected(date),
            ),
          );
        }),
        Semantics(
          label: l10n.dashboardDateSelectorNext,
          button: true,
          child: IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: l10n.dashboardDateSelectorNext,
            onPressed: onNextWeek,
          ),
        ),
      ],
    );
  }

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.dayLabel,
    required this.semanticsLabel,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final String dayLabel;
  final String semanticsLabel;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isSelected ? AppColors.accent : Colors.transparent;
    final Border? border = isToday && !isSelected
        ? Border.all(color: AppColors.accent, width: 2)
        : null;
    final Color textColor = isSelected
        ? AppColors.textOnPrimary
        : isToday
        ? AppColors.accentDark
        : AppColors.textSecondary;

    return Semantics(
      label: semanticsLabel,
      button: true,
      selected: isSelected,
      child: SizedBox(
        width: AppDimensions.minTouchTarget,
        height: AppDimensions.minTouchTarget,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                border: border,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayLabel,
                    style: AppTextStyles.body.copyWith(
                      color: textColor,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: AppTextStyles.bodySemiBold.copyWith(
                      color: textColor,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
