import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class LoveChatItem {
  const LoveChatItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.messageCount,
    required this.icon,
    this.isUnread = false,
    this.isFavorite = false,
    this.mood,
  });

  final String id;
  final String title;
  final String subtitle;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int messageCount;
  final IconData icon;
  final bool isUnread;
  final bool isFavorite;
  final String? mood;
}

class LoveChatScreen extends StatefulWidget {
  const LoveChatScreen({
    super.key,
    this.chats = const [],
    this.onChatTap,
    this.onCreateChat,
    this.onSearch,
    this.onFavoriteChanged,
  });

  final List<LoveChatItem> chats;
  final ValueChanged<LoveChatItem>? onChatTap;
  final VoidCallback? onCreateChat;
  final ValueChanged<String>? onSearch;
  final ValueChanged<LoveChatItem>? onFavoriteChanged;

  @override
  State<LoveChatScreen> createState() => _LoveChatScreenState();
}

class _LoveChatScreenState extends State<LoveChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<LoveChatItem> get _filteredChats {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.chats;
    }

    return widget.chats.where((chat) {
      return chat.title.toLowerCase().contains(query) ||
          chat.subtitle.toLowerCase().contains(query) ||
          chat.lastMessage.toLowerCase().contains(query);
    }).toList();
  }

  int get _unreadCount {
    return widget.chats.where((chat) => chat.isUnread).length;
  }

  @override
  Widget build(BuildContext context) {
    final chats = _filteredChats;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _LoveChatBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(context),
              ),

              SliverToBoxAdapter(
                child: _buildHero(),
              ),

              if (widget.chats.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildSearchArea(),
                ),

              if (chats.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    135,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final chat = chats[index];

                        return _AnimatedEntry(
                          index: index,
                          controller: _animationController,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _LoveChatCard(
                              chat: chat,
                              onTap: () {
                                widget.onChatTap?.call(chat);
                              },
                              onFavorite: () {
                                widget.onFavoriteChanged?.call(chat);
                              },
                            ),
                          ),
                        );
                      },
                      childCount: chats.length,
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

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                    'LOVE CHAT',
                    style: AppTextTheme.labelSmall.copyWith(
                      letterSpacing: 1.7,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Our conversations',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
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

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7E5E6),
              Color(0xFFF4D8DA),
              Color(0xFFEFE4E4),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -28,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.26),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.primary,
                    size: 21,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'JUST BETWEEN US',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Little conversations,\njust ours.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 27,
                    height: 1.16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 11),

                Text(
                  widget.chats.isEmpty
                      ? 'A quiet place for everything you want to say to each other.'
                      : '${widget.chats.length} little conversations${_unreadCount > 0 ? ' · $_unreadCount waiting for you' : ''}.',
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchArea() {
    if (!_showSearch) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
        child: Row(
          children: [
            Text(
              'YOUR CONVERSATIONS',
              style: AppTextTheme.labelSmall.copyWith(
                letterSpacing: 1.5,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (_unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$_unreadCount unread',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.7),
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
            hintText: 'Search your conversations...',
            hintStyle: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textDisabled,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 19,
              color: AppColors.primary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final searching = _searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 10, 32, 145),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 6,
                ),
              ),
              child: Icon(
                searching
                    ? Icons.search_off_rounded
                    : Icons.mark_unread_chat_alt_outlined,
                size: 34,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              searching
                  ? 'Nothing found'
                  : 'Start your first conversation',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              searching
                  ? 'Try a different word or topic.'
                  : 'Some conversations are worth giving their own little space.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),

            if (!searching) ...[
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: widget.onCreateChat,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 18,
                ),
                label: const Text('Start a new chat'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.45),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: Material(
                color: Colors.transparent,
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
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.24),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: widget.onCreateChat,
                    borderRadius: BorderRadius.circular(29),
                    splashColor: Colors.white.withValues(alpha: 0.12),
                    highlightColor: Colors.white.withValues(alpha: 0.06),
                    child: Row(
                      children: [
                        const SizedBox(width: 7),

                        // ─────────────────────────
                        // Plus icon
                        // ─────────────────────────
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 13),

                        // ─────────────────────────
                        // Text
                        // ─────────────────────────
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start something new',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
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
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF6D9DC),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'A new little corner, just for us',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextTheme.labelSmall.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.72,
                                        ),
                                        fontSize: 10,
                                        letterSpacing: 0.15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // ─────────────────────────
                        // Arrow
                        // ─────────────────────────
                        Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.14),
                              width: 1,
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


// ─────────────────────────────────────────────────────────────
// CHAT CARD
// ─────────────────────────────────────────────────────────────

class _LoveChatCard extends StatelessWidget {
  const _LoveChatCard({
    required this.chat,
    this.onTap,
    this.onFavorite,
  });

  final LoveChatItem chat;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: chat.isUnread
                  ? AppColors.primary.withValues(alpha: 0.24)
                  : AppColors.outlineVariant.withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ChatIcon(
                icon: chat.icon,
                unread: chat.isUnread,
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        if (chat.isFavorite)
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.favorite_rounded,
                              size: 13,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    if (chat.subtitle.trim().isNotEmpty)
                      Text(
                        chat.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    const SizedBox(height: 5),

                    Text(
                      chat.lastMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontSize: 12,
                        height: 1.35,
                        color: chat.isUnread
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: chat.isUnread
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        Text(
                          _relativeDate(chat.lastMessageAt),
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 9,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(width: 7),
                        _TinyDot(),
                        const SizedBox(width: 7),
                        Text(
                          '${chat.messageCount} ${chat.messageCount == 1 ? 'message' : 'messages'}',
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 9,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SmallIconButton(
                    icon: chat.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: chat.isFavorite
                        ? AppColors.primary
                        : AppColors.textDisabled,
                    onTap: onFavorite,
                  ),

                  const SizedBox(height: 7),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}


// ─────────────────────────────────────────────────────────────
// ICON
// ─────────────────────────────────────────────────────────────

class _ChatIcon extends StatelessWidget {
  const _ChatIcon({
    required this.icon,
    required this.unread,
  });

  final IconData icon;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: unread
                ? const Color(0xFFFCE4EC)
                : const Color(0xFFF5F0EE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 21,
            color: AppColors.primary,
          ),
        ),

        if (unread)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}


// ─────────────────────────────────────────────────────────────
// BACKGROUND
// ─────────────────────────────────────────────────────────────

class _LoveChatBackground extends StatelessWidget {
  const _LoveChatBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: -90,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.32),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 340,
            left: -110,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 130,
            right: -80,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────
// SMALL WIDGETS
// ─────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    this.onTap,
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
            color: Colors.white.withValues(alpha: 0.78),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.6),
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

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            icon,
            size: 15,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _TinyDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: AppColors.textDisabled,
        shape: BoxShape.circle,
      ),
    );
  }
}

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