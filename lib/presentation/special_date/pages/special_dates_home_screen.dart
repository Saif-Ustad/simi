import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

/// ---------------------------------------------------------------------------
/// MODELS
/// ---------------------------------------------------------------------------

enum SpecialDateCategory {
  anniversary,
  birthday,
  firstMeeting,
  firstDate,
  firstKiss,
  firstTrip,
  customMoment,
}

enum SpecialDateStatus {
  upcoming,
  today,
  past,
}

class SpecialDateItem {
  const SpecialDateItem({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    this.description = '',
    this.status = SpecialDateStatus.upcoming,
    this.repeatsYearly = false,
    this.reminderDays = 7,
    this.image,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final DateTime date;
  final SpecialDateCategory category;
  final String description;
  final SpecialDateStatus status;
  final bool repeatsYearly;
  final int reminderDays;
  final ImageProvider? image;
  final bool isPinned;
}

/// ---------------------------------------------------------------------------
/// SCREEN
/// ---------------------------------------------------------------------------

class SpecialDatesHomeScreen extends StatefulWidget {
  const SpecialDatesHomeScreen({
    super.key,
    this.specialDates = const [],
    this.onDateTap,
    this.onAddDate,
    this.onSearch,
    this.onSettings,
    this.onCountdownTap,
  });

  final List<SpecialDateItem> specialDates;

  final ValueChanged<SpecialDateItem>? onDateTap;
  final VoidCallback? onAddDate;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onSettings;
  final ValueChanged<SpecialDateItem>? onCountdownTap;

  @override
  State<SpecialDatesHomeScreen> createState() =>
      _SpecialDatesHomeScreenState();
}

class _SpecialDatesHomeScreenState extends State<SpecialDatesHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // DATA
  // -------------------------------------------------------------------------

  List<SpecialDateItem> get _filteredDates {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.specialDates;
    }

    return widget.specialDates.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          _categoryLabel(item.category).toLowerCase().contains(query);
    }).toList();
  }

  SpecialDateItem? get _nextDate {
    final dates = widget.specialDates
        .where(
          (date) => date.status != SpecialDateStatus.past,
    )
        .toList();

    if (dates.isEmpty) return null;

    dates.sort(
          (a, b) => _daysUntilItem(a).compareTo(
        _daysUntilItem(b),
      ),
    );

    return dates.first;
  }

  List<SpecialDateItem> get _upcomingDates {
    final dates = _filteredDates
        .where(
          (item) => item.status != SpecialDateStatus.past,
    )
        .toList();

    dates.sort(
          (a, b) => _daysUntil(a.date).compareTo(_daysUntil(b.date)),
    );

    return dates;
  }

  List<SpecialDateItem> get _pastDates {
    final dates = _filteredDates
        .where(
          (item) => item.status == SpecialDateStatus.past,
    )
        .toList();

    dates.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return dates;
  }

  int _daysUntil(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    var target = DateTime(
      today.year,
      date.month,
      date.day,
    );

    if (target.isBefore(today)) {
      target = DateTime(
        today.year + 1,
        date.month,
        date.day,
      );
    }

    return target.difference(today).inDays;
  }

  bool _isYearlyDateInFuture(
      DateTime date,
      DateTime today,
      ) {
    if (!widget.specialDates.contains(date)) {
      // No-op. Actual yearly handling is based on item.repeatsYearly
      // in the card calculation below.
    }

    return false;
  }

  int _daysUntilItem(SpecialDateItem item) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    if (item.repeatsYearly) {
      var target = DateTime(
        today.year,
        item.date.month,
        item.date.day,
      );

      if (target.isBefore(today)) {
        target = DateTime(
          today.year + 1,
          item.date.month,
          item.date.day,
        );
      }

      return target.difference(today).inDays;
    }

    return item.date.difference(today).inDays;
  }

  // -------------------------------------------------------------------------
  // BUILD
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDates;
    final upcoming = filtered
        .where((item) => item.status != SpecialDateStatus.past)
        .toList();
    final past = filtered
        .where((item) => item.status == SpecialDateStatus.past)
        .toList();

    upcoming.sort(
          (a, b) => _daysUntilItem(a).compareTo(_daysUntilItem(b)),
    );

    past.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _SpecialDatesBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 145,
              ),
              children: [
                _buildTopBar(context),

                const SizedBox(height: 8),

                _buildHero(),

                const SizedBox(height: 18),

                _buildInsightStrip(),

                const SizedBox(height: 26),

                if (widget.specialDates.isNotEmpty)
                  _buildSearchBar(),

                if (_nextDate != null) ...[
                  const SizedBox(height: 22),
                  _buildNextDateSection(_nextDate!),
                ],

                if (upcoming.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  _buildSectionHeader(
                    title: 'UPCOMING',
                    subtitle: 'The moments waiting for you.',
                  ),
                  const SizedBox(height: 13),
                  ...upcoming.map(
                        (date) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _AnimatedEntry(
                        controller: _animationController,
                        child: _SpecialDateCard(
                          date: date,
                          onTap: () {
                            widget.onDateTap?.call(date);
                          },
                        ),
                      ),
                    ),
                  ),
                ],

                if (past.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  _buildSectionHeader(
                    title: 'PAST MOMENTS',
                    subtitle: 'Days worth remembering.',
                  ),
                  const SizedBox(height: 13),
                  ...past.map(
                        (date) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _AnimatedEntry(
                        controller: _animationController,
                        child: _PastDateCard(
                          date: date,
                          onTap: () {
                            widget.onDateTap?.call(date);
                          },
                        ),
                      ),
                    ),
                  ),
                ],

                if (filtered.isEmpty)
                  _buildEmptyState(),

                const SizedBox(height: 24),

                _buildClosingMessage(),
              ],
            ),
          ),

          if (widget.onAddDate != null)
            _buildBottomAction(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // TOP BAR
  // -------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPECIAL DATES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Our little milestones',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          _CircleButton(
            icon: _showSearch
                ? Icons.close_rounded
                : Icons.search_rounded,
            onTap: () {
              setState(() {
                _showSearch = !_showSearch;

                if (!_showSearch) {
                  _searchQuery = '';
                }
              });
            },
          ),

          const SizedBox(width: 8),

          _CircleButton(
            icon: Icons.settings_outlined,
            onTap: widget.onSettings,
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // HERO
  // -------------------------------------------------------------------------

  Widget _buildHero() {
    final next = _nextDate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 238,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF332526),
                        Color(0xFF624447),
                        Color(0xFF806165),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                right: -50,
                top: -55,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: 0.06,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: -40,
                bottom: -80,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8B4B8).withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 20,
                right: 22,
                child: Icon(
                  Icons.favorite_rounded,
                  size: 17,
                  color: const Color(0xFFF6D9DC).withValues(
                    alpha: 0.75,
                  ),
                ),
              ),

              Positioned(
                top: 20,
                left: 22,
                child: _HeroLabel(
                  icon: Icons.auto_awesome_rounded,
                  text: 'OUR SPECIAL MOMENTS',
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  62,
                  24,
                  22,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      next == null
                          ? 'A little place\nfor our milestones.'
                          : 'The days worth\ncounting down to.',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 29,
                        height: 1.08,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    if (next != null)
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  next.title.toUpperCase(),
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style:
                                  AppTextTheme.labelSmall
                                      .copyWith(
                                    fontSize: 9,
                                    fontWeight:
                                    FontWeight.w700,
                                    letterSpacing: 1.5,
                                    color: const Color(
                                      0xFFF4D8DB,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _formatDate(next.date),
                                  style:
                                  AppTextTheme.bodyMedium
                                      .copyWith(
                                    fontSize: 11,
                                    color: Colors.white
                                        .withValues(
                                      alpha: 0.72,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _HeroCountdown(
                            days: _daysUntilItem(next),
                            onTap: () {
                              widget.onCountdownTap
                                  ?.call(next);
                            },
                          ),
                        ],
                      )
                    else
                      Text(
                        'Save the days that mean something to both of you.',
                        style: AppTextTheme.bodyMedium
                            .copyWith(
                          fontSize: 11,
                          color: Colors.white.withValues(
                            alpha: 0.72,
                          ),
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

  // -------------------------------------------------------------------------
  // INSIGHT
  // -------------------------------------------------------------------------

  Widget _buildInsightStrip() {
    final total = widget.specialDates.length;

    final upcoming = widget.specialDates
        .where(
          (item) => item.status != SpecialDateStatus.past,
    )
        .length;

    final past = widget.specialDates
        .where(
          (item) => item.status == SpecialDateStatus.past,
    )
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.55,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            _InsightItem(
              icon: Icons.favorite_border_rounded,
              value: '$total',
              label: 'Moments',
            ),

            _InsightDivider(),

            _InsightItem(
              icon: Icons.event_rounded,
              value: '$upcoming',
              label: 'Upcoming',
            ),

            _InsightDivider(),

            _InsightItem(
              icon: Icons.auto_awesome_outlined,
              value: '$past',
              label: 'Remembered',
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SEARCH
  // -------------------------------------------------------------------------

  Widget _buildSearchBar() {
    if (!_showSearch) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),

              // Search icon
              const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.primary,
              ),

              const SizedBox(width: 11),

              // Text field
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });

                    widget.onSearch?.call(value);
                  },
                  cursorColor: AppColors.primary,
                  cursorWidth: 1.2,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12.5,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isCollapsed: true,
                    hintText:
                    'Search your special moments...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
              ),

              // Clear button
              if (_searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchQuery = '';
                    });

                    widget.onSearch?.call('');
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.only(
                      right: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EEEC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // NEXT DATE
  // -------------------------------------------------------------------------

  Widget _buildNextDateSection(
      SpecialDateItem date,
      ) {
    final days = _daysUntilItem(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: 'NEXT MILESTONE',
            subtitle: 'The one coming up first.',
          ),

          const SizedBox(height: 13),

          GestureDetector(
            onTap: () {
              widget.onDateTap?.call(date);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(
                    0xFFE8B4B8,
                  ).withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _categoryIcon(date.category),
                      color: AppColors.primary,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          date.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatDate(date.date),
                          style:
                          AppTextTheme.labelSmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      Text(
                        days == 0
                            ? 'TODAY'
                            : '$days',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: days == 0 ? 16 : 23,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      if (days != 0)
                        Text(
                          days == 1 ? 'DAY' : 'DAYS',
                          style:
                          AppTextTheme.labelSmall.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 5),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SECTION HEADER
  // -------------------------------------------------------------------------

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // EMPTY STATE
  // -------------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          24,
          30,
          24,
          28,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 30,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              _searchQuery.isEmpty
                  ? 'Nothing special yet.'
                  : 'No moments found.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              _searchQuery.isEmpty
                  ? 'Save the dates that deserve to be remembered. Your little milestones start here.'
                  : 'Try another search and see what memories you find.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            if (_searchQuery.isEmpty &&
                widget.onAddDate != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 46,
                child: FilledButton.icon(
                  onPressed: widget.onAddDate,
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 18,
                  ),
                  label: Text(
                    'Add our first date',
                    style:
                    AppTextTheme.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(23),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // CLOSING MESSAGE
  // -------------------------------------------------------------------------

  Widget _buildClosingMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        32,
        6,
        32,
        0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 17,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Some dates are worth more than a place on a calendar.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'They are little pieces of your story.',
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

  // -------------------------------------------------------------------------
  // BOTTOM CTA
  // -------------------------------------------------------------------------

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 14,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
            child: GestureDetector(
              onTap: widget.onAddDate,
              child: Container(
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
                    color: Colors.white.withValues(
                      alpha: 0.15,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.23,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 7),

                    // Add icon
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.14,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 23,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // Text
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add a special date',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            'Keep another little moment close',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            AppTextTheme.labelSmall.copyWith(
                              fontSize: 10,
                              color: Colors.white.withValues(
                                alpha: 0.72,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Arrow
                    Container(
                      width: 42,
                      height: 42,
                      margin: const EdgeInsets.only(
                        right: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.12,
                        ),
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
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------------------------

  String _formatDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _categoryLabel(
      SpecialDateCategory category,
      ) {
    switch (category) {
      case SpecialDateCategory.anniversary:
        return 'Anniversary';
      case SpecialDateCategory.birthday:
        return 'Birthday';
      case SpecialDateCategory.firstMeeting:
        return 'First Meeting';
      case SpecialDateCategory.firstDate:
        return 'First Date';
      case SpecialDateCategory.firstKiss:
        return 'First Kiss';
      case SpecialDateCategory.firstTrip:
        return 'First Trip';
      case SpecialDateCategory.customMoment:
        return 'Custom Moment';
    }
  }

  IconData _categoryIcon(
      SpecialDateCategory category,
      ) {
    switch (category) {
      case SpecialDateCategory.anniversary:
        return Icons.favorite_rounded;
      case SpecialDateCategory.birthday:
        return Icons.cake_outlined;
      case SpecialDateCategory.firstMeeting:
        return Icons.people_outline_rounded;
      case SpecialDateCategory.firstDate:
        return Icons.local_cafe_outlined;
      case SpecialDateCategory.firstKiss:
        return Icons.favorite_border_rounded;
      case SpecialDateCategory.firstTrip:
        return Icons.flight_takeoff_rounded;
      case SpecialDateCategory.customMoment:
        return Icons.auto_awesome_rounded;
    }
  }
}

/// ---------------------------------------------------------------------------
/// SPECIAL DATE CARD
/// ---------------------------------------------------------------------------

class _SpecialDateCard extends StatelessWidget {
  const _SpecialDateCard({
    required this.date,
    required this.onTap,
  });

  final SpecialDateItem date;
  final VoidCallback onTap;

  int _daysUntil() {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    if (date.repeatsYearly) {
      var target = DateTime(
        today.year,
        date.date.month,
        date.date.day,
      );

      if (target.isBefore(today)) {
        target = DateTime(
          today.year + 1,
          date.date.month,
          date.date.day,
        );
      }

      return target.difference(today).inDays;
    }

    return date.date
        .difference(today)
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysUntil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.78,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color:
                AppColors.outlineVariant.withValues(
                  alpha: 0.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                  Colors.black.withValues(alpha: 0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                _DateIcon(
                  category: date.category,
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              date.title,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              GoogleFonts.playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                AppColors.textPrimary,
                              ),
                            ),
                          ),

                          if (date.isPinned)
                            const Padding(
                              padding:
                              EdgeInsets.only(
                                left: 5,
                              ),
                              child: Icon(
                                Icons.push_pin_rounded,
                                size: 13,
                                color:
                                AppColors.primary,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _categoryLabel(
                          date.category,
                        ),
                        style:
                        AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 9,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        _formatDate(date.date),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        AppTextTheme.bodyMedium
                            .copyWith(
                          fontSize: 10,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      days == 0
                          ? 'TODAY'
                          : '$days',
                      style:
                      GoogleFonts.playfairDisplay(
                        fontSize:
                        days == 0 ? 13 : 20,
                        fontWeight:
                        FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    if (days != 0)
                      Text(
                        days == 1
                            ? 'DAY'
                            : 'DAYS',
                        style:
                        AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 7.5,
                          fontWeight:
                          FontWeight.w700,
                          letterSpacing: 1,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(
      SpecialDateCategory category,
      ) {
    switch (category) {
      case SpecialDateCategory.anniversary:
        return 'Anniversary';
      case SpecialDateCategory.birthday:
        return 'Birthday';
      case SpecialDateCategory.firstMeeting:
        return 'First Meeting';
      case SpecialDateCategory.firstDate:
        return 'First Date';
      case SpecialDateCategory.firstKiss:
        return 'First Kiss';
      case SpecialDateCategory.firstTrip:
        return 'First Trip';
      case SpecialDateCategory.customMoment:
        return 'Custom Moment';
    }
  }

  String _formatDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// ---------------------------------------------------------------------------
/// PAST DATE CARD
/// ---------------------------------------------------------------------------

class _PastDateCard extends StatelessWidget {
  const _PastDateCard({
    required this.date,
    required this.onTap,
  });

  final SpecialDateItem date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.58,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                AppColors.outlineVariant.withValues(
                  alpha: 0.42,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2ECEA),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _categoryIcon(date.category),
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        date.title,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(date.date),
                        style:
                        AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 9,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F1F0),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Remembered',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      color:
                      AppColors.textSecondary,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 9,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(
      SpecialDateCategory category,
      ) {
    switch (category) {
      case SpecialDateCategory.anniversary:
        return Icons.favorite_rounded;
      case SpecialDateCategory.birthday:
        return Icons.cake_outlined;
      case SpecialDateCategory.firstMeeting:
        return Icons.people_outline_rounded;
      case SpecialDateCategory.firstDate:
        return Icons.local_cafe_outlined;
      case SpecialDateCategory.firstKiss:
        return Icons.favorite_border_rounded;
      case SpecialDateCategory.firstTrip:
        return Icons.flight_takeoff_rounded;
      case SpecialDateCategory.customMoment:
        return Icons.auto_awesome_rounded;
    }
  }

  String _formatDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// ---------------------------------------------------------------------------
/// DATE ICON
/// ---------------------------------------------------------------------------

class _DateIcon extends StatelessWidget {
  const _DateIcon({
    required this.category,
  });

  final SpecialDateCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        color: Color(0xFFFCE4EC),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _icon,
        color: AppColors.primary,
        size: 22,
      ),
    );
  }

  IconData get _icon {
    switch (category) {
      case SpecialDateCategory.anniversary:
        return Icons.favorite_rounded;
      case SpecialDateCategory.birthday:
        return Icons.cake_outlined;
      case SpecialDateCategory.firstMeeting:
        return Icons.people_outline_rounded;
      case SpecialDateCategory.firstDate:
        return Icons.local_cafe_outlined;
      case SpecialDateCategory.firstKiss:
        return Icons.favorite_border_rounded;
      case SpecialDateCategory.firstTrip:
        return Icons.flight_takeoff_rounded;
      case SpecialDateCategory.customMoment:
        return Icons.auto_awesome_rounded;
    }
  }
}

/// ---------------------------------------------------------------------------
/// HERO HELPERS
/// ---------------------------------------------------------------------------

class _HeroLabel extends StatelessWidget {
  const _HeroLabel({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: const Color(0xFFF6D9DC),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 7.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white.withValues(
                alpha: 0.78,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCountdown extends StatelessWidget {
  const _HeroCountdown({
    required this.days,
    required this.onTap,
  });

  final int days;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.10,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.12,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              days == 0 ? 'TODAY' : '$days',
              style: GoogleFonts.playfairDisplay(
                fontSize: days == 0 ? 12 : 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (days != 0) ...[
              const SizedBox(width: 5),
              Text(
                days == 1 ? 'DAY' : 'DAYS',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: Colors.white.withValues(
                    alpha: 0.68,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 5),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 12,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// INSIGHTS
/// ---------------------------------------------------------------------------

class _InsightItem extends StatelessWidget {
  const _InsightItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.outlineVariant.withValues(
        alpha: 0.55,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SECTION ANIMATION
/// ---------------------------------------------------------------------------

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
  });

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// ---------------------------------------------------------------------------
/// BACKGROUND
/// ---------------------------------------------------------------------------

class _SpecialDatesBackground extends StatelessWidget {
  const _SpecialDatesBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 100,
            right: -90,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            top: 420,
            left: -110,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CIRCLE BUTTON
/// ---------------------------------------------------------------------------

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.72,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color:
              AppColors.outlineVariant.withValues(
                alpha: 0.45,
              ),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}