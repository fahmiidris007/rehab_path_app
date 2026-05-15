/// App-level enumerations used across features.
///
/// Note: [AppThemeMode] is named to avoid conflict with Flutter's built-in
/// [ThemeMode] enum.
library;

enum AppThemeMode { light, dark, system }

enum AppLocale { en, id }

enum FontSizeLevel { defaultSize, large, extraLarge }

// ── Domain enums ──────────────────────────────────────────────────────────────

enum ProgramLevel { beginner, intermediate, advanced }

enum ExerciseCategory {
  warmUp,
  balanceTraining,
  strengthTraining,
  enduranceAerobic,
  taiChi,
  walkingProgram,
  gettingUpFromFloor,
  coolDown,
}

enum BodyCondition { sitting, standing }

enum SupportUsed { walkingAid, kitchenWorktop, noSupport }
