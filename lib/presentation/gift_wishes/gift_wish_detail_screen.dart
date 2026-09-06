import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'gift_wishes_home_screen.dart';

class GiftWishDetailScreen extends StatefulWidget {
  const GiftWishDetailScreen({
    super.key,
    required this.wish,
    this.onBack,
    this.onEdit,
    this.onDelete,
    this.onFavoriteChanged,
    this.onMarkAsPlanned,
    this.onMarkAsGifted,
  });

  final GiftWishItem wish;

  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onFavoriteChanged;
  final VoidCallback? onMarkAsPlanned;
  final VoidCallback? onMarkAsGifted;

  @override
  State<GiftWishDetailScreen> createState() =>
      _GiftWishDetailScreenState();
}

class _GiftWishDetailScreenState
    extends State<GiftWishDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _isFavorite;

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.wish.isFavorite;

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

  String get _priorityLabel {
    switch (widget.wish.priority) {
      case GiftWishPriority.thought:
        return 'JUST A THOUGHT';

      case GiftWishPriority.wouldLove:
        return 'WOULD LOVE';

      case GiftWishPriority.reallyWant:
        return 'REALLY WANT';
    }
  }

  String get _statusLabel {
    switch (widget.wish.status) {
      case GiftWishStatus.wished:
        return 'Wished';

      case GiftWishStatus.planned:
        return 'Planned';

      case GiftWishStatus.gifted:
        return 'Gifted';
    }
  }

  String get _ownerLabel {
    switch (widget.wish.owner) {
      case GiftWishOwner.me:
        return 'My wish';

      case GiftWishOwner.love:
        return "Love's wish";
    }
  }

  IconData get _statusIcon {
    switch (widget.wish.status) {
      case GiftWishStatus.wished:
        return Icons.favorite_border_rounded;

      case GiftWishStatus.planned:
        return Icons.event_available_outlined;

      case GiftWishStatus.gifted:
        return Icons.card_giftcard_rounded;
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    widget.onFavoriteChanged?.call(_isFavorite);
  }

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _WishOptionsSheet(
          wish: widget.wish,
          onEdit: () {
            Navigator.pop(sheetContext);
            widget.onEdit?.call();
          },
          onDelete: () {
            Navigator.pop(sheetContext);
            _confirmDelete();
          },
          onMarkAsPlanned: widget.onMarkAsPlanned == null
              ? null
              : () {
            Navigator.pop(sheetContext);
            widget.onMarkAsPlanned?.call();
          },
          onMarkAsGifted: widget.onMarkAsGifted == null
              ? null
              : () {
            Navigator.pop(sheetContext);
            widget.onMarkAsGifted?.call();
          },
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            'Let this wish go?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This little wish will be removed from your collection.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Keep it',
                style: AppTextTheme.labelLarge.copyWith(
                  color: AppColors.primary,
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
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _DetailBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(),
              ),

              SliverToBoxAdapter(
                child: _buildHero(),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  130,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.10,
                        child: _buildWishIdentity(),
                      ),

                      const SizedBox(height: 18),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.18,
                        child: _buildStatusCard(),
                      ),

                      const SizedBox(height: 18),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.26,
                        child: _buildDescription(),
                      ),

                      if (widget.wish.price != null) ...[
                        const SizedBox(height: 18),
                        _AnimatedEntry(
                          controller: _animationController,
                          delay: 0.34,
                          child: _buildPriceCard(),
                        ),
                      ],

                      const SizedBox(height: 18),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.42,
                        child: _buildDetails(),
                      ),

                      if (widget.wish.note != null &&
                          widget.wish.note!.trim().isNotEmpty) ...[
                        const SizedBox(height: 18),
                        _AnimatedEntry(
                          controller: _animationController,
                          delay: 0.50,
                          child: _buildPrivateNote(),
                        ),
                      ],

                      const SizedBox(height: 24),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.58,
                        child: _buildFooterMessage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          _buildBottomBar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ?? () => Navigator.pop(context),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                children: [
                  Text(
                    'GIFT WISHES',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A little wish',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            _CircleButton(
              icon: Icons.more_horiz_rounded,
              onTap: _showOptions,
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
    final image = widget.wish.image;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 620,
          ),
          child: Container(
            height: 330,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF2D2526),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image != null)
                  Image(
                    image: image,
                    fit: BoxFit.cover,
                  )
                else
                  const _WishHeroArtwork(),

                if (image != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.06),
                          Colors.black.withValues(alpha: 0.18),
                          Colors.black.withValues(alpha: 0.82),
                        ],
                      ),
                    ),
                  ),

                Positioned(
                  top: 18,
                  left: 18,
                  child: _HeroPill(
                    icon: _statusIcon,
                    label: _statusLabel.toUpperCase(),
                  ),
                ),

                Positioned(
                  top: 18,
                  right: 18,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: _isFavorite
                                ? const Color(0xFFF6C7CC)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _priorityLabel,
                        style: AppTextTheme.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        widget.wish.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          height: 1.08,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Wished on ${_formatDate(widget.wish.addedAt)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.labelSmall.copyWith(
                                fontSize: 10,
                                color: Colors.white.withValues(
                                  alpha: 0.70,
                                ),
                              ),
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
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // IDENTITY
  // ---------------------------------------------------------------------------

  Widget _buildWishIdentity() {
    return Row(
      children: [
        _SoftIcon(
          icon: Icons.card_giftcard_outlined,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _ownerLabel,
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.wish.category,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _CategoryPill(
          label: widget.wish.category,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS
  // ---------------------------------------------------------------------------

  Widget _buildStatusCard() {
    return _ContentCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon,
              size: 20,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This wish is',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _statusLabel,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          if (widget.wish.status != GiftWishStatus.gifted)
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESCRIPTION
  // ---------------------------------------------------------------------------

  Widget _buildDescription() {
    if (widget.wish.description.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return _ContentCard(
      padding: const EdgeInsets.fromLTRB(18, 19, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            eyebrow: 'WHY I WANT IT',
            icon: Icons.favorite_border_rounded,
          ),
          const SizedBox(height: 13),
          Text(
            widget.wish.description,
            style: GoogleFonts.playfairDisplay(
              fontSize: 19,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRICE
  // ---------------------------------------------------------------------------

  Widget _buildPriceCard() {
    final price = widget.wish.price!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF302728),
            Color(0xFF4A383A),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '₹',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A little price tag',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.58),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Text(
            'just for reference',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.50),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DETAILS
  // ---------------------------------------------------------------------------

  Widget _buildDetails() {
    return _ContentCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            eyebrow: 'THE LITTLE DETAILS',
            icon: Icons.auto_awesome_outlined,
          ),

          const SizedBox(height: 12),

          _DetailRow(
            icon: Icons.folder_outlined,
            label: 'Category',
            value: widget.wish.category,
          ),

          _DetailRow(
            icon: Icons.favorite_border_rounded,
            label: 'Priority',
            value: _priorityLabel.toLowerCase(),
          ),

          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'For',
            value: _ownerLabel,
          ),

          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Added',
            value: _formatDate(widget.wish.addedAt),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NOTE
  // ---------------------------------------------------------------------------

  Widget _buildPrivateNote() {
    return Container(
      padding: const EdgeInsets.fromLTRB(19, 20, 19, 21),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0EF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'A little note',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            widget.wish.note!,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 13,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FOOTER
  // ---------------------------------------------------------------------------

  Widget _buildFooterMessage() {
    return Column(
      children: [
        const Icon(
          Icons.favorite_rounded,
          size: 17,
          color: Color(0xFFE8B4B8),
        ),
        const SizedBox(height: 9),
        Text(
          'Maybe someday…',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'The sweetest gifts are the ones remembered.',
          textAlign: TextAlign.center,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (widget.wish.status ==
                        GiftWishStatus.wished) {
                      widget.onMarkAsPlanned?.call();
                    } else if (widget.wish.status ==
                        GiftWishStatus.planned) {
                      widget.onMarkAsGifted?.call();
                    }
                  },
                  borderRadius: BorderRadius.circular(29),
                  splashColor: Colors.white.withValues(
                    alpha: 0.12,
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
                          ),
                          child: Icon(
                            widget.wish.status ==
                                GiftWishStatus.wished
                                ? Icons.event_available_outlined
                                : widget.wish.status ==
                                GiftWishStatus.planned
                                ? Icons.card_giftcard_rounded
                                : Icons.favorite_rounded,
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
                                widget.wish.status ==
                                    GiftWishStatus.wished
                                    ? 'Keep this in mind'
                                    : widget.wish.status ==
                                    GiftWishStatus.planned
                                    ? 'Mark as gifted'
                                    : 'This one was remembered',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.wish.status ==
                                    GiftWishStatus.gifted
                                    ? 'A little wish, remembered with love'
                                    : 'Move this wish one step closer',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.labelSmall.copyWith(
                                  fontSize: 9.5,
                                  color: Colors.white.withValues(
                                    alpha: 0.70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(right: 4),
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
      ),
    );
  }
}

// =============================================================================
// OPTIONS SHEET
// =============================================================================

class _WishOptionsSheet extends StatelessWidget {
  const _WishOptionsSheet({
    required this.wish,
    this.onEdit,
    this.onDelete,
    this.onMarkAsPlanned,
    this.onMarkAsGifted,
  });

  final GiftWishItem wish;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkAsPlanned;
  final VoidCallback? onMarkAsGifted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          20,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),

              const SizedBox(height: 22),

              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wish options',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          wish.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              if (wish.status ==
                  GiftWishStatus.wished &&
                  onMarkAsPlanned != null)
                _SheetAction(
                  icon: Icons.event_available_outlined,
                  title: 'Plan this wish',
                  subtitle: 'Move it from a wish to a plan.',
                  onTap: onMarkAsPlanned!,
                ),

              if (wish.status ==
                  GiftWishStatus.planned &&
                  onMarkAsGifted != null)
                _SheetAction(
                  icon: Icons.card_giftcard_rounded,
                  title: 'Mark as gifted',
                  subtitle: 'Keep the moment you made it happen.',
                  onTap: onMarkAsGifted!,
                ),

              if (onEdit != null)
                _SheetAction(
                  icon: Icons.edit_outlined,
                  title: 'Edit wish',
                  subtitle: 'Change the little details.',
                  onTap: onEdit!,
                ),

              if (onDelete != null)
                _SheetAction(
                  icon: Icons.delete_outline_rounded,
                  title: 'Remove wish',
                  subtitle: 'Let this one go.',
                  destructive: true,
                  onTap: onDelete!,
                ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SMALL COMPONENTS
// =============================================================================

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.45,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 420,
            left: -100,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9F2).withValues(
                  alpha: 0.45,
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

class _WishHeroArtwork extends StatelessWidget {
  const _WishHeroArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF282021),
            Color(0xFF4A3638),
            Color(0xFF6A4C50),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.09,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 48,
                color: Color(0xFFF4D7DA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 150,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
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
              Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.60,
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
      child: child,
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 130,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1F0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextTheme.labelSmall.copyWith(
          fontSize: 9,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.eyebrow,
    required this.icon,
  });

  final String eyebrow;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          eyebrow,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.primary,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextTheme.labelLarge.copyWith(
                fontSize: 11,
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
      color: Colors.white.withValues(alpha: 0.78),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
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
        ? const Color(0xFF9C5B61)
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: destructive
                  ? const Color(0xFFFFF4F4)
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: destructive
                    ? const Color(0xFFF0D5D7)
                    : AppColors.outlineVariant.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: destructive
                        ? const Color(0xFFFBE4E6)
                        : const Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
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
                          fontSize: 12,
                          color: destructive
                              ? const Color(0xFF8D4C53)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 9.5,
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
        ),
      ),
    );
  }
}

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
    this.delay = 0,
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
        1,
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
              14 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}