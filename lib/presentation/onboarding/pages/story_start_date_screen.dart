import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
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
  State<StoryStartDateScreen> createState() =>
      _StoryStartDateScreenState();
}

class _StoryStartDateScreenState extends State<StoryStartDateScreen> {
  DateTime? _selectedDate = DateTime(2023, 10, 14);

  // ------------------------------------------------------------
  // DATE PICKER
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------

  String _formatDate(DateTime date) {
    final String month =
    date.month.toString().padLeft(2, '0');

    final String day =
    date.day.toString().padLeft(2, '0');

    return '$month/$day/${date.year}';
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

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

            // ====================================================
            // MAIN CONTENT
            // ====================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [

                    // ==================================================
                    // HERO IMAGE
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: Image.asset(
                        'assets/images/story_start.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // ==================================================
                    // MAIN CONTENT CARD
                    // ==================================================

                    Transform.translate(
                      offset: const Offset(0, -28),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          30,
                          24,
                          28,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(38),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.07,
                              ),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            // ========================================
                            // TITLE
                            // ========================================

                            Text(
                              'When did your\nstory begin?',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.displayLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ========================================
                            // DESCRIPTION
                            // ========================================

                            Text(
                              'Choose the date you consider\nyour anniversary.',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ========================================
                            // DATE FIELD
                            // ========================================

                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceBright,
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  border: Border.all(
                                    color:
                                    AppColors.outlineVariant,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Colors.black.withValues(
                                        alpha: 0.035,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [

                                    // Calendar icon
                                    Icon(
                                      Icons
                                          .calendar_month_outlined,
                                      size: 22,
                                      color:
                                      AppColors.secondary,
                                    ),

                                    const SizedBox(width: 18),

                                    // Date
                                    Text(
                                      _selectedDate == null
                                          ? 'Select date'
                                          : _formatDate(
                                        _selectedDate!,
                                      ),
                                      style: AppTextTheme.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        height: 1.4,
                                      ),
                                    ),

                                    const Spacer(),

                                    // Small dropdown indicator
                                    Icon(
                                      Icons
                                          .keyboard_arrow_down_rounded,
                                      size: 22,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // ========================================
                            // DATE TYPE CHIPS
                            // ========================================

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [

                                _DateTypeChip(
                                  icon: Icons
                                      .favorite_border_rounded,
                                  label: 'Special day',
                                  selected: true,
                                ),

                                const SizedBox(width: 10),

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

                    // Space after translated card
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),

            // ====================================================
            // BOTTOM ACTION AREA
            // ====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                24,
                10,
                24,
                18,
              ),
              color: AppColors.surface,
              child: Column(
                children: [

                  // ==============================================
                  // CONTINUE BUTTON
                  // ==============================================

                  AppMainButton(
                    text: 'Continue',
                    onPressed: _selectedDate == null
                        ? null
                        : () {
                      widget.onContinue(
                        _selectedDate!,
                      );
                    },
                    height: 48,
                    borderRadius: 6,
                  ),

                  const SizedBox(height: 12),

                  // ==============================================
                  // NOT SURE
                  // ==============================================

                  GestureDetector(
                    onTap: widget.onNotSure,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        "I'm not sure yet",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
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
      height: 36,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFE2DEFF)
            : const Color(0xFFECE7E4),
        borderRadius: BorderRadius.circular(20),
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
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: selected
                  ? AppColors.secondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}