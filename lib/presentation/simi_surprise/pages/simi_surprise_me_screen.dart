import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'simi_surprises_home_screen.dart';

class SimiSurpriseMeScreen extends StatefulWidget {
  const SimiSurpriseMeScreen({
    super.key,
    required this.surprises,
    this.onBack,
    this.onOpenSurprise,
  });

  final List<SimiSurpriseItem> surprises;

  final VoidCallback? onBack;
  final ValueChanged<SimiSurpriseItem>? onOpenSurprise;

  @override
  State<SimiSurpriseMeScreen> createState() =>
      _SimiSurpriseMeScreenState();
}

class _SimiSurpriseMeScreenState
    extends State<SimiSurpriseMeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _revealController;
  late final AnimationController _pulseController;

  SimiSurpriseItem? _selectedSurprise;

  bool _revealed = false;
  bool _isPicking = false;

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _revealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // SURPRISE
  // ===========================================================================

  Future<void> _surpriseMe() async {
    if (_isPicking || widget.surprises.isEmpty) {
      return;
    }

    setState(() {
      _isPicking = true;
      _revealed = false;
      _selectedSurprise = null;
    });

    _revealController.reset();

    await _rotationController.forward(from: 0);

    if (!mounted) return;

    final selected =
    widget.surprises[_random.nextInt(
      widget.surprises.length,
    )];

    setState(() {
      _selectedSurprise = selected;
      _isPicking = false;
      _revealed = true;
    });

    await _revealController.forward();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _SurpriseBackground(),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(context),

                Expanded(
                  child: SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      40,
                    ),
                    child: Column(
                      children: [
                        _buildIntro(),
                        const SizedBox(height: 26),
                        _buildSurpriseStage(),
                        const SizedBox(height: 28),
                        _buildHint(),
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

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: widget.onBack ??
                    () => Navigator.maybePop(context),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'SIMI SURPRISES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'A little surprise',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntro() {
    return Column(
      children: [
        Text(
          'NO PEEKING',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          _revealed
              ? 'Look what SIMI found.'
              : 'Let SIMI pick\nsomething for you.',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            height: 1.12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          _revealed
              ? 'A little piece of your story, '
              'chosen just for you two.'
              : 'You don\'t choose. You don\'t search. '
              'You just let SIMI surprise you.',
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            height: 1.55,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SURPRISE STAGE
  // ===========================================================================

  Widget _buildSurpriseStage() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationController,
        _revealController,
        _pulseController,
      ]),
      builder: (context, child) {
        final reveal =
        Curves.easeOutBack.transform(
          _revealController.value,
        );

        final rotation =
            _rotationController.value *
                math.pi *
                2;

        final pulse =
            1 +
                (_pulseController.value * 0.035);

        return Transform.scale(
          scale: _revealed
              ? 0.98 + (reveal * 0.02)
              : pulse,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildGlow(),

              if (!_revealed)
                Transform.rotate(
                  angle: _isPicking
                      ? rotation
                      : 0,
                  child: _buildMysteryCard(),
                )
              else
                Transform.scale(
                  scale: reveal.clamp(0.0, 1.0),
                  child: Opacity(
                    opacity: reveal.clamp(0.0, 1.0),
                    child: _buildResultCard(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlow() {
    return Container(
      width: 315,
      height: 315,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFE8B4B8)
                .withValues(alpha: 0.20),
            const Color(0xFFE8B4B8)
                .withValues(alpha: 0.04),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MYSTERY CARD
  // ===========================================================================

  Widget _buildMysteryCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 370,
        minHeight: 350,
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF282223),
            Color(0xFF4C3639),
            Color(0xFF302728),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
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
              Icons.auto_awesome_rounded,
              size: 37,
              color: Color(0xFFF6D9DC),
            ),
          ),

          const SizedBox(height: 27),

          Text(
            _isPicking
                ? 'SIMI IS LOOKING...'
                : 'SOMETHING IS WAITING',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8.5,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE8B4B8),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'A little piece\nof your story.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 27,
              height: 1.12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _isPicking
                ? 'Finding something that feels like you two...'
                : 'Tap the button below.\n'
                'Then trust SIMI.',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 11,
              height: 1.5,
              color: Colors.white
                  .withValues(alpha: 0.58),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RESULT CARD
  // ===========================================================================

  Widget _buildResultCard() {
    final surprise = _selectedSurprise!;

    final info =
    _SurpriseTypeInfo.fromType(surprise.type);

    return GestureDetector(
      onTap: () {
        widget.onOpenSurprise?.call(surprise);
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 370,
        ),
        padding: const EdgeInsets.fromLTRB(
          21,
          21,
          21,
          22,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.08,
              ),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: info.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    info.icon,
                    size: 19,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.label,
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 8,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        surprise.timeLabel,
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          color:
                          AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                  child: Text(
                    'JUST FOR YOU',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 7,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              surprise.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 25,
                height: 1.15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              surprise.message,
              style: AppTextTheme.bodyLarge.copyWith(
                fontSize: 13,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 19),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F1F0),
                borderRadius:
                BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 15,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SIMI thought this was worth showing you.',
                      style: AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 9.5,
                        height: 1.35,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                Text(
                  'Tap to explore',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HINT
  // ===========================================================================

  Widget _buildHint() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _revealed ? 0.55 : 1,
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              _revealed
                  ? 'You can always ask SIMI for another one.'
                  : 'SIMI won\'t tell you what it picked beforehand.',
              textAlign: TextAlign.center,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textDisabled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM ACTION
  // ===========================================================================

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
            child: GestureDetector(
              onTap: _surpriseMe,
              child: AnimatedContainer(
                duration:
                const Duration(milliseconds: 250),
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
                  borderRadius:
                  BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withValues(alpha: 0.24),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.08),
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
                        color: Colors.white
                            .withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPicking
                            ? Icons.hourglass_top_rounded
                            : Icons.auto_awesome_rounded,
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
                            _isPicking
                                ? 'Finding something...'
                                : _revealed
                                ? 'Surprise me again'
                                : 'Surprise Us',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: GoogleFonts
                                .playfairDisplay(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _revealed
                                ? 'There might be another little thing'
                                : 'Let SIMI choose this one',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: Colors.white
                                  .withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 42,
                      height: 42,
                      margin:
                      const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.11),
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
    );
  }
}

// =============================================================================
// TYPE INFO
// =============================================================================

class _SurpriseTypeInfo {
  const _SurpriseTypeInfo({
    required this.label,
    required this.icon,
    required this.background,
  });

  final String label;
  final IconData icon;
  final Color background;

  static _SurpriseTypeInfo fromType(
      SimiSurpriseType type,
      ) {
    switch (type) {
      case SimiSurpriseType.memory:
        return const _SurpriseTypeInfo(
          label: 'MEMORY MOMENT',
          icon: Icons.photo_camera_outlined,
          background: Color(0xFFFCE4EC),
        );

      case SimiSurpriseType.chat:
        return const _SurpriseTypeInfo(
          label: 'LOVE CHAT',
          icon: Icons.chat_bubble_outline_rounded,
          background: Color(0xFFE9E8F2),
        );

      case SimiSurpriseType.period:
        return const _SurpriseTypeInfo(
          label: 'YOUR RHYTHM',
          icon: Icons.calendar_month_outlined,
          background: Color(0xFFFCE4EC),
        );

      case SimiSurpriseType.specialDate:
        return const _SurpriseTypeInfo(
          label: 'SPECIAL DATE',
          icon: Icons.event_outlined,
          background: Color(0xFFF6E9E4),
        );

      case SimiSurpriseType.futureMessage:
        return const _SurpriseTypeInfo(
          label: 'FUTURE MESSAGE',
          icon: Icons.mark_email_unread_outlined,
          background: Color(0xFFE9E8F2),
        );

      case SimiSurpriseType.mood:
        return const _SurpriseTypeInfo(
          label: 'MOOD JOURNAL',
          icon:
          Icons.sentiment_satisfied_alt_outlined,
          background: Color(0xFFF1F0EF),
        );

      case SimiSurpriseType.giftWish:
        return const _SurpriseTypeInfo(
          label: 'GIFT WISH',
          icon: Icons.card_giftcard_outlined,
          background: Color(0xFFFCE4EC),
        );

      case SimiSurpriseType.milestone:
        return const _SurpriseTypeInfo(
          label: 'LITTLE MILESTONE',
          icon: Icons.auto_awesome_rounded,
          background: Color(0xFFF4E9DD),
        );

      case SimiSurpriseType.surprise:
        return const _SurpriseTypeInfo(
          label: 'SIMI',
          icon: Icons.auto_awesome_rounded,
          background: Color(0xFFFCE4EC),
        );
    }
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.78,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.50),
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

// =============================================================================
// BACKGROUND
// =============================================================================

class _SurpriseBackground extends StatelessWidget {
  const _SurpriseBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 90,
          right: -90,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 45,
              sigmaY: 45,
            ),
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          top: 430,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.045),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 80,
          right: -80,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
            ),
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}