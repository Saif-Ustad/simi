import 'package:flutter/material.dart';

import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PartnerNamesScreen extends StatefulWidget {
  const PartnerNamesScreen({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  State<PartnerNamesScreen> createState() => _PartnerNamesScreenState();
}

class _PartnerNamesScreenState extends State<PartnerNamesScreen> {
  final TextEditingController _yourNameController = TextEditingController();
  final TextEditingController _partnerNameController =
  TextEditingController();

  @override
  void dispose() {
    _yourNameController.dispose();
    _partnerNameController.dispose();
    super.dispose();
  }

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
                      onPressed: widget.onBack,
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
                        currentStep: 2,
                        totalSteps: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================================
            // MAIN CONTENT
            // ==========================================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 90),

                    // ====================================================
                    // WHITE CARD
                    // ====================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ------------------------------------------------
                          // HEART ICON
                          // ------------------------------------------------
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 36,
                            color: AppColors.primary,
                          ),

                          const SizedBox(height: 24),

                          // ------------------------------------------------
                          // TITLE
                          // ------------------------------------------------
                          Text(
                            'Who is embarking on\nthis journey?',
                            textAlign: TextAlign.center,
                            style: AppTextTheme.headlineMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ------------------------------------------------
                          // DESCRIPTION
                          // ------------------------------------------------
                          Text(
                            'Tell us your names so we can\n'
                                'personalize your digital sanctuary.',
                            textAlign: TextAlign.center,
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ------------------------------------------------
                          // YOUR NAME LABEL
                          // ------------------------------------------------
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Your Name',
                              style: AppTextTheme.labelSmall.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // ------------------------------------------------
                          // YOUR NAME FIELD
                          // ------------------------------------------------
                          _NameField(
                            controller: _yourNameController,
                            hintText: 'e.g. Alex',
                          ),

                          const SizedBox(height: 20),

                          // ------------------------------------------------
                          // & DIVIDER
                          // ------------------------------------------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 1,
                                color: AppColors.outlineVariant
                                    .withValues(alpha: 0.35),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '&',
                                style: AppTextTheme.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 30,
                                height: 1,
                                color: AppColors.outlineVariant
                                    .withValues(alpha: 0.35),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ------------------------------------------------
                          // PARTNER NAME LABEL
                          // ------------------------------------------------
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Partner's Name",
                              style: AppTextTheme.labelSmall.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // ------------------------------------------------
                          // PARTNER NAME FIELD
                          // ------------------------------------------------
                          _NameField(
                            controller: _partnerNameController,
                            hintText: 'e.g. Jordan',
                          ),

                          const SizedBox(height: 34),

                          // ------------------------------------------------
                          // CONTINUE BUTTON
                          // ------------------------------------------------
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: widget.onContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                elevation: 3,
                                shadowColor: Colors.black.withValues(
                                  alpha: 0.08,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Continue',
                                style: AppTextTheme.labelLarge.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
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


// ======================================================================
// NAME INPUT FIELD
// ======================================================================

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        style: AppTextTheme.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textDisabled,
          ),
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: AppColors.surface,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}