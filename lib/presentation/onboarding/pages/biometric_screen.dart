import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({
    super.key,
    required this.onBack,
    required this.onSetBiometric,
    required this.onSkip,
  });

  final VoidCallback onBack;
  final VoidCallback onSetBiometric;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [

            // ------------------------------------------------------------
            // TOP NAVIGATION
            // ------------------------------------------------------------
            SizedBox(
              height: 72,
              width: double.infinity,
              child: Stack(
                children: [
                  // Back arrow — fixed to top-left
                  Positioned(
                    left: 16,
                    top: 12,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                      color: AppColors.primary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ),

                  // Progress indicators — centered
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: const ProgressDots(
                        currentStep: 5,
                        totalSteps: 5,
                      ),
                    ),
                  ),

                  // Skip
                  Positioned(
                    right: 16,
                    top: 12,
                    child: TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),



            // =====================================================
            // MAIN CONTENT
            // =====================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    // -------------------------------------------------
                    // FINGERPRINT ICON
                    // -------------------------------------------------
                    const _BiometricIcon(),

                    const SizedBox(height: 28),

                    // -------------------------------------------------
                    // TITLE
                    // -------------------------------------------------
                    Text(
                      'Faster, Secure Access',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headlineMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // -------------------------------------------------
                    // DESCRIPTION
                    // -------------------------------------------------
                    Text(
                      'Enable Face ID or Touch ID for\n'
                          'instant access to your shared\n'
                          'sanctuary. Your memories,\n'
                          'beautifully protected.',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    // -------------------------------------------------
                    // SET BIOMETRIC BUTTON
                    // -------------------------------------------------

                    AppMainButton(
                      text: 'Set Biometric',
                      onPressed: onSetBiometric,
                      height: 48,
                      borderRadius: 6,
                    ),

                    const SizedBox(height: 12),

                    // ----------------------------------------------
                    // SKIP
                    // ----------------------------------------------
                    GestureDetector(
                      onTap: onSkip,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Skip for now',
                          style: AppTextTheme.bodyMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// BIOMETRIC ICON
// =============================================================

class _BiometricIcon extends StatelessWidget {
  const _BiometricIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryContainer.withValues(
          alpha: 0.45,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.primaryContainer,
            width: 7,
          ),
        ),
        child: Icon(
          Icons.fingerprint_rounded,
          size: 38,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// =============================================================
// PROGRESS INDICATOR
// =============================================================

class _ProgressDot extends StatelessWidget {
  const _ProgressDot({
    required this.active,
    required this.width,
  });

  final bool active;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary
            : AppColors.outlineVariant.withValues(
          alpha: 0.7,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
