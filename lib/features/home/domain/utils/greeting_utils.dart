/// Returns a time-appropriate greeting based on the hour of [now].
/// - 05:00–11:59 → "Good morning"
/// - 12:00–17:59 → "Good afternoon"
/// - 18:00–04:59 → "Good evening"
String getGreeting(DateTime now) {
  final hour = now.hour;
  if (hour >= 5 && hour < 12) return 'Good morning';
  if (hour >= 12 && hour < 18) return 'Good afternoon';
  return 'Good evening';
}
