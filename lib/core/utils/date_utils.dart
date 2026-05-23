/// Date helpers used across the app for day-bucketing logic.
///
/// All helpers operate in the device's **local** timezone. They are intended
/// for situations where we want to treat dates as "calendar days" — for
/// example, computing today's adherence, grouping session entries by date,
/// or deciding whether two timestamps fall on the same day.
///
/// The class is named [AppDateUtils] (rather than `DateUtils`) to avoid a
/// name clash with Flutter's `DateUtils` from `package:flutter/material.dart`.
class AppDateUtils {
  // Private constructor — this class is a namespace for static helpers and is
  // not meant to be instantiated.
  AppDateUtils._();

  /// Returns a [DateTime] representing midnight (00:00:00.000) of [dt]'s
  /// calendar date, in the **local** timezone.
  ///
  /// Useful for normalizing timestamps to a "day bucket" so that two values
  /// occurring on the same calendar date compare as equal.
  static DateTime toLocalMidnight(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// Returns today's date at local midnight (00:00:00.000).
  ///
  /// Equivalent to `toLocalMidnight(DateTime.now())`.
  static DateTime todayLocal() {
    return toLocalMidnight(DateTime.now());
  }

  /// Whether [a] and [b] fall on the same calendar day in their respective
  /// representations.
  ///
  /// Compares year, month, and day only — hours, minutes, and timezone offset
  /// are ignored. Callers that need timezone-aware behavior should normalize
  /// inputs via [toLocalMidnight] beforehand.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
