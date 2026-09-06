import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

import 'future_messages_home_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class FutureMessageDetailScreen extends StatefulWidget {
  const FutureMessageDetailScreen({
    super.key,
    required this.message,
    this.onBack,
    this.onOpen,
    this.onFavoriteChanged,
    this.onMore,
    this.onDelete,
  });

  final FutureMessageItem message;

  final VoidCallback? onBack;
  final VoidCallback? onOpen;
  final ValueChanged<bool>? onFavoriteChanged;
  final VoidCallback? onMore;
  final VoidCallback? onDelete;

  @override
  State<FutureMessageDetailScreen> createState() =>
      _FutureMessageDetailScreenState();
}

class _FutureMessageDetailScreenState
    extends State<FutureMessageDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _isFavorite;

  late final AudioPlayer _audioPlayer;

  bool _isPlaying = false;
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.message.isFavorite;

    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen(
          (state) {
        if (!mounted) return;

        setState(() {
          _isPlaying =
              state == PlayerState.playing;
        });
      },
    );

    _audioPlayer.onDurationChanged.listen(
          (duration) {
        if (!mounted) return;

        setState(() {
          _audioDuration = duration;
        });
      },
    );

    _audioPlayer.onPositionChanged.listen(
          (position) {
        if (!mounted) return;

        setState(() {
          _audioPosition = position;
        });
      },
    );

    _audioPlayer.onPlayerComplete.listen(
          (_) {
        if (!mounted) return;

        setState(() {
          _isPlaying = false;
          _audioPosition = Duration.zero;
        });
      },
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();

    super.dispose();
  }

  Future<void> _toggleVoiceNote() async {
    final path = widget.message.voicePath;

    if (path == null || path.trim().isEmpty) {
      _showMessage(
        'No voice recording is attached.',
      );
      return;
    }

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      final assetPath = path.startsWith('assets/')
          ? path.substring('assets/'.length)
          : path;

      debugPrint('Playing asset: $assetPath');

      await _audioPlayer.play(
        AssetSource(assetPath),
      );
    } catch (e, stackTrace) {
      debugPrint('VOICE PLAY ERROR: $e');
      debugPrint('$stackTrace');

      _showMessage(
        'Could not play this voice note.',
      );
    }
  }

  // ===========================================================================
  // STATUS
  // ===========================================================================

  bool get _isLocked =>
      widget.message.status ==
          FutureMessageStatus.locked;

  bool get _isReady =>
      widget.message.status ==
          FutureMessageStatus.ready;

  bool get _isOpened =>
      widget.message.status ==
          FutureMessageStatus.opened;

  String get _statusLabel {
    if (_isLocked) {
      return 'SEALED FOR THE FUTURE';
    }

    if (_isReady) {
      return 'READY TO OPEN';
    }

    return 'OPENED';
  }

  String get _statusDescription {
    if (_isLocked) {
      return 'This little message is still resting '
          'until the moment you chose.';
    }

    if (_isReady) {
      return 'The moment has arrived. '
          'Your message is ready.';
    }

    return 'A little piece of the past, '
        'opened when the time was right.';
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
            child: _DetailBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 140,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildStatusCard(),
                _buildMessageCard(),
                if (_isOpened) _buildMemoryDetails(),
                if (_isOpened &&
                    widget.message.photoCount > 0)
                  _buildPhotosSection(),
                if (_isOpened &&
                    widget.message.voiceDuration !=
                        null)
                  _buildVoiceSection(),
                _buildCreatedDetails(),
                _buildPrivateFooter(),
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

          const Spacer(),

          Column(
            children: [
              Text(
                'TIME CAPSULE',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'A Message For Later',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const Spacer(),

          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: () {
              _showOptions(context);
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            25,
            22,
            24,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isOpened
                  ? const [
                Color(0xFF6C5053),
                Color(0xFF8B666A),
              ]
                  : const [
                Color(0xFF2B2526),
                Color(0xFF403233),
                Color(0xFF554043),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.13,
                ),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -55,
                top: -55,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.045,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                left: -70,
                bottom: -90,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.055),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.10,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white
                                .withValues(alpha: 0.13),
                          ),
                        ),
                        child: Icon(
                          _isOpened
                              ? Icons.mark_email_read_outlined
                              : Icons.lock_clock_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.09,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            999,
                          ),
                          border: Border.all(
                            color: Colors.white
                                .withValues(alpha: 0.10),
                          ),
                        ),
                        child: Text(
                          _statusLabel,
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 7.5,
                            fontWeight:
                            FontWeight.w600,
                            letterSpacing: 1.1,
                            color: Colors.white
                                .withValues(alpha: 0.76),
                          ),
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: _isFavorite
                                ? const Color(0xFFF6C8CD)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  Text(
                    _isOpened
                        ? 'A little piece\nof then.'
                        : 'Something\nfor later.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      height: 1.06,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _statusDescription,
                    style:
                    AppTextTheme.bodyMedium.copyWith(
                      fontSize: 11,
                      height: 1.55,
                      color: Colors.white.withValues(
                        alpha: 0.67,
                      ),
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

  // ===========================================================================
  // STATUS CARD
  // ===========================================================================

  Widget _buildStatusCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isOpened
              ? const Color(0xFFF3ECEB)
              : const Color(0xFFF5E6E7),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isOpened
                    ? Icons.lock_open_rounded
                    : Icons.schedule_rounded,
                size: 20,
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
                    _isLocked
                        ? 'Opens ${_relativeDate(widget.message.openAt)}'
                        : _isReady
                        ? 'Ready right now'
                        : 'Opened ${_relativePastDate(widget.message.openAt)}',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatDateTime(
                      widget.message.openAt,
                    ),
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (_isLocked)
              _CountdownBadge(
                date: widget.message.openAt,
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  Widget _buildMessageCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          19,
          20,
          19,
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.86,
          ),
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.035,
              ),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _isLocked
            ? _buildLockedMessage()
            : _buildOpenedMessage(),
      ),
    );
  }

  Widget _buildLockedMessage() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFFF7E7E8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 25,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          widget.message.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 21,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 9),

        Text(
          'This message is sealed.\n'
              'Its words are waiting for the right moment.',
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 10.5,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 17),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F3F2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.visibility_off_outlined,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'The message stays private until '
                      'its opening date.',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    height: 1.4,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOpenedMessage() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFF5E5E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.format_quote_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Text(
                'YOUR MESSAGE',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 17),

        Text(
          widget.message.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 23,
            height: 1.15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.outlineVariant
              .withValues(alpha: 0.42),
        ),

        const SizedBox(height: 15),

        Text(
          widget.message.description,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            height: 1.65,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            const Icon(
              Icons.favorite_rounded,
              size: 12,
              color: AppColors.primary,
            ),
            const SizedBox(width: 5),
            Text(
              'Written for the future',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 8.5,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // MEMORY DETAILS
  // ===========================================================================

  Widget _buildMemoryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _ContentCard(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _sectionLabel('KEPT WITH IT'),

            const SizedBox(height: 13),

            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Created',
                    value: _formatDate(
                      widget.message.createdAt ??
                          DateTime.now(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _DetailItem(
                    icon: Icons.lock_clock_outlined,
                    label: 'Opened',
                    value: _formatDate(
                      widget.message.openAt,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PHOTOS
  // ===========================================================================

  Widget _buildPhotosSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _ContentCard(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _sectionLabel('LITTLE PIECES'),

            const SizedBox(height: 11),

            Row(
              children: [
                for (int i = 0;
                i <
                    (widget.message.photoCount >
                        4
                        ? 4
                        : widget.message.photoCount);
                i++)
                  Expanded(
                    child: Padding(
                      padding:
                      EdgeInsets.only(
                        right: i == 3 ? 0 : 7,
                      ),
                      child: Container(
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF2E7E6,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            13,
                          ),
                        ),
                        child: const Icon(
                          Icons.photo_outlined,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              '${widget.message.photoCount} photos were sealed with this message.',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // VOICE
  // ===========================================================================
  String _formatAudioDuration(
      Duration duration,
      ) {
    final minutes =
    duration.inMinutes.toString().padLeft(2, '0');

    final seconds =
    (duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  Widget _buildVoiceSection() {

    final fallbackDuration =
        widget.message.voiceDuration ??
            Duration.zero;

    final duration = _audioDuration > Duration.zero
        ? _audioDuration
        : fallbackDuration;

    final position = _audioPosition > duration
        ? duration
        : _audioPosition;

    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds /
        duration.inMilliseconds
        : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _ContentCard(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------------
            // SECTION TITLE
            // ---------------------------------------------------------------

            Text(
              'A VOICE FROM THEN',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // PLAYER
            // ---------------------------------------------------------------

            Row(
              children: [
                GestureDetector(
                  onTap: _toggleVoiceNote,
                  child: AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? AppColors.primary
                          : const Color(0xFFF5E5E7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 24,
                      color: _isPlaying
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _isPlaying
                                  ? 'Playing your voice note'
                                  : 'A little voice from then',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              GoogleFonts.playfairDisplay(
                                fontSize: 14.5,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                AppColors.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            _formatAudioDuration(
                              position,
                            ),
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 8.5,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      // -------------------------------------------------------
                      // PROGRESS BAR
                      // -------------------------------------------------------

                      GestureDetector(
                        onTapDown: (details) {
                          if (duration ==
                              Duration.zero) {
                            return;
                          }

                          final box =
                          context.findRenderObject()
                          as RenderBox;

                          final localPosition =
                          box.globalToLocal(
                            details.globalPosition,
                          );

                          final width =
                              box.size.width;

                          final percentage =
                          (localPosition.dx /
                              width)
                              .clamp(0.0, 1.0);

                          final newPosition =
                          Duration(
                            milliseconds:
                            (duration
                                .inMilliseconds *
                                percentage)
                                .round(),
                          );

                          _audioPlayer.seek(
                            newPosition,
                          );
                        },
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(999),
                          child: SizedBox(
                            height: 5,
                            child: Stack(
                              children: [
                                Container(
                                  color: const Color(
                                    0xFFE9DEDC,
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor:
                                  progress.clamp(
                                    0.0,
                                    1.0,
                                  ),
                                  child: Container(
                                    decoration:
                                    const BoxDecoration(
                                      color:
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            // ---------------------------------------------------------------
            // WAVEFORM
            // ---------------------------------------------------------------

            SizedBox(
              height: 28,
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: List.generate(
                  38,
                      (index) {
                    final isActive =
                        index <
                            (38 * progress);

                    final heights = [
                      8.0,
                      14.0,
                      20.0,
                      11.0,
                      17.0,
                      24.0,
                      13.0,
                      19.0,
                      9.0,
                      15.0,
                    ];

                    return Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 1.5,
                        ),
                        child: AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds: 180,
                          ),
                          height:
                          heights[index % 10],
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : const Color(
                              0xFFDCCCCC,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              999,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Text(
                  _isPlaying
                      ? 'Playing...'
                      : 'Tap to listen',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const Spacer(),

                Text(
                  _formatAudioDuration(duration),
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.5,
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

  // ===========================================================================
  // CREATED DETAILS
  // ===========================================================================

  Widget _buildCreatedDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _ContentCard(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _sectionLabel('CAPSULE DETAILS'),

            const SizedBox(height: 13),

            _DetailRow(
              icon: Icons.edit_calendar_outlined,
              label: 'Created',
              value: _formatDate(
                widget.message.createdAt ??
                    DateTime.now(),
              ),
            ),

            const SizedBox(height: 11),

            _DetailRow(
              icon: Icons.schedule_outlined,
              label: 'Opening date',
              value: _formatDateTime(
                widget.message.openAt,
              ),
            ),

            const SizedBox(height: 11),

            _DetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy',
              value: 'Just between us',
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildPrivateFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        28,
        24,
        28,
        0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            _isOpened
                ? 'Some words are worth waiting for.'
                : 'Some things are worth keeping for later.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
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
    if (_isLocked) {
      return const SizedBox.shrink();
    }

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
              padding:
              const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: GestureDetector(
                onTap: _isReady
                    ? widget.onOpen
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 58,
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
                    BorderRadius.circular(29),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(alpha: 0.23),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isReady
                            ? Icons.lock_open_rounded
                            : Icons.favorite_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isReady
                            ? 'Open This Message'
                            : 'Keep This Moment Close',
                        style: AppTextTheme
                            .labelLarge
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
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // OPTIONS
  // ===========================================================================

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            16,
            9,
            16,
            18,
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
              // -----------------------------------------------------------------
              // HANDLE
              // -----------------------------------------------------------------

              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              const SizedBox(height: 17),

              // -----------------------------------------------------------------
              // HEADER
              // -----------------------------------------------------------------

              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5E4E6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isOpened
                          ? Icons.mark_email_read_outlined
                          : Icons.lock_clock_outlined,
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
                          'Message options',
                          style:
                          GoogleFonts.playfairDisplay(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.message.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          AppTextTheme.labelSmall.copyWith(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // -----------------------------------------------------------------
              // OPTION 1 — OPEN / VIEW
              // -----------------------------------------------------------------

              if (_isReady)
                _FutureMessageOptionTile(
                  icon: Icons.lock_open_rounded,
                  iconBackground:
                  const Color(0xFFF5E4E6),
                  title: 'Open this message',
                  subtitle:
                  'The waiting is over.',
                  onTap: () {
                    Navigator.pop(sheetContext);

                    widget.onOpen?.call();
                  },
                ),

              // -----------------------------------------------------------------
              // OPTION 2 — FAVORITE
              // -----------------------------------------------------------------

              _FutureMessageOptionTile(
                icon: _isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconBackground:
                const Color(0xFFF5E4E6),
                title: _isFavorite
                    ? 'Remove favorite'
                    : 'Keep as favorite',
                subtitle: _isFavorite
                    ? 'Take it out of your favorites.'
                    : 'Keep this little message close.',
                onTap: () {
                  Navigator.pop(sheetContext);

                  _toggleFavorite();
                },
              ),

              // -----------------------------------------------------------------
              // OPTION 3 — SHARE
              // -----------------------------------------------------------------

              _FutureMessageOptionTile(
                icon: Icons.ios_share_outlined,
                iconBackground:
                const Color(0xFFF1EFF6),
                title: 'Share message',
                subtitle:
                'Share this little piece of your story.',
                onTap: () {
                  Navigator.pop(sheetContext);

                  _showMessage(
                    'Sharing can be connected later.',
                  );
                },
              ),

              // -----------------------------------------------------------------
              // OPTION 4 — DELETE
              // -----------------------------------------------------------------

              _FutureMessageOptionTile(
                icon: Icons.delete_outline_rounded,
                iconBackground:
                const Color(0xFFFCEEEE),
                title: 'Remove message',
                subtitle:
                'Let this little capsule go.',
                destructive: true,
                onTap: () {
                  Navigator.pop(sheetContext);

                  _confirmDelete(context);
                },
              ),

              const SizedBox(height: 3),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

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
            'Delete this capsule?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This little piece of your story will '
                'be permanently removed.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Keep it',
                style:
                AppTextTheme.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete?.call();
              },
              child: Text(
                'Delete',
                style:
                AppTextTheme.labelLarge.copyWith(
                  color: const Color(0xFF9A5B62),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // FAVORITE
  // ===========================================================================

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    widget.onFavoriteChanged?.call(
      _isFavorite,
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextTheme.labelSmall.copyWith(
        fontSize: 8.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.6,
        color: AppColors.textSecondary,
      ),
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;

    final minute =
    date.minute.toString().padLeft(2, '0');

    final period =
    date.hour >= 12 ? 'PM' : 'AM';

    return '${_formatDate(date)} • '
        '$hour:$minute $period';
  }

  String _relativeDate(DateTime date) {
    final difference =
    date.difference(DateTime.now());

    if (difference.inDays == 0) {
      return 'today';
    }

    if (difference.inDays == 1) {
      return 'tomorrow';
    }

    if (difference.inDays < 7) {
      return 'in ${difference.inDays} days';
    }

    if (difference.inDays < 30) {
      return 'in ${(difference.inDays / 7).ceil()} weeks';
    }

    if (difference.inDays < 365) {
      return 'in ${(difference.inDays / 30).ceil()} months';
    }

    return 'in ${(difference.inDays / 365).ceil()} years';
  }

  String _relativePastDate(DateTime date) {
    final difference =
    DateTime.now().difference(date);

    if (difference.inDays == 0) {
      return 'today';
    }

    if (difference.inDays == 1) {
      return 'yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }

    return '${(difference.inDays / 30).floor()} months ago';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.82,
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.40),
        ),
      ),
      child: child,
    );
  }
}

// =============================================================================
// DETAIL ITEM
// =============================================================================

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
            AppTextTheme.labelLarge.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DETAIL ROW
// =============================================================================

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
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: const BoxDecoration(
            color: Color(0xFFF7E8E9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            label,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
            AppTextTheme.labelLarge.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// COUNTDOWN BADGE
// =============================================================================

class _CountdownBadge extends StatelessWidget {
  const _CountdownBadge({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final difference =
    date.difference(DateTime.now());

    final days = difference.inDays;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.82,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        days <= 0
            ? 'Soon'
            : '$days ${days == 1 ? 'day' : 'days'}',
        style:
        AppTextTheme.labelSmall.copyWith(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
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
            alpha: 0.78,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
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
// SHEET
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

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? const Color(0xFF9A5B62)
        : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 4,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: destructive
                  ? color
                  : AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style:
              AppTextTheme.labelLarge.copyWith(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
  });

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(
          controller.value,
        );

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              16 * (1 - value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: _SoftCircle(
              size: 210,
              color: const Color(0xFFE8B4B8),
            ),
          ),
          Positioned(
            top: 420,
            left: -100,
            child: _SoftCircle(
              size: 230,
              color: const Color(0xFFDCD9E8),
            ),
          ),
          Positioned(
            bottom: 70,
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
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
    );
  }
}


class _FutureMessageOptionTile extends StatelessWidget {
  const _FutureMessageOptionTile({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final titleColor = destructive
        ? const Color(0xFF965B62)
        : AppColors.textPrimary;

    final iconColor = destructive
        ? const Color(0xFFB86F77)
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: destructive
                ? const Color(0xFFFFF5F5)
                : Colors.white.withValues(
              alpha: 0.88,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: destructive
                  ? const Color(0xFFF1D5D8)
                  : AppColors.outlineVariant
                  .withValues(alpha: 0.55),
            ),
          ),
          child: Row(
            children: [
              // ---------------------------------------------------------------
              // ICON
              // ---------------------------------------------------------------

              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 11),

              // ---------------------------------------------------------------
              // TEXT
              // ---------------------------------------------------------------

              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      AppTextTheme.labelLarge.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 7.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ---------------------------------------------------------------
              // ARROW
              // ---------------------------------------------------------------

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: destructive
                    ? const Color(0xFFB86F77)
                    : AppColors.primary,
              ),

              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}