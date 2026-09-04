import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodCycleLengthScreen extends StatefulWidget {
  const PeriodCycleLengthScreen({
    super.key,
    this.initialCycleLength = 28,
    this.onContinue,
    this.onSkip,
  });

  final int initialCycleLength;
  final ValueChanged<int>? onContinue;
  final VoidCallback? onSkip;

  @override
  State<PeriodCycleLengthScreen> createState() =>
      _PeriodCycleLengthScreenState();
}

class _PeriodCycleLengthScreenState extends State<PeriodCycleLengthScreen> {
  static const int _minCycleLength = 21;
  static const int _maxCycleLength = 35;

  static const double _itemExtent = 56.0;
  static const double _selectionHeight = 64.0;

  late FixedExtentScrollController _scrollController;

  late int _selectedCycleLength;

  bool _isNotSure = false;

  @override
  void initState() {
    super.initState();

    _selectedCycleLength = widget.initialCycleLength.clamp(
      _minCycleLength,
      _maxCycleLength,
    );

    _scrollController = FixedExtentScrollController(
      initialItem: _selectedCycleLength - _minCycleLength,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // SELECTION
  // ---------------------------------------------------------------------------

  void _onCycleChanged(int index) {
    final value = _minCycleLength + index;

    if (value == _selectedCycleLength) {
      return;
    }

    HapticFeedback.selectionClick();

    setState(() {
      _selectedCycleLength = value;
      _isNotSure = false;
    });
  }

  void _handleNotSure() {
    HapticFeedback.selectionClick();

    setState(() {
      _isNotSure = !_isNotSure;
    });
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION
  // ---------------------------------------------------------------------------

  void _handleContinue() {
    widget.onContinue?.call(_selectedCycleLength);

    // Add the next setup route here when ready.
    //
    // Example:
    context.push(AppRoutes.periodLength);
  }

  void _handleSkip() {
    widget.onSkip?.call();

    if (widget.onSkip == null) {
      context.go(AppRoutes.period);
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
                      4,
                      16,
                      4,
                    ),
                    child: Column(
                      children: [
                        _buildHeading(),

                        const SizedBox(height: 8),

                        Expanded(
                          child: _buildCyclePicker(),
                        ),

                        const SizedBox(height: 4),

                        _buildNotSureButton(),

                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: AppMainButton(
                text: 'Continue',
                onPressed: _handleContinue,
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
                child: const ProgressDots(currentStep: 2, totalSteps: 3),
              ),
            ),

            // Skip
            Positioned(
              right: 16,
              top: 12,
              child: TextButton(
                onPressed: () => (),
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
          'How long is your typical\ncycle?',
          textAlign: TextAlign.center,
          style: AppTextTheme.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'This helps us personalize your insights and\npredictions.',
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
  // CYCLE PICKER
  // ---------------------------------------------------------------------------

  Widget _buildCyclePicker() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.clamp(
          280.0,
          340.0,
        );

        return SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ----------------------------------------------------------------
              // SELECTION HIGHLIGHT
              //
              // IMPORTANT:
              // This is centered using Align instead of calculating "top".
              // Therefore it is always aligned with the wheel's center item.
              // ----------------------------------------------------------------
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  child: Container(
                    height: _selectionHeight,
                    decoration: BoxDecoration(
                      color: const Color(0x19E8B4B8),
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

              // ----------------------------------------------------------------
              // TOP FADE
              // ----------------------------------------------------------------
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 50,
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

              // ----------------------------------------------------------------
              // BOTTOM FADE
              // ----------------------------------------------------------------
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 50,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.surface,
                          AppColors.surface.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ----------------------------------------------------------------
              // WHEEL
              // ----------------------------------------------------------------
              Positioned.fill(
                child: ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: _itemExtent,
                  diameterRatio: 2.8,
                  perspective: 0.002,
                  squeeze: 1.0,
                  physics: const FixedExtentScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  overAndUnderCenterOpacity: 0.35,
                  onSelectedItemChanged: _onCycleChanged,
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount:
                    _maxCycleLength - _minCycleLength + 1,
                    builder: (context, index) {
                      if (index == null) {
                        return null;
                      }

                      final cycleLength =
                          _minCycleLength + index;

                      final isSelected =
                          cycleLength == _selectedCycleLength;

                      return _buildCycleItem(
                        cycleLength,
                        isSelected,
                      );
                    },
                  ),
                ),
              ),

              // ----------------------------------------------------------------
              // RE-DRAW BORDER
              //
              // This keeps the border visually crisp above the wheel.
              // ----------------------------------------------------------------
              IgnorePointer(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Container(
                      height: _selectionHeight,
                      decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide(
                            color: AppColors.primaryContainer,
                            width: 1,
                          ),
                          bottom: BorderSide(
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
        );
      },
    );
  }

  Widget _buildCycleItem(
      int cycleLength,
      bool isSelected,
      ) {
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
        child: Text(
          '$cycleLength days',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // I'M NOT SURE
  // ---------------------------------------------------------------------------

  Widget _buildNotSureButton() {
    final borderColor = _isNotSure
        ? AppColors.primary
        : const Color(0xFFD4C2C3);

    final backgroundColor = _isNotSure
        ? const Color(0x12E8B4B8)
        : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleNotSure,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isNotSure
                      ? Icons.check_circle_outline_rounded
                      : Icons.help_outline_rounded,
                  size: 12,
                  color: _isNotSure
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),

                const SizedBox(width: 5),

                Text(
                  "I'm not sure",
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _isNotSure
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONTINUE BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 448,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF7C5357),
                  Color(0xFFE8B4B8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x337C5357),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleContinue,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}