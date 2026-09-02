import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================
  // CORE SURFACES
  // ============================================================

  /// Main application background.
  static const surface = Color(0xFFFFF8F5);

  /// Secondary surface / subtle backgrounds.
  static const surfaceDim = Color(0xFFE1D8D4);

  /// Elevated surface / highlights.
  static const surfaceBright = Color(0xFFFFF8F5);

  // ============================================================
  // PRIMARY
  // ============================================================

  /// Main brand color.
  static const primary = Color(0xFF8E6E6E);

  /// Light rose container.
  static const primaryContainer = Color(0xFFE8B4B8);

  /// Content displayed on primary.
  static const onPrimary = Color(0xFFFFFFFF);

  // ============================================================
  // SECONDARY
  // ============================================================

  /// Mauve / lavender accent.
  static const secondary = Color(0xFF6B6D91);

  /// Content displayed on secondary.
  static const onSecondary = Color(0xFFFFFFFF);

  // ============================================================
  // TEXT
  // ============================================================

  /// Main headings and body text.
  static const textPrimary = Color(0xFF322F2E);

  /// Supporting text, subtitles and labels.
  static const textSecondary = Color(0xFF6D6765);

  /// Disabled / placeholder text.
  static const textDisabled = Color(0xFFA8A2A0);

  // ============================================================
  // BORDERS
  // ============================================================

  /// Soft borders and inactive icons.
  static const outlineVariant = Color(0xFFD1C4C0);

  // ============================================================
  // STATUS
  // ============================================================

  static const error = Color(0xFFBA1A1A);

  static const success = Color(0xFF4F7A5A);

  static const warning = Color(0xFFB7791F);

  // ============================================================
  // FEATURE COLORS
  // ============================================================

  /// Period tracking.
  static const period = Color(0xFFFCE4EC);

  static const periodAccent = Color(0xFFE8B4B8);

  /// Future messages.
  static const futureMessage = Color(0xFF6B6D91);

  /// Private vault.
  static const vault = Color(0xFF322F2E);

  /// Mood journal neutral base.
  static const moodNeutral = Color(0xFFF5F5F5);

  // ============================================================
  // IMAGE / OVERLAY COLORS
  // ============================================================

  static const imageOverlay = Color(0x66000000);

  static const transparent = Colors.transparent;

  // ============================================================
  // COMMON WHITE / BLACK
  // ============================================================

  static const white = Color(0xFFFFFFFF);

  static const black = Color(0xFF000000);
}