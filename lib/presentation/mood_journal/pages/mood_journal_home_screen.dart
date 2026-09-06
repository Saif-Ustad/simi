import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

enum MoodType {
  happy,
  loved,
  calm,
  normal,
  sad,
  angry,
  tired,
}

class MoodEntry {
  const MoodEntry({
    required this.date,
    required this.mood,
    required this.intensity,
    this.note = '',
    this.isShared = false,
  });

  final DateTime date;
  final MoodType mood;
  final int intensity;
  final String note;
  final bool isShared;
}

class MoodJournalHomeScreen extends StatefulWidget {
  const MoodJournalHomeScreen({
    super.key,
    this.entries = const [],
    this.onDateTap,
    this.onAddMood,
  });

  final List<MoodEntry> entries;
  final ValueChanged<DateTime>? onDateTap;
  final VoidCallback? onAddMood;

  @override
  State<MoodJournalHomeScreen> createState() =>
      _MoodJournalHomeScreenState();
}

class _MoodJournalHomeScreenState
    extends State<MoodJournalHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _visibleMonth = DateTime(
      now.year,
      now.month,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _MoodBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 130,
              ),
              children: [
                _buildTopBar(context),

                _buildHero(),

                _buildCalendar(),

                _buildMonthSummary(),

                _buildTodayCard(),

                _buildLittleMessage(),
              ],
            ),
          ),

          if (widget.onAddMood != null)
            _buildBottomAction(),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        0,
      ),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const _CircleButton(
                icon: Icons.arrow_back_rounded,
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    'MOOD JOURNAL',
                    style:
                    AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 8,
                      fontWeight:
                      FontWeight.w600,
                      letterSpacing: 1.8,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your little feelings',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 42),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    final todayEntry = _entryForDate(
      DateTime.now(),
    );

    final mood = todayEntry != null
        ? _moodInfo(todayEntry.mood)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        8,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.05,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.fromLTRB(
            20,
            21,
            20,
            21,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCE4EC),
                Color(0xFFF8EEEE),
                Color(0xFFF0E8E6),
              ],
            ),
            borderRadius:
            BorderRadius.circular(26),
            border: Border.all(
              color: const Color(0xFFE8B4B8)
                  .withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration:
                const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    mood?.emoji ?? '🌸',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A LITTLE CHECK-IN',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        fontWeight:
                        FontWeight.w600,
                        letterSpacing: 1.7,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      mood == null
                          ? 'How are you feeling today?'
                          : 'Today feels ${mood.label.toLowerCase()}.',
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      mood == null
                          ? 'A tiny moment to notice yourself.'
                          : 'It only takes a moment to remember how you felt.',
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 9,
                        height: 1.45,
                        color:
                        AppColors.textSecondary,
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

  // ===========================================================================
  // CALENDAR
  // ===========================================================================

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.12,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.fromLTRB(
            15,
            17,
            15,
            15,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.82,
            ),
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(
                alpha: 0.45,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildCalendarHeader(),

              const SizedBox(height: 16),

              _buildWeekLabels(),

              const SizedBox(height: 7),

              _buildCalendarGrid(),

              const SizedBox(height: 13),

              _buildCalendarLegend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    final monthName = _monthName(
      _visibleMonth.month,
    );

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration:
          const BoxDecoration(
            color: Color(0xFFFCE4EC),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 18,
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
                monthName,
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textPrimary,
                ),
              ),
              Text(
                '${_visibleMonth.year}',
                style: AppTextTheme.labelSmall
                    .copyWith(
                  fontSize: 8.5,
                  color:
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        _CalendarArrowButton(
          icon:
          Icons.chevron_left_rounded,
          onTap: _previousMonth,
        ),

        const SizedBox(width: 6),

        _CalendarArrowButton(
          icon:
          Icons.chevron_right_rounded,
          onTap: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildWeekLabels() {
    const labels = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 8,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textDisabled,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;

    // Monday = 1 ... Sunday = 7.
    final leadingDays =
        firstDay.weekday - 1;

    final totalCells =
        ((leadingDays + daysInMonth) / 7)
            .ceil() *
            7;

    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 7,
        crossAxisSpacing: 3,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        if (index < leadingDays) {
          return const SizedBox();
        }

        final day =
            index - leadingDays + 1;

        if (day > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(
          _visibleMonth.year,
          _visibleMonth.month,
          day,
        );

        final entry =
        _entryForDate(date);

        return _CalendarDay(
          date: date,
          entry: entry,
          isToday:
          _isToday(date),
          onTap: () {
            widget.onDateTap?.call(date);
          },
        );
      },
    );
  }

  Widget _buildCalendarLegend() {
    return Row(
      children: [
        _LegendItem(
          emoji: '😊',
          label: 'Mood recorded',
        ),
        const Spacer(),
        Text(
          'Tap a day to see more',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 8,
            color:
            AppColors.textDisabled,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MONTH SUMMARY
  // ===========================================================================

  Widget _buildMonthSummary() {
    final monthEntries =
    widget.entries.where((entry) {
      return entry.date.year ==
          _visibleMonth.year &&
          entry.date.month ==
              _visibleMonth.month;
    }).toList();

    final counts =
    <MoodType, int>{};

    for (final entry in monthEntries) {
      counts[entry.mood] =
          (counts[entry.mood] ?? 0) + 1;
    }

    final sorted =
    counts.entries.toList()
      ..sort(
            (a, b) =>
            b.value.compareTo(a.value),
      );

    final topMoods =
    sorted.take(3).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.20,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'THIS MONTH',
            ),

            const SizedBox(height: 5),

            Text(
              monthEntries.isEmpty
                  ? 'Your feelings will slowly tell the story.'
                  : '${monthEntries.length} ${monthEntries.length == 1 ? 'day' : 'days'} you checked in.',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color:
                AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 11),

            if (topMoods.isEmpty)
              _buildNoMoodSummary()
            else
              Row(
                children: topMoods.map((item) {
                  return Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                        right: 8,
                      ),
                      child:
                      _MoodSummaryCard(
                        mood: item.key,
                        count: item.value,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoodSummary() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.65,
        ),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            '🌱',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No mood entries yet this month.',
              style: AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 9.5,
                color:
                AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TODAY
  // ===========================================================================

  Widget _buildTodayCard() {
    final today = DateTime.now();

    final entry =
    _entryForDate(today);

    final info = entry == null
        ? null
        : _moodInfo(entry.mood);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.28,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.fromLTRB(
            17,
            17,
            17,
            17,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.78,
            ),
            borderRadius:
            BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(
                alpha: 0.42,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    info?.emoji ?? '🌸',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TODAY',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        fontWeight:
                        FontWeight.w600,
                        letterSpacing: 1.4,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      info?.label ??
                          'No mood yet',
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      entry?.note
                          .trim()
                          .isNotEmpty ==
                          true
                          ? entry!.note
                          : 'How are you feeling today?',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8.5,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  widget.onDateTap?.call(
                    today,
                  );
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // LITTLE MESSAGE
  // ===========================================================================

  Widget _buildLittleMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        10,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.34,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE4EC)
                .withValues(
              alpha: 0.55,
            ),
            borderRadius:
            BorderRadius.circular(23),
          ),
          child: Column(
            children: [
              const Text(
                '🌷',
                style: TextStyle(
                  fontSize: 23,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Every feeling belongs somewhere.',
                textAlign: TextAlign.center,
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontStyle:
                  FontStyle.italic,
                  fontWeight:
                  FontWeight.w500,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'A little record of the days, '
                    'the moods, and everything in between.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8.5,
                  height: 1.5,
                  color:
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM ACTION
  // ===========================================================================

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 14,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 540,
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: GestureDetector(
                onTap: widget.onAddMood,
                child: Container(
                  height: 58,
                  decoration:
                  BoxDecoration(
                    gradient:
                    const LinearGradient(
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color(0xFF765457),
                        Color(0xFF966E72),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      29,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 20,
                        offset:
                        const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 12,
                        offset:
                        const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),

                      Container(
                        width: 46,
                        height: 46,
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.14,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .add_reaction_outlined,
                          size: 21,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 13,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              'How do you feel?',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Save a little piece of today',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors
                                    .white
                                    .withValues(
                                  alpha: 0.72,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 42,
                        height: 42,
                        margin:
                        const EdgeInsets
                            .only(
                          right: 4,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.12,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 19,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MONTH NAVIGATION
  // ===========================================================================

  void _previousMonth() {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + 1,
      );
    });
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  MoodEntry? _entryForDate(
      DateTime date,
      ) {
    for (final entry in widget.entries) {
      if (_sameDate(entry.date, date)) {
        return entry;
      }
    }

    return null;
  }

  bool _sameDate(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool _isToday(DateTime date) {
    return _sameDate(
      date,
      DateTime.now(),
    );
  }

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

  _MoodInfo _moodInfo(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return const _MoodInfo(
          emoji: '😊',
          label: 'Happy',
          background: Color(0xFFFFF2CC),
        );

      case MoodType.loved:
        return const _MoodInfo(
          emoji: '🥰',
          label: 'Loved',
          background: Color(0xFFFCE4EC),
        );

      case MoodType.calm:
        return const _MoodInfo(
          emoji: '😌',
          label: 'Calm',
          background: Color(0xFFE8F3F1),
        );

      case MoodType.normal:
        return const _MoodInfo(
          emoji: '😐',
          label: 'Normal',
          background: Color(0xFFF1F1F1),
        );

      case MoodType.sad:
        return const _MoodInfo(
          emoji: '😔',
          label: 'Low',
          background: Color(0xFFE8EAF6),
        );

      case MoodType.angry:
        return const _MoodInfo(
          emoji: '😡',
          label: 'Angry',
          background: Color(0xFFFDE2E2),
        );

      case MoodType.tired:
        return const _MoodInfo(
          emoji: '😴',
          label: 'Tired',
          background: Color(0xFFEDE7F6),
        );
    }
  }
}

// ===========================================================================
// CALENDAR DAY
// ===========================================================================

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.entry,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final MoodEntry? entry;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final info = entry == null
        ? null
        : _MoodInfo.fromMood(entry!.mood);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? const Color(0xFFFCE4EC)
              .withValues(alpha: 0.65)
              : Colors.transparent,
          borderRadius:
          BorderRadius.circular(12),
          border: isToday
              ? Border.all(
            color: const Color(
              0xFFE8B4B8,
            ),
          )
              : null,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style:
              AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 9,
                fontWeight: isToday
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: isToday
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 3),

            if (info != null)
              Text(
                info.emoji,
                style: const TextStyle(
                  fontSize: 18,
                ),
              )
            else
              const SizedBox(
                height: 18,
              ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// MOOD SUMMARY CARD
// ===========================================================================

class _MoodSummaryCard
    extends StatelessWidget {
  const _MoodSummaryCard({
    required this.mood,
    required this.count,
  });

  final MoodType mood;
  final int count;

  @override
  Widget build(BuildContext context) {
    final info =
    _MoodInfo.fromMood(mood);

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: info.background
            .withValues(alpha: 0.72),
        borderRadius:
        BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Text(
            info.emoji,
            style: const TextStyle(
              fontSize: 21,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '$count ${count == 1 ? 'day' : 'days'}',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style:
            AppTextTheme.labelSmall
                .copyWith(
              fontSize: 8,
              fontWeight:
              FontWeight.w600,
              color:
              AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            info.label,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style:
            AppTextTheme.labelSmall
                .copyWith(
              fontSize: 7.5,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// LEGEND
// ===========================================================================

class _LegendItem
    extends StatelessWidget {
  const _LegendItem({
    required this.emoji,
    required this.label,
  });

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 7.5,
            color:
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// CALENDAR ARROW
// ===========================================================================

class _CalendarArrowButton
    extends StatelessWidget {
  const _CalendarArrowButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration:
        const BoxDecoration(
          color: Color(0xFFF7F0EE),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ===========================================================================
// CIRCLE BUTTON
// ===========================================================================

class _CircleButton
    extends StatelessWidget {
  const _CircleButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.72,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Icon(
        icon,
        size: 19,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ===========================================================================
// SECTION LABEL
// ===========================================================================

class _SectionLabel
    extends StatelessWidget {
  const _SectionLabel({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
      AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.8,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ===========================================================================
// MOOD INFO
// ===========================================================================

class _MoodInfo {
  const _MoodInfo({
    required this.emoji,
    required this.label,
    required this.background,
  });

  final String emoji;
  final String label;
  final Color background;

  static _MoodInfo fromMood(
      MoodType mood,
      ) {
    switch (mood) {
      case MoodType.happy:
        return const _MoodInfo(
          emoji: '😊',
          label: 'Happy',
          background: Color(0xFFFFF2CC),
        );

      case MoodType.loved:
        return const _MoodInfo(
          emoji: '🥰',
          label: 'Loved',
          background: Color(0xFFFCE4EC),
        );

      case MoodType.calm:
        return const _MoodInfo(
          emoji: '😌',
          label: 'Calm',
          background: Color(0xFFE8F3F1),
        );

      case MoodType.normal:
        return const _MoodInfo(
          emoji: '😐',
          label: 'Normal',
          background: Color(0xFFF1F1F1),
        );

      case MoodType.sad:
        return const _MoodInfo(
          emoji: '😔',
          label: 'Low',
          background: Color(0xFFE8EAF6),
        );

      case MoodType.angry:
        return const _MoodInfo(
          emoji: '😡',
          label: 'Angry',
          background: Color(0xFFFDE2E2),
        );

      case MoodType.tired:
        return const _MoodInfo(
          emoji: '😴',
          label: 'Tired',
          background: Color(0xFFEDE7F6),
        );
    }
  }
}

// ===========================================================================
// BACKGROUND
// ===========================================================================

class _MoodBackground
    extends StatelessWidget {
  const _MoodBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration:
          const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8F5),
                Color(0xFFF5ECE9),
              ],
            ),
          ),
        ),

        Positioned(
          left: -100,
          top: 120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.14,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          right: -100,
          bottom: 160,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(
              width: 240,
              height: 240,
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFD9D5E4,
                ).withValues(
                  alpha: 0.14,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// ANIMATION
// ===========================================================================

class _AnimatedEntry
    extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.delay,
    required this.child,
  });

  final AnimationController controller;
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation =
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        1,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value =
            animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              16 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}