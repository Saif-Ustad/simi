import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodCycleStartDateScreen extends StatefulWidget {
  const PeriodCycleStartDateScreen({
    super.key,
    this.initialDate,
    this.onBack,
    this.onSkip,
    this.onContinue,
    this.onDontRemember,
  });

  final DateTime? initialDate;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final ValueChanged<DateTime>? onContinue;
  final VoidCallback? onDontRemember;

  @override
  State<PeriodCycleStartDateScreen> createState() =>
      _PeriodCycleStartDateScreenState();
}

class _PeriodCycleStartDateScreenState
    extends State<PeriodCycleStartDateScreen> {
  late DateTime _visibleMonth;
  DateTime? _selectedDate;
  bool _dontRemember = false;

  @override
  void initState() {
    super.initState();

    final initialDate = widget.initialDate;

    _selectedDate = initialDate;

    if (initialDate != null) {
      _visibleMonth = DateTime(initialDate.year, initialDate.month);
    } else {
      final now = DateTime.now();

      _visibleMonth = DateTime(now.year, now.month);
    }
  }

  DateTime get _today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime? first, DateTime? second) {
    if (first == null || second == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _isFuture(DateTime date) {
    return date.isAfter(_today);
  }

  void _selectDate(DateTime date) {
    if (_isFuture(date)) {
      return;
    }

    setState(() {
      _selectedDate = date;
      _dontRemember = false;
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    final nextMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);

    final currentMonth = DateTime(_today.year, _today.month);

    if (nextMonth.isAfter(currentMonth)) {
      return;
    }

    setState(() {
      _visibleMonth = nextMonth;
    });
  }

  void _handleDontRemember() {
    setState(() {
      _selectedDate = null;
      _dontRemember = true;
    });

    widget.onDontRemember?.call();
  }

  void _handleContinue() {
    final selectedDate = _selectedDate;

    if (selectedDate == null) {
      return;
    }

    widget.onContinue?.call(selectedDate);
  }

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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 448),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildHeading(),
                        const SizedBox(height: 12),
                        _buildCalendarCard(),
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
                onPressed: () => context.push(AppRoutes.periodCycleLength),
                height: 48,
                borderRadius: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              child: const ProgressDots(currentStep: 1, totalSteps: 3),
            ),
          ),

          // Skip
          Positioned(
            right: 16,
            top: 12,
            child: TextButton(
              onPressed: () => context.push(AppRoutes.periodCycleLength),
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

  Widget _buildHeading() {
    return Column(
      children: [
        Text(
          'When did your last period\nstart?',
          textAlign: TextAlign.center,
          style: AppTextTheme.headlineMedium.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'This helps us understand your unique cycle\nrhythm.',
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSelectedDate(),
          _buildMonthHeader(),
          _buildWeekDays(),
          _buildCalendarGrid(),
          _buildDontRemember(),
        ],
      ),
    );
  }

  Widget _buildSelectedDate() {
    final date = _selectedDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceBright, AppColors.surfaceDim],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(
            'SELECTED DATE',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date == null ? 'Select a date' : _formatMonthDay(date),
            style: AppTextTheme.headlineMedium.copyWith(
              color: AppColors.primary,
              fontSize: 26,
            ),
          ),
          if (date != null) ...[
            const SizedBox(height: 1),
            Text('${date.year}', style: AppTextTheme.bodyMediumSecondary),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final canGoNext = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
    ).isBefore(DateTime(_today.year, _today.month + 1));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _goToPreviousMonth,
            icon: const Icon(Icons.chevron_left_rounded, size: 22),
            color: AppColors.textSecondary,
          ),
          Expanded(
            child: Text(
              _formatMonth(_visibleMonth),
              textAlign: TextAlign.center,
              style: AppTextTheme.labelLarge,
            ),
          ),
          IconButton(
            onPressed: canGoNext ? _goToNextMonth : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 22),
            color: canGoNext ? AppColors.textSecondary : AppColors.textDisabled,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
      child: Row(
        children:
            days.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTextTheme.labelSmall.copyWith(fontSize: 10),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);

    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;

    // DateTime weekday:
    // Monday = 1 ... Sunday = 7
    // Convert to Sunday-first calendar.
    final leadingEmptyDays = firstDay.weekday % 7;

    final totalCells = ((leadingEmptyDays + daysInMonth) / 7).ceil() * 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalCells,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final dayNumber = index - leadingEmptyDays + 1;

          if (dayNumber < 1 || dayNumber > daysInMonth) {
            return const SizedBox.shrink();
          }

          final date = DateTime(
            _visibleMonth.year,
            _visibleMonth.month,
            dayNumber,
          );

          return _CalendarDay(
            date: date,
            isSelected: _isSameDay(date, _selectedDate),
            isToday: _isSameDay(date, _today),
            isFuture: _isFuture(date),
            onTap: () => _selectDate(date),
          );
        },
      ),
    );
  }

  Widget _buildDontRemember() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: TextButton(
        onPressed: _handleDontRemember,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        child: Text(
          "I don't remember",
          style: AppTextTheme.labelLarge.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  String _formatMonthDay(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatMonth(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isFuture,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isFuture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isFuture
            ? AppColors.textDisabled.withValues(alpha: 0.45)
            : AppColors.textPrimary;

    return Center(
      child: GestureDetector(
        onTap: isFuture ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: AppTextTheme.bodyMedium.copyWith(
                color: isSelected ? AppColors.onPrimary : textColor,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
