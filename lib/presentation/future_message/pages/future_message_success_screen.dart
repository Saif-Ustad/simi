import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'create_future_message_screen.dart';

class FutureMessageSuccessScreen extends StatefulWidget {
  const FutureMessageSuccessScreen({
    super.key,
    required this.data,
    this.onViewMessages,
    this.onCreateAnother,
  });

  final CreateFutureMessageData data;

  final VoidCallback? onViewMessages;
  final VoidCallback? onCreateAnother;

  @override
  State<FutureMessageSuccessScreen> createState() =>
      _FutureMessageSuccessScreenState();
}

class _FutureMessageSuccessScreenState
    extends State<FutureMessageSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1100,
      ),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.18,
        1,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            child: _SuccessBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                150,
              ),
              children: [
                _buildTopBar(context),
                _buildSuccessHero(),
                _buildCountdownCard(),
                _buildMessageSummary(),
                _buildPrivateNote(),
                _buildBottomMessage(),
              ],
            ),
          ),

          _buildBottomActions(context),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: 40),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TIME CAPSULE',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Message Created',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          _CircleButton(
            icon: Icons.close_rounded,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SUCCESS HERO
  // ===========================================================================

  Widget _buildSuccessHero() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: 0.86 + (_scaleAnimation.value * 0.14),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            28,
            22,
            28,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.82,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.45,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.055,
                ),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildEnvelopeIcon(),

              const SizedBox(height: 20),

              Text(
                'Message Created Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                'Your little message is safely waiting '
                    'for the future ❤️',
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvelopeIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFF8E4E6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.12,
                ),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
        ),

        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 25,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // COUNTDOWN
  // ===========================================================================

  Widget _buildCountdownCard() {
    final remaining = _remainingTime();

    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E8E6),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.35,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              'UNLOCKS IN',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.7,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 13),

            Row(
              children: [
                Expanded(
                  child: _CountdownValue(
                    value: remaining.inDays,
                    label: 'Days',
                  ),
                ),
                _CountdownDivider(),
                Expanded(
                  child: _CountdownValue(
                    value: remaining.inHours % 24,
                    label: 'Hours',
                  ),
                ),
                _CountdownDivider(),
                Expanded(
                  child: _CountdownValue(
                    value: remaining.inMinutes % 60,
                    label: 'Mins',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              height: 1,
              color: AppColors.outlineVariant.withValues(
                alpha: 0.32,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Target date: ${_formatDate(widget.data.openDate)}',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
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

  Duration _remainingTime() {
    final target = DateTime(
      widget.data.openDate.year,
      widget.data.openDate.month,
      widget.data.openDate.day,
      widget.data.openTime.hour,
      widget.data.openTime.minute,
    );

    final difference = target.difference(
      DateTime.now(),
    );

    if (difference.isNegative) {
      return Duration.zero;
    }

    return difference;
  }

  // ===========================================================================
  // MESSAGE SUMMARY
  // ===========================================================================

  Widget _buildMessageSummary() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.82,
          ),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.42,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR CAPSULE',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 19,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _messagePreview(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                _MiniInfo(
                  icon: Icons.lock_outline_rounded,
                  label: 'Sealed',
                ),

                if (widget.data.photos.isNotEmpty) ...[
                  const SizedBox(width: 7),
                  _MiniInfo(
                    icon: Icons.photo_outlined,
                    label:
                    '${widget.data.photos.length} photos',
                  ),
                ],

                if (widget.data.voiceNote) ...[
                  const SizedBox(width: 7),
                  const _MiniInfo(
                    icon: Icons.mic_none_rounded,
                    label: 'Voice note',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _messagePreview() {
    final text = widget.data.message.trim();

    if (text.isEmpty) {
      return 'A little piece of your heart, '
          'waiting for the right moment.';
    }

    return text;
  }

  // ===========================================================================
  // PRIVATE NOTE
  // ===========================================================================

  Widget _buildPrivateNote() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 14,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF332A2B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'JUST BETWEEN US',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 7.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.white.withValues(
                        alpha: 0.52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'This message is sealed until '
                        'the date you chose.',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM MESSAGE
  // ===========================================================================

  Widget _buildBottomMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        28,
        23,
        28,
        0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Future you is going to love this.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM ACTIONS
  // ===========================================================================

  Widget _buildBottomActions(BuildContext context) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: widget.onViewMessages,
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient:
                        const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF765457),
                            Color(0xFF966E72),
                          ],
                        ),
                        borderRadius:
                        BorderRadius.circular(27),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: 0.22),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mail_outline_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'View My Messages',
                            style:
                            AppTextTheme.labelLarge
                                .copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  GestureDetector(
                    onTap: widget.onCreateAnother,
                    child: Container(
                      width: double.infinity,
                      height: 43,
                      decoration: BoxDecoration(
                        color: AppColors.surface
                            .withValues(alpha: 0.92),
                        borderRadius:
                        BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.primary
                              .withValues(alpha: 0.42),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Create Another',
                        style:
                        AppTextTheme.labelLarge.copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}

// =============================================================================
// COUNTDOWN VALUE
// =============================================================================

class _CountdownValue extends StatelessWidget {
  const _CountdownValue({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: GoogleFonts.playfairDisplay(
            fontSize: 25,
            height: 1,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
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

// =============================================================================
// COUNTDOWN DIVIDER
// =============================================================================

class _CountdownDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      ':',
      style: GoogleFonts.playfairDisplay(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: AppColors.primary.withValues(
          alpha: 0.45,
        ),
      ),
    );
  }
}

// =============================================================================
// MINI INFO
// =============================================================================

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 125,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F1F0),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 11,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
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
          color: Colors.white.withValues(
            alpha: 0.76,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.45,
            ),
          ),
        ),
        child: Icon(
          icon,
          size: 17,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _SuccessBackground extends StatelessWidget {
  const _SuccessBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -80,
            child: _SoftCircle(
              size: 220,
              color: const Color(0xFFE8B4B8),
            ),
          ),
          Positioned(
            top: 320,
            left: -100,
            child: _SoftCircle(
              size: 220,
              color: const Color(0xFFDCD9E8),
            ),
          ),
          Positioned(
            bottom: 40,
            right: -70,
            child: _SoftCircle(
              size: 180,
              color: const Color(0xFFF1D9DC),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.15,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}