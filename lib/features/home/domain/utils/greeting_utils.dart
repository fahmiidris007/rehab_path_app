import '../../../../l10n/app_localizations.dart';

/// Returns a time-appropriate greeting based on the hour of [now].
/// - 05:00–11:59 → morning greeting
/// - 12:00–17:59 → afternoon greeting
/// - 18:00–04:59 → evening greeting
String getGreeting(DateTime now, AppLocalizations l10n) {
  final hour = now.hour;
  if (hour >= 5 && hour < 12) return l10n.homeGreetingMorning;
  if (hour >= 12 && hour < 18) return l10n.homeGreetingAfternoon;
  return l10n.homeGreetingEvening;
}
