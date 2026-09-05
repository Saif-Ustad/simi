import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PrivateVaultHomeScreen extends StatefulWidget {
  const PrivateVaultHomeScreen({
    super.key,

    // Insights
    this.memoriesCount = 0,
    this.privateChatsCount = 0,
    this.specialDatesCount = 0,
    this.giftWishesCount = 0,
    this.futureMessagesCount = 0,
    this.loveNotificationsCount = 0,
    this.photosCount = 0,
    this.videosCount = 0,

    // Navigation
    this.onBack,
    this.onLock,
    this.onSettings,

    this.onMemoriesTap,
    this.onPrivateChatTap,
    this.onSpecialDatesTap,
    this.onGiftWishesTap,
    this.onFutureMessagesTap,
    this.onLoveNotificationsTap,
    this.onPhotosTap,
    this.onVideosTap,

    this.onAddToVault,
  });

  final int memoriesCount;
  final int privateChatsCount;
  final int specialDatesCount;
  final int giftWishesCount;
  final int futureMessagesCount;
  final int loveNotificationsCount;
  final int photosCount;
  final int videosCount;

  final VoidCallback? onBack;
  final VoidCallback? onLock;
  final VoidCallback? onSettings;

  final VoidCallback? onMemoriesTap;
  final VoidCallback? onPrivateChatTap;
  final VoidCallback? onSpecialDatesTap;
  final VoidCallback? onGiftWishesTap;
  final VoidCallback? onFutureMessagesTap;
  final VoidCallback? onLoveNotificationsTap;
  final VoidCallback? onPhotosTap;
  final VoidCallback? onVideosTap;

  final VoidCallback? onAddToVault;

  @override
  State<PrivateVaultHomeScreen> createState() =>
      _PrivateVaultHomeScreenState();
}

