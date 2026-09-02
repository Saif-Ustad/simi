// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../common/widgets/app_main_button.dart';
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_spacing.dart';
// import '../../../core/config/theme/app_text_theme.dart';
//
// import 'package:flutter_svg/flutter_svg.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({
//     super.key,
//     required this.onGetStarted,
//   });
//
//   final VoidCallback onGetStarted;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.lg,
//             vertical: AppSpacing.md,
//           ),
//           child: Column(
//             children: [
//               const Spacer(flex: 3),
//
//               // -----------------------------------------------------------
//               // Logo
//               // -----------------------------------------------------------
//               const _WelcomeLogo(),
//
//               const SizedBox(height: 48),
//
//               // -----------------------------------------------------------
//               // App Name
//               // -----------------------------------------------------------
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'SIMI',
//                       style: GoogleFonts.playfairDisplay(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                         height: 1.2,
//                       ),
//                     ),
//                     const TextSpan(text: ' '),
//                     const TextSpan(
//                       text: '❤️',
//                       style: TextStyle(
//                         fontSize: 28,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // -----------------------------------------------------------
//               // Subtitle
//               // -----------------------------------------------------------
//               Text(
//                 'A private little world for the two\nof you.',
//                 textAlign: TextAlign.center,
//                 style: AppTextTheme.bodyMedium.copyWith(
//                   fontSize: 15,
//                   color: AppColors.textSecondary,
//                   height: 1.5,
//                 ),
//               ),
//
//               const Spacer(flex: 4),
//
//               // -----------------------------------------------------------
//               // Get Started Button
//               // -----------------------------------------------------------
//
//               AppMainButton(
//                 text: 'Get Started',
//                 onPressed: onGetStarted,
//                 height: 48,
//                 borderRadius: 6,
//               ),
//
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // ===========================================================================
// // SIMI LOGO
// // ===========================================================================
// //
// // class _WelcomeLogo extends StatelessWidget {
// //   const _WelcomeLogo();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: 88,
// //       height: 88,
// //       child: SvgPicture.asset(
// //         'assets/vectors/Welcome_Logo.svg',
// //         width: 88,
// //         height: 88,
// //         fit: BoxFit.contain,
// //       ),
// //     );
// //   }
// // }
//
//
// class _WelcomeLogo extends StatelessWidget {
//   const _WelcomeLogo();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 88,
//       height: 88,
//       decoration: BoxDecoration(
//         color: AppColors.surfaceBright,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(alpha: 0.45),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Container(
//           width: 68,
//           height: 68,
//           decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Center(
//             child: Icon(
//               Icons.favorite_border_rounded,
//               size: 32,
//               color: AppColors.primary.withValues(alpha: 0.75),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
  });

  final VoidCallback onGetStarted;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _contentAnimation;

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // ANIMATION CONTROLLER
    // ------------------------------------------------------------

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // ------------------------------------------------------------
    // FADE
    // ------------------------------------------------------------

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.65,
        curve: Curves.easeOut,
      ),
    );

    // ------------------------------------------------------------
    // LOGO SCALE
    // ------------------------------------------------------------

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.7,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // ------------------------------------------------------------
    // CONTENT SLIDE
    // ------------------------------------------------------------

    _contentAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.25,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [

          // ============================================================
          // BACKGROUND DECORATION
          // ============================================================

          const _BackgroundDecoration(),

          // ============================================================
          // MAIN CONTENT
          // ============================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              child: Column(
                children: [

                  // ==================================================
                  // TOP BRAND
                  // ==================================================

                  const SizedBox(height: 28),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _TopBrand(),
                  ),

                  // ==================================================
                  // CENTER CONTENT
                  // ==================================================

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // ----------------------------------------
                            // LOGO
                            // ----------------------------------------

                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: const _WelcomeLogo(),
                              ),
                            ),

                            const SizedBox(height: 34),

                            // ----------------------------------------
                            // APP NAME
                            // ----------------------------------------

                            SlideTransition(
                              position: _contentAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: const _AppTitle(),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ----------------------------------------
                            // DESCRIPTION
                            // ----------------------------------------


                            const SizedBox(height: 26),

                            // ----------------------------------------
                            // LITTLE LOVE MESSAGE
                            // ----------------------------------------

                          ],
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // BOTTOM ACTION
                  // ==================================================

                  SlideTransition(
                    position: _contentAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [

                          // ----------------------------------------
                          // GET STARTED
                          // ----------------------------------------

                          AppMainButton(
                            text: 'Get Started',
                            onPressed: widget.onGetStarted,
                            height: 48,
                            borderRadius: 6,
                          ),

                          const SizedBox(height: 18),

                          // ----------------------------------------
                          // PRIVACY
                          // ----------------------------------------

                          const _PrivacyLabel(),

                          SizedBox(
                            height: screenSize.height < 700
                                ? 16
                                : 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BACKGROUND DECORATION
// ============================================================================

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [

          // ----------------------------------------------------------
          // TOP RIGHT GLOW
          // ----------------------------------------------------------

          Positioned(
            top: -130,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(
                  alpha: 0.18,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // BOTTOM LEFT GLOW
          // ----------------------------------------------------------

          Positioned(
            bottom: -160,
            left: -120,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(
                  alpha: 0.13,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // SMALL HEART
          // ----------------------------------------------------------

          Positioned(
            top: 150,
            right: 38,
            child: Icon(
              Icons.favorite_rounded,
              size: 14,
              color: AppColors.primary.withValues(
                alpha: 0.16,
              ),
            ),
          ),

          // ----------------------------------------------------------
          // SMALL HEART
          // ----------------------------------------------------------

          Positioned(
            top: 220,
            left: 34,
            child: Icon(
              Icons.favorite_rounded,
              size: 10,
              color: AppColors.primary.withValues(
                alpha: 0.12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TOP BRAND
// ============================================================================

class _TopBrand extends StatelessWidget {
  const _TopBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(
              alpha: 0.5,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          'JUST FOR TWO',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 10),

        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(
              alpha: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// WELCOME LOGO
// ============================================================================
// ============================================================================
// SIMI LOVE EMBLEM
// ============================================================================

class _WelcomeLogo extends StatelessWidget {
  const _WelcomeLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: 118,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceBright,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [

          // ================================================================
          // OUTER RING
          // ================================================================

          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
          ),

          // ================================================================
          // LEFT PERSON / SOUL
          // ================================================================

          Positioned(
            left: 27,
            top: 36,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(alpha: 0.55),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  width: 1,
                ),
              ),
            ),
          ),

          // ================================================================
          // RIGHT PERSON / SOUL
          // ================================================================

          Positioned(
            right: 27,
            top: 36,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.16),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
            ),
          ),

          // ================================================================
          // CENTER HEART
          // ================================================================

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.favorite_rounded,
                size: 25,
                color: AppColors.primary,
              ),
            ),
          ),

          // ================================================================
          // SMALL TOP SPARK
          // ================================================================

          Positioned(
            top: 18,
            right: 30,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
            ),
          ),

          // ================================================================
          // SMALL BOTTOM SPARK
          // ================================================================

          Positioned(
            bottom: 20,
            left: 31,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// APP TITLE
// ============================================================================

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [

              TextSpan(
                text: 'SIMI',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'MY LOVE',
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PRIVACY LABEL
// ============================================================================

class _PrivacyLabel extends StatelessWidget {
  const _PrivacyLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: AppColors.textSecondary.withValues(
            alpha: 0.75,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          'Private • Secure • Just Yours',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

