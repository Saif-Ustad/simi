import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateDetailScreen extends StatefulWidget {
  const SpecialDateDetailScreen({
    super.key,
    required this.specialDate,
    this.onBack,
    this.onEdit,
    this.onDelete,
    this.onCountdown,
    this.onViewMemories,
    this.onAddMemory,
    this.onReminderChanged,
  });

  final SpecialDateItem specialDate;

  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCountdown;
  final VoidCallback? onViewMemories;
  final VoidCallback? onAddMemory;
  final ValueChanged<bool>? onReminderChanged;

  @override
  State<SpecialDateDetailScreen> createState() =>
      _SpecialDateDetailScreenState();
}

class _SpecialDateDetailScreenState
    extends State<SpecialDateDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _reminderEnabled;

  @override
  void initState() {
    super.initState();

    _reminderEnabled = true;

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

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  SpecialDateItem get date => widget.specialDate;

  int get _daysUntil {
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

    return date.date.difference(today).inDays;
  }

  bool get _isToday => _daysUntil == 0;

  bool get _isPast =>
      !date.repeatsYearly &&
          date.date.isBefore(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          );

  String get _categoryName {
    switch (date.category) {
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

  IconData get _categoryIcon {
    switch (date.category) {
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
            child: _DetailBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 140,
              ),
              children: [
                _buildTopBar(context),

                const SizedBox(height: 8),

                _buildHero(),

                const SizedBox(height: 22),

                _buildDateIdentity(),

                const SizedBox(height: 22),

                _buildCountdownCard(),

                const SizedBox(height: 28),

                _buildStorySection(),

                const SizedBox(height: 26),

                _buildDetailsSection(),

                const SizedBox(height: 26),

                _buildReminderSection(),

                const SizedBox(height: 28),

                _buildMemoriesSection(),

                const SizedBox(height: 30),

                _buildClosingMessage(),
              ],
            ),
          ),

          _buildBottomBar(),
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
        20,
        8,
        20,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: widget.onBack ??
                    () {
                  Navigator.of(context).maybePop();
                },
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
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
                  'A moment worth\nkeeping',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: () => _showOptions(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HERO
  // ---------------------------------------------------------------------------

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SizedBox(
        height: 310,
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
                        Color(0xFF5C4144),
                        Color(0xFF806165),
                      ],
                    ),
                  ),
                ),
              ),

              // Decorative glow.
              Positioned(
                right: -55,
                top: -65,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: 0.055,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: -70,
                bottom: -80,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.09),
                  ),
                ),
              ),

              // Small floating hearts.
              Positioned(
                right: 30,
                top: 26,
                child: Icon(
                  Icons.favorite_rounded,
                  size: 15,
                  color: const Color(0xFFF6D9DC)
                      .withValues(alpha: 0.7),
                ),
              ),

              Positioned(
                right: 63,
                top: 54,
                child: Icon(
                  Icons.favorite_rounded,
                  size: 8,
                  color: Colors.white.withValues(
                    alpha: 0.28,
                  ),
                ),
              ),

              // Top label.
              Positioned(
                top: 20,
                left: 20,
                child: _HeroLabel(
                  icon: _categoryIcon,
                  text: _categoryName.toUpperCase(),
                ),
              ),

              // Main content.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  70,
                  24,
                  22,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    Center(
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.11,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        child: Icon(
                          _categoryIcon,
                          size: 28,
                          color: const Color(
                            0xFFF7DDE0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: Text(
                        date.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 29,
                          height: 1.08,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Center(
                      child: Text(
                        _formatDate(date.date),
                        style:
                        AppTextTheme.bodyMedium.copyWith(
                          fontSize: 11,
                          color: Colors.white.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Center(
                      child: _StatusPill(
                        isToday: _isToday,
                        isPast: _isPast,
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

  // ---------------------------------------------------------------------------
  // IDENTITY
  // ---------------------------------------------------------------------------

  Widget _buildDateIdentity() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: _IdentityCard(
              icon: _categoryIcon,
              label: 'CATEGORY',
              value: _categoryName,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _IdentityCard(
              icon: date.repeatsYearly
                  ? Icons.repeat_rounded
                  : Icons.event_outlined,
              label: 'REPEATS',
              value: date.repeatsYearly
                  ? 'Every year'
                  : 'Once',
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _IdentityCard(
              icon: Icons.notifications_none_rounded,
              label: 'REMINDER',
              value: '${date.reminderDays} days',
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COUNTDOWN
  // ---------------------------------------------------------------------------

  Widget _buildCountdownCard() {
    final days = _daysUntil;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: GestureDetector(
        onTap: widget.onCountdown,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            18,
            18,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE4EC),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFFE8B4B8)
                  .withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_bottom_rounded,
                  size: 21,
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
                      _isToday
                          ? 'IT\'S TODAY ❤️'
                          : _isPast
                          ? 'A MOMENT WE REMEMBER'
                          : 'COUNTING DOWN',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _isToday
                          ? 'Today is the day.'
                          : _isPast
                          ? 'This one already became a memory.'
                          : 'Until ${date.title}.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      AppTextTheme.bodyMedium.copyWith(
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
                    _isPast
                        ? '♥'
                        : days == 0
                        ? 'TODAY'
                        : '$days',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: days == 0 || _isPast
                          ? 14
                          : 27,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  if (!_isPast && days != 0)
                    Text(
                      days == 1 ? 'DAY' : 'DAYS',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 7),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STORY
  // ---------------------------------------------------------------------------

  Widget _buildStorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            title: 'THE STORY',
            subtitle: 'Why this day matters to you.',
          ),

          const SizedBox(height: 13),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              18,
              20,
              18,
              20,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.78,
              ),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color:
                AppColors.outlineVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.format_quote_rounded,
                        size: 17,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      'A little piece of us',
                      style:
                      GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  date.description.trim().isEmpty
                      ? 'No story has been added for this moment yet. Sometimes the date itself says enough.'
                      : date.description,
                  style:
                  AppTextTheme.bodyMedium.copyWith(
                    fontSize: 13,
                    height: 1.65,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DETAILS
  // ---------------------------------------------------------------------------

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            title: 'DETAILS',
            subtitle: 'Everything around this little moment.',
          ),

          const SizedBox(height: 13),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.76,
              ),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color:
                AppColors.outlineVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: _formatDate(date.date),
                ),

                _DetailDivider(),

                _DetailRow(
                  icon: date.repeatsYearly
                      ? Icons.repeat_rounded
                      : Icons.event_outlined,
                  label: 'Frequency',
                  value: date.repeatsYearly
                      ? 'Repeats every year'
                      : 'One-time date',
                ),

                _DetailDivider(),

                _DetailRow(
                  icon: Icons.notifications_none_rounded,
                  label: 'Reminder',
                  value:
                  '${date.reminderDays} days before',
                ),

                _DetailDivider(),

                _DetailRow(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Category',
                  value: _categoryName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REMINDER
  // ---------------------------------------------------------------------------

  Widget _buildReminderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          17,
          15,
          14,
          15,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.76,
          ),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color:
            AppColors.outlineVariant.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
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
                    'Remind us about this',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'We\'ll gently remind you ${date.reminderDays} days before.',
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Switch.adaptive(
              value: _reminderEnabled,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                });

                widget.onReminderChanged
                    ?.call(value);
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MEMORIES
  // ---------------------------------------------------------------------------

  Widget _buildMemoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _SectionLabel(
                  title: 'MEMORIES',
                  subtitle:
                  'Moments connected to this date.',
                ),
              ),
              if (widget.onViewMemories != null)
                GestureDetector(
                  onTap: widget.onViewMemories,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all',
                        style:
                        AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 9,
                          fontWeight:
                          FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 13),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              20,
              23,
              20,
              22,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F0EE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                AppColors.outlineVariant.withValues(
                  alpha: 0.42,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    size: 23,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Keep the memories close',
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Connect photos and memories to this special date so your story stays together.',
                  textAlign: TextAlign.center,
                  style:
                  AppTextTheme.bodyMedium.copyWith(
                    fontSize: 10.5,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                if (widget.onAddMemory != null) ...[
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: widget.onAddMemory,
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 17,
                      ),
                      label: Text(
                        'Add a memory',
                        style:
                        AppTextTheme.labelLarge
                            .copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                      style:
                      OutlinedButton.styleFrom(
                        foregroundColor:
                        AppColors.primary,
                        side: BorderSide(
                          color:
                          AppColors.primary
                              .withValues(
                            alpha: 0.35,
                          ),
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CLOSING
  // ---------------------------------------------------------------------------

  Widget _buildClosingMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 16,
            color: AppColors.primary,
          ),

          const SizedBox(height: 9),

          Text(
            'Some dates become memories.\nSome memories become your story.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              height: 1.35,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Just between us.',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM BAR
  // ---------------------------------------------------------------------------

  Widget _buildBottomBar() {
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
            child: Row(
              children: [
                if (widget.onEdit != null)
                  GestureDetector(
                    onTap: widget.onEdit!,
                    child: Container(
                      width: 58,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.outlineVariant
                              .withValues(alpha: 0.55),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.07,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.edit_outlined,
                          size: 19,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                if (widget.onEdit != null &&
                    widget.onCountdown != null)
                  const SizedBox(width: 9),

                if (widget.onCountdown != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onCountdown!,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF765457),
                              Color(0xFF966E72),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: 0.22,
                              ),
                              blurRadius: 18,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isToday
                                  ? Icons.favorite_rounded
                                  : Icons.hourglass_bottom_rounded,
                              size: 18,
                              color: Colors.white,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              _isToday
                                  ? 'Today is the day'
                                  : 'Open countdown',
                              style:
                              AppTextTheme.labelLarge.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 7),

                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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
  // OPTIONS
  // ---------------------------------------------------------------------------

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),

              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _categoryIcon,
                      color: AppColors.primary,
                      size: 21,
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
                            fontSize: 19,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Special date',
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
                ],
              ),

              const SizedBox(height: 20),

              if (widget.onEdit != null)
                _SheetAction(
                  icon: Icons.edit_outlined,
                  title: 'Edit this date',
                  subtitle:
                  'Change the details or reminder.',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onEdit?.call();
                  },
                ),

              if (widget.onCountdown != null)
                _SheetAction(
                  icon:
                  Icons.hourglass_bottom_rounded,
                  title: 'Open countdown',
                  subtitle:
                  'See the days until this moment.',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onCountdown?.call();
                  },
                ),

              if (widget.onViewMemories != null)
                _SheetAction(
                  icon:
                  Icons.photo_library_outlined,
                  title: 'View memories',
                  subtitle:
                  'See memories connected to this date.',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onViewMemories?.call();
                  },
                ),

              const SizedBox(height: 6),

              if (widget.onDelete != null)
                _SheetAction(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete special date',
                  subtitle:
                  'Remove this moment from your story.',
                  destructive: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDelete(context);
                  },
                ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Forget this date?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This special date will be removed from your shared timeline. This cannot be undone.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          actionsPadding:
          const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Keep it',
                style:
                AppTextTheme.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(22),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

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

/// =============================================================================
/// BACKGROUND
/// =============================================================================

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 120,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            top: 530,
            left: -120,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.025),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =============================================================================
/// HERO LABEL
/// =============================================================================

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
              letterSpacing: 1.15,
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

/// =============================================================================
/// STATUS PILL
/// =============================================================================

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.isToday,
    required this.isPast,
  });

  final bool isToday;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final String label;
    final IconData icon;

    if (isToday) {
      label = 'TODAY ❤️';
      icon = Icons.favorite_rounded;
    } else if (isPast) {
      label = 'A MEMORY';
      icon = Icons.auto_awesome_rounded;
    } else {
      label = 'COUNTING DOWN';
      icon = Icons.hourglass_bottom_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.13,
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
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 7.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
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

/// =============================================================================
/// IDENTITY CARD
/// =============================================================================

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        12,
        10,
        11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.72,
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color:
          AppColors.outlineVariant.withValues(
            alpha: 0.48,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),

          const SizedBox(height: 8),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.textDisabled,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// =============================================================================
/// SECTION LABEL
/// =============================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

/// =============================================================================
/// DETAIL ROW
/// =============================================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              label,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
              AppTextTheme.labelLarge.copyWith(
                fontSize: 10,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 61,
      endIndent: 16,
      color: AppColors.outlineVariant.withValues(
        alpha: 0.42,
      ),
    );
  }
}

/// =============================================================================
/// CIRCLE BUTTON
/// =============================================================================

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
              alpha: 0.74,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color:
              AppColors.outlineVariant.withValues(
                alpha: 0.48,
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

/// =============================================================================
/// SHEET HANDLE
/// =============================================================================

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.outlineVariant,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

/// =============================================================================
/// SHEET ACTION
/// =============================================================================

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final iconColor = destructive
        ? const Color(0xFFB05C64)
        : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: destructive
                      ? const Color(0xFFFBEDEF)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                      AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: destructive
                            ? const Color(
                          0xFFB05C64,
                        )
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}