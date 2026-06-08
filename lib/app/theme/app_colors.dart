import 'package:flutter/material.dart';

/// Design-token color palette for Teman Lansia.
///
/// All values are `const` — no runtime allocation.
class AppColors {
  AppColors._();

  // ── Primary ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF00609B);
  static const Color primaryLight = Color(0xFF0079C3);

  // ── Accent / CTA ─────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFFFA454);
  static const Color accentDark = Color(0xFF713B00);

  // ── Backgrounds & Surfaces ───────────────────────────────────────────────
  static const Color background = Color(0xFFF9F9F9);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // ── Borders ──────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFC0C7D3);
  static const Color blueLightBorder = Color(0xFFD0E4FF);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1C1C);
  static const Color textSecondary = Color(0xFF404751);
  static const Color textDisabled = Color(0xFF707882);
  static const Color textOnPrimary = Color(0xFFFDFCFF);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);
  static const Color neutralGray = Color(0xFFE2E2E2);

  // ── Dark-theme overrides ─────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF1A1C1C);
  static const Color surfaceDark = Color(0xFF2A2C2C);
  static const Color textPrimaryDark = Color(0xFFFDFCFF);
  static const Color textSecondaryDark = Color(0xFFC0C7D3);
}
