import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'confirm_pin_screen.dart';
import 'create_pin_screen.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
    required this.onSet,
  });

  final VoidCallback onBack;
  final VoidCallback onComplete;
  final VoidCallback onSet;

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String? createdPin;
  String? confirmedPin;

  void _openCreatePin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePinScreen(
          onBack: () {
            Navigator.pop(context);
          },
          onPinCreated: (pin) {
            setState(() {
              createdPin = pin;
            });

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _openConfirmPin() {
    if (createdPin == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmPinScreen(
          onBack: () {
            Navigator.pop(context);
          },
          createdPin: createdPin!,
          onPinConfirmed: (pin) {
            setState(() {
              confirmedPin = pin;
            });

            Navigator.pop(context);

            if (pin == createdPin) {
              widget.onComplete();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'PIN does not match. Please try again.',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canConfirm = createdPin != null;

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
                        currentStep: 4,
                        totalSteps: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------------------------------------------------
            // CONTENT
            // ---------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Lock icon circle
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.primary,
                        size: 25,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Create New PIN',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headlineMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Account verified. Please enter a new 4-\ndigit PIN to secure your vault.',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // -------------------------------------------------
                    // ENTER NEW PIN
                    // -------------------------------------------------
                    _PinInputCard(
                      title: 'Enter New PIN',
                      enabled: true,
                      filled: createdPin != null,
                      onTap: _openCreatePin,
                    ),

                    const SizedBox(height: 16),

                    // -------------------------------------------------
                    // CONFIRM NEW PIN
                    // -------------------------------------------------
                    _PinInputCard(
                      title: 'Confirm New PIN',
                      enabled: canConfirm,
                      filled: confirmedPin != null,
                      onTap: _openConfirmPin,
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),

            // ---------------------------------------------------------
            // SET NEW PIN BUTTON
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: AppMainButton(
                text: 'Set New PIN',
                onPressed:
                createdPin != null &&
                    confirmedPin != null &&
                    createdPin == confirmedPin
                    ? widget.onSet
                    : null,
                height: 48,
                borderRadius: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// =====================================================================
// PIN INPUT CARD
// =====================================================================

class _PinInputCard extends StatelessWidget {
  const _PinInputCard({
    required this.title,
    required this.enabled,
    required this.filled,
    required this.onTap,
  });

  final String title;
  final bool enabled;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.55,
        child: Container(
          width: double.infinity,
          height: 84,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: filled
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
