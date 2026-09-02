import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,

      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,

      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.textPrimary,

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,

      secondaryContainer: AppColors.surfaceDim,
      onSecondaryContainer: AppColors.textPrimary,

      tertiary: AppColors.primaryContainer,
      onTertiary: AppColors.textPrimary,

      error: AppColors.error,
      onError: AppColors.white,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      surfaceContainerHighest: AppColors.surfaceDim,
      onSurfaceVariant: AppColors.textSecondary,

      outline: AppColors.outlineVariant,
      outlineVariant: AppColors.outlineVariant,

      shadow: AppColors.black,
      scrim: AppColors.black,
    );

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.surface,

      fontFamily: 'Inter',

      // ========================================================
      // TYPOGRAPHY
      // ========================================================

      textTheme: TextTheme(
        displayLarge: AppTextTheme.displayLarge,
        headlineMedium: AppTextTheme.headlineMedium,
        headlineSmall: AppTextTheme.headlineSmall,

        bodyLarge: AppTextTheme.bodyLarge,
        bodyMedium: AppTextTheme.bodyMedium,

        labelLarge: AppTextTheme.labelLarge,
        labelSmall: AppTextTheme.labelSmall,
      ),

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: true,

        toolbarHeight: 64,

        titleTextStyle: AppTextTheme.headlineSmall,

        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),

      // ========================================================
      // BUTTON
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),

          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          textStyle: AppTextTheme.button,

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
        ),
      ),

      // ========================================================
      // TEXT BUTTON
      // ========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,

          textStyle: AppTextTheme.labelLarge,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ========================================================
      // OUTLINED BUTTON
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),

          foregroundColor: AppColors.primary,

          side: const BorderSide(
            color: AppColors.outlineVariant,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          textStyle: AppTextTheme.labelLarge,
        ),
      ),

      // ========================================================
      // INPUT FIELDS
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: AppColors.surfaceBright,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: AppTextTheme.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),

        labelStyle: AppTextTheme.bodyMedium,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(
            color: AppColors.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // ========================================================
      // ICONS
      // ========================================================

      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // ========================================================
      // DIVIDERS
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.surfaceBright,

        elevation: 0,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        shadowColor: AppColors.black.withValues(
          alpha: 0.05,
        ),
      ),

      // ========================================================
      // DIALOG
      // ========================================================

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceBright,

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),

        titleTextStyle: AppTextTheme.headlineSmall,

        contentTextStyle: AppTextTheme.bodyMedium,
      ),

      // ========================================================
      // BOTTOM SHEET
      // ========================================================

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
      ),

      // ========================================================
      // CHECKBOX
      // ========================================================

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),

        side: const BorderSide(
          color: AppColors.outlineVariant,
        ),

        fillColor: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.surfaceBright;
          },
        ),
      ),

      // ========================================================
      // SWITCH
      // ========================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.onPrimary;
            }

            return AppColors.textSecondary;
          },
        ),

        trackColor: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.surfaceDim;
          },
        ),
      ),
    );
  }
}