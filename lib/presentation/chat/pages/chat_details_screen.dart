import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'love_chat_screen.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({
    super.key,
    required this.chat,
    this.partnerName = 'Love',
    this.createdAt,
    this.onBack,
    this.onFavoriteChanged,
    this.onRename,
    this.onArchive,
    this.onClearMessages,
    this.onDelete,
  });

  final LoveChatItem chat;

  final String partnerName;
  final DateTime? createdAt;

  final VoidCallback? onBack;
  final ValueChanged<bool>? onFavoriteChanged;
  final ValueChanged<String>? onRename;
  final VoidCallback? onArchive;
  final VoidCallback? onClearMessages;
  final VoidCallback? onDelete;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _isFavorite;
  late String _title;

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.chat.isFavorite;
    _title = widget.chat.title;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  String _formatShortDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    widget.onFavoriteChanged?.call(_isFavorite);
  }

  Future<void> _showRenameDialog() async {
    final newTitle = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return _RenameChatDialog(
          initialTitle: _title,
        );
      },
    );

    if (!mounted || newTitle == null) return;

    final trimmedTitle = newTitle.trim();

    if (trimmedTitle.isEmpty || trimmedTitle == _title) {
      return;
    }

    setState(() {
      _title = trimmedTitle;
    });

    widget.onRename?.call(trimmedTitle);
  }

  void _showClearConfirmation() {
    _showConfirmationSheet(
      icon: Icons.cleaning_services_outlined,
      title: 'Clear messages?',
      description:
      'The conversation itself will stay here, but all of its messages will be removed.',
      actionLabel: 'Clear messages',
      destructive: true,
      onConfirm: widget.onClearMessages,
    );
  }

  void _showDeleteConfirmation() {
    _showConfirmationSheet(
      icon: Icons.delete_outline_rounded,
      title: 'Delete this conversation?',
      description:
      'This will remove this conversation and everything inside it.',
      actionLabel: 'Delete conversation',
      destructive: true,
      onConfirm: widget.onDelete,
    );
  }

  void _showConfirmationSheet({
    required IconData icon,
    required String title,
    required String description,
    required String actionLabel,
    required bool destructive,
    VoidCallback? onConfirm,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
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

              const SizedBox(height: 22),

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: destructive
                      ? const Color(0xFFFBE9EB)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: destructive
                      ? const Color(0xFFB45E68)
                      : AppColors.primary,
                  size: 25,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    onConfirm?.call();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: destructive
                        ? const Color(0xFFB45E68)
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    actionLabel,
                    style: AppTextTheme.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 7),

              TextButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: Text(
                  'Keep it',
                  style: AppTextTheme.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _MoreOptionsSheet(
          onRename: () {
            Navigator.pop(sheetContext);
            _showRenameDialog();
          },
          onArchive: () {
            Navigator.pop(sheetContext);
            widget.onArchive?.call();
          },
          onClear: () {
            Navigator.pop(sheetContext);
            _showClearConfirmation();
          },
          onDelete: () {
            Navigator.pop(sheetContext);
            _showDeleteConfirmation();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = widget.createdAt ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _DetailsBackground(),

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
                      _buildOverview(),

                      const SizedBox(height: 28),

                      _buildSectionLabel(
                        'CONVERSATION',
                        'A little information about this space',
                      ),

                      const SizedBox(height: 13),

                      _buildConversationInfo(
                        createdAt,
                      ),

                      const SizedBox(height: 28),

                      _buildSectionLabel(
                        'TOPIC',
                        'What brings you here',
                      ),

                      const SizedBox(height: 13),

                      _buildTopicCard(),

                      const SizedBox(height: 28),

                      _buildSectionLabel(
                        'PRIVACY',
                        'Just between the two of you',
                      ),

                      const SizedBox(height: 13),

                      _buildPrivacyCard(),

                      const SizedBox(height: 28),

                      _buildSectionLabel(
                        'A LITTLE REMINDER',
                        'Because some conversations matter',
                      ),

                      const SizedBox(height: 13),

                      _buildLoveNote(),
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

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _CircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: widget.onBack ?? () => Navigator.pop(context),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    'CHAT DETAILS',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              _CircleButton(
                icon: Icons.more_horiz_rounded,
                onTap: _showMoreOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 23),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF292122),
                  Color(0xFF4A3537),
                  Color(0xFF63494B),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
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
                  right: -30,
                  top: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.035),
                    ),
                  ),
                ),

                Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Icon(
                        widget.chat.icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'JUST BETWEEN US',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: const Color(0xFFE8B4B8),
                        fontSize: 9,
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 27,
                        height: 1.15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      widget.chat.subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 14,
                              color: const Color(0xFFE8B4B8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isFavorite
                                  ? 'KEPT CLOSE'
                                  : 'KEEP THIS CLOSE',
                              style: AppTextTheme.labelSmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                                fontSize: 9,
                                letterSpacing: 0.9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // OVERVIEW
  // ===========================================================================

  Widget _buildOverview() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.chat_bubble_outline_rounded,
            value: '${widget.chat.messageCount}',
            label: 'MESSAGES',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.favorite_border_rounded,
            value: _isFavorite ? 'YES' : '—',
            label: 'FAVORITE',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.lock_outline_rounded,
            value: '100%',
            label: 'PRIVATE',
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // CONVERSATION INFO
  // ===========================================================================

  Widget _buildConversationInfo(DateTime createdAt) {
    return _ContentCard(
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            title: 'Created',
            value: _formatDate(createdAt),
          ),

          const Divider(
            height: 24,
            color: AppColors.outlineVariant,
          ),

          _DetailRow(
            icon: Icons.schedule_outlined,
            title: 'Last activity',
            value: _relativeTime(widget.chat.lastMessageAt),
          ),

          const Divider(
            height: 24,
            color: AppColors.outlineVariant,
          ),

          _DetailRow(
            icon: Icons.people_outline_rounded,
            title: 'People',
            value: 'You & ${widget.partnerName}',
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return _formatShortDate(date);
  }

  // ===========================================================================
  // TOPIC
  // ===========================================================================

  Widget _buildTopicCard() {
    return _ContentCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.chat.icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.chat.subtitle,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 17),
      decoration: BoxDecoration(
        color: const Color(0xFF302728),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFE8B4B8),
                  size: 19,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRIVATE CONVERSATION',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Only you and ${widget.partnerName} belong here.',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.verified_rounded,
                color: Color(0xFFE8B4B8),
                size: 18,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.055),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.visibility_off_outlined,
                  color: Color(0xFFE8B4B8),
                  size: 16,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'This conversation is part of your private relationship space. '
                        'Keep the things you say here close.',
                    style: AppTextTheme.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.67),
                      fontSize: 10,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // LOVE NOTE
  // ===========================================================================

  Widget _buildLoveNote() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 21),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            color: AppColors.primary,
            size: 21,
          ),

          const SizedBox(height: 10),

          Text(
            'Some conversations become memories.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Keep talking. Keep laughing. Keep choosing each other.',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM BAR
  // ===========================================================================

  Widget _buildBottomBar() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 16,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  height: 62,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(
                        alpha: 0.55,
                      ),
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
                        child: _BottomAction(
                          icon: _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: _isFavorite
                              ? 'Kept close'
                              : 'Keep close',
                          onTap: _toggleFavorite,
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 30,
                        color: AppColors.outlineVariant.withValues(
                          alpha: 0.55,
                        ),
                      ),

                      Expanded(
                        child: _BottomAction(
                          icon: Icons.edit_outlined,
                          label: 'Rename',
                          onTap: _showRenameDialog,
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

  Widget _buildSectionLabel(
      String eyebrow,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.7,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// STAT CARD
// =============================================================================

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.50),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 7,
              letterSpacing: 0.7,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CONTENT CARD
// =============================================================================

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.52),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =============================================================================
// DETAIL ROW
// =============================================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFFCE4EC),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Text(
            title,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        Text(
          value,
          textAlign: TextAlign.right,
          style: AppTextTheme.labelLarge.copyWith(
            fontSize: 11,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// BOTTOM ACTION
// =============================================================================

class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 11,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.74),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Icon(
            icon,
            size: 17,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MORE OPTIONS
// =============================================================================

class _MoreOptionsSheet extends StatelessWidget {
  const _MoreOptionsSheet({
    required this.onRename,
    required this.onArchive,
    required this.onClear,
    required this.onDelete,
  });

  final VoidCallback onRename;
  final VoidCallback onArchive;
  final VoidCallback onClear;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
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
            'Conversation options',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Take care of this little corner.',
            style: AppTextTheme.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          _OptionTile(
            icon: Icons.edit_outlined,
            title: 'Rename conversation',
            subtitle: 'Give it a new name',
            onTap: onRename,
          ),

          _OptionTile(
            icon: Icons.archive_outlined,
            title: 'Archive conversation',
            subtitle: 'Move it out of your main chat list',
            onTap: onArchive,
          ),

          _OptionTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Clear messages',
            subtitle: 'Keep the chat but remove its messages',
            onTap: onClear,
          ),

          _OptionTile(
            icon: Icons.delete_outline_rounded,
            title: 'Delete conversation',
            subtitle: 'Remove this entire conversation',
            destructive: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// OPTION TILE
// =============================================================================

class _OptionTile extends StatelessWidget {
  const _OptionTile({
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
    final color = destructive
        ? const Color(0xFFB45E68)
        : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: destructive
                      ? const Color(0xFFFBE9EB)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: color,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextTheme.labelLarge.copyWith(
                        color: destructive
                            ? color
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SHEET HANDLE
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
            top: 90,
            right: -90,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC).withValues(alpha: 0.32),
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
                color: const Color(0xFFE8B4B8).withValues(alpha: 0.08),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            right: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91).withValues(alpha: 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _RenameChatDialog extends StatefulWidget {
  const _RenameChatDialog({
    required this.initialTitle,
  });

  final String initialTitle;

  @override
  State<_RenameChatDialog> createState() => _RenameChatDialogState();
}

class _RenameChatDialogState extends State<_RenameChatDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.initialTitle,
    );

    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();

    if (value.isEmpty) return;

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          22,
          24,
          22,
          20,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Icons.edit_outlined,
                      color: AppColors.primary,
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
                          'Rename conversation',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Give this little corner a name.',
                          style: AppTextTheme.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Our Future',
                    hintStyle: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.textDisabled,
                    ),
                    prefixIcon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: (_) => _save(),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize:
                        const Size.fromHeight(50),
                        side: const BorderSide(
                          color: AppColors.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextTheme.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize:
                        const Size.fromHeight(50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Save'),
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
}