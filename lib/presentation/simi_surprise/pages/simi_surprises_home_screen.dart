import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

enum SimiSurpriseType {
  memory,
  chat,
  period,
  specialDate,
  futureMessage,
  mood,
  giftWish,
  milestone,
  surprise,
}

class SimiSurpriseItem {
  const SimiSurpriseItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timeLabel,
    this.actionLabel,
    this.icon,
    this.isNew = false,
    this.isFeatured = false,
  });

  final String id;
  final SimiSurpriseType type;
  final String title;
  final String message;
  final String timeLabel;
  final String? actionLabel;
  final IconData? icon;
  final bool isNew;
  final bool isFeatured;
}

class SimiSurprisesHomeScreen extends StatefulWidget {
  const SimiSurprisesHomeScreen({
    super.key,
    this.surprises = const [],
    this.totalMoments = 128,
    this.onSurpriseTap,
    this.onSurpriseUs,
    this.onSettings,
    this.onSearch,
  });

  final List<SimiSurpriseItem> surprises;
  final int totalMoments;

  final ValueChanged<SimiSurpriseItem>? onSurpriseTap;
  final VoidCallback? onSurpriseUs;
  final VoidCallback? onSettings;
  final ValueChanged<String>? onSearch;

  @override
  State<SimiSurprisesHomeScreen> createState() =>
      _SimiSurprisesHomeScreenState();
}

class _SimiSurprisesHomeScreenState
    extends State<SimiSurprisesHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  bool _showSearch = false;
  final TextEditingController _searchController =
  TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  List<SimiSurpriseItem> get _visibleSurprises {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.surprises;
    }

    return widget.surprises.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.message.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final surprises = _visibleSurprises;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _SurprisesBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 150,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildInsightCard(),
                _buildSectionHeader(),
                if (_showSearch) _buildSearchField(),
                if (surprises.isEmpty)
                  _buildEmptyState()
                else
                  ...surprises.asMap().entries.map(
                        (entry) {
                      return _AnimatedEntry(
                        controller: _animationController,
                        index: entry.key,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            13,
                          ),
                          child: _SurpriseCard(
                            item: entry.value,
                            onTap: () {
                              widget.onSurpriseTap
                                  ?.call(entry.value);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                _buildSurpriseUs(),
                const SizedBox(height: 24),
                _buildPrivacyMessage(),
              ],
            ),
          ),

          _buildBottomFade(),
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
        10,
        16,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.maybePop(context),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIMI SURPRISES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2.2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Little things SIMI noticed.',
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
            icon: _showSearch
                ? Icons.close_rounded
                : Icons.search_rounded,
            onTap: () {
              setState(() {
                _showSearch = !_showSearch;

                if (!_showSearch) {
                  _searchController.clear();
                  widget.onSearch?.call('');
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

  // ---------------------------------------------------------------------------
  // HERO
  // ---------------------------------------------------------------------------

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
        index: 0,
        child: Container(
          height: 245,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF272021),
                Color(0xFF403033),
                Color(0xFF5A4145),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -55,
                right: -35,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.10),
                  ),
                ),
              ),

              Positioned(
                bottom: -70,
                left: -40,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.035),
                  ),
                ),
              ),

              Positioned(
                top: 24,
                right: 28,
                child: _FloatingSpark(
                  controller: _animationController,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  22,
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
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.12),
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: Color(0xFFF6D9DC),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Text(
                          'SIMI NOTICED',
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 9,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                                .withValues(alpha: 0.62),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Text(
                      'Little things',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 31,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Things SIMI noticed about you two.',
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontSize: 13,
                        height: 1.45,
                        color: Colors.white
                            .withValues(alpha: 0.70),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_border_rounded,
                          size: 14,
                          color: Color(0xFFF6D9DC),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.totalMoments} little moments',
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 10,
                            color: Colors.white
                                .withValues(alpha: 0.58),
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
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INSIGHT
  // ---------------------------------------------------------------------------

  Widget _buildInsightCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.visibility_outlined,
                size: 20,
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
                    'YOUR STORY IS STILL GROWING',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8.5,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SIMI looks across your little world '
                        'and finds moments worth showing you.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textPrimary,
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
  // SECTION
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'TODAY',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (widget.surprises.isNotEmpty)
            Text(
              '${widget.surprises.length} little things',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textDisabled,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        14,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {});
            widget.onSearch?.call(value);
          },
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search your little moments...',
            hintStyle: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              color: AppColors.textDisabled,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 19,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SURPRISE US
  // ---------------------------------------------------------------------------

  Widget _buildSurpriseUs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        0,
      ),
      child: GestureDetector(
        onTap: widget.onSurpriseUs,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF765457),
                Color(0xFF966E72),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: 0.20),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.14),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surprise Us',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Show us something from our story.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 10,
                        color: Colors.white
                            .withValues(alpha: 0.68),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                size: 19,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIVACY
  // ---------------------------------------------------------------------------

  Widget _buildPrivacyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'SIMI only uses the moments you choose to share.',
              textAlign: TextAlign.center,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                height: 1.4,
                color: AppColors.textDisabled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        28,
        30,
        28,
        20,
      ),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Nothing little yet.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Keep using SIMI together. '
                'Soon, I might notice something sweet.',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM FADE
  // ---------------------------------------------------------------------------

  Widget _buildBottomFade() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surface.withValues(alpha: 0),
                AppColors.surface,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SURPRISE CARD
