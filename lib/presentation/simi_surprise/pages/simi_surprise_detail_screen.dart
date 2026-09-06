import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'simi_surprises_home_screen.dart';

class SimiSurpriseDetailScreen extends StatefulWidget {
  const SimiSurpriseDetailScreen({
    super.key,
    required this.surprise,
    this.onBack,
    this.onOpenOriginal,
    this.onFavorite,
    this.onDismiss,
    this.onMore,
  });

  final SimiSurpriseItem surprise;

  final VoidCallback? onBack;
  final VoidCallback? onOpenOriginal;
  final VoidCallback? onFavorite;
  final VoidCallback? onDismiss;
  final VoidCallback? onMore;

  @override
  State<SimiSurpriseDetailScreen> createState() =>
      _SimiSurpriseDetailScreenState();
}

class _SimiSurpriseDetailScreenState
    extends State<SimiSurpriseDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _SurpriseDetailInfo get _info {
    return _SurpriseDetailInfo.fromType(
      widget.surprise.type,
    );
  }

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
                bottom: 135,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildWhySimiNoticed(),
                _buildMainStory(),
                _buildDetails(),
                _buildReflection(),
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

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        16,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: widget.onBack ??
                    () => Navigator.maybePop(context),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'SIMI SURPRISES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2.1,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'A little thing for you.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          _CircleButton(
            icon: _isFavorite
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            iconColor: _isFavorite
                ? AppColors.primary
                : AppColors.textPrimary,
            onTap: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });

              widget.onFavorite?.call();
            },
          ),

          const SizedBox(width: 8),

          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: () => _showOptions(context),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            26,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF292223),
                Color(0xFF443234),
                Color(0xFF5D4145),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.12,
                ),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -45,
                top: -55,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                left: -50,
                bottom: -80,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: 0.025),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: _info.background
                              .withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white
                                .withValues(alpha: 0.12),
                          ),
                        ),
                        child: Icon(
                          _info.icon,
                          size: 20,
                          color: const Color(0xFFF6D9DC),
                        ),
                      ),

                      const SizedBox(width: 11),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              _info.label,
                              style: AppTextTheme.labelSmall
                                  .copyWith(
                                fontSize: 8.5,
                                letterSpacing: 1.7,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                                    .withValues(alpha: 0.60),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.surprise.timeLabel,
                              style: AppTextTheme.labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors.white
                                    .withValues(alpha: 0.42),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Text(
                    widget.surprise.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      height: 1.10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    widget.surprise.message,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontSize: 13,
                      height: 1.55,
                      color: Colors.white
                          .withValues(alpha: 0.70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // WHY SIMI NOTICED
  // ===========================================================================

  Widget _buildWhySimiNoticed() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.12,
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.55),
            ),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
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
                      'WHY SIMI NOTICED',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8.5,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _info.reason,
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontSize: 11.5,
                        height: 1.5,
                        color: AppColors.textPrimary,
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
  // MAIN STORY
  // ===========================================================================

  Widget _buildMainStory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.22,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _SectionLabel(
              label: _info.sectionTitle,
            ),

            const SizedBox(height: 11),

            _StoryCard(
              type: widget.surprise.type,
              icon: _info.icon,
              accent: _info.foreground,
              title: _info.storyTitle,
              message: _info.storyMessage,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DETAILS
  // ===========================================================================

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.32,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'A LITTLE MORE',
            ),

            const SizedBox(height: 11),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.80),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.50),
                ),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: _info.icon,
                    label: 'From',
                    value: _info.sourceName,
                  ),
                  const _DetailDivider(),
                  _DetailRow(
                    icon: Icons.schedule_rounded,
                    label: 'When',
                    value: widget.surprise.timeLabel,
                  ),
                  const _DetailDivider(),
                  _DetailRow(
                    icon: Icons.auto_awesome_outlined,
                    label: 'Why',
                    value: _info.shortReason,
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
  // REFLECTION
  // ===========================================================================

  Widget _buildReflection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.42,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            21,
            20,
            21,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF4ECEB),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.format_quote_rounded,
                size: 22,
                color: AppColors.primary,
              ),

              const SizedBox(height: 7),

              Text(
                _info.reflection,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                'SIMI',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDisabled,
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
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(29),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.55),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 7),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });

                      widget.onFavorite?.call();
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 21,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onOpenOriginal,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            _info.actionTitle,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            AppTextTheme.labelLarge.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _info.actionSubtitle,
                            maxLines: 1,
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
                  ),

                  GestureDetector(
                    onTap: widget.onOpenOriginal,
                    child: Container(
                      width: 42,
                      height: 42,
                      margin:
                      const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // OPTIONS
  // ===========================================================================

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
            18,
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
                      _info.icon,
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
                          'This little thing',
                          style:
                          GoogleFonts.playfairDisplay(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color:
                            AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'What would you like to do?',
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

              _SheetAction(
                icon: _isFavorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                title: _isFavorite
                    ? 'Remove from favorites'
                    : 'Keep this close',
                subtitle:
                'Save this surprise for later.',
                onTap: () {
                  Navigator.pop(sheetContext);

                  setState(() {
                    _isFavorite = !_isFavorite;
                  });

                  widget.onFavorite?.call();
                },
              ),

              const SizedBox(height: 9),

              _SheetAction(
                icon: Icons.open_in_new_rounded,
                title: _info.actionTitle,
                subtitle: _info.actionSubtitle,
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onOpenOriginal?.call();
                },
              ),

              const SizedBox(height: 9),

              _SheetAction(
                icon: Icons.visibility_off_outlined,
                title: 'Not for now',
                subtitle:
                'Hide this surprise from your feed.',
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onDismiss?.call();
                },
              ),

              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// DETAIL INFO
// =============================================================================

class _SurpriseDetailInfo {
  const _SurpriseDetailInfo({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.reason,
    required this.shortReason,
    required this.sectionTitle,
    required this.storyTitle,
    required this.storyMessage,
    required this.reflection,
    required this.sourceName,
    required this.actionTitle,
    required this.actionSubtitle,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  final String reason;
  final String shortReason;
  final String sectionTitle;
  final String storyTitle;
  final String storyMessage;
  final String reflection;
  final String sourceName;
  final String actionTitle;
  final String actionSubtitle;

  static _SurpriseDetailInfo fromType(
      SimiSurpriseType type,
      ) {
    switch (type) {
      case SimiSurpriseType.memory:
        return const _SurpriseDetailInfo(
          label: 'MEMORY MOMENT',
          icon: Icons.photo_camera_outlined,
          background: Color(0xFFFCE4EC),
          foreground: AppColors.primary,
          reason:
          'SIMI found a memory whose date matches today. '
              'Some days deserve to come back around.',
          shortReason: 'The date matched today.',
          sectionTitle: 'THE MOMENT',
          storyTitle: 'One year ago today',
          storyMessage:
          'You were in Goa together and saved 6 '
              'little memories from that day.',
          reflection:
          'Some memories never really become old.',
          sourceName: 'Memories',
          actionTitle: 'Relive this memory',
          actionSubtitle:
          'Go back to the moment.',
        );

      case SimiSurpriseType.chat:
        return const _SurpriseDetailInfo(
          label: 'A LITTLE COINCIDENCE',
          icon: Icons.chat_bubble_outline_rounded,
          background: Color(0xFFE8E7F3),
          foreground: AppColors.secondary,
          reason:
          'SIMI noticed a topic appearing repeatedly '
              'in your conversations.',
          shortReason:
          'A topic appeared repeatedly.',
          sectionTitle: 'THE LITTLE COINCIDENCE',
          storyTitle: 'Someone really wants Japan',
          storyMessage:
          'You mentioned Japan 4 times this month. '
              'Maybe this conversation is trying to tell '
              'you something.',
          reflection:
          'Sometimes the things we keep talking about '
              'are the things we secretly want.',
          sourceName: 'Love Chat',
          actionTitle: 'See your conversations',
          actionSubtitle:
          'Continue where you left off.',
        );

      case SimiSurpriseType.period:
        return const _SurpriseDetailInfo(
          label: 'YOUR RHYTHM',
          icon: Icons.calendar_month_outlined,
          background: Color(0xFFFCE4EC),
          foreground: AppColors.primary,
          reason:
          'SIMI noticed your cycle is approaching '
              'another expected phase.',
          shortReason:
          'Your cycle is approaching.',
          sectionTitle: 'YOUR RHYTHM',
          storyTitle: 'It may be getting close',
          storyMessage:
          'Your next period may be approaching in '
              'about 4 days.',
          reflection:
          'A little reminder to take care of yourself.',
          sourceName: 'Period',
          actionTitle: 'See your period',
          actionSubtitle:
          'Open your cycle overview.',
        );

      case SimiSurpriseType.specialDate:
        return const _SurpriseDetailInfo(
          label: 'SPECIAL DATE',
          icon: Icons.event_outlined,
          background: Color(0xFFF7E7E4),
          foreground: Color(0xFF9A6A63),
          reason:
          'SIMI noticed that one of your special '
              'dates is getting close.',
          shortReason:
          'A special date is approaching.',
          sectionTitle: 'YOUR LITTLE DATE',
          storyTitle: 'It deserves a little attention',
          storyMessage:
          'Your first date is only 8 days away. '
              'Maybe this year can be a little different.',
          reflection:
          'The best celebrations usually start '
              'with remembering.',
          sourceName: 'Special Dates',
          actionTitle: 'See special date',
          actionSubtitle:
          'Open your saved moment.',
        );

      case SimiSurpriseType.futureMessage:
        return const _SurpriseDetailInfo(
          label: 'FROM THE PAST',
          icon: Icons.mark_email_unread_outlined,
          background: Color(0xFFE8E7F3),
          foreground: AppColors.secondary,
          reason:
          'A message you wrote for the future has '
              'reached its opening date.',
          shortReason:
          'A future message is ready.',
          sectionTitle: 'A MESSAGE WAITING',
          storyTitle: 'Someone from the past is knocking',
          storyMessage:
          'You wrote this little piece of your story '
              '30 days ago. It is ready now.',
          reflection:
          'Sometimes the person you needed to hear '
              'from was you.',
          sourceName: 'Future Messages',
          actionTitle: 'Open your message',
          actionSubtitle:
          'See what you left for the future.',
        );

      case SimiSurpriseType.mood:
        return const _SurpriseDetailInfo(
          label: 'SOMETHING SIMI NOTICED',
          icon: Icons.sentiment_satisfied_alt_outlined,
          background: Color(0xFFF0EFEF),
          foreground: AppColors.textSecondary,
          reason:
          'SIMI noticed a small pattern in the moods '
              'you have been recording.',
          shortReason:
          'A pattern appeared in your moods.',
          sectionTitle: 'YOUR LITTLE PATTERN',
          storyTitle: 'You have felt loved lately',
          storyMessage:
          'You marked yourself as feeling loved '
              '3 times this week.',
          reflection:
          'Maybe that is something worth keeping '
              'close.',
          sourceName: 'Mood Journal',
          actionTitle: 'See your moods',
          actionSubtitle:
          'Look back at your little pattern.',
        );

      case SimiSurpriseType.giftWish:
        return const _SurpriseDetailInfo(
          label: 'A LITTLE WISH',
          icon: Icons.card_giftcard_outlined,
          background: Color(0xFFF8E8E9),
          foreground: AppColors.primary,
          reason:
          'SIMI found a wish that has been sitting '
              'quietly in your list for a while.',
          shortReason:
          'An old wish is still waiting.',
          sectionTitle: 'STILL ON YOUR LIST',
          storyTitle: 'You might have forgotten this',
          storyMessage:
          'Those headphones have been in your wishes '
              'for 3 months.',
          reflection:
          'Maybe some little wishes are worth '
              'remembering.',
          sourceName: 'Gift Wishes',
          actionTitle: 'See the wish',
          actionSubtitle:
          'Open your little wishlist.',
        );

      case SimiSurpriseType.milestone:
        return const _SurpriseDetailInfo(
          label: 'A LITTLE MILESTONE',
          icon: Icons.auto_awesome_rounded,
          background: Color(0xFFF3E7D8),
          foreground: Color(0xFF8B6D49),
          reason:
          'SIMI noticed that your relationship has '
              'reached a little milestone.',
          shortReason:
          'You reached a new milestone.',
          sectionTitle: 'LOOK HOW FAR YOU\'VE COME',
          storyTitle: '100 memories together',
          storyMessage:
          'That is 100 little pieces of your story, '
              'all kept in one place.',
          reflection:
          '100 moments. And hopefully, many more.',
          sourceName: 'Your SIMI Story',
          actionTitle: 'Look through them',
          actionSubtitle:
          'See the memories you created.',
        );

      case SimiSurpriseType.surprise:
        return const _SurpriseDetailInfo(
          label: 'JUST FOR YOU TWO',
          icon: Icons.auto_awesome_rounded,
          background: Color(0xFFFCE4EC),
          foreground: AppColors.primary,
          reason:
          'SIMI found something meaningful from '
              'your shared story.',
          shortReason:
          'SIMI chose this one for you.',
          sectionTitle: 'A SURPRISE',
          storyTitle: 'Remember this little moment?',
          storyMessage:
          'SIMI found something from your story '
              'that felt worth bringing back today.',
          reflection:
          'Some things are better when they surprise you.',
          sourceName: 'SIMI',
          actionTitle: 'Open this moment',
          actionSubtitle:
          'Go back to where it came from.',
        );
    }
  }
}

// =============================================================================
// STORY CARD
// =============================================================================

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.type,
    required this.icon,
    required this.accent,
    required this.title,
    required this.message,
  });

  final SimiSurpriseType type;
  final IconData icon;
  final Color accent;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.52),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 19,
              color: accent,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              height: 1.15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            message,
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
}

// =============================================================================
// DETAIL ROW
// =============================================================================

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
      padding: const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.primary,
          ),

          const SizedBox(width: 12),

          Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: AppColors.outlineVariant
          .withValues(alpha: 0.38),
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextTheme.labelSmall.copyWith(
        fontSize: 9.5,
        letterSpacing: 1.9,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.76),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// BOTTOM SHEET
// =============================================================================

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

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
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
                    title,
                    style: AppTextTheme.labelLarge.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 11,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 120,
          right: -90,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 32,
              sigmaY: 32,
            ),
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
        ),
        Positioned(
          top: 500,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 36,
              sigmaY: 36,
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.045),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedEntry extends StatelessWidget {
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
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        (delay + 0.45).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              16 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}