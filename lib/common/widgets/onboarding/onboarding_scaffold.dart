import 'package:flutter/material.dart';
import 'onboarding_progress.dart';

class OnboardingScaffold extends StatelessWidget {
  final Widget child;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final String continueText;
  final String? skipText;
  final VoidCallback? onSkip;
  final bool showBackButton;
  final bool showProgress;
  final bool showBottomButton;

  const OnboardingScaffold({
    super.key,
    required this.child,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onContinue,
    this.continueText = 'Continue',
    this.skipText,
    this.onSkip,
    this.showBackButton = true,
    this.showProgress = true,
    this.showBottomButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Row(
                children: [
                  if (showBackButton)
                    GestureDetector(
                      onTap: onBack,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                    )
                  else
                    const SizedBox(width: 18),

                  const Spacer(),

                  if (showProgress)
                    OnboardingProgress(
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                    ),

                  const Spacer(),

                  const SizedBox(width: 18),
                ],
              ),
            ),

            // Screen content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: child,
              ),
            ),

            // Bottom actions
            if (showBottomButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onContinue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(continueText),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (skipText != null) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: onSkip,
                        child: Text(
                          skipText!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}