import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  // ============================================================
  // PLAYFAIR DISPLAY
  // ============================================================

  static TextStyle get displayLarge {
    return GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get headlineMedium {
    return GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get headlineSmall {
    return GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.textPrimary,
    );
  }

  // ============================================================
  // INTER
  // ============================================================

  static TextStyle get bodyLarge {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get bodyMedium {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get labelLarge {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get labelSmall {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle get navigationLabel {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: AppColors.textSecondary,
    );
  }

  // ============================================================
  // ADDITIONAL USEFUL STYLES
  // ============================================================

  static TextStyle get bodyLargeSecondary {
    return bodyLarge.copyWith(
      color: AppColors.textSecondary,
    );
  }

  static TextStyle get bodyMediumSecondary {
    return bodyMedium.copyWith(
      color: AppColors.textSecondary,
    );
  }

  static TextStyle get caption {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle get button {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.onPrimary,
    );
  }
}