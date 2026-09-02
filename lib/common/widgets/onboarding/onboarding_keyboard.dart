import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

// =====================================================================
// REUSABLE KEYPAD LAYOUT
// =====================================================================

class PinKeypadLayout extends StatelessWidget {
  const PinKeypadLayout({
    super.key,
    required this.title,
    required this.pin,
    required this.onBack,
    required this.onKeyPressed,
    required this.onDelete,
  });

  final String title;
  final String pin;
  final VoidCallback onBack;
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------------------------------------------------
            // BACK BUTTON
            // ---------------------------------------------------------
            SizedBox(
              height: 64,
              child: Align(
                alignment: Alignment.centerLeft,
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
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------
            // TITLE
            // ---------------------------------------------------------
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextTheme.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'This ensures only you can access\nyour digital sanctuary.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // ---------------------------------------------------------
            // PIN DOTS
            // ---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (index) {
                  final bool selected = index < pin.length;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                        width: 1.4,
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // ---------------------------------------------------------
            // NUMBER KEYPAD
            // ---------------------------------------------------------
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  _keyRow(['1', '2', '3']),
                  _keyRow(['4', '5', '6']),
                  _keyRow(['7', '8', '9']),
                  _keyRow(['', '0', 'delete']),
                ],
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }



  Widget _keyRow(List<String> keys) {
    return SizedBox(
      height: 66,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) {
          if (key.isEmpty) {
            return const SizedBox(
              width: 60,
              height: 60,
            );
          }

          if (key == 'delete') {
            return SizedBox(
              width: 60,
              height: 60,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.backspace_outlined,
                  size: 20,
                ),
                color: AppColors.textPrimary,
              ),
            );
          }

          return SizedBox(
            width: 60,
            height: 60,
            child: TextButton(
              onPressed: () => onKeyPressed(key),
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: Text(
                key,
                style: AppTextTheme.headlineMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}