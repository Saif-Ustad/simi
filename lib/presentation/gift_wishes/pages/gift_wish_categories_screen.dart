import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_theme.dart';

import 'gift_wishes_home_screen.dart';

class GiftWishCategory {
  const GiftWishCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.count,
    this.emoji,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final int count;
  final String? emoji;
}

class GiftWishCategoriesScreen extends StatefulWidget {
  const GiftWishCategoriesScreen({
    super.key,
    this.categories = const [],
    this.onBack,
    this.onCategoryTap,
    this.onCreateWish,
  });

  final List<GiftWishCategory> categories;
  final VoidCallback? onBack;
  final ValueChanged<GiftWishCategory>? onCategoryTap;
  final VoidCallback? onCreateWish;

  @override
  State<GiftWishCategoriesScreen> createState() =>
      _GiftWishCategoriesScreenState();
}

class _GiftWishCategoriesScreenState
    extends State<GiftWishCategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<GiftWishCategory> get _filteredCategories {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.categories;
    }

    return widget.categories.where((category) {
      return category.name.toLowerCase().contains(query) ||
          category.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  int get _totalWishes {
    return widget.categories.fold(
      0,
          (total, category) => total + category.count,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _filteredCategories;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _CategoriesBackground(),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopBar(context),

                  _buildHero(),

                  _buildInsightCard(),

                  _buildSearch(),

                  const SizedBox(height: 8),

                  if (categories.isEmpty)
                    _buildEmptyState()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ...categories.map(
                                (category) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 14,
                                ),
                                child: _CategoryCard(
                                  category: category,
                                  onTap: () {
                                    widget.onCategoryTap?.call(
                                      category,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (widget.onCreateWish != null)
            _buildBottomAction(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          0,
        ),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ?? () => Navigator.pop(context),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GIFT WISHES',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Our little categories',
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
              icon: Icons.add_rounded,
              onTap: widget.onCreateWish,
            ),
          ],
        ),
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
        28,
        20,
        18,
      ),
      child: _HeroCard(
        totalWishes: _totalWishes,
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
        0,
        20,
        18,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.55,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
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

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                'Organize little hints into places '
                    'that make sense to both of you.',
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.70),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: 'Find a category...',
                hintStyle: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textDisabled,
                  fontSize: 12,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    final searching = _searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          20,
          32,
          120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                searching
                    ? Icons.search_off_rounded
                    : Icons.auto_awesome_outlined,
                size: 30,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              searching
                  ? 'Nothing found'
                  : 'No categories yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              searching
                  ? 'Try another category name.'
                  : 'Your wishes will find little homes here.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            if (!searching && widget.onCreateWish != null) ...[
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: widget.onCreateWish,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Add a wish',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM CTA
  // ---------------------------------------------------------------------------

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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onCreateWish,
                  borderRadius: BorderRadius.circular(29),
                  splashColor: Colors.white.withValues(
                    alpha: 0.12,
                  ),
                  highlightColor: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                  child: Ink(
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
                            alpha: 0.24,
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

                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.14,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.card_giftcard_rounded,
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
                                'Add a little wish',
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
                                'Leave another tiny hint',
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style:
                                AppTextTheme.labelSmall
                                    .copyWith(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.72,
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

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
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: 0.14,
                              ),
                            ),
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
        ),
      ),
    );
  }
}

// =============================================================================
// HERO CARD
// =============================================================================

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.totalWishes,
  });

  final int totalWishes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 205,
      ),
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF332526),
            Color(0xFF5A3F42),
            Color(0xFF765457),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.055),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 35,
            bottom: -70,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.11,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.category_outlined,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$totalWishes wishes',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: Colors.white.withValues(
                          alpha: 0.82,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              const SizedBox(height: 32),

              Text(
                'JUST A LITTLE ORGANIZED',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: const Color(0xFFF2D8DA),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Every wish has\\na little story.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  height: 1.12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                'Keep the hints, dreams and someday ideas '
                    'in their own little corners.',
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  height: 1.45,
                  color: Colors.white.withValues(
                    alpha: 0.70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CATEGORY CARD
// =============================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final GiftWishCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _CategoryIcon(
                icon: category.icon,
                emoji: category.emoji,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            category.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppColors.textPrimary,
                            ),
                          ),
                        ),

                        const SizedBox(width: 7),

                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE4EC),
                            borderRadius:
                            BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${category.count}',
                            style: AppTextTheme.labelSmall
                                .copyWith(
                              fontSize: 9,
                              fontWeight:
                              FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      category.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      AppTextTheme.bodyMedium.copyWith(
                        fontSize: 11,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1F0),
                  shape: BoxShape.circle,
                ),
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
}

// =============================================================================
// CATEGORY ICON
// =============================================================================

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.icon,
    this.emoji,
  });

  final IconData icon;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFCE4EC),
            Color(0xFFF5E7E5),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.primary,
          ),

          if (emoji != null)
            Positioned(
              right: 2,
              bottom: 1,
              child: Text(
                emoji!,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _CategoriesBackground extends StatelessWidget {
  const _CategoriesBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.55,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 360,
            left: -110,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            right: -90,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91).withValues(
                  alpha: 0.05,
                ),
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
// CIRCLE BUTTON
// =============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
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
            color: Colors.white.withValues(alpha: 0.72),
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
      ),
    );
  }
}

// =============================================================================
// ANIMATED ENTRY
// =============================================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.6);
    final end = (start + 0.38).clamp(0.0, 1.0);

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
        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              18 * (1 - value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}