import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({
    super.key,
    required this.onEnterHome,
  });

  final VoidCallback onEnterHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // =========================================================
            // SOFT BACKGROUND DECORATIONS
            // =========================================================

            Positioned(
              left: -128,
              top: -128,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer.withValues(
                    alpha: 0.30,
                  ),
                ),
              ),
            ),

            Positioned(
              right: -120,
              bottom: 80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFCDCAFE).withValues(
                    alpha: 0.20,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 98,
              bottom: -140,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFCCBEC0).withValues(
                    alpha: 0.25,
                  ),
                ),
              ),
            ),

            // =========================================================
            // MAIN CONTENT
            // =========================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  // ---------------------------------------------------
                  // TOP / CENTER CONTENT
                  // ---------------------------------------------------

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // =================================================
                        // HEART CIRCLE
                        // =================================================

                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF2ED),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(
                                alpha: 0.10,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.04,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.favorite_rounded,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // =================================================
                        // TITLE
                        // =================================================

                        Text(
                          'Setup Complete',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                            letterSpacing: -0.6,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // =================================================
                        // DESCRIPTION
                        // =================================================

                        Text(
                          'Your little world is ready ❤️. A\n'
                              'private space designed just for\n'
                              'the two of you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =====================================================
                  // ENTER HOME BUTTON
                  // =====================================================

                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.sm,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onEnterHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          elevation: 4,
                          shadowColor: Colors.black.withValues(
                            alpha: 0.08,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter Home',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}