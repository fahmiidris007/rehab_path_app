/// Spacing and sizing tokens for Teman Lansia.
///
/// All values are `const` — no runtime allocation.
class AppDimensions {
  AppDimensions._();

  // ── Layout ────────────────────────────────────────────────────────────────
  static const double screenPaddingH = 24.0;
  static const double cardPadding = 17.0;
  static const double cardInnerPadding = 16.0;
  static const double sectionGap = 32.0;
  static const double cardGap = 16.0;

  // ── Border radii ──────────────────────────────────────────────────────────
  static const double radiusCard = 12.0;
  static const double radiusButton = 12.0;
  static const double radiusPill = 9999.0;
  static const double radiusNavTab = 12.0;

  // ── Component heights ─────────────────────────────────────────────────────
  static const double topAppBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double primaryButtonH = 56.0;

  // ── Touch targets ─────────────────────────────────────────────────────────
  static const double minTouchTarget = 48.0;
  static const double minTouchTarget2 = 32.0;
  static const double recTouchTarget = 56.0;

  // ── Progress indicators ───────────────────────────────────────────────────
  static const double progressRingSize = 166.0;
  static const double progressBarH = 12.0;

  // ── Exercise path nodes ───────────────────────────────────────────────────
  static const double nodeActive = 96.0;
  static const double nodeCompleted = 80.0;
  static const double nodeLocked = 72.0;
}
