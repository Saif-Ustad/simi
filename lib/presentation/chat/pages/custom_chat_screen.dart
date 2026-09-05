import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class CustomChatData {
  const CustomChatData({
    required this.title,
    required this.topic,
    required this.prompt,
    required this.icon,
  });

  final String title;
  final String topic;
  final String prompt;
  final IconData icon;
}

class CustomChatScreen extends StatefulWidget {
  const CustomChatScreen({
    super.key,
    this.onBack,
    this.onCreateChat,
  });

  final VoidCallback? onBack;
  final ValueChanged<CustomChatData>? onCreateChat;

  @override
  State<CustomChatScreen> createState() => _CustomChatScreenState();
}

class _CustomChatScreenState extends State<CustomChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  IconData _selectedIcon = Icons.favorite_rounded;

  final List<IconData> _icons = const [
    Icons.favorite_rounded,
    Icons.auto_awesome_rounded,
    Icons.chat_bubble_outline_rounded,
    Icons.nightlight_round,
    Icons.flight_takeoff_rounded,
    Icons.photo_camera_outlined,
    Icons.music_note_rounded,
    Icons.celebration_outlined,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _titleController.addListener(_refresh);
    _topicController.addListener(_refresh);
    _promptController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _topicController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  bool get _canCreate {
    return _titleController.text.trim().isNotEmpty &&
        _topicController.text.trim().isNotEmpty;
  }

  void _createChat() {
    if (!_canCreate) return;

    final data = CustomChatData(
      title: _titleController.text.trim(),
      topic: _topicController.text.trim(),
      prompt: _promptController.text.trim(),
      icon: _selectedIcon,
    );

    widget.onCreateChat?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _CustomChatBackground(),

          SafeArea(
            child: CustomScrollView(
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
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildTitleSection(),
                        const SizedBox(height: 20),

                        _buildTopicSection(),
                        const SizedBox(height: 20),

                        _buildPromptSection(),
                        const SizedBox(height: 24),

                        _buildPreview(),
                        const SizedBox(height: 24),

                        _buildPrivacyNote(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: widget.onBack ?? () => Navigator.pop(context),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  'LOVE CHAT',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2.2,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Create your own',
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
            icon: Icons.close_rounded,
            onTap: widget.onBack ?? () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HERO
  // ------------------------------------------------------------

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF302728),
                Color(0xFF574346),
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
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFFF7DDE0),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JUST BETWEEN US',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: const Color(0xFFE8B4B8),
                        fontSize: 9,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Make it yours.',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a conversation around anything '
                          'your heart wants to talk about.',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 11,
                        height: 1.45,
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

  // ------------------------------------------------------------
  // TITLE
  // ------------------------------------------------------------

  Widget _buildTitleSection() {
    return _SectionCard(
      eyebrow: '01  ·  GIVE IT A NAME',
      title: 'What should we call it?',
      child: Column(
        children: [
          _InputField(
            controller: _titleController,
            hintText: 'Something only we would call it',
            icon: Icons.title_rounded,
            maxLines: 1,
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Examples: “That One Sunday”, “Us in 5 Years”, '
                  '“Things We Never Say”',
              style: AppTextTheme.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TOPIC
  // ------------------------------------------------------------

  Widget _buildTopicSection() {
    return _SectionCard(
      eyebrow: '02  ·  THE TOPIC',
      title: 'What is this conversation about?',
      child: Column(
        children: [
          _InputField(
            controller: _topicController,
            hintText: 'Tell us what you want to talk about...',
            icon: Icons.chat_bubble_outline_rounded,
            maxLines: 4,
            minLines: 3,
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'CHOOSE A FEELING',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 11),

          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _icons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 9),
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final selected = icon == _selectedIcon;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFF8F2F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.outlineVariant
                            .withValues(alpha: 0.65),
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: selected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PROMPT
  // ------------------------------------------------------------

  Widget _buildPromptSection() {
    return _SectionCard(
      eyebrow: '03  ·  STARTING THOUGHT',
      title: 'Give the conversation a little spark.',
      subtitle: 'Optional — you can always start with a blank page.',
      child: _InputField(
        controller: _promptController,
        hintText: '“There is something I have been wanting to tell you...”',
        icon: Icons.auto_awesome_rounded,
        maxLines: 5,
        minLines: 4,
      ),
    );
  }

  // ------------------------------------------------------------
  // PREVIEW
  // ------------------------------------------------------------

  Widget _buildPreview() {
    final title = _titleController.text.trim().isEmpty
        ? 'Our little conversation'
        : _titleController.text.trim();

    final topic = _topicController.text.trim().isEmpty
        ? 'Something just for the two of us'
        : _topicController.text.trim();

    final prompt = _promptController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A LITTLE PREVIEW',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.7,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _selectedIcon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          topic,
                          maxLines: 2,
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

              if (prompt.isNotEmpty) ...[
                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    15,
                    13,
                    15,
                    13,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prompt,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 14,
                            height: 1.45,
                            color: AppColors.textPrimary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 17),

              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Only you two',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PRIVACY
  // ------------------------------------------------------------

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC).withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 17,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A space just for you two',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your conversations stay private and belong '
                      'only to your relationship.',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    height: 1.45,
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

  // ------------------------------------------------------------
  // BOTTOM ACTION
  // ------------------------------------------------------------

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 14,
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 16,
              sigmaY: 16,
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.75),
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
                height: 54,
                child: FilledButton(
                  onPressed: _canCreate ? _createChat : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
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
                        'Create our conversation',
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

// ============================================================
// REUSABLE WIDGETS
// ============================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.eyebrow,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.60),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        textCapitalization: TextCapitalization.sentences,
        style: AppTextTheme.bodyLarge.copyWith(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
          ),
          hintText: hintText,
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textDisabled,
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
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
            size: 17,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _CustomChatBackground extends StatelessWidget {
  const _CustomChatBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.12),
              ),
            ),
          ),

          Positioned(
            top: 430,
            left: -100,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.055),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            right: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}