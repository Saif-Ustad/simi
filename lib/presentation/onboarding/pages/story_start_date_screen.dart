import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';

class StoryStartDateScreen extends StatefulWidget {
  const StoryStartDateScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
    required this.onNotSure,
  });

  final ValueChanged<DateTime> onContinue;
  final VoidCallback onBack;
  final VoidCallback onNotSure;

  @override
  State<StoryStartDateScreen> createState() => _StoryStartDateScreenState();
}

class _StoryStartDateScreenState extends State<StoryStartDateScreen> {
  DateTime? _selectedDate = DateTime(2023, 10, 14);

  Future<void> _selectDate() async {
    final DateTime initialDate =
        _selectedDate ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');

    return '$month/$day/${date.year}';
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
                        currentStep: 1,
                        totalSteps: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------------------
            // HERO IMAGE
            // ------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/story_start.jpg',
                        fit: BoxFit.fill,

                        // If your image has a different filename,
                        // change the path here.
                      ),
                    ),

                    // ----------------------------------------------------
                    // CONTENT CARD
                    // ----------------------------------------------------
                    Transform.translate(
                      offset: const Offset(0, -1),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          28,
                          18,
                          26,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBright,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Heading
                            Text(
                              'When did your\nstory begin?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.15,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Description
                            Text(
                              'Choose the date you consider\nyour anniversary.',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 26),

                            // ------------------------------------------------
                            // DATE FIELD
                            // ------------------------------------------------
                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                width: double.infinity,
                                height: 52,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceBright,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.outlineVariant,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 20,
                                      color: AppColors.secondary,
                                    ),

                                    const SizedBox(width: 20),

                                    Text(
                                      _selectedDate == null
                                          ? 'Select date'
                                          : _formatDate(_selectedDate!),
                                      style: AppTextTheme.bodyLarge.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // ------------------------------------------------
                            // DATE TYPE CHIPS
                            // ------------------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _DateTypeChip(
                                  icon: Icons.favorite_border_rounded,
                                  label: 'Special day',
                                  selected: true,
                                ),

                                const SizedBox(width: 12),

                                _DateTypeChip(
                                  label: 'First meeting',
                                  selected: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Space so content doesn't touch bottom button
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------------------
            // BOTTOM ACTIONS
            // ------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                12,
                24,
                18,
              ),
              child: Column(
                children: [
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedDate == null
                          ? null
                          : () {
                        widget.onContinue(
                          _selectedDate!,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        disabledBackgroundColor:
                        AppColors.primary.withValues(
                          alpha: 0.4,
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withValues(
                          alpha: 0.08,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: AppTextTheme.labelLarge.copyWith(
                              color: AppColors.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Not sure button
                  GestureDetector(
                    onTap: widget.onNotSure,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "I'm not sure yet",
                        style: AppTextTheme.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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

// ============================================================================
// BACK BUTTON
// ============================================================================

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: const SizedBox(
        width: 48,
        height: 48,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DATE TYPE CHIP
// ============================================================================

class _DateTypeChip extends StatelessWidget {
  const _DateTypeChip({
    this.icon,
    required this.label,
    required this.selected,
  });

  final IconData? icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFE2DEFF)
            : const Color(0xFFECE7E4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.secondary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 7),
          ],
          Text(
            label,
            style: AppTextTheme.labelLarge.copyWith(
              fontSize: 12,
              color: selected
                  ? AppColors.secondary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}