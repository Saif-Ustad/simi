import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_theme.dart';

/// ------------------------------------------------------------
/// MODEL
/// ------------------------------------------------------------

enum GiftWishPriority {
  thought,
  wouldLove,
  reallyWant,
}

enum GiftWishStatus {
  wished,
  planned,
  gifted,
}

enum GiftWishOwner {
  me,
  love,
}

class GiftWishItem {
  const GiftWishItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.owner,
    required this.addedAt,
    this.price,
    this.image,
    this.note,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final GiftWishPriority priority;
  final GiftWishStatus status;
  final GiftWishOwner owner;
  final DateTime addedAt;
  final double? price;
  final ImageProvider? image;
  final String? note;
  final bool isFavorite;
}

/// ------------------------------------------------------------
/// SCREEN
/// ------------------------------------------------------------

class GiftWishesHomeScreen extends StatefulWidget {
  const GiftWishesHomeScreen({
    super.key,
    this.wishes = const [],
    this.onWishTap,
    this.onCreateWish,
    this.onSearch,
    this.onFavoriteChanged,
    this.onFilterChanged,
    this.onCategories,
  });

  final List<GiftWishItem> wishes;

  final ValueChanged<GiftWishItem>? onWishTap;
  final VoidCallback? onCreateWish;
  final ValueChanged<String>? onSearch;
  final ValueChanged<GiftWishItem>? onFavoriteChanged;
  final ValueChanged<String>? onFilterChanged;
  final VoidCallback? onCategories;

  @override
  State<GiftWishesHomeScreen> createState() =>
      _GiftWishesHomeScreenState();
}

class _GiftWishesHomeScreenState
    extends State<GiftWishesHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  String _selectedFilter = 'All';
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showSearch = false;

  final List<String> _filters = const [
    'All',
    'Mine',
    "Love's",
    'Gifted',
  ];

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

  List<GiftWishItem> get _filteredWishes {
    Iterable<GiftWishItem> result = widget.wishes;

    switch (_selectedFilter) {
      case 'Mine':
        result = result.where(
              (wish) => wish.owner == GiftWishOwner.me,
        );
        break;

      case "Love's":
        result = result.where(
              (wish) => wish.owner == GiftWishOwner.love,
        );
        break;

      case 'Gifted':
        result = result.where(
              (wish) => wish.status == GiftWishStatus.gifted,
        );
        break;
    }

    if (_selectedCategory != 'All') {
      result = result.where(
            (wish) =>
        wish.category.toLowerCase() ==
            _selectedCategory.toLowerCase(),
      );
    }

    final query = _searchQuery.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where(
            (wish) =>
        wish.title.toLowerCase().contains(query) ||
            wish.description.toLowerCase().contains(query) ||
            wish.category.toLowerCase().contains(query),
      );
    }

    final list = result.toList();

    list.sort(
          (a, b) => b.addedAt.compareTo(a.addedAt),
    );

    return list;
  }

  List<String> get _categories {
    final categories = <String>{'All'};

    for (final wish in widget.wishes) {
      if (wish.category.trim().isNotEmpty) {
        categories.add(wish.category);
      }
    }

    return categories.toList();
  }

  int get _totalWishes => widget.wishes.length;

  int get _myWishes => widget.wishes
      .where((wish) => wish.owner == GiftWishOwner.me)
      .length;

  int get _loveWishes => widget.wishes
      .where((wish) => wish.owner == GiftWishOwner.love)
      .length;

  int get _giftedWishes => widget.wishes
      .where((wish) => wish.status == GiftWishStatus.gifted)
      .length;

  @override
  Widget build(BuildContext context) {
    final wishes = _filteredWishes;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _GiftWishBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(context),
              ),

              SliverToBoxAdapter(
                child: _buildHero(),
              ),

              SliverToBoxAdapter(
                child: _buildInsightStrip(),
              ),

              SliverToBoxAdapter(
                child: _buildFilters(),
              ),

              if (widget.wishes.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildCategoryChips(),
                ),

              if (wishes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    6,
                    20,
                    130,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final wish = wishes[index];

                        return _AnimatedEntry(
                          index: index,
                          controller: _animationController,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 14,
                            ),
                            child: _GiftWishCard(
                              wish: wish,
                              onTap: () {
                                widget.onWishTap?.call(wish);
                              },
                              onFavorite: () {
                                widget.onFavoriteChanged?.call(wish);
                              },
                            ),
                          ),
                        );
                      },
                      childCount: wishes.length,
                    ),
                  ),
                ),
            ],
          ),

          _buildBottomAction(context),
        ],
      ),
    );
  }

  /// ----------------------------------------------------------
  /// TOP BAR
  /// ----------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GIFT WISHES',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Little things worth remembering.',
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
                    _searchQuery = '';
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// HERO
  /// ----------------------------------------------------------

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Container(
        height: 218,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6F5053),
              Color(0xFF8D6569),
              Color(0xFFAA7A7E),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -38,
              top: -42,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 28,
              bottom: -54,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 25,
              top: 28,
              child: _HeroGiftIcon(
                controller: _animationController,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                25,
                24,
                22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              size: 11,
                              color: Color(0xFFF9DDE0),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'JUST BETWEEN US',
                              style: AppTextTheme.labelSmall.copyWith(
                                fontSize: 9,
                                letterSpacing: 1.2,
                                color: Colors.white.withValues(
                                  alpha: 0.88,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: 260,
                    child: Text(
                      'Things I secretly hope you’ll remember.',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 27,
                        height: 1.16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    _totalWishes == 0
                        ? 'A little place for things we would love.'
                        : '$_totalWishes little wishes saved between us.',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.74),
                      fontSize: 12,
                      height: 1.45,
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

  /// ----------------------------------------------------------
  /// INSIGHTS
  /// ----------------------------------------------------------

  Widget _buildInsightStrip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
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
        ),
        child: Row(
          children: [
            Expanded(
              child: _InsightItem(
                icon: Icons.auto_awesome_rounded,
                value: '$_totalWishes',
                label: 'Wishes',
              ),
            ),
            _VerticalDivider(),
            Expanded(
              child: _InsightItem(
                icon: Icons.person_outline_rounded,
                value: '$_myWishes',
                label: 'Mine',
              ),
            ),
            _VerticalDivider(),
            Expanded(
              child: _InsightItem(
                icon: Icons.favorite_border_rounded,
                value: '$_loveWishes',
                label: "Love's",
              ),
            ),
            _VerticalDivider(),
            Expanded(
              child: _InsightItem(
                icon: Icons.card_giftcard_rounded,
                value: '$_giftedWishes',
                label: 'Gifted',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// FILTERS
  /// ----------------------------------------------------------

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showSearch) ...[
            Container(
              height: 48,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(
                    alpha: 0.65,
                  ),
                ),
              ),
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });

                  widget.onSearch?.call(value);
                },
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  hintText: 'Search your wishes...',
                  hintStyle: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],

          Text(
            'OUR WISHES',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _filters.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final selected = filter == _selectedFilter;

                return _FilterChip(
                  label: filter,
                  selected: selected,
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });

                    widget.onFilterChanged?.call(filter);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------------
  /// CATEGORY CHIPS
  /// ----------------------------------------------------------

  Widget _buildCategoryChips() {
    final categories = _categories;

    if (categories.length <= 1) {
      return const SizedBox(height: 4);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------
          // CATEGORY HEADER
          // -------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              2,
              20,
              8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'CATEGORIES',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: widget.onCategories,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See all',
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
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
          ),

          // -------------------------------------------------------
          // CATEGORY CHIPS
          // -------------------------------------------------------
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                8,
              ),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected =
                    category == _selectedCategory;

                return _CategoryChip(
                  label: category,
                  selected: selected,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------------
  /// EMPTY STATE
  /// ----------------------------------------------------------

  Widget _buildEmptyState() {
    final hasFilters = _selectedFilter != 'All' ||
        _selectedCategory != 'All' ||
        _searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          30,
          30,
          30,
          120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_outlined,
                size: 38,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              hasFilters
                  ? 'Nothing here yet'
                  : 'A little space for wishes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              hasFilters
                  ? 'Try another filter or search.'
                  : 'Save the things you love, the things you dream about, and the little things you hope they remember.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            if (!hasFilters) ...[
              const SizedBox(height: 22),

              OutlinedButton.icon(
                onPressed: widget.onCreateWish,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 18,
                ),
                label: const Text('Add your first wish'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
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

  /// ----------------------------------------------------------
  /// BOTTOM CTA
  /// ----------------------------------------------------------

  Widget _buildBottomAction(BuildContext context) {
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
              child: GestureDetector(
                onTap: widget.onCreateWish,
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

                      // Add icon
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
                              'Add a little wish',
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

                            Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration:
                                  const BoxDecoration(
                                    color: Color(0xFFF6D9DC),
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                Flexible(
                                  child: Text(
                                    'Something worth remembering',
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: AppTextTheme.labelSmall
                                        .copyWith(
                                      color: Colors.white
                                          .withValues(
                                        alpha: 0.72,
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}

/// ============================================================
/// GIFT WISH CARD
/// ============================================================

class _GiftWishCard extends StatelessWidget {
  const _GiftWishCard({
    required this.wish,
    required this.onTap,
    required this.onFavorite,
  });

  final GiftWishItem wish;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final gifted = wish.status == GiftWishStatus.gifted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                _WishImage(
                  image: wish.image,
                  gifted: gifted,
                  category: wish.category,
                ),

                const SizedBox(width: 12),

                // CONTENT
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 0,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // TITLE + FAVORITE
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                wish.title,
                                maxLines: 2,
                                overflow:
                                TextOverflow.ellipsis,
                                style:
                                GoogleFonts.playfairDisplay(
                                  fontSize: 17,
                                  height: 1.15,
                                  fontWeight: FontWeight.w600,
                                  color:
                                  AppColors.textPrimary,
                                ),
                              ),
                            ),

                            const SizedBox(width: 4),

                            GestureDetector(
                              behavior:
                              HitTestBehavior.opaque,
                              onTap: onFavorite,
                              child: Padding(
                                padding:
                                const EdgeInsets.all(3),
                                child: Icon(
                                  wish.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons
                                      .favorite_border_rounded,
                                  size: 17,
                                  color: wish.isFavorite
                                      ? AppColors.primary
                                      : AppColors.textDisabled,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // DESCRIPTION
                        Text(
                          wish.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                          AppTextTheme.bodyMedium.copyWith(
                            fontSize: 11.5,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 9),

                        // PILLS
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            _SmallPill(
                              icon: _ownerIcon(wish.owner),
                              label: _ownerLabel(wish.owner),
                            ),
                            _SmallPill(
                              icon:
                              Icons.sell_outlined,
                              label: wish.category,
                            ),
                          ],
                        ),

                        const SizedBox(height: 9),

                        // BOTTOM INFO
                        Row(
                          children: [
                            Flexible(
                              child: _PriorityIndicator(
                                priority: wish.priority,
                              ),
                            ),

                            const SizedBox(width: 6),

                            if (wish.price != null)
                              Flexible(
                                child: Text(
                                  '₹${wish.price!.toStringAsFixed(0)}',
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: AppTextTheme
                                      .labelLarge
                                      .copyWith(
                                    fontSize: 10.5,
                                    color:
                                    AppColors.textPrimary,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),

                            const SizedBox(width: 4),

                            if (gifted)
                              const _GiftedPill()
                            else
                              const Icon(
                                Icons
                                    .arrow_forward_ios_rounded,
                                size: 10,
                                color:
                                AppColors.primary,
                              ),
                          ],
                        ),
                      ],
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

  IconData _ownerIcon(GiftWishOwner owner) {
    switch (owner) {
      case GiftWishOwner.me:
        return Icons.person_outline_rounded;

      case GiftWishOwner.love:
        return Icons.favorite_border_rounded;
    }
  }

  String _ownerLabel(GiftWishOwner owner) {
    switch (owner) {
      case GiftWishOwner.me:
        return 'Mine';

      case GiftWishOwner.love:
        return "Love's";
    }
  }
}

/// ============================================================
/// IMAGE
/// ============================================================

class _WishImage extends StatelessWidget {
  const _WishImage({
    required this.image,
    required this.gifted,
    required this.category,
  });

  final ImageProvider? image;
  final bool gifted;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 118,
      decoration: BoxDecoration(
        color: const Color(0xFFF7ECEB),
        borderRadius: BorderRadius.circular(19),
        image: image != null
            ? DecorationImage(
          image: image!,
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: image == null
          ? Center(
        child: Icon(
          _categoryIcon(category),
          size: 31,
          color: AppColors.primary.withValues(
            alpha: 0.72,
          ),
        ),
      )
          : Stack(
        children: [
          if (gifted)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.48),
                    ],
                  ),
                ),
              ),
            ),

          if (gifted)
            const Positioned(
              left: 10,
              bottom: 10,
              child: _GiftedPill(
                dark: true,
              ),
            ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fashion':
        return Icons.checkroom_outlined;
      case 'tech':
        return Icons.headphones_outlined;
      case 'books':
        return Icons.menu_book_outlined;
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'beauty':
        return Icons.spa_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'experiences':
        return Icons.auto_awesome_outlined;
      case 'fun':
        return Icons.sports_esports_outlined;
      default:
        return Icons.card_giftcard_outlined;
    }
  }
}

/// ============================================================
/// HERO ICON
/// ============================================================

class _HeroGiftIcon extends StatelessWidget {
  const _HeroGiftIcon({
    required this.controller,
  });

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value =
        Curves.easeOut.transform(controller.value);

        return Transform.translate(
          offset: Offset(
            0,
            7 * (1 - value),
          ),
          child: Transform.rotate(
            angle: (1 - value) * -0.05,
            child: child,
          ),
        );
      },
      child: Container(
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.11),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: const Icon(
          Icons.card_giftcard_rounded,
          size: 34,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// ============================================================
/// PRIORITY
/// ============================================================

class _PriorityIndicator extends StatelessWidget {
  const _PriorityIndicator({
    required this.priority,
  });

  final GiftWishPriority priority;

  @override
  Widget build(BuildContext context) {
    final String text;

    switch (priority) {
      case GiftWishPriority.thought:
        text = 'Just a thought';
        break;

      case GiftWishPriority.wouldLove:
        text = 'Would love';
        break;

      case GiftWishPriority.reallyWant:
        text = 'Really want';
        break;
    }

    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 11,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// SMALL PILL
/// ============================================================

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1F0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// GIFTED PILL
/// ============================================================

class _GiftedPill extends StatelessWidget {
  const _GiftedPill({
    this.dark = false,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withValues(alpha: 0.38)
            : const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 10,
            color: dark
                ? Colors.white
                : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            'Gifted',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: dark
                  ? Colors.white
                  : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// INSIGHT ITEM
/// ============================================================

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
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 8.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: AppColors.outlineVariant.withValues(
        alpha: 0.55,
      ),
    );
  }
}

/// ============================================================
/// FILTER CHIP
/// ============================================================

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: AppTextTheme.labelLarge.copyWith(
              fontSize: 11,
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary,
              fontWeight: selected
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// CATEGORY CHIP
/// ============================================================

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFCE4EC)
              : Colors.white.withValues(alpha: 0.68),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.outlineVariant.withValues(
              alpha: 0.65,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9.5,
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// CIRCLE BUTTON
/// ============================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.72),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
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

/// ============================================================
/// BACKGROUND
/// ============================================================

class _GiftWishBackground extends StatelessWidget {
  const _GiftWishBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 120,
            right: -80,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.42,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 470,
            left: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.09,
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

/// ============================================================
/// ANIMATED ENTRY
/// ============================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final Animation<double> controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.7);

    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final progress = ((controller.value - start) /
            (1 - start))
            .clamp(0.0, 1.0);

        final eased =
        Curves.easeOutCubic.transform(progress);

        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(
              0,
              18 * (1 - eased),
            ),
            child: child,
          ),
        );
      },
    );
  }
}