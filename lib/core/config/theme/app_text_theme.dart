// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'app_colors.dart';
//
// class AppTextTheme {
//   AppTextTheme._();
//
//   // ============================================================
//   // PLAYFAIR DISPLAY
//   // ============================================================
//
//   static TextStyle get displayLarge {
//     return GoogleFonts.playfairDisplay(
//       fontSize: 32,
//       fontWeight: FontWeight.w600,
//       height: 1.2,
//       color: AppColors.textPrimary,
//     );
//   }
//
//   static TextStyle get headlineMedium {
//     return GoogleFonts.playfairDisplay(
//       fontSize: 24,
//       fontWeight: FontWeight.w600,
//       height: 1.3,
//       color: AppColors.textPrimary,
//     );
//   }
//
//   static TextStyle get headlineSmall {
//     return GoogleFonts.playfairDisplay(
//       fontSize: 20,
//       fontWeight: FontWeight.w500,
//       height: 1.4,
//       color: AppColors.textPrimary,
//     );
//   }
//
//   // ============================================================
//   // INTER
//   // ============================================================
//
//   static TextStyle get bodyLarge {
//     return GoogleFonts.inter(
//       fontSize: 16,
//       fontWeight: FontWeight.w400,
//       height: 1.5,
//       color: AppColors.textPrimary,
//     );
//   }
//
//   static TextStyle get bodyMedium {
//     return GoogleFonts.inter(
//       fontSize: 14,
//       fontWeight: FontWeight.w400,
//       height: 1.5,
//       color: AppColors.textPrimary,
//     );
//   }
//
//   static TextStyle get labelLarge {
//     return GoogleFonts.inter(
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//       height: 1.2,
//       color: AppColors.textPrimary,
//     );
//   }
//
//   static TextStyle get labelSmall {
//     return GoogleFonts.inter(
//       fontSize: 12,
//       fontWeight: FontWeight.w400,
//       height: 1.2,
//       color: AppColors.textSecondary,
//     );
//   }
//
//   static TextStyle get navigationLabel {
//     return GoogleFonts.inter(
//       fontSize: 10,
//       fontWeight: FontWeight.w500,
//       height: 1.0,
//       color: AppColors.textSecondary,
//     );
//   }
//
//   // ============================================================
//   // ADDITIONAL USEFUL STYLES
//   // ============================================================
//
//   static TextStyle get bodyLargeSecondary {
//     return bodyLarge.copyWith(
//       color: AppColors.textSecondary,
//     );
//   }
//
//   static TextStyle get bodyMediumSecondary {
//     return bodyMedium.copyWith(
//       color: AppColors.textSecondary,
//     );
//   }
//
//   static TextStyle get caption {
//     return GoogleFonts.inter(
//       fontSize: 12,
//       fontWeight: FontWeight.w400,
//       height: 1.2,
//       color: AppColors.textSecondary,
//     );
//   }
//
//   static TextStyle get button {
//     return GoogleFonts.inter(
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//       height: 1.2,
//       color: AppColors.onPrimary,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  // ============================================================
  // DISPLAY / PAGE HEADINGS
  // Playfair Display
  // ============================================================

  /// Large emotional/page heading.
  /// Example: "Welcome to SIMI ❤️"
  static TextStyle get displayLarge {
    return GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.textPrimary,
    );
  }

  /// Main screen heading.
  /// Example: "Your Memories"
  static TextStyle get headlineMedium {
    return GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
    );
  }

  /// Section/card heading.
  /// Example: "Your little world"
  static TextStyle get headlineSmall {
    return GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.textPrimary,
    );
  }

  // ============================================================
  // BODY TEXT
  // Inter
  // ============================================================

  /// Main body text.
  static TextStyle get bodyLarge {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary,
    );
  }

  /// Normal body / description text.
  static TextStyle get bodyMedium {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary,
    );
  }

  /// Small supporting body text.
  static TextStyle get bodySmall {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textSecondary,
    );
  }

  // ============================================================
  // SECONDARY BODY TEXT
  // ============================================================

  /// Large secondary text.
  static TextStyle get bodyLargeSecondary {
    return bodyLarge.copyWith(
      color: AppColors.textSecondary,
    );
  }

  /// Medium secondary text.
  static TextStyle get bodyMediumSecondary {
    return bodyMedium.copyWith(
      color: AppColors.textSecondary,
    );
  }

  // ============================================================
  // LABELS
  // ============================================================

  /// Standard UI label.
  /// Example: "Continue", "Save", "Add Memory"
  static TextStyle get labelLarge {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.textPrimary,
    );
  }

  /// Small UI label.
  static TextStyle get labelSmall {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: AppColors.textSecondary,
    );
  }

  /// Very small section/card label.
  /// Example: "YOUR STORY", "UPCOMING", "TODAY"
  static TextStyle get cardLabel {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 1.2,
      color: AppColors.textSecondary,
    );
  }

  /// Emotional/section eyebrow.
  /// Example: "JUST FOR TWO"
  static TextStyle get eyebrow {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 2.0,
      color: AppColors.primary,
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  static TextStyle get navigationLabel {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: AppColors.textSecondary,
    );
  }

  /// Selected bottom navigation label.
  static TextStyle get navigationLabelSelected {
    return navigationLabel.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================

  static TextStyle get button {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.onPrimary,
    );
  }

  /// Slightly stronger button text.
  static TextStyle get buttonPrimary {
    return button.copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  /// Text button / secondary action.
  static TextStyle get buttonSecondary {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.primary,
    );
  }

  // ============================================================
  // SPECIAL / RELATIONSHIP
  // Playfair Display
  // ============================================================

  /// Couple names.
  /// Example: "Saif & Simran"
  static TextStyle get coupleNames {
    return GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.3,
      color: AppColors.primary,
    );
  }

  /// Large relationship statistic.
  /// Example: "1,245"
  static TextStyle get statValue {
    return GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.1,
      color: AppColors.textPrimary,
    );
  }

  /// Small label under a statistic.
  /// Example: "DAYS TOGETHER"
  static TextStyle get statLabel {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 1.0,
      color: AppColors.textSecondary,
    );
  }

  // ============================================================
  // CAPTIONS / META
  // ============================================================

  static TextStyle get caption {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: AppColors.textSecondary,
    );
  }

  /// Metadata such as dates, times, small details.
  static TextStyle get metadata {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      height: 1.3,
      color: AppColors.textSecondary,
    );
  }

  // ============================================================
  // FORM / INPUT
  // ============================================================

  /// Text entered by user.
  static TextStyle get input {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.textPrimary,
    );
  }

  /// Input hint text.
  static TextStyle get inputHint {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.textDisabled,
    );
  }

  /// Input field label.
  static TextStyle get inputLabel {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.textPrimary,
    );
  }

  // ============================================================
  // STATES
  // ============================================================

  /// Error text.
  static TextStyle get error {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.3,
      color: Colors.red.shade700,
    );
  }

  /// Disabled text.
  static TextStyle get disabled {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textDisabled,
    );
  }

  // ============================================================
  // CARD CONTENT
  // ============================================================

  /// Main title inside a card.
  static TextStyle get cardTitle {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
    );
  }

  /// Description inside a card.
  static TextStyle get cardDescription {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textSecondary,
    );
  }

  // ============================================================
  // ICON / BADGE TEXT
  // ============================================================

  static TextStyle get badge {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: AppColors.textPrimary,
    );
  }

  // ============================================================
  // UTILITY
  // ============================================================

  /// Use this when you need to change only the color/weight/etc.
  /// of an existing semantic style.
  ///
  /// Example:
  /// AppTextTheme.bodyMedium.copyWith(
  ///   color: AppColors.primary,
  /// )
  static TextStyle get pageTitle {
    return displayLarge;
  }

  static TextStyle get sectionTitle {
    return headlineSmall;
  }
}