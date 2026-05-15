import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

/// Provides the Material 3 [ThemeData] for light and dark modes.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme:     AppTheme.light(),
///   darkTheme: AppTheme.dark(),
/// )
/// ```
class AppTheme {
  AppTheme._();

  // ── Light theme ────────────────────────────────────────────────────────────

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.h2AppBar.copyWith(
          color: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      textTheme: _buildTextTheme(AppColors.textPrimary),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.primary),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      cardTheme: _buildCardTheme(),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }

  // ── Dark theme ─────────────────────────────────────────────────────────────

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.backgroundDark,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.h2AppBar.copyWith(
          color: AppColors.primaryLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryLight),
      ),
      textTheme: _buildTextTheme(AppColors.textPrimaryDark),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.primaryLight),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      cardTheme: _buildCardTheme(
        backgroundColor: AppColors.surfaceDark,
        borderColor: AppColors.textSecondaryDark,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.textSecondaryDark),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color defaultColor) {
    return TextTheme(
      displayLarge: AppTextStyles.displayH1.copyWith(color: defaultColor),
      displayMedium: AppTextStyles.displayH1.copyWith(color: defaultColor),
      displaySmall: AppTextStyles.displayH1.copyWith(color: defaultColor),
      headlineLarge: AppTextStyles.h2AppBar.copyWith(color: defaultColor),
      headlineMedium: AppTextStyles.h3Section.copyWith(color: defaultColor),
      headlineSmall: AppTextStyles.h3Section.copyWith(color: defaultColor),
      titleLarge: AppTextStyles.bodySemiBold.copyWith(color: defaultColor),
      titleMedium: AppTextStyles.bodySemiBold.copyWith(color: defaultColor),
      titleSmall: AppTextStyles.label.copyWith(color: defaultColor),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: defaultColor),
      bodyMedium: AppTextStyles.body.copyWith(color: defaultColor),
      bodySmall: AppTextStyles.body.copyWith(color: defaultColor),
      labelLarge: AppTextStyles.button.copyWith(color: defaultColor),
      labelMedium: AppTextStyles.label.copyWith(color: defaultColor),
      labelSmall: AppTextStyles.label.copyWith(color: defaultColor),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: AppTextStyles.button,
        minimumSize: const Size.fromHeight(AppDimensions.primaryButtonH),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        ),
        elevation: 2,
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Color borderColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor,
        textStyle: AppTextStyles.button,
        minimumSize: const Size.fromHeight(AppDimensions.primaryButtonH),
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardInnerPadding,
        vertical: 16,
      ),
    );
  }

  static CardThemeData _buildCardTheme({
    Color backgroundColor = AppColors.background,
    Color borderColor = AppColors.border,
  }) {
    return CardThemeData(
      color: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        side: BorderSide(color: borderColor),
      ),
      margin: EdgeInsets.zero,
    );
  }
}
