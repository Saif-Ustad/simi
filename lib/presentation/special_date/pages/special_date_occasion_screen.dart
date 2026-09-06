import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateOccasionScreen extends StatefulWidget {
  const SpecialDateOccasionScreen({
    super.key,
    required this.category,
    this.onBack,
    this.onContinue,
  });

  final SpecialDateCategory category;

  final VoidCallback? onBack;

  final void Function(
      String title,
      String description,
      )? onContinue;

  @override
  State<SpecialDateOccasionScreen> createState() =>
      _SpecialDateOccasionScreenState();
}

class _SpecialDateOccasionScreenState
    extends State<SpecialDateOccasionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _titleController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();

    _titleController
      ..removeListener(_onTextChanged)
      ..dispose();

    _descriptionController.dispose();

    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  // ===========================================================================
  // CATEGORY INFORMATION
  // ===========================================================================

  _CategoryInfo get _categoryInfo {
    switch (widget.category) {
      case SpecialDateCategory.anniversary:
        return const _CategoryInfo(
          title: 'Anniversary',
          emoji: '❤️',
          icon: Icons.favorite_rounded,
          subtitle: 'A day that belongs only to us.',
          suggestions: [
            'Our Anniversary',
            'Our 1st Anniversary',
            'The day we chose us',
          ],
        );

      case SpecialDateCategory.birthday:
        return const _CategoryInfo(
          title: 'Birthday',
          emoji: '🎂',
          icon: Icons.cake_outlined,
          subtitle: 'A day worth celebrating together.',
          suggestions: [
            'My Birthday',
            'Love’s Birthday',
            'Your Special Day',
          ],
        );

      case SpecialDateCategory.firstMeeting:
        return const _CategoryInfo(
          title: 'First Meeting',
          emoji: '✨',
          icon: Icons.people_outline_rounded,
          subtitle: 'Where our story first began.',
          suggestions: [
            'The day we met',
            'When our story began',
            'The day we first met',
          ],
        );

      case SpecialDateCategory.firstDate:
        return const _CategoryInfo(
          title: 'First Date',
          emoji: '💕',
          icon: Icons.favorite_border_rounded,
          subtitle: 'The beginning of something beautiful.',
          suggestions: [
            'Our First Date',
            'The night it all began',
            'Our first little adventure',
          ],
        );

      case SpecialDateCategory.firstKiss:
        return const _CategoryInfo(
          title: 'First Kiss',
          emoji: '💋',
          icon: Icons.face_retouching_natural_outlined,
          subtitle: 'One little moment we never forgot.',
          suggestions: [
            'Our First Kiss',
            'The kiss I remember',
            'That little moment',
          ],
        );

      case SpecialDateCategory.firstTrip:
        return const _CategoryInfo(
          title: 'First Trip',
          emoji: '✈️',
          icon: Icons.flight_takeoff_rounded,
          subtitle: 'The first place we explored together.',
          suggestions: [
            'Our First Trip',
            'Our first adventure',
            'The trip that started it',
          ],
        );

      case SpecialDateCategory.customMoment:
        return const _CategoryInfo(
          title: 'Custom Moment',
          emoji: '🌷',
          icon: Icons.auto_awesome_rounded,
          subtitle: 'Something special that is just ours.',
          suggestions: [
            'A day worth remembering',
            'Our little moment',
            'Something special',
          ],
        );
    }
  }

  // ===========================================================================
  // CONTINUE
  // ===========================================================================

  void _continue() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      FocusScope.of(context).requestFocus(_titleFocusNode);
      return;
    }

    widget.onContinue?.call(
      title,
      description,
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
            child: _OccasionBackground(),
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

                const SizedBox(height: 28),

                _buildHero(info),

                const SizedBox(height: 28),

                _buildTitleSection(info),

                const SizedBox(height: 27),

                _buildDescriptionSection(),

                const SizedBox(height: 26),

                _buildLittleReminder(),
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
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '2 OF 5',
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
            final active = index <= 1;

            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(
                  right: index == 4 ? 0 : 5,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary
                      : AppColors.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero(_CategoryInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2021),
              Color(0xFF594044),
              Color(0xFF765457),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -45,
              top: -60,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.045,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              left: -65,
              bottom: -85,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8B4B8).withValues(
                    alpha: 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.11,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.10,
                            ),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              info.icon,
                              size: 20,
                              color: Colors.white,
                            ),
                            Positioned(
                              right: 1,
                              bottom: 1,
                              child: Text(
                                info.emoji,
                                style: const TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOU CHOSE',
                              style: AppTextTheme.labelSmall.copyWith(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.white.withValues(
                                  alpha: 0.60,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              info.title,
                              style:
                              GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    'Now give this little moment a name.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    info.subtitle,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontSize: 10.5,
                      color: Colors.white.withValues(
                        alpha: 0.68,
                      ),
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
  // TITLE
  // ===========================================================================

  Widget _buildTitleSection(_CategoryInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            title: 'NAME THIS MOMENT',
            subtitle: 'Something you will smile at later.',
          ),

          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.86,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _titleController.text.isNotEmpty
                    ? AppColors.primary.withValues(
                  alpha: 0.45,
                )
                    : AppColors.outlineVariant.withValues(
                  alpha: 0.55,
                ),
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
            child: TextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _descriptionFocusNode.requestFocus();
              },
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: _defaultHint(info),
                hintStyle: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDisabled,
                ),
                prefixIcon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: AppColors.primary,
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 17,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'A few ideas',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: info.suggestions.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 7),
              itemBuilder: (context, index) {
                final suggestion =
                info.suggestions[index];

                return GestureDetector(
                  onTap: () {
                    _titleController.text = suggestion;
                    _titleController.selection =
                        TextSelection.collapsed(
                          offset:
                          _titleController.text.length,
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EFEE),
                      borderRadius:
                      BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.outlineVariant
                            .withValues(alpha: 0.45),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _defaultHint(_CategoryInfo info) {
    switch (widget.category) {
      case SpecialDateCategory.anniversary:
        return 'Our Anniversary';

      case SpecialDateCategory.birthday:
        return 'Love’s Birthday';

      case SpecialDateCategory.firstMeeting:
        return 'The day we met';

      case SpecialDateCategory.firstDate:
        return 'Our First Date';

      case SpecialDateCategory.firstKiss:
        return 'Our First Kiss';

      case SpecialDateCategory.firstTrip:
        return 'Our First Trip';

      case SpecialDateCategory.customMoment:
        return 'Our little moment';
    }
  }

  // ===========================================================================
  // DESCRIPTION
  // ===========================================================================

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            title: 'A LITTLE NOTE',
            subtitle: 'Optional — why does this day matter?',
          ),

          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.80,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
            child: TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
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
                'Write something you would want to remember about this day…',
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
                      Icons.notes_outlined,
                      size: 18,
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

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                'Only you two will see this.',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // REMINDER MESSAGE
  // ===========================================================================

  Widget _buildLittleReminder() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F1EF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.45,
            ),
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
                Icons.auto_awesome_rounded,
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
                    'Make it yours.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'You can always change the name or note later. '
                        'For now, just capture what this moment means to you.',
                    style: AppTextTheme.labelSmall.copyWith(
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
  // BOTTOM ACTION
  // ===========================================================================

  Widget _buildBottomAction() {
    final enabled =
        _titleController.text.trim().isNotEmpty;

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
              onTap: enabled ? _continue : null,
              child: AnimatedContainer(
                duration:
                const Duration(milliseconds: 220),
                height: 58,
                decoration: BoxDecoration(
                  gradient: enabled
                      ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF765457),
                      Color(0xFF966E72),
                    ],
                  )
                      : null,
                  color: enabled
                      ? null
                      : const Color(0xFFE5DEDB),
                  borderRadius:
                  BorderRadius.circular(29),
                  boxShadow: enabled
                      ? [
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
                  ]
                      : null,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 7),

                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: enabled
                            ? Colors.white.withValues(
                          alpha: 0.14,
                        )
                            : Colors.white.withValues(
                          alpha: 0.55,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        enabled
                            ? Icons.arrow_forward_rounded
                            : Icons.edit_outlined,
                        size: 21,
                        color: enabled
                            ? Colors.white
                            : AppColors.textDisabled,
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
                            enabled
                                ? 'Continue'
                                : 'Name your moment',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: enabled
                                  ? Colors.white
                                  : AppColors.textDisabled,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            enabled
                                ? 'Next, we’ll choose the date'
                                : 'Give this memory a little name',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            AppTextTheme.labelSmall.copyWith(
                              fontSize: 10,
                              color: enabled
                                  ? Colors.white
                                  .withValues(
                                alpha: 0.72,
                              )
                                  : AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (enabled) ...[
                      const SizedBox(width: 8),

                      Container(
                        width: 42,
                        height: 42,
                        margin:
                        const EdgeInsets.only(
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
                    ],

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
    required this.title,
    required this.emoji,
    required this.icon,
    required this.subtitle,
    required this.suggestions,
  });

  final String title;
  final String emoji;
  final IconData icon;
  final String subtitle;
  final List<String> suggestions;
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
            color: AppColors.outlineVariant.withValues(
              alpha: 0.55,
            ),
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

class _OccasionBackground extends StatelessWidget {
  const _OccasionBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 60,
            right: -80,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 38,
                sigmaY: 38,
              ),
              child: Container(
                width: 210,
                height: 210,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E3E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 430,
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
            bottom: 100,
            right: -80,
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