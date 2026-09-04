import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodLengthScreen extends StatefulWidget {
  const PeriodLengthScreen({
    super.key,
    this.initialPeriodLength = 5,
    this.onFinishSetup,
    this.onSkip,
  });

  final int initialPeriodLength;
  final ValueChanged<int>? onFinishSetup;
  final VoidCallback? onSkip;

  @override
  State<PeriodLengthScreen> createState() => _PeriodLengthScreenState();
}

class _PeriodLengthScreenState extends State<PeriodLengthScreen> {
  static const int _minPeriodLength = 2;
  static const int _maxPeriodLength = 8;

  static const double _itemExtent = 56.0;
  static const double _selectionHeight = 56.0;

  late FixedExtentScrollController _scrollController;

  late int _selectedPeriodLength;

  @override
  void initState() {
    super.initState();

    _selectedPeriodLength = widget.initialPeriodLength.clamp(
      _minPeriodLength,
      _maxPeriodLength,
    );

    _scrollController = FixedExtentScrollController(
      initialItem: _selectedPeriodLength - _minPeriodLength,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // PERIOD LENGTH SELECTION
  // ---------------------------------------------------------------------------

  void _onPeriodChanged(int index) {
    final value = _minPeriodLength + index;

    if (value == _selectedPeriodLength) {
      return;
    }

    HapticFeedback.selectionClick();

    setState(() {
      _selectedPeriodLength = value;
    });
  }

  // ---------------------------------------------------------------------------
  // FINISH SETUP
  // ---------------------------------------------------------------------------

  void _handleFinishSetup() {
    HapticFeedback.mediumImpact();

    widget.onFinishSetup?.call(_selectedPeriodLength);

    // If no callback is provided, return to the period home.
    if (widget.onFinishSetup == null) {
      context.push(AppRoutes.periodSetupComplete);
    }
  }

  // ---------------------------------------------------------------------------
  // SKIP
  // ---------------------------------------------------------------------------

  void _handleSkip() {
    widget.onSkip?.call();

    if (widget.onSkip == null) {
      context.push(AppRoutes.periodSetupComplete);
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 448,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      6,
                      16,
                      4,
                    ),
                    child: Column(
                      children: [
                        _buildHeading(),

                        const SizedBox(height: 18),

                        Expanded(
                          child: _buildPeriodPicker(),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: AppMainButton(
                text: 'Finish Setup',
                onPressed: _handleFinishSetup,
                height: 48,
                borderRadius: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return
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
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),

            // Progress indicators — centered
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: const ProgressDots(currentStep: 3, totalSteps: 3),
              ),
            ),

            // Skip
            Positioned(
              right: 16,
              top: 12,
              child: TextButton(
                onPressed: _handleSkip,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 40),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }


  // ---------------------------------------------------------------------------
  // HEADING
  // ---------------------------------------------------------------------------

  Widget _buildHeading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'How many days does your\nperiod usually last?',
          textAlign: TextAlign.center,
          style: AppTextTheme.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'This helps us accurately predict your cycle\nand fertile window.',
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PERIOD LENGTH PICKER
  // ---------------------------------------------------------------------------

  Widget _buildPeriodPicker() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pickerHeight = constraints.maxHeight.clamp(
          150.0,
          210.0,
        );

        return Center(
          child: SizedBox(
            width: double.infinity,
            height: pickerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // --------------------------------------------------------------
                // SELECTED BACKGROUND
                // --------------------------------------------------------------

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Container(
                      height: _selectionHeight,
                      decoration: BoxDecoration(
                        color: const Color(0x14E8B4B8),
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: AppColors.primaryContainer,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // --------------------------------------------------------------
                // WHEEL
                // --------------------------------------------------------------

                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: _itemExtent,
                      diameterRatio: 2.8,
                      perspective: 0.002,
                      squeeze: 1.0,
                      physics: const FixedExtentScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      overAndUnderCenterOpacity: 0.25,
                      onSelectedItemChanged: _onPeriodChanged,
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount:
                        _maxPeriodLength - _minPeriodLength + 1,
                        builder: (context, index) {
                          if (index == null) {
                            return null;
                          }

                          final periodLength =
                              _minPeriodLength + index;

                          final isSelected =
                              periodLength == _selectedPeriodLength;

                          return _buildPeriodItem(
                            periodLength,
                            isSelected,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // --------------------------------------------------------------
                // TOP FADE
                // --------------------------------------------------------------

                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 32,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.surface,
                            AppColors.surface.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // --------------------------------------------------------------
                // BOTTOM FADE
                // --------------------------------------------------------------

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 32,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.surface,
                            AppColors.surface.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // --------------------------------------------------------------
                // SELECTION BORDERS
                // --------------------------------------------------------------

                IgnorePointer(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      child: Container(
                        height: _selectionHeight,
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: AppColors.primaryContainer,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodItem(int periodLength,
      bool isSelected,) {
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        style: GoogleFonts.playfairDisplay(
          fontSize: isSelected ? 26 : 16,
          fontWeight:
          isSelected ? FontWeight.w700 : FontWeight.w600,
          height: 1.2,
          letterSpacing: isSelected ? -0.5 : 0,
          color: isSelected
              ? AppColors.primary
              : const Color(0x4C504444),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$periodLength days',
            ),

            // if (isSelected) ...[
            //   const SizedBox(width: 5),
            //
            //   Text(
            //     'days',
            //     style: GoogleFonts.inter(
            //       fontSize: 16,
            //       // fontWeight: FontWeight.w400,
            //       // color: AppColors.primary,
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

// ---------------------------------------------------------------------------
// FINISH SETUP BUTTON
// ---------------------------------------------------------------------------
}