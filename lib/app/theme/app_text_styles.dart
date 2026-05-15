import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens for RehabPath.
///
/// All styles use **Public Sans** loaded via the `google_fonts` package.
/// Base sizes are defined here; runtime scaling is applied by
/// `MediaQuery.withClampedTextScaling` in the root widget.
class AppTextStyles {
  AppTextStyles._();

  /// Display / Hero heading — Bold 30sp, lh 38/30, ls −0.3
  static TextStyle get displayH1 => GoogleFonts.publicSans(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        height: 38 / 30,
        letterSpacing: -0.3,
      );

  /// App-bar title — Bold 24sp, lh 32/24
  static TextStyle get h2AppBar => GoogleFonts.publicSans(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        height: 32 / 24,
      );

  /// Section heading — Bold 24sp, lh 32/24
  static TextStyle get h3Section => GoogleFonts.publicSans(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        height: 32 / 24,
      );

  /// Large body copy — Regular 20sp, lh 30/20
  static TextStyle get bodyLarge => GoogleFonts.publicSans(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        height: 30 / 20,
      );

  /// Body copy — Regular 18sp, lh 28/18
  static TextStyle get body => GoogleFonts.publicSans(
        fontWeight: FontWeight.normal,
        fontSize: 18,
        height: 28 / 18,
      );

  /// Emphasised body copy — SemiBold (w600) 18sp, lh 28/18
  static TextStyle get bodySemiBold => GoogleFonts.publicSans(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 28 / 18,
      );

  /// Label / tag — SemiBold (w600) 18sp, lh 24/18, ls 0.36
  static TextStyle get label => GoogleFonts.publicSans(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 24 / 18,
        letterSpacing: 0.36,
      );

  /// Button text — Bold 18sp, lh 24/18
  static TextStyle get button => GoogleFonts.publicSans(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        height: 24 / 18,
      );
}