// =============================================================================

class _SurpriseCard extends StatelessWidget {
  const _SurpriseCard({
    required this.item,
    required this.onTap,
  });

  final SimiSurpriseItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final info = _SurpriseInfo.fromType(item.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(22),
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
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: info.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon ?? info.icon,
                    size: 18,
                    color: info.foreground,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 8.5,
                          letterSpacing: 1.25,
                          fontWeight: FontWeight.w600,
                          color: info.foreground,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.timeLabel,
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 8.5,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),

                if (item.isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC),
                      borderRadius:
                      BorderRadius.circular(999),
                    ),
                    child: Text(
                      'NEW',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 7.5,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              item.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 19,
                height: 1.15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              item.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            if (item.actionLabel != null) ...[
              const SizedBox(height: 13),
              Row(
                children: [
                  Text(
                    item.actionLabel!,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SURPRISE INFO
// =============================================================================

class _SurpriseInfo {
  const _SurpriseInfo({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  static _SurpriseInfo fromType(
      SimiSurpriseType type,
      ) {
    switch (type) {
      case SimiSurpriseType.memory:
        return const _SurpriseInfo(
          label: 'MEMORY MOMENT',
          icon: Icons.photo_camera_outlined,
          background: Color(0xFFFCE4EC),
          foreground: AppColors.primary,
        );

      case SimiSurpriseType.chat:
        return const _SurpriseInfo(
          label: 'A LITTLE COINCIDENCE',
          icon: Icons.chat_bubble_outline_rounded,
          background: Color(0xFFE8E7F3),
          foreground: AppColors.secondary,
        );

      case SimiSurpriseType.period:
        return const _SurpriseInfo(
          label: 'YOUR RHYTHM',
          icon: Icons.calendar_month_outlined,
          background: Color(0xFFFCE4EC),
          foreground: AppColors.primary,
        );

      case SimiSurpriseType.specialDate:
        return const _SurpriseInfo(
          label: 'IT\'S GETTING CLOSE',
          icon: Icons.event_outlined,
          background: Color(0xFFF7E7E4),
          foreground: Color(0xFF9A6A63),
        );

      case SimiSurpriseType.futureMessage:
        return const _SurpriseInfo(
          label: 'FROM THE PAST',
          icon: Icons.mark_email_unread_outlined,
          background: Color(0xFFE8E7F3),
          foreground: AppColors.secondary,
        );

      case SimiSurpriseType.mood:
        return const _SurpriseInfo(
          label: 'SOMETHING SIMI NOTICED',
          icon: Icons.sentiment_satisfied_alt_outlined,
          background: Color(0xFFF0EFEF),
          foreground: AppColors.textSecondary,
        );

      case SimiSurpriseType.giftWish:
        return const _SurpriseInfo(
          label: 'YOU MIGHT HAVE FORGOTTEN THIS',
          icon: Icons.card_giftcard_outlined,
          background: Color(0xFFF8E8E9),
          foreground: AppColors.primary,
        );

      case SimiSurpriseType.milestone:
        return const _SurpriseInfo(
          label: 'A LITTLE MILESTONE',
          icon: Icons.auto_awesome_rounded,
          background: Color(0xFFF3E7D8),
          foreground: Color(0xFF8B6D49),
        );

      case SimiSurpriseType.surprise:
        return const _SurpriseInfo(
          label: 'JUST FOR YOU TWO',
          icon: Icons.auto_awesome_rounded,
          background: Color(0xFFFCE4EC),
          foreground: AppColors.primary,
        );
    }
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _SurprisesBackground extends StatelessWidget {
  const _SurprisesBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 120,
          right: -80,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 30,
              sigmaY: 30,
            ),
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.13),
              ),
            ),
          ),
        ),
        Positioned(
          top: 470,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 35,
              sigmaY: 35,
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.06),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// FLOATING SPARK
// =============================================================================

class _FloatingSpark extends StatelessWidget {
  const _FloatingSpark({
    required this.controller,
  });

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;

        return Transform.translate(
          offset: Offset(
            0,
            -4 * value,
          ),
          child: Opacity(
            opacity: 0.45 + (value * 0.55),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.auto_awesome_rounded,
        size: 20,
        color: Color(0xFFF6D9DC),
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
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.74),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.index,
    required this.child,
  });

  final AnimationController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.65);
    final end = (start + 0.35).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        start,
        end,
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
              18 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}