import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'vault_feature_screen.dart';

class VaultItemDetailScreen extends StatefulWidget {
  const VaultItemDetailScreen({
    super.key,
    required this.type,
    required this.item,
    this.onBack,
    this.onMore,
    this.onFavorite,
    this.onDelete,
    this.onOpen,
  });

  final VaultFeatureType type;
  final VaultFeatureItem item;

  final VoidCallback? onBack;
  final VoidCallback? onMore;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;
  final VoidCallback? onOpen;

  @override
  State<VaultItemDetailScreen> createState() =>
      _VaultItemDetailScreenState();
}

class _VaultItemDetailScreenState
    extends State<VaultItemDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  bool _favorite = false;

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

  bool get _isMedia =>
      widget.type == VaultFeatureType.photos ||
          widget.type == VaultFeatureType.videos;

  String get _typeLabel {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'PRIVATE MEMORY';
      case VaultFeatureType.privateChat:
        return 'PRIVATE CONVERSATION';
      case VaultFeatureType.specialDates:
        return 'SPECIAL DATE';
      case VaultFeatureType.giftWishes:
        return 'GIFT WISH';
      case VaultFeatureType.futureMessages:
        return 'FUTURE MESSAGE';
      case VaultFeatureType.loveNotifications:
        return 'LOVE NOTE';
      case VaultFeatureType.photos:
        return 'PRIVATE PHOTO';
      case VaultFeatureType.videos:
        return 'PRIVATE VIDEO';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return Icons.auto_stories_outlined;
      case VaultFeatureType.privateChat:
        return Icons.forum_outlined;
      case VaultFeatureType.specialDates:
        return Icons.event_outlined;
      case VaultFeatureType.giftWishes:
        return Icons.card_giftcard_outlined;
      case VaultFeatureType.futureMessages:
        return Icons.mail_outline_rounded;
      case VaultFeatureType.loveNotifications:
        return Icons.favorite_border_rounded;
      case VaultFeatureType.photos:
        return Icons.photo_outlined;
      case VaultFeatureType.videos:
        return Icons.videocam_outlined;
    }
  }

  String get _bottomActionLabel {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'Keep this close';
      case VaultFeatureType.privateChat:
        return 'Open conversation';
      case VaultFeatureType.specialDates:
        return 'Keep this date';
      case VaultFeatureType.giftWishes:
        return 'Keep on wishlist';
      case VaultFeatureType.futureMessages:
        return 'Read message';
      case VaultFeatureType.loveNotifications:
        return 'Keep this note';
      case VaultFeatureType.photos:
        return 'Keep this photo';
      case VaultFeatureType.videos:
        return 'Watch video';
    }
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
                child: _buildTopBar(context),
              ),

              SliverToBoxAdapter(
                child: _AnimatedEntry(
                  controller: _animationController,
                  child: _buildPrivateHeader(),
                ),
              ),

              SliverToBoxAdapter(
                child: _AnimatedEntry(
                  controller: _animationController,
                  delay: 0.10,
                  child: _buildHero(),
                ),
              ),

              SliverToBoxAdapter(
                child: _AnimatedEntry(
                  controller: _animationController,
                  delay: 0.18,
                  child: _buildTitleSection(),
                ),
              ),

              SliverToBoxAdapter(
                child: _AnimatedEntry(
                  controller: _animationController,
                  delay: 0.26,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      24,
                      20,
                      140,
                    ),
                    child: _buildTypeSpecificContent(),
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

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ?? () => Navigator.of(context).pop(),
            ),

            const Spacer(),

            Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  'PRIVATE VAULT',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const Spacer(),

            _CircleButton(
              icon: Icons.more_horiz_rounded,
              onTap: () => _showOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIVATE HEADER
  // ---------------------------------------------------------------------------

  Widget _buildPrivateHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF322F2E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _typeLabel,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Just between us.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HERO
  // ---------------------------------------------------------------------------

  Widget _buildHero() {
    if (_isMedia && widget.item.image != null) {
      return _buildImageHero();
    }

    if (widget.type == VaultFeatureType.memories &&
        widget.item.image != null) {
      return _buildImageHero();
    }

    return _buildEditorialHero();
  }

  Widget _buildImageHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: AspectRatio(
        aspectRatio: 1.08,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image(
                image: widget.item.image!,
                fit: BoxFit.cover,
              ),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [
                      0,
                      0.45,
                      1,
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 16,
                right: 16,
                child: _GlassLock(),
              ),

              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.dateLabel,
                        style: AppTextTheme.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 10,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (widget.type == VaultFeatureType.videos)
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.30),
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 23,
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

  Widget _buildEditorialHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Container(
        width: double.infinity,
        height: 230,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF171515),
              Color(0xFF302727),
              Color(0xFF3C2D2F),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: -35,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8B4B8).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 25,
              bottom: 20,
              child: Icon(
                _icon,
                size: 100,
                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Icon(
                      _icon,
                      color: const Color(0xFFE8B4B8),
                      size: 22,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    _typeLabel,
                    style: AppTextTheme.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 9,
                      letterSpacing: 1.7,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'A little piece\nof us.',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 18,
              top: 18,
              child: _GlassLock(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TITLE
  // ---------------------------------------------------------------------------

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.item.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 29,
                    height: 1.12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _favorite = !_favorite;
                  });

                  widget.onFavorite?.call();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _favorite
                        ? const Color(0xFFFCE4EC)
                        : Colors.white.withValues(alpha: 0.78),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                  child: Icon(
                    _favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 19,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            widget.item.subtitle,
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 12,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                widget.item.dateLabel,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TYPE SPECIFIC CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildTypeSpecificContent() {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return _buildMemoryContent();

      case VaultFeatureType.privateChat:
        return _buildChatContent();

      case VaultFeatureType.specialDates:
        return _buildSpecialDateContent();

      case VaultFeatureType.giftWishes:
        return _buildGiftContent();

      case VaultFeatureType.futureMessages:
        return _buildFutureMessageContent();

      case VaultFeatureType.loveNotifications:
        return _buildLoveNotificationContent();

      case VaultFeatureType.photos:
        return _buildPhotoContent();

      case VaultFeatureType.videos:
        return _buildVideoContent();
    }
  }

  // ---------------------------------------------------------------------------
  // MEMORY
  // ---------------------------------------------------------------------------

  Widget _buildMemoryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('THE STORY'),
        const SizedBox(height: 10),

        _ContentCard(
          child: Text(
            widget.item.description?.trim().isNotEmpty == true
                ? widget.item.description!
                : 'A moment we decided was worth keeping.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              height: 1.55,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(height: 24),

        _sectionLabel('DETAILS'),
        const SizedBox(height: 10),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: widget.item.subtitle,
            ),
            _DetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy',
              value: 'Private to both of you',
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildTags(),
        const SizedBox(height: 24),
        _buildPrivateMessage(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PRIVATE CHAT
  // ---------------------------------------------------------------------------

  Widget _buildChatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('PRIVATE CONVERSATION'),
        const SizedBox(height: 10),

        _ContentCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _ChatBubble(
                text: widget.item.description?.isNotEmpty == true
                    ? widget.item.description!
                    : 'I miss you ❤️',
                fromMe: false,
              ),
              const SizedBox(height: 10),
              const _ChatBubble(
                text: 'I miss you more.',
                fromMe: true,
              ),
              const SizedBox(height: 10),
              const _ChatBubble(
                text: 'Come here. I have something to tell you.',
                fromMe: false,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.person_outline_rounded,
              label: 'Conversation',
              value: 'Just the two of you',
            ),
            _DetailRow(
              icon: Icons.schedule_outlined,
              label: 'Last activity',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy',
              value: 'Private conversation',
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SPECIAL DATE
  // ---------------------------------------------------------------------------

  Widget _buildSpecialDateContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCountdownCard(),

        const SizedBox(height: 24),

        _sectionLabel('ABOUT THIS DAY'),
        const SizedBox(height: 10),

        _ContentCard(
          child: Text(
            widget.item.description?.isNotEmpty == true
                ? widget.item.description!
                : 'One of those dates that quietly became part of your story.',
            style: AppTextTheme.bodyLarge.copyWith(
              height: 1.55,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(height: 24),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.event_outlined,
              label: 'Date',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.favorite_border_rounded,
              label: 'Meaning',
              value: widget.item.subtitle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OUR SPECIAL DAY',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.4,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.item.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
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

  // ---------------------------------------------------------------------------
  // GIFT WISH
  // ---------------------------------------------------------------------------

  Widget _buildGiftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.80),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'SOMETHING TO REMEMBER',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              if (widget.item.description?.isNotEmpty == true) ...[
                const SizedBox(height: 10),
                Text(
                  widget.item.description!,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyMedium.copyWith(
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.add_circle_outline_rounded,
              label: 'Added',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Visibility',
              value: 'Only you two',
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // FUTURE MESSAGE
  // ---------------------------------------------------------------------------

  Widget _buildFutureMessageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F0F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.secondary,
                size: 36,
              ),

              const SizedBox(height: 15),

              Text(
                'A LETTER FROM YOU',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                widget.item.description?.isNotEmpty == true
                    ? widget.item.description!
                    : 'Open this when you need a little reminder of how much you are loved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.edit_calendar_outlined,
              label: 'Written',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.lock_clock_outlined,
              label: 'Opens',
              value: 'When its time comes',
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LOVE NOTIFICATION
  // ---------------------------------------------------------------------------

  Widget _buildLoveNotificationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCE4EC),
                Color(0xFFF8EEF0),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 28,
              ),

              const SizedBox(height: 18),

              Text(
                'A LITTLE LOVE FOR YOU',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.item.description?.isNotEmpty == true
                    ? widget.item.description!
                    : widget.item.subtitle,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.schedule_outlined,
              label: 'Received',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.favorite_border_rounded,
              label: 'From',
              value: 'Your person',
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PHOTO
  // ---------------------------------------------------------------------------

  Widget _buildPhotoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('PHOTO DETAILS'),
        const SizedBox(height: 10),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Added',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy',
              value: 'Private photo',
            ),
          ],
        ),

        if (widget.item.description?.isNotEmpty == true) ...[
          const SizedBox(height: 24),
          _sectionLabel('A NOTE'),
          const SizedBox(height: 10),
          _ContentCard(
            child: Text(
              widget.item.description!,
              style: AppTextTheme.bodyLarge.copyWith(
                height: 1.55,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // VIDEO
  // ---------------------------------------------------------------------------

  Widget _buildVideoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContentCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A moment in motion',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap play to watch this private video.',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildDetailsCard(
          [
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Added',
              value: widget.item.dateLabel,
            ),
            _DetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy',
              value: 'Private video',
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED CONTENT
  // ---------------------------------------------------------------------------

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        letterSpacing: 1.6,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildDetailsCard(List<_DetailRow> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      rows[i].icon,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rows[i].label,
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      rows[i].value,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i != rows.length - 1)
              Divider(
                height: 1,
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.45,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTags() {
    final tags = <String>[
      'Private',
      'Us',
      if (widget.type == VaultFeatureType.memories) 'Special',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('TAGS'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
              child: Text(
                '#$tag',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrivateMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF322F2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFE8B4B8),
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This stays between the two of you.',
              style: AppTextTheme.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTION
  // ---------------------------------------------------------------------------

  Widget _buildBottomBar() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 16,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 560,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  height: 62,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.80),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: widget.onOpen,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size(
                              double.infinity,
                              48,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          icon: Icon(
                            _isMedia
                                ? Icons.open_in_full_rounded
                                : _icon,
                            size: 17,
                          ),
                          label: Text(
                            _bottomActionLabel,
                            style: AppTextTheme.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      _CircleButton(
                        icon: Icons.more_horiz_rounded,
                        onTap: () {},
                      ),
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

  // ---------------------------------------------------------------------------
  // OPTIONS
  // ---------------------------------------------------------------------------

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
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
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Keep this moment close',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Private actions for this item.',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              _SheetAction(
                icon: Icons.favorite_border_rounded,
                title: 'Keep close',
                subtitle: 'Add this to your favorites',
                onTap: () {
                  Navigator.pop(sheetContext);
                  setState(() {
                    _favorite = true;
                  });
                  widget.onFavorite?.call();
                },
              ),

              _SheetAction(
                icon: Icons.share_outlined,
                title: 'Share',
                subtitle: 'Share this private item',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showComingSoon(context, 'Private sharing');
                },
              ),

              _SheetAction(
                icon: Icons.delete_outline_rounded,
                title: 'Remove from vault',
                subtitle: 'Move this item out of Private Vault',
                destructive: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(context);
                },
              ),

              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

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
            'Remove from vault?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'This will remove the item from your private vault.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Keep'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(
      BuildContext context,
      String feature,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be connected next.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// =============================================================================
// SUPPORTING WIDGETS
// =============================================================================

class _DetailRow {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
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
      color: Colors.white.withValues(alpha: 0.76),
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

class _GlassLock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
        ),
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: child,
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.fromMe,
  });

  final String text;
  final bool fromMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 270,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: fromMe
              ? AppColors.primary
              : const Color(0xFFF2EEEC),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(17),
            topRight: const Radius.circular(17),
            bottomLeft: Radius.circular(fromMe ? 17 : 4),
            bottomRight: Radius.circular(fromMe ? 4 : 17),
          ),
        ),
        child: Text(
          text,
          style: AppTextTheme.bodyMedium.copyWith(
            color: fromMe
                ? Colors.white
                : AppColors.textPrimary,
            height: 1.4,
          ),
        ),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 3,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: destructive
              ? const Color(0xFFFFEEEE)
              : const Color(0xFFFCE4EC),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: destructive
              ? Colors.red.shade400
              : AppColors.primary,
          size: 19,
        ),
      ),
      title: Text(
        title,
        style: AppTextTheme.labelLarge.copyWith(
          color: destructive
              ? Colors.red.shade400
              : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextTheme.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 12,
        color: AppColors.textDisabled,
      ),
      onTap: onTap,
    );
  }
}

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 110,
            right: -100,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.06,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 520,
            left: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91).withValues(
                  alpha: 0.035,
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

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
    this.delay = 0,
  });

  final AnimationController controller;
  final Widget child;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        0.75 + delay * 0.25,
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