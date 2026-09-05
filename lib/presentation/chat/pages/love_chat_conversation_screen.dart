import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'love_chat_screen.dart';

class LoveChatMessage {
  const LoveChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
    this.isRead = true,
  });

  final String text;
  final DateTime time;
  final bool isMine;
  final bool isRead;
}

class LoveChatConversationScreen extends StatefulWidget {
  const LoveChatConversationScreen({
    super.key,
    required this.chat,
    this.messages = const [],
    this.partnerName = 'Love',
    this.partnerInitial = 'L',
    this.onBack,
    this.onMore,
    this.onDetails,
    this.onSend,
  });

  final LoveChatItem chat;
  final List<LoveChatMessage> messages;

  final String partnerName;
  final String partnerInitial;

  final VoidCallback? onBack;
  final VoidCallback? onMore;
  final VoidCallback? onDetails;
  final ValueChanged<String>? onSend;

  @override
  State<LoveChatConversationScreen> createState() =>
      _LoveChatConversationScreenState();
}

class _LoveChatConversationScreenState
    extends State<LoveChatConversationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;

  late List<LoveChatMessage> _messages;

  @override
  void initState() {
    super.initState();

    _messages = List<LoveChatMessage>.from(widget.messages);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    final message = LoveChatMessage(
      text: text,
      time: DateTime.now(),
      isMine: true,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    widget.onSend?.call(text);

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _showConversationOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _ConversationOptionsSheet(
          onDetails: () {
            Navigator.pop(sheetContext);
            widget.onDetails?.call();
          },
          onFavorite: () {
            Navigator.pop(sheetContext);
          },
          onClear: () {
            Navigator.pop(sheetContext);
            _showClearConfirmation();
          },
        );
      },
    );
  }

  void _showClearConfirmation() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _ConfirmSheet(
          title: 'Clear this conversation?',
          description:
          'The conversation will be removed from this device.',
          confirmLabel: 'Clear conversation',
          onConfirm: () {
            Navigator.pop(sheetContext);

            setState(() {
              _messages.clear();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const _ConversationBackground(),

          Column(
            children: [
              _buildTopBar(),
              _buildConversationHeader(),
              Expanded(
                child: _buildMessages(),
              ),
              _buildComposer(),
            ],
          ),
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
      child: SizedBox(
        height: 62,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _CircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: widget.onBack ?? () => Navigator.pop(context),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOVE CHAT',
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          letterSpacing: 2.2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'just between us',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              _CircleButton(
                icon: Icons.more_horiz_rounded,
                onTap: widget.onMore ?? _showConversationOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONVERSATION HEADER
  // ---------------------------------------------------------------------------

  Widget _buildConversationHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.55),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                _TopicIcon(
                  icon: widget.chat.icon,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chat.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.chat.subtitle,
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 11,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'PRIVATE',
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 8,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
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
  // MESSAGES
  // ---------------------------------------------------------------------------

  Widget _buildMessages() {
    if (_messages.isEmpty) {
      return _buildEmptyConversation();
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: _messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildConversationStart();
        }

        final message = _messages[index - 1];

        return _AnimatedMessage(
          index: index - 1,
          controller: _animationController,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MessageBubble(
              message: message,
              partnerInitial: widget.partnerInitial,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConversationStart() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const SizedBox(height: 4),

          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            widget.chat.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'A little corner of your story.',
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Text(
              'Only you two can see this conversation',
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

  Widget _buildEmptyConversation() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Start your little conversation',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Say something that belongs only here.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'PRIVATE • JUST BETWEEN US',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.1,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPOSER
  // ---------------------------------------------------------------------------

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(
                        alpha: 0.55,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ComposerIcon(
                        icon: Icons.add_rounded,
                        onTap: () {},
                      ),

                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          minLines: 1,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.newline,
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Say something...',
                            hintStyle: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.textDisabled,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 11,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      _SendButton(
                        onTap: _sendMessage,
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
// MESSAGE BUBBLE
// =============================================================================

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.partnerInitial,
  });

  final LoveChatMessage message;
  final String partnerInitial;

  String _formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;

    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (message.isMine) {
      return Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 310,
              ),
              padding: const EdgeInsets.fromLTRB(
                15,
                12,
                15,
                10,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF795458),
                    Color(0xFF956C70),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                  bottomLeft: Radius.circular(21),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Text(
                message.text,
                style: AppTextTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.time),
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    color: AppColors.textDisabled,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  message.isRead
                      ? Icons.done_all_rounded
                      : Icons.done_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              partnerInitial,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 310,
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    15,
                    12,
                    15,
                    10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(21),
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(21),
                    ),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(
                        alpha: 0.45,
                      ),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatTime(message.time),
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TOPIC ICON
// =============================================================================

class _TopicIcon extends StatelessWidget {
  const _TopicIcon({
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

// =============================================================================
// BUTTONS
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
            color: Colors.white.withValues(alpha: 0.72),
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

class _ComposerIcon extends StatelessWidget {
  const _ComposerIcon({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 20,
        color: AppColors.textSecondary,
      ),
      splashRadius: 20,
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_upward_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// OPTIONS SHEET
// =============================================================================

class _ConversationOptionsSheet extends StatelessWidget {
  const _ConversationOptionsSheet({
    required this.onDetails,
    required this.onFavorite,
    required this.onClear,
  });

  final VoidCallback onDetails;
  final VoidCallback onFavorite;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
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
              'This little conversation',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Keep it exactly how you like it.',
              style: AppTextTheme.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            _SheetAction(
              icon: Icons.info_outline_rounded,
              title: 'Conversation details',
              subtitle: 'See topic and conversation info',
              onTap: onDetails,
            ),

            _SheetAction(
              icon: Icons.favorite_border_rounded,
              title: 'Keep close',
              subtitle: 'Add this conversation to favorites',
              onTap: onFavorite,
            ),

            _SheetAction(
              icon: Icons.delete_outline_rounded,
              title: 'Clear conversation',
              subtitle: 'Remove the messages from this chat',
              destructive: true,
              onTap: onClear,
            ),
          ],
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
    final iconColor =
    destructive ? const Color(0xFFB45E68) : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
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
                  color: iconColor,
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
                            ? const Color(0xFFB45E68)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
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
// CONFIRM SHEET
// =============================================================================

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.onConfirm,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
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
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFFBE9EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFB45E68),
              size: 25,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB45E68),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                confirmLabel,
                style: AppTextTheme.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          TextButton(
            onPressed: () => Navigator.pop(context),
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

class _ConversationBackground extends StatelessWidget {
  const _ConversationBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 80,
            right: -100,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC).withValues(alpha: 0.34),
              ),
            ),
          ),

          Positioned(
            bottom: 110,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8).withValues(alpha: 0.09),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedMessage extends StatelessWidget {
  const _AnimatedMessage({
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);

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
              12 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}