class _PrivateVaultHomeScreenState
    extends State<PrivateVaultHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  int get _totalItems {
    return widget.memoriesCount +
        widget.privateChatsCount +
        widget.specialDatesCount +
        widget.giftWishesCount +
        widget.futureMessagesCount +
        widget.loveNotificationsCount +
        widget.photosCount +
        widget.videosCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _VaultBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  120,
                ),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _buildHeroCard(),

                          const SizedBox(height: 20),

                          _buildTotalInsights(),

                          const SizedBox(height: 34),

                          _buildPrivateWorldHeader(),

                          const SizedBox(height: 14),

                          _buildPrivateWorld(),

                          const SizedBox(height: 34),

                          _buildPrivateMediaHeader(),

                          const SizedBox(height: 14),

                          _buildPrivateMedia(),

                          const SizedBox(height: 34),

                          _buildVaultMessage(),

                          const SizedBox(height: 18),

                          _buildSecurityInfo(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          _buildVaultSeal(),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          4,
        ),
        child: Row(
          children: [
            _VaultCircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ??
                      () => Navigator.of(context).maybePop(),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR HIDDEN WORLD',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Private Vault',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            _VaultCircleButton(
              icon: Icons.settings_outlined,
              onTap: widget.onSettings,
            ),

            const SizedBox(width: 8),

            _VaultCircleButton(
              icon: Icons.lock_outline_rounded,
              filled: true,
              onTap: widget.onLock,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHeroCard() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final value = _glowController.value;

        return Container(
          width: double.infinity,
          height: 238,
          clipBehavior: Clip.antiAlias,
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
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Large atmospheric circle.
              Positioned(
                right: -70 + (value * 10),
                top: -85,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.075),
                  ),
                ),
              ),

              // Circle outline.
              Positioned(
                right: -30,
                top: -45,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white
                          .withValues(alpha: 0.035),
                    ),
                  ),
                ),
              ),

              // Bottom decoration.
              Positioned(
                left: -80,
                bottom: -100,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE8B4B8)
                          .withValues(alpha: 0.035),
                    ),
                  ),
                ),
              ),

              // Decorative heart.
              Positioned(
                right: 55,
                top: 55,
                child: Opacity(
                  opacity: 0.30,
                  child: Transform.rotate(
                    angle: -0.18,
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 12,
                      color: Color(0xFFE8B4B8),
                    ),
                  ),
                ),
              ),

              // Main content.
              Padding(
                padding: const EdgeInsets.all(24),
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
                            color: const Color(0xFFE8B4B8)
                                .withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE8B4B8)
                                  .withValues(alpha: 0.20),
                            ),
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 20,
                            color: Color(0xFFE8B4B8),
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: 0.065),
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration:
                                const BoxDecoration(
                                  color: Color(0xFFE8B4B8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PRIVATE & LOCKED',
                                style: AppTextTheme.labelSmall
                                    .copyWith(
                                  fontSize: 7,
                                  letterSpacing: 1.1,
                                  color: Colors.white
                                      .withValues(alpha: 0.62),
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Text(
                      'JUST BETWEEN US',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        letterSpacing: 2.0,
                        color: const Color(0xFFE8B4B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'The things we\nkeep close.',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 29,
                        height: 1.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Your private memories, conversations,\\n'
                          'wishes and little moments — all in one place.',
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontSize: 10,
                        height: 1.45,
                        color: Colors.white
                            .withValues(alpha: 0.56),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // TOTAL INSIGHTS
  // ===========================================================================

  Widget _buildTotalInsights() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        17,
        18,
        15,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
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
              const Icon(
                Icons.auto_awesome_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                'TOTAL INSIGHTS',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$_totalItems protected',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child: _InsightItem(
                  icon: Icons.favorite_border_rounded,
                  value: widget.memoriesCount,
                  label: 'Memories',
                ),
              ),
              _InsightDivider(),
              Expanded(
                child: _InsightItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  value: widget.privateChatsCount,
                  label: 'Chats',
                ),
              ),
              _InsightDivider(),
              Expanded(
                child: _InsightItem(
                  icon: Icons.event_outlined,
                  value: widget.specialDatesCount,
                  label: 'Dates',
                ),
              ),
              _InsightDivider(),
              Expanded(
                child: _InsightItem(
                  icon: Icons.photo_outlined,
                  value: widget.photosCount,
                  label: 'Photos',
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            height: 1,
            color: AppColors.outlineVariant
                .withValues(alpha: 0.38),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _MiniInsight(
                value: widget.videosCount,
                label: 'videos',
              ),
              const _Dot(),
              _MiniInsight(
                value: widget.giftWishesCount,
                label: 'wishes',
              ),
              const _Dot(),
              _MiniInsight(
                value: widget.futureMessagesCount,
                label: 'future messages',
              ),
              const _Dot(),
              _MiniInsight(
                value: widget.loveNotificationsCount,
                label: 'love notes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PRIVATE WORLD
  // ===========================================================================

  Widget _buildPrivateWorldHeader() {
    return Row(
      children: [
        Text(
          'YOUR PRIVATE WORLD',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivateWorld() {
    return Column(
      children: [
        _VaultFeatureTile(
          icon: Icons.favorite_outline_rounded,
          title: 'Hidden Memories',
          subtitle: 'Memories you want to keep private',
          count: widget.memoriesCount,
          countLabel: 'memories',
          accent: const Color(0xFFE8B4B8),
          onTap: widget.onMemoriesTap,
        ),

        const SizedBox(height: 10),

        _VaultFeatureTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Private Chat',
          subtitle: 'Conversations kept just between you',
          count: widget.privateChatsCount,
          countLabel: 'conversations',
          accent: const Color(0xFF6B6D91),
          onTap: widget.onPrivateChatTap,
        ),

        const SizedBox(height: 10),

        _VaultFeatureTile(
          icon: Icons.event_outlined,
          title: 'Special Dates',
          subtitle: 'Important moments and dates',
          count: widget.specialDatesCount,
          countLabel: 'dates',
          accent: const Color(0xFFE6B89C),
          onTap: widget.onSpecialDatesTap,
        ),

        const SizedBox(height: 10),

        _VaultFeatureTile(
          icon: Icons.card_giftcard_outlined,
          title: 'Gift Wishes',
          subtitle: 'Little things you want to remember',
          count: widget.giftWishesCount,
          countLabel: 'wishes',
          accent: const Color(0xFFD8B5C8),
          onTap: widget.onGiftWishesTap,
        ),

        const SizedBox(height: 10),

        _VaultFeatureTile(
          icon: Icons.mail_outline_rounded,
          title: 'Future Messages',
          subtitle: 'Words waiting for the right moment',
          count: widget.futureMessagesCount,
          countLabel: 'messages',
          accent: const Color(0xFF9D9BB8),
          onTap: widget.onFutureMessagesTap,
        ),

        const SizedBox(height: 10),

        _VaultFeatureTile(
          icon: Icons.notifications_none_rounded,
          title: 'Love Notifications',
          subtitle: 'Private little reminders of us',
          count: widget.loveNotificationsCount,
          countLabel: 'moments',
          accent: const Color(0xFFE8B4B8),
          onTap: widget.onLoveNotificationsTap,
        ),
      ],
    );
  }

  // ===========================================================================
  // PRIVATE MEDIA
  // ===========================================================================

  Widget _buildPrivateMediaHeader() {
    return Row(
      children: [
        Text(
          'PRIVATE MEDIA',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivateMedia() {
    return Row(
      children: [
        Expanded(
          child: _MediaVaultCard(
            icon: Icons.photo_library_outlined,
            title: 'Private Photos',
            count: widget.photosCount,
            onTap: widget.onPhotosTap,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _MediaVaultCard(
            icon: Icons.video_library_outlined,
            title: 'Private Videos',
            count: widget.videosCount,
            onTap: widget.onVideosTap,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  Widget _buildVaultMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9E7)
            .withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE8B4B8)
              .withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 17,
            color: AppColors.primary,
          ),

          const SizedBox(height: 9),

          Text(
            'Some things are meant\nto stay between us.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Your private world is protected, just like the memories inside it.',
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECURITY
  // ===========================================================================

  Widget _buildSecurityInfo() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shield_outlined,
            size: 13,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Private content stays hidden until you unlock the vault.',
              textAlign: TextAlign.center,
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

  // ===========================================================================
  // ADD BUTTON
  // ===========================================================================

  Widget _buildVaultSeal() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 18,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onAddToVault,
                borderRadius: BorderRadius.circular(28),
                child: Ink(
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF171515),
                        Color(0xFF302727),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),

                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SEAL SOMETHING',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Keep it just between us',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.58),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 38,
                        height: 38,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
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
}

// =============================================================================
// FEATURE TILE
// =============================================================================

class _VaultFeatureTile extends StatelessWidget {
  const _VaultFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.countLabel,
    required this.accent,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int count;
  final String countLabel;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
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
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
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
                        fontSize: 8.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$count',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    countLabel,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 7,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 9),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MEDIA CARD
// =============================================================================

class _MediaVaultCard extends StatelessWidget {
  const _MediaVaultCard({
    required this.icon,
    required this.title,
    required this.count,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          height: 135,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF3E8E5),
                Color(0xFFEFE1DF),
              ],
            ),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),

              const Spacer(),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '$count private items',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.textSecondary,
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
// INSIGHT ITEM
// =============================================================================

class _InsightItem extends StatelessWidget {
  const _InsightItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),
        const SizedBox(height: 5),
        Text(
          '$value',
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
            fontSize: 8,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _InsightDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 31,
      color: AppColors.outlineVariant
          .withValues(alpha: 0.55),
    );
  }
}

// =============================================================================
// MINI INSIGHT
// =============================================================================

class _MiniInsight extends StatelessWidget {
  const _MiniInsight({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextSpan(
              text: label,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 7.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: AppColors.outlineVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _VaultCircleButton extends StatelessWidget {
  const _VaultCircleButton({
    required this.icon,
    this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.80),
            border: filled
                ? null
                : Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.55),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: filled
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _VaultBackground extends StatelessWidget {
  const _VaultBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -90,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.055),
              ),
            ),
          ),

          Positioned(
            top: 450,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.025),
              ),
            ),
          ),
        ],
      ),
    );
  }
}