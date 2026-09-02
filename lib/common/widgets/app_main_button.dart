import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/config/theme/app_colors.dart';

class AppMainButton extends StatelessWidget {
  const AppMainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 48,
    this.borderRadius = 6,
    this.elevation = 3,
    this.showArrow = false,
    this.enabled = true,
  });

  final String text;
  final VoidCallback? onPressed;

  final double height;
  final double borderRadius;
  final double elevation;

  /// Shows → after the button text.
  final bool showArrow;

  /// Useful when you want to explicitly disable the button.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? callback =
    enabled ? onPressed : null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(
            alpha: 0.35,
          ),
          foregroundColor: AppColors.onPrimary,
          disabledForegroundColor: AppColors.onPrimary,
          elevation: elevation,
          shadowColor: Colors.black.withValues(
            alpha: 0.08,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onPrimary,
              ),
            ),

            if (showArrow) ...[
              const SizedBox(width: 6),

              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}