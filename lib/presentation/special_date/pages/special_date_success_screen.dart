import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateSuccessScreen extends StatefulWidget {
  const SpecialDateSuccessScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.repeatsYearly,
    required this.reminderDays,
    required this.note,
    this.onCountdown,
    this.onDone,
    this.onBack,
  });

  final SpecialDateCategory category;
  final String title;
  final String description;
  final DateTime date;
  final bool repeatsYearly;
  final int reminderDays;
  final String note;

  final VoidCallback? onCountdown;
  final VoidCallback? onDone;
  final VoidCallback? onBack;

  @override
  State<SpecialDateSuccessScreen> createState() =>
      _SpecialDateSuccessScreenState();
}

class _SpecialDateSuccessScreenState
    extends State<SpecialDateSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _heartController;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // CATEGORY INFO
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
  // DATE
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

  String get _shortDate {
    return '${widget.date.day} '
        '${_monthName(widget.date.month).substring(0, 3)}';
  }

  String get _reminderText {
    switch (widget.reminderDays) {
      case 1:
        return '1 day before';

      case 3:
        return '3 days before';

      case 7:
        return '1 week before';

      case 14:
        return '2 weeks before';

      case 30:
        return '1 month before';

      default:
        return '${widget.reminderDays} days before';
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
            child: _SuccessBackground(),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 150,
              ),
              child: Column(
                children: [
                  _buildTopBar(context),
                  _buildSuccessHero(),
                  _buildDateCard(),
                  _buildReminderCard(),
                  _buildPrivateMessage(),
                ],
              ),
            ),
          ),

          _buildBottomActions(),
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
                icon: Icons.close_rounded,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
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
                    'Saved with love',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.55),
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUCCESS HERO
  // ---------------------------------------------------------------------------

  Widget _buildSuccessHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        20,
      ),
      child: AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          final value = Curves.easeOutBack.transform(
            _entryController.value,
          );

          return Opacity(
            opacity: _entryController.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(
                0,
                20 * (1 - value),
              ),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            // Heart artwork
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                final scale =
                    1 + (_heartController.value * 0.045);

                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 142,
                    height: 142,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC)
                          .withValues(alpha: 0.72),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.90),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary
                              .withValues(alpha: 0.12),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 43,
                          color: AppColors.primary,
                        ),
                        Positioned(
                          bottom: 26,
                          child: Container(
                            width: 34,
                            height: 17,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.date.day}',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 9,
                    child: Text(
                      _categoryInfo.emoji,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 27),

            Text(
              'IT\'S YOURS NOW',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.3,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              'A little moment,\nkept forever.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                height: 1.10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Your special date has been saved to your '
                  'little collection of moments.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE CARD
  // ---------------------------------------------------------------------------

  Widget _buildDateCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 67,
              height: 67,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    _monthName(widget.date.month)
                        .substring(0, 3)
                        .toUpperCase(),
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${widget.date.day}',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    _categoryInfo.label.toUpperCase(),
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title.trim().isEmpty
                        ? 'A beautiful moment'
                        : widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 19,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formattedDate,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
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
  // REMINDER CARD
  // ---------------------------------------------------------------------------

  Widget _buildReminderCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F1F0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'REMINDER SET',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _reminderText,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.repeatsYearly
                        ? 'You\'ll remember it every year.'
                        : 'Your reminder is ready.',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.check_circle_rounded,
              size: 20,
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
        30,
        34,
        30,
        10,
      ),
      child: Column(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 19,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'JUST BETWEEN US.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'A little date for two people, '
                'and nobody else.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Saved safely in your Special Dates.',
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
  // BOTTOM ACTIONS
  // ---------------------------------------------------------------------------

  Widget _buildBottomActions() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            GestureDetector(
              onTap: widget.onCountdown,
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
                        Icons.hourglass_bottom_rounded,
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
                            'See the countdown',
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
                            'See how long until your moment',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.labelSmall.copyWith(
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

            const SizedBox(height: 8),

            GestureDetector(
              onTap: widget.onDone,
              child: Container(
                height: 36,
                alignment: Alignment.center,
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
          ],
        ),
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
        color: Colors.white.withValues(alpha: 0.82),
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
// BACKGROUND
// =============================================================================

class _SuccessBackground extends StatelessWidget {
  const _SuccessBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -110,
            right: -90,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.72),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 330,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            right: -90,
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