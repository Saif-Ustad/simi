import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalSteps,
            (index) {
          final isActive = index == currentStep - 1;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : 8,
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? primary
                  : primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}