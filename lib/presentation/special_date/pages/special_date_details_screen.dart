import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateDetailsScreen extends StatefulWidget {
  const SpecialDateDetailsScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.repeatsYearly,
    this.initialReminderDays = 7,
    this.initialNote = '',
    this.onBack,
    this.onContinue,
  });

  final SpecialDateCategory category;
  final String title;
  final String description;
  final DateTime date;
  final bool repeatsYearly;

  final int initialReminderDays;
  final String initialNote;

  final VoidCallback? onBack;

  final void Function(
      int reminderDays,
      String note,
      )? onContinue;

  @override
  State<SpecialDateDetailsScreen> createState() =>
      _SpecialDateDetailsScreenState();
}

class _SpecialDateDetailsScreenState
    extends State<SpecialDateDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TextEditingController _noteController;

  late int _reminderDays;
  late bool _notificationsEnabled;

  final List<int> _reminderOptions = const [
    1,
    3,
    7,
    14,
    30,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _noteController = TextEditingController(
      text: widget.initialNote,
    );

    _reminderDays = widget.initialReminderDays;
    _notificationsEnabled = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // CATEGORY INFO
  // ===========================================================================

  _CategoryInfo get _categoryInfo {
    switch (widget.category) {
      case SpecialDateCategory.anniversary:
        return const _CategoryInfo(
          emoji: '❤️',
          icon: Icons.favorite_rounded,
          label: 'ANNIVERSARY',
        );

      case SpecialDateCategory.birthday:
        return const _CategoryInfo(
          emoji: '🎂',
          icon: Icons.cake_outlined,
          label: 'BIRTHDAY',
        );

      case SpecialDateCategory.firstMeeting:
        return const _CategoryInfo(
          emoji: '✨',
          icon: Icons.people_outline_rounded,
          label: 'FIRST MEETING',
        );

      case SpecialDateCategory.firstDate:
        return const _CategoryInfo(
          emoji: '💕',
          icon: Icons.favorite_border_rounded,
          label: 'FIRST DATE',
        );

      case SpecialDateCategory.firstKiss:
        return const _CategoryInfo(
          emoji: '💋',
          icon: Icons.face_retouching_natural_outlined,
          label: 'FIRST KISS',
        );

      case SpecialDateCategory.firstTrip:
        return const _CategoryInfo(
          emoji: '✈️',
          icon: Icons.flight_takeoff_rounded,
          label: 'FIRST TRIP',
        );

      case SpecialDateCategory.customMoment:
        return const _CategoryInfo(
          emoji: '🌷',
          icon: Icons.auto_awesome_rounded,
          label: 'CUSTOM MOMENT',
        );
    }
  }

  // ===========================================================================
  // DATE FORMATTING
  // ===========================================================================

  String get _formattedDate {
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

    return '${widget.date.day} '
        '${months[widget.date.month - 1]} '
        '${widget.date.year}';
  }

  String get _reminderLabel {
    switch (_reminderDays) {
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
        return '$_reminderDays days before';
    }
  }

  // ===========================================================================
  // CONTINUE
  // ===========================================================================

  void _continue() {
    widget.onContinue?.call(
      _reminderDays,
      _noteController.text.trim(),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final info = _categoryInfo;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _DetailsBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 130,
              ),
              children: [
                _buildTopBar(),

                const SizedBox(height: 12),

                _buildProgress(),

                const SizedBox(height: 27),

                _buildIntro(info),

                const SizedBox(height: 25),

                _buildDateSummary(),

                const SizedBox(height: 26),

                _buildReminderSection(),

                const SizedBox(height: 26),

                _buildNoteSection(),

                const SizedBox(height: 25),

                _buildPrivacyCard(),
              ],
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar() {
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
            onTap: widget.onBack ?? () => context.pop(),
          ),

          const SizedBox(width: 13),

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
                  'Create a special date',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius:
              BorderRadius.circular(999),
            ),
            child: Text(
              '4 OF 5',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PROGRESS
  // ===========================================================================

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: List.generate(
          5,
              (index) {
            final active = index <= 3;

            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(
                  right: index == 4 ? 0 : 5,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary
                      : AppColors.outlineVariant
                      .withValues(alpha: 0.55),
                  borderRadius:
                  BorderRadius.circular(99),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntro(_CategoryInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius:
              BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  info.emoji,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  info.label,
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),

          Text(
            'Make it a little\nmore personal.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 31,
              height: 1.06,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Add a reminder and a private note. '
                'These little details make the day feel like yours.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DATE SUMMARY
  // ===========================================================================

  Widget _buildDateSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.84,
          ),
          borderRadius:
          BorderRadius.circular(21),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.025,
              ),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
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
                    widget.title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _formattedDate,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(
                        widget.repeatsYearly
                            ? Icons.replay_rounded
                            : Icons.event_outlined,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.repeatsYearly
                            ? 'Every year'
                            : 'One time',
                        style: AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 9,
                          color: AppColors.primary,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // REMINDER
  // ===========================================================================

  Widget _buildReminderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            title: 'A LITTLE REMINDER',
            subtitle:
            'We’ll make sure you never forget.',
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.84,
              ),
              borderRadius:
              BorderRadius.circular(21),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.55),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration:
                      const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
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
                            'Remind us',
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _notificationsEnabled
                                ? 'You’ll get a little reminder before the day.'
                                : 'Reminders are turned off.',
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: AppTextTheme.labelSmall
                                .copyWith(
                              fontSize: 9.5,
                              height: 1.4,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _notificationsEnabled =
                          !_notificationsEnabled;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        width: 48,
                        height: 28,
                        padding:
                        const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: _notificationsEnabled
                              ? AppColors.primary
                              : const Color(0xFFD9D2CF),
                          borderRadius:
                          BorderRadius.circular(999),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(
                            milliseconds: 180,
                          ),
                          alignment:
                          _notificationsEnabled
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration:
                            const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_notificationsEnabled) ...[
                  const SizedBox(height: 18),

                  Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Text(
                      'REMIND ME',
                      style: AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection:
                      Axis.horizontal,
                      physics:
                      const BouncingScrollPhysics(),
                      itemCount:
                      _reminderOptions.length,
                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(width: 7),
                      itemBuilder:
                          (context, index) {
                        final days =
                        _reminderOptions[index];

                        final selected =
                            days == _reminderDays;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _reminderDays = days;
                            });
                          },
                          child: AnimatedContainer(
                            duration:
                            const Duration(
                              milliseconds: 180,
                            ),
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 13,
                              vertical: 9,
                            ),
                            decoration:
                            BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : const Color(
                                0xFFF7F1F0,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                999,
                              ),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors
                                    .outlineVariant
                                    .withValues(
                                  alpha: 0.50,
                                ),
                              ),
                            ),
                            child: Text(
                              _reminderText(days),
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : AppColors
                                    .textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
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

  String _reminderText(int days) {
    switch (days) {
      case 1:
        return '1 day';
      case 3:
        return '3 days';
      case 7:
        return '1 week';
      case 14:
        return '2 weeks';
      case 30:
        return '1 month';
      default:
        return '$days days';
    }
  }

  // ===========================================================================
  // NOTE
  // ===========================================================================

  Widget _buildNoteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            title: 'ONE LAST LITTLE THING',
            subtitle:
            'Optional — leave a note for your future selves.',
          ),

          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.82,
              ),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.55),
              ),
            ),
            child: TextField(
              controller: _noteController,
              minLines: 4,
              maxLines: 6,
              textCapitalization:
              TextCapitalization.sentences,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                'Maybe write what you hope you’ll remember…',
                hintStyle:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  height: 1.5,
                  color: AppColors.textDisabled,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(
                    left: 14,
                    right: 4,
                    top: 15,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    widthFactor: 1,
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: 19,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.fromLTRB(
                  8,
                  15,
                  14,
                  15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacyCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F1EF),
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 16,
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
                    'Just between us.',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Your notes and reminders stay private '
                        'to your little world in SIMI.',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9.5,
                      height: 1.45,
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

  // ===========================================================================
  // BOTTOM CTA
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
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
            child: GestureDetector(
              onTap: _continue,
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
                  borderRadius:
                  BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withValues(alpha: 0.23),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.07),
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
                            .withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
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
                            'Continue to review',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'One last look before we save it',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            AppTextTheme.labelSmall
                                .copyWith(
                              fontSize: 10,
                              color: Colors.white
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
                      const EdgeInsets.only(
                        right: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(
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
}

// =============================================================================
// SECTION LABEL
// =============================================================================

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
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.7,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CATEGORY INFO
// =============================================================================

class _CategoryInfo {
  const _CategoryInfo({
    required this.emoji,
    required this.icon,
    required this.label,
  });

  final String emoji;
  final IconData icon;
  final String label;
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.80,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
        ),
        child: Icon(
          icon,
          size: 19,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _DetailsBackground extends StatelessWidget {
  const _DetailsBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 55,
            right: -85,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 38,
                sigmaY: 38,
              ),
              child: Container(
                width: 215,
                height: 215,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E3E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 420,
            left: -110,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 42,
                sigmaY: 42,
              ),
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0xFFECE9F1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            right: -75,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 36,
                sigmaY: 36,
              ),
              child: Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E5E8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}