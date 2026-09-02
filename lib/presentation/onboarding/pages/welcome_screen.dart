import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';

import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
  });

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // -----------------------------------------------------------
              // Logo
              // -----------------------------------------------------------
              const _WelcomeLogo(),

              const SizedBox(height: 48),

              // -----------------------------------------------------------
              // App Name
              // -----------------------------------------------------------
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'SIMI',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    const TextSpan(
                      text: '❤️',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // -----------------------------------------------------------
              // Subtitle
              // -----------------------------------------------------------
              Text(
                'A private little world for the two\nof you.',
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 4),

              // -----------------------------------------------------------
              // Get Started Button
              // -----------------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: AppTextTheme.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


// ===========================================================================
// SIMI LOGO
// ===========================================================================
//
// class _WelcomeLogo extends StatelessWidget {
//   const _WelcomeLogo();
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 88,
//       height: 88,
//       child: SvgPicture.asset(
//         'assets/vectors/Welcome_Logo.svg',
//         width: 88,
//         height: 88,
//         fit: BoxFit.contain,
//       ),
//     );
//   }
// }


class _WelcomeLogo extends StatelessWidget {
  const _WelcomeLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.favorite_border_rounded,
              size: 32,
              color: AppColors.primary.withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}