import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class CreateChatData {
  const CreateChatData({
    required this.title,
    required this.topic,
    required this.icon,
    required this.prompt,
  });

  final String title;
  final String topic;
  final IconData icon;
  final String prompt;
}

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({
    super.key,
    this.onBack,
    this.onCreateChat,
  });

  final VoidCallback? onBack;
  final ValueChanged<CreateChatData>? onCreateChat;

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  int _selectedTopicIndex = 0;

  final List<_ChatTopic> _topics = const [
    _ChatTopic(
      title: 'Our Future',
      subtitle: 'Dream about what comes next.',
      icon: Icons.auto_awesome_rounded,
      emoji: '✨',
    ),
    _ChatTopic(
      title: 'Things I Love',
      subtitle: 'Talk about the little things.',
      icon: Icons.favorite_rounded,
      emoji: '💕',
    ),
    _ChatTopic(
      title: 'Late Night Thoughts',
      subtitle: 'The things we say after midnight.',
      icon: Icons.nightlight_round,
      emoji: '🌙',
    ),
    _ChatTopic(
      title: 'Dream Trips',
      subtitle: 'Places we want to see together.',
      icon: Icons.flight_takeoff_rounded,
      emoji: '✈️',
    ),
    _ChatTopic(
      title: 'Our Memories',
      subtitle: 'Talk about moments we treasure.',
      icon: Icons.photo_camera_outlined,
      emoji: '📸',
    ),
    _ChatTopic(
      title: 'Deep Talk',
      subtitle: 'Questions that bring us closer.',
      icon: Icons.chat_bubble_outline_rounded,
      emoji: '💭',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  _ChatTopic get _selectedTopic => _topics[_selectedTopicIndex];

  String get _chatTitle {
    final customTitle = _titleController.text.trim();

    if (customTitle.isNotEmpty) {
      return customTitle;
    }

    return _selectedTopic.title;
  }

  void _selectTopic(int index) {
    setState(() {
      _selectedTopicIndex = index;
      _titleController.text = _topics[index].title;
    });
  }

  void _createChat() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _titleController.text = _selectedTopic.title;
    }

    final data = CreateChatData(
      title: _chatTitle,
      topic: _selectedTopic.title,
      icon: _selectedTopic.icon,
      prompt: _promptController.text.trim(),
    );

    widget.onCreateChat?.call(data);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _CreateChatBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(context),
              ),
              SliverToBoxAdapter(
                child: _buildHero(),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  150,
                ),
                sliver: SliverToBoxAdapter(
                  child: _buildContent(),
                ),
              ),
            ],
          ),

          _buildBottomBar(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TOP BAR
  // ─────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ?? () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOVE CHAT',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.8,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Start a conversation',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            _CircleButton(
              icon: Icons.favorite_border_rounded,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HERO
  // ─────────────────────────────────────────────

  Widget _buildHero() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(
          _animationController.value,
        );

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            24,
            22,
            24,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF34282A),
                Color(0xFF51383B),
                Color(0xFF68494D),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
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
                right: -20,
                top: -28,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                right: 25,
                bottom: -55,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.08),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFF3C8CC),
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'JUST BETWEEN US',
                        style: AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          letterSpacing: 1.8,
                          color: Colors.white.withValues(alpha: 0.70),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'What do you want\nto talk about?',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 29,
                      height: 1.12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create a little space for the two of you.',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 13,
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

  // ─────────────────────────────────────────────
  // CONTENT
  // ─────────────────────────────────────────────

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          'CHOOSE A FEELING',
          'Start with a conversation theme',
        ),
        const SizedBox(height: 14),

        _buildTopicGrid(),

        const SizedBox(height: 14),

        _buildCustomChatButton(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'NAME YOUR CONVERSATION',
          'Give this little corner a name',
        ),
        const SizedBox(height: 14),

        _buildTitleField(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'A LITTLE PROMPT',
          'Optional — give your conversation a starting point',
        ),
        const SizedBox(height: 14),

        _buildPromptField(),

        const SizedBox(height: 28),

        _buildPreview(),

        const SizedBox(height: 22),

        _buildPrivacyNote(),
      ],
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
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TOPIC GRID
  // ─────────────────────────────────────────────

  Widget _buildTopicGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _topics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.18,
      ),
      itemBuilder: (context, index) {
        final topic = _topics[index];
        final selected = index == _selectedTopicIndex;

        return _TopicCard(
          topic: topic,
          selected: selected,
          onTap: () => _selectTopic(index),
        );
      },
    );
  }


  Widget _buildCustomChatButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.customChat);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.60),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
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
                child: const Icon(
                  Icons.edit_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your own',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Have something completely personal in mind?',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TITLE
  // ─────────────────────────────────────────────

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.60),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _titleController,
        onChanged: (_) => setState(() {}),
        textCapitalization: TextCapitalization.sentences,
        style: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(11),
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          hintText: 'Our Future',
          hintStyle: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textDisabled,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 17,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PROMPT
  // ─────────────────────────────────────────────

  Widget _buildPromptField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.60),
        ),
      ),
      child: TextField(
        controller: _promptController,
        onChanged: (_) => setState(() {}),
        maxLines: 4,
        minLines: 3,
        textCapitalization: TextCapitalization.sentences,
        style: AppTextTheme.bodyMedium.copyWith(
          fontSize: 13,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText:
          'For example: Where should we travel next year?',
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            fontSize: 13,
            color: AppColors.textDisabled,
            height: 1.5,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 8,
              top: 17,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              widthFactor: 1,
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(
            8,
            16,
            16,
            16,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PREVIEW
  // ─────────────────────────────────────────────

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EFED),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE5D6D2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'YOUR LITTLE CORNER',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.visibility_outlined,
                size: 15,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8B4B8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _selectedTopic.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _chatTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedTopic.emoji} ${_selectedTopic.title}',
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

          if (_promptController.text.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                14,
                12,
                14,
                12,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _promptController.text.trim(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PRIVACY
  // ─────────────────────────────────────────────

  Widget _buildPrivacyNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFFFCE4EC),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'This conversation is only for the two of you. '
                'Your little corner stays private.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM CTA
  // ─────────────────────────────────────────────

  Widget _buildBottomBar() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.90),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.09),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _createChat,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Start this conversation',
                        style: AppTextTheme.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

// ═══════════════════════════════════════════════════
// TOPIC MODEL
// ═══════════════════════════════════════════════════

class _ChatTopic {
  const _ChatTopic({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emoji,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String emoji;
}

// ═══════════════════════════════════════════════════
// TOPIC CARD
// ═══════════════════════════════════════════════════

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.selected,
    required this.onTap,
  });

  final _ChatTopic topic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFF2D5D8)
                : Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : AppColors.outlineVariant.withValues(alpha: 0.60),
              width: selected ? 1.3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: selected ? 0.055 : 0.025,
                ),
                blurRadius: selected ? 16 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      topic.icon,
                      size: 18,
                      color: selected
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                ],
              ),
              const Spacer(),
              Text(
                topic.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                topic.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9.5,
                  height: 1.3,
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

// ═══════════════════════════════════════════════════
// CIRCLE BUTTON
// ═══════════════════════════════════════════════════

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
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.76),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.55),
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

// ═══════════════════════════════════════════════════
// BACKGROUND
// ═══════════════════════════════════════════════════

class _CreateChatBackground extends StatelessWidget {
  const _CreateChatBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 90,
            right: -80,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 420,
            left: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: -90,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}