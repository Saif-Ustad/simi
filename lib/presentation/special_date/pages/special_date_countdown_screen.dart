import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateCountdownScreen extends StatefulWidget {
  const SpecialDateCountdownScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.repeatsYearly,
    required this.reminderDays,
    required this.note,
    this.onBack,
    this.onEdit,
    this.onDone,
  });

  final SpecialDateCategory category;
  final String title;
  final String description;
  final DateTime date;
  final bool repeatsYearly;
  final int reminderDays;
  final String note;

  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDone;

  @override
  State<SpecialDateCountdownScreen> createState() =>
      _SpecialDateCountdownScreenState();
}

class _SpecialDateCountdownScreenState
    extends State<SpecialDateCountdownScreen>
    with TickerProviderStateMixin {
  late final Timer _timer;

  late final AnimationController _pulseController;
  late final AnimationController _orbitController;
  late final AnimationController _entryController;

  Duration _remaining = Duration.zero;

  DateTime get _targetDate {
    final now = DateTime.now();

    if (!widget.repeatsYearly) {
      return widget.date;
    }

    DateTime target = DateTime(
      now.year,
      widget.date.month,
      widget.date.day,
      widget.date.hour,
      widget.date.minute,
      widget.date.second,
    );

    if (!target.isAfter(now)) {
      target = DateTime(
        now.year + 1,
        widget.date.month,
        widget.date.day,
        widget.date.hour,
        widget.date.minute,
        widget.date.second,
      );
    }

    return target;
  }

  bool get _isToday {
    final now = DateTime.now();

    return now.year == widget.date.year &&
        now.month == widget.date.month &&
        now.day == widget.date.day;
  }

  bool get _hasPassed {
    if (widget.repeatsYearly) {
      return false;
    }

    return DateTime.now().isAfter(widget.date);
  }

  @override
  void initState() {
    super.initState();

    _updateCountdown();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateCountdown(),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _orbitController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _updateCountdown() {
    final remaining = _targetDate.difference(DateTime.now());

    if (!mounted) {
      return;
    }

    setState(() {
      _remaining = remaining.isNegative
          ? Duration.zero
          : remaining;
    });
  }

  // ---------------------------------------------------------------------------
  // CATEGORY
  // ---------------------------------------------------------------------------

  _CategoryInfo get _categoryInfo {
    switch (widget.category) {
      case SpecialDateCategory.anniversary:
        return const _CategoryInfo(
          label: 'Anniversary',
          emoji: '❤️',
          icon: Icons.favorite_rounded,
        );

      case SpecialDateCategory.birthday:
        return const _CategoryInfo(
          label: 'Birthday',
          emoji: '🎂',
          icon: Icons.cake_outlined,
        );

      case SpecialDateCategory.firstMeeting:
        return const _CategoryInfo(
          label: 'First Meeting',
          emoji: '✨',
          icon: Icons.people_outline_rounded,
        );

      case SpecialDateCategory.firstDate:
        return const _CategoryInfo(
          label: 'First Date',
          emoji: '💕',
          icon: Icons.favorite_border_rounded,
        );

      case SpecialDateCategory.firstKiss:
        return const _CategoryInfo(
          label: 'First Kiss',
          emoji: '💋',
          icon: Icons.face_retouching_natural_rounded,
        );

      case SpecialDateCategory.firstTrip:
        return const _CategoryInfo(
          label: 'First Trip',
          emoji: '✈️',
          icon: Icons.flight_takeoff_rounded,
        );

      case SpecialDateCategory.customMoment:
        return const _CategoryInfo(
          label: 'Custom Moment',
          emoji: '🌷',
          icon: Icons.auto_awesome_rounded,
        );
    }
  }

  // ---------------------------------------------------------------------------
  // DATE HELPERS
  // ---------------------------------------------------------------------------

  String _monthName(int month) {
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

    return months[month - 1];
  }

  String get _formattedDate {
    return '${widget.date.day} '
        '${_monthName(widget.date.month)} '
        '${widget.date.year}';
  }

  String get _weekday {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[widget.date.weekday - 1];
  }

  // ---------------------------------------------------------------------------
  // COUNTDOWN VALUES
  // ---------------------------------------------------------------------------

  int get _days => _remaining.inDays;

  int get _hours => _remaining.inHours.remainder(24);

  int get _minutes => _remaining.inMinutes.remainder(60);

  int get _seconds => _remaining.inSeconds.remainder(60);

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _CountdownBackground(),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 145,
              ),
              child: Column(
                children: [
                  _buildTopBar(context),
                  _buildHeader(),
                  _buildCountdownCard(),
                  _buildDateInfo(),
                  _buildReminderCard(),
                  _buildPrivateMessage(),
                ],
              ),
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        0,
      ),
      child: SizedBox(
        height: 55,
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onBack ??
                      () => Navigator.of(context).pop(),
              child: const _CircleButton(
                icon: Icons.arrow_back_rounded,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPECIAL DATES',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Our little countdown',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: widget.onEdit,
              child: const _CircleButton(
                icon: Icons.edit_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        28,
        24,
        20,
      ),
      child: AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          final progress = Curves.easeOut.transform(
            _entryController.value,
          );

          return Opacity(
            opacity: _entryController.value,
            child: Transform.translate(
              offset: Offset(
                0,
                18 * (1 - progress),
              ),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            Text(
              _isToday
                  ? 'TODAY IS OUR DAY'
                  : 'UNTIL OUR NEXT MOMENT',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.3,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                height: 1.12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _categoryInfo.emoji,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _categoryInfo.label,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COUNTDOWN CARD
  // ---------------------------------------------------------------------------

  Widget _buildCountdownCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 365,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF211A1B),
              Color(0xFF49383A),
              Color(0xFF73575A),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // Background glow
              Positioned(
                right: -70,
                top: -70,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                left: -80,
                bottom: -70,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.035),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Orbit
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _OrbitPainter(
                        rotation: _orbitController.value *
                            math.pi *
                            2,
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  22,
                  18,
                  18,
                ),
                child: Column(
                  children: [
                    // Small label
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF6D9DC),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          widget.repeatsYearly
                              ? 'EVERY YEAR, WE FIND OUR WAY BACK'
                              : 'COUNTING DOWN TO OUR LITTLE MOMENT',
                          textAlign: TextAlign.center,
                          style:
                          AppTextTheme.labelSmall.copyWith(
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: Colors.white
                                .withValues(alpha: 0.62),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    // Heart
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale =
                            1 +
                                (_pulseController.value * 0.055);

                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white
                                .withValues(alpha: 0.10),
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 29,
                          color: Color(0xFFE8B4B8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Days
                    Text(
                      _days.toString(),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 68,
                        height: 0.92,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      _days == 1 ? 'DAY TO GO' : 'DAYS TO GO',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                        color: Colors.white
                            .withValues(alpha: 0.58),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Time boxes
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        _TimeUnit(
                          value: _twoDigits(_hours),
                          label: 'HOURS',
                        ),
                        _timeDivider(),
                        _TimeUnit(
                          value: _twoDigits(_minutes),
                          label: 'MINUTES',
                        ),
                        _timeDivider(),
                        _TimeUnit(
                          value: _twoDigits(_seconds),
                          label: 'SECONDS',
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    Text(
                      _hasPassed
                          ? 'This moment has already passed.'
                          : _isToday
                          ? 'It\'s finally here. ❤️'
                          : 'The wait makes the moment sweeter.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white
                            .withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Text(
        ':',
        style: GoogleFonts.playfairDisplay(
          fontSize: 20,
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE INFO
  // ---------------------------------------------------------------------------

  Widget _buildDateInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.84),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _categoryInfo.icon,
                size: 22,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'THE DAY',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formattedDate,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _weekday,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (widget.repeatsYearly)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1F0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.repeat_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'YEARLY',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.primary,
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

  // ---------------------------------------------------------------------------
  // REMINDER
  // ---------------------------------------------------------------------------

  Widget _buildReminderCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F1F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'REMINDER',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${widget.reminderDays} '
                        '${widget.reminderDays == 1 ? 'day' : 'days'} before',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.check_circle_rounded,
              size: 19,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIVATE MESSAGE
  // ---------------------------------------------------------------------------

  Widget _buildPrivateMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        28,
        30,
        28,
        10,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),

          const SizedBox(height: 9),

          Text(
            'JUST BETWEEN US.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Some dates are worth counting down to.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'And this one belongs to the two of you.',
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTION
  // ---------------------------------------------------------------------------

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            GestureDetector(
              onTap: widget.onEdit,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 540,
                ),
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF765457),
                      Color(0xFF966E72),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.14),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withValues(alpha: 0.23),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 7),

                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 13),

                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit this moment',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Change the date or details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            AppTextTheme.labelSmall.copyWith(
                              fontSize: 9,
                              color: Colors.white
                                  .withValues(alpha: 0.70),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 42,
                      height: 42,
                      margin:
                      const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 19,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 7),

            GestureDetector(
              onTap: widget.onDone,
              child: SizedBox(
                height: 32,
                child: Center(
                  child: Text(
                    'Back to Special Dates',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TIME UNIT
// =============================================================================

class _TimeUnit extends StatelessWidget {
  const _TimeUnit({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 6.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Colors.white.withValues(alpha: 0.48),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 17,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// =============================================================================
// CATEGORY INFO
// =============================================================================

class _CategoryInfo {
  const _CategoryInfo({
    required this.label,
    required this.emoji,
    required this.icon,
  });

  final String label;
  final String emoji;
  final IconData icon;
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _CountdownBackground extends StatelessWidget {
  const _CountdownBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -85,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.70),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 380,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 80,
            right: -95,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ORBIT PAINTER
// =============================================================================

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter({
    required this.rotation,
  });

  final double rotation;

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center = Offset(
      size.width / 2,
      size.height / 2 + 5,
    );

    final radius = math.min(
      size.width,
      size.height,
    ) *
        0.34;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = Colors.white.withValues(alpha: 0.07);

    canvas.drawCircle(
      center,
      radius,
      paint,
    );

    canvas.drawCircle(
      center,
      radius * 0.82,
      paint,
    );

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFE8B4B8)
          .withValues(alpha: 0.65);

    final angle = rotation;

    final dot = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );

    canvas.drawCircle(
      dot,
      2.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _OrbitPainter oldDelegate,
      ) {
    return oldDelegate.rotation != rotation;
  }
}