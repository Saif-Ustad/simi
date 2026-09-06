import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_theme.dart';

/// ---------------------------------------------------------------------------
/// MODEL
/// ---------------------------------------------------------------------------

enum FutureMessageStatus {
  locked,
  ready,
  opened,
}

class FutureMessageItem {
  const FutureMessageItem({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.openAt,
    required this.status,
    this.image,
    this.photoCount = 0,
    this.voiceDuration,
    this.voicePath,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime openAt;
  final FutureMessageStatus status;

  final ImageProvider? image;
  final int photoCount;
  final Duration? voiceDuration;
  final bool isFavorite;

  /// Local path of the recorded voice note.
  final String? voicePath;
}

/// ---------------------------------------------------------------------------
/// HOME SCREEN
/// ---------------------------------------------------------------------------

class FutureMessagesHomeScreen extends StatefulWidget {
  const FutureMessagesHomeScreen({
    super.key,
    this.messages = const [],
    this.onMessageTap,
    this.onCreateMessage,
    this.onSearch,
    this.onFavoriteChanged,
    this.onMore,
  });

  final List<FutureMessageItem> messages;

  final ValueChanged<FutureMessageItem>? onMessageTap;
  final VoidCallback? onCreateMessage;
  final ValueChanged<String>? onSearch;
  final ValueChanged<FutureMessageItem>? onFavoriteChanged;
  final ValueChanged<FutureMessageItem>? onMore;

  @override
  State<FutureMessagesHomeScreen> createState() =>
      _FutureMessagesHomeScreenState();
}

class _FutureMessagesHomeScreenState
    extends State<FutureMessagesHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  FutureMessageStatus? _selectedFilter;

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

  List<FutureMessageItem> get _filteredMessages {
    var result = widget.messages;

    if (_selectedFilter != null) {
      result = result
          .where(
            (message) => message.status == _selectedFilter,
      )
          .toList();
    }

    final query = _searchQuery.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((message) {
        return message.title.toLowerCase().contains(query) ||
            message.description.toLowerCase().contains(query);
      }).toList();
    }

    result.sort(
          (a, b) => a.openAt.compareTo(b.openAt),
    );

    return result;
  }

  int _count(FutureMessageStatus status) {
    return widget.messages
        .where((message) => message.status == status)
        .length;
  }

  int get _lockedCount =>
      _count(FutureMessageStatus.locked);

  int get _readyCount =>
      _count(FutureMessageStatus.ready);

  int get _openedCount =>
      _count(FutureMessageStatus.opened);

  @override
  Widget build(BuildContext context) {
    final messages = _filteredMessages;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _FutureMessagesBackground(),
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
                _buildHero(),
                _buildInsights(),
                _buildSectionHeader(),
                _buildFilters(),
                _buildSearch(),

                if (messages.isEmpty)
                  _buildEmptyState()
                else
                  _buildMessages(messages),
              ],
            ),
          ),

          if (widget.onCreateMessage != null)
            _buildBottomAction(),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// TOP BAR
  /// -------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        8,
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
                  'FUTURE MESSAGES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Messages for another day.',
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
            icon: Icons.more_horiz_rounded,
            onTap: () {
              _showMoreSheet(context);
            },
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// HERO
  /// -------------------------------------------------------------------------

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        18,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final value = Curves.easeOut.transform(
            _animationController.value,
          );

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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            22,
            22,
            22,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF765457),
                Color(0xFF946B70),
                Color(0xFF6B4D50),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -35,
                top: -45,
                child: Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.06,
                    ),
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
                    color: const Color(0xFFF6D9DC)
                        .withValues(alpha: 0.08),
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
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.13,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.14,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'JUST BETWEEN TODAY & TOMORROW',
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.35,
                          color: Colors.white.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Some words are meant\nto wait for us.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 27,
                      height: 1.12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Write something now. Let SIMI keep it safe '
                        'until the right moment.',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: Colors.white.withValues(
                        alpha: 0.76,
                      ),
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      _HeroMiniStat(
                        value: '${widget.messages.length}',
                        label: 'capsules',
                      ),
                      const SizedBox(width: 22),
                      _HeroMiniStat(
                        value: '❤️',
                        label: 'just ours',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// INSIGHTS
  /// -------------------------------------------------------------------------

  Widget _buildInsights() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        25,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          18,
          16,
          18,
          15,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.50,
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR TIME CAPSULES',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _InsightItem(
                    value: '$_lockedCount',
                    label: 'Locked',
                    icon: Icons.lock_outline_rounded,
                  ),
                ),
                _VerticalDivider(),
                Expanded(
                  child: _InsightItem(
                    value: '$_readyCount',
                    label: 'Ready',
                    icon: Icons.mark_email_unread_outlined,
                  ),
                ),
                _VerticalDivider(),
                Expanded(
                  child: _InsightItem(
                    value: '$_openedCount',
                    label: 'Opened',
                    icon: Icons.favorite_border_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// SECTION HEADER
  /// -------------------------------------------------------------------------

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR LITTLE CAPSULES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.7,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Waiting for the right moment.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// FILTERS
  /// -------------------------------------------------------------------------

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          4,
        ),
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.auto_awesome_rounded,
            selected: _selectedFilter == null,
            onTap: () {
              setState(() {
                _selectedFilter = null;
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterChip(
            label: 'Locked',
            icon: Icons.lock_outline_rounded,
            count: _lockedCount,
            selected:
            _selectedFilter ==
                FutureMessageStatus.locked,
            onTap: () {
              setState(() {
                _selectedFilter =
                    FutureMessageStatus.locked;
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterChip(
            label: 'Ready',
            icon: Icons.mark_email_unread_outlined,
            count: _readyCount,
            selected:
            _selectedFilter ==
                FutureMessageStatus.ready,
            onTap: () {
              setState(() {
                _selectedFilter =
                    FutureMessageStatus.ready;
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterChip(
            label: 'Opened',
            icon: Icons.favorite_border_rounded,
            count: _openedCount,
            selected:
            _selectedFilter ==
                FutureMessageStatus.opened,
            onTap: () {
              setState(() {
                _selectedFilter =
                    FutureMessageStatus.opened;
              });
            },
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// SEARCH
  /// -------------------------------------------------------------------------

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        16,
      ),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.48,
            ),
          ),
        ),
        child: TextField(
          controller: _searchController,
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
            hintText: 'Search your capsules...',
            hintStyle: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textDisabled,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 19,
              color: AppColors.textSecondary,
            ),
            suffixIcon: _searchQuery.isEmpty
                ? null
                : GestureDetector(
              onTap: () {
                _searchController.clear();

                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// MESSAGE LIST
  /// -------------------------------------------------------------------------

  Widget _buildMessages(
      List<FutureMessageItem> messages,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          for (int index = 0;
          index < messages.length;
          index++)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: _AnimatedEntry(
                index: index,
                controller: _animationController,
                child: _FutureMessageCard(
                  message: messages[index],
                  onTap: () {
                    widget.onMessageTap?.call(
                      messages[index],
                    );
                  },
                  onFavorite: () {
                    widget.onFavoriteChanged?.call(
                      messages[index],
                    );
                  },
                  onMore: () {
                    widget.onMore?.call(
                      messages[index],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// EMPTY STATE
  /// -------------------------------------------------------------------------

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        40,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          24,
          32,
          24,
          32,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.45,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_unread_outlined,
                size: 31,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              isSearching
                  ? 'Nothing found.'
                  : 'Nothing is waiting yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              isSearching
                  ? 'Try another little word.'
                  : 'Write something today that you want '
                  'your future selves to discover.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),

            if (!isSearching &&
                widget.onCreateMessage != null) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: widget.onCreateMessage,
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Create your first capsule',
                        style: AppTextTheme.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// BOTTOM CTA
  /// -------------------------------------------------------------------------

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
              child: GestureDetector(
                onTap: widget.onCreateMessage,
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
                          alpha: 0.22,
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
                        ),
                        child: const Icon(
                          Icons.mark_email_unread_outlined,
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
                              'Create a Time Capsule',
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

                            Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Color(0xFFF6D9DC),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Write something for another day',
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: AppTextTheme
                                        .labelSmall
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

                      Container(
                        width: 42,
                        height: 42,
                        margin:
                        const EdgeInsets.only(right: 4),
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
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// MORE SHEET
  /// -------------------------------------------------------------------------

  void _showMoreSheet(BuildContext context) {
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

              Text(
                'Future Messages',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'A few things kept safe for another day.',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              _SheetAction(
                icon: Icons.settings_outlined,
                title: 'Future Message Settings',
                subtitle: 'Notifications and privacy',
                onTap: () {
                  Navigator.pop(sheetContext);
                  // Connect settings route later.
                },
              ),

              const SizedBox(height: 10),

              _SheetAction(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle: 'Your capsules are just between us',
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// FUTURE MESSAGE CARD
/// ---------------------------------------------------------------------------

class _FutureMessageCard extends StatelessWidget {
  const _FutureMessageCard({
    required this.message,
    this.onTap,
    this.onFavorite,
    this.onMore,
  });

  final FutureMessageItem message;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final isLocked =
        message.status == FutureMessageStatus.locked;

    final isReady =
        message.status == FutureMessageStatus.ready;

    final isOpened =
        message.status == FutureMessageStatus.opened;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.45,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            if (message.image != null)
              _CardImage(
                image: message.image!,
                opened: isOpened,
              )
            else
              _CardArtwork(
                status: message.status,
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                15,
                16,
                15,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatusPill(
                        status: message.status,
                      ),

                      const Spacer(),

                      if (onFavorite != null)
                        GestureDetector(
                          onTap: onFavorite,
                          child: Icon(
                            message.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: message.isFavorite
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),

                      if (onMore != null) ...[
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: onMore,
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            size: 18,
                            color:
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 11),

                  Text(
                    message.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      height: 1.18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    message.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (isLocked)
                    _LockedMeta(message: message),

                  if (isReady)
                    _ReadyMeta(message: message),

                  if (isOpened)
                    _OpenedMeta(message: message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CARD ARTWORK
/// ---------------------------------------------------------------------------

class _CardArtwork extends StatelessWidget {
  const _CardArtwork({
    required this.status,
  });

  final FutureMessageStatus status;

  @override
  Widget build(BuildContext context) {
    final isReady =
        status == FutureMessageStatus.ready;

    final isOpened =
        status == FutureMessageStatus.opened;

    return SizedBox(
      height: 142,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isOpened
                    ? const [
                  Color(0xFFE8B4B8),
                  Color(0xFFF7E4E6),
                ]
                    : isReady
                    ? const [
                  Color(0xFFE9DDE0),
                  Color(0xFFF8EEF0),
                ]
                    : const [
                  Color(0xFFF3E5E5),
                  Color(0xFFF9EFED),
                ],
              ),
            ),
          ),

          Positioned(
            left: -25,
            top: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.30,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: -30,
            bottom: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.25,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.72,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.04,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              isReady
                  ? Icons.mark_email_unread_outlined
                  : isOpened
                  ? Icons.favorite_rounded
                  : Icons.lock_outline_rounded,
              size: 28,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// IMAGE
/// ---------------------------------------------------------------------------

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.image,
    required this.opened,
  });

  final ImageProvider image;
  final bool opened;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: image,
            fit: BoxFit.cover,
          ),

          if (!opened)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: Container(
                color: Colors.white.withValues(
                  alpha: 0.12,
                ),
              ),
            ),

          Positioned(
            left: 14,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.28,
                ),
                borderRadius:
                BorderRadius.circular(999),
              ),
              child: Icon(
                opened
                    ? Icons.photo_outlined
                    : Icons.lock_outline_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// STATUS PILL
/// ---------------------------------------------------------------------------

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.status,
  });

  final FutureMessageStatus status;

  @override
  Widget build(BuildContext context) {
    late String label;
    late IconData icon;
    late Color background;
    late Color foreground;

    switch (status) {
      case FutureMessageStatus.locked:
        label = 'LOCKED';
        icon = Icons.lock_outline_rounded;
        background = const Color(0xFFF5E9E8);
        foreground = AppColors.primary;
        break;

      case FutureMessageStatus.ready:
        label = 'READY TO OPEN';
        icon = Icons.mark_email_unread_outlined;
        background = const Color(0xFFEDE7EE);
        foreground = AppColors.secondary;
        break;

      case FutureMessageStatus.opened:
        label = 'OPENED';
        icon = Icons.favorite_border_rounded;
        background = const Color(0xFFFCE4EC);
        foreground = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: foreground,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// LOCKED META
/// ---------------------------------------------------------------------------

class _LockedMeta extends StatelessWidget {
  const _LockedMeta({
    required this.message,
  });

  final FutureMessageItem message;

  @override
  Widget build(BuildContext context) {
    final remaining =
    message.openAt.difference(DateTime.now());

    final days = remaining.inDays.clamp(0, 9999);

    return Row(
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 13,
          color: AppColors.primary,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            days > 0
                ? 'OPENS IN $days ${days == 1 ? 'DAY' : 'DAYS'}'
                : 'OPENS SOON',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: AppColors.primary,
            ),
          ),
        ),
        const Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// READY META
/// ---------------------------------------------------------------------------

class _ReadyMeta extends StatelessWidget {
  const _ReadyMeta({
    required this.message,
  });

  final FutureMessageItem message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            'WAITING FOR YOU',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppColors.primary,
            ),
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 11,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// OPENED META
/// ---------------------------------------------------------------------------

class _OpenedMeta extends StatelessWidget {
  const _OpenedMeta({
    required this.message,
  });

  final FutureMessageItem message;

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.favorite_border_rounded,
          size: 13,
          color: AppColors.primary,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            'OPENED ${_formatDate(message.openAt).toUpperCase()}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.45,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 10,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// FILTER CHIP
/// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white.withValues(
            alpha: 0.76,
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 5),
              Text(
                '$count',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white.withValues(
                    alpha: 0.72,
                  )
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// INSIGHT ITEM
/// ---------------------------------------------------------------------------

class _InsightItem extends StatelessWidget {
  const _InsightItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: AppColors.outlineVariant.withValues(
        alpha: 0.45,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// HERO MINI STAT
/// ---------------------------------------------------------------------------

class _HeroMiniStat extends StatelessWidget {
  const _HeroMiniStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: Colors.white.withValues(
              alpha: 0.62,
            ),
          ),
        ),
      ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
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
    );
  }
}

/// ---------------------------------------------------------------------------
/// SHEET
/// ---------------------------------------------------------------------------

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
            color: AppColors.outlineVariant.withValues(
              alpha: 0.45,
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
              child: Icon(
                icon,
                size: 19,
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
                    title,
                    style:
                    AppTextTheme.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// ANIMATION
/// ---------------------------------------------------------------------------

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
    final start = (index * 0.08).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.0, 1.0);

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
      child: child,
    );
  }
}

/// ---------------------------------------------------------------------------
/// BACKGROUND
/// ---------------------------------------------------------------------------

class _FutureMessagesBackground extends StatelessWidget {
  const _FutureMessagesBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _BlurCircle(
              size: 210,
              color: const Color(0xFFE8B4B8),
            ),
          ),
          Positioned(
            top: 310,
            left: -110,
            child: _BlurCircle(
              size: 230,
              color: const Color(0xFFDCD9E8),
            ),
          ),
          Positioned(
            bottom: 120,
            right: -90,
            child: _BlurCircle(
              size: 190,
              color: const Color(0xFFF1D9DC),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 35,
        sigmaY: 35,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}