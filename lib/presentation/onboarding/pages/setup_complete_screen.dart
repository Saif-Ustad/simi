import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';

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
                          style: AppTextTheme.displayLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
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
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =====================================================
                  // ENTER HOME BUTTON
                  // =====================================================

                  AppMainButton(
                    text: 'Enter Home',
                    onPressed: () {},
                    height: 48,
                    borderRadius: 6,
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