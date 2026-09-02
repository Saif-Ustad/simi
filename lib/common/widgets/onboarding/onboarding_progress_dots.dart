
import 'package:flutter/material.dart';

import '../../../core/config/theme/app_colors.dart';

class ProgressDots extends StatelessWidget {
  const ProgressDots({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
            (index) {
          final bool active = index + 1 == currentStep;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: active ? 16 : 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary
                  : AppColors.outlineVariant.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}