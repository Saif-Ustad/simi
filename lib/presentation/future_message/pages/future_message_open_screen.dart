import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'future_messages_home_screen.dart';

class FutureMessageOpenScreen extends StatefulWidget {
  const FutureMessageOpenScreen({
    super.key,
    required this.message,
    this.onBack,
    this.onOpened,
  });

  final FutureMessageItem message;

  final VoidCallback? onBack;
  final VoidCallback? onOpened;

  @override
  State<FutureMessageOpenScreen> createState() =>
      _FutureMessageOpenScreenState();
}

class _FutureMessageOpenScreenState
    extends State<FutureMessageOpenScreen>
    with TickerProviderStateMixin {
  late final AnimationController _capsuleController;
  late final AnimationController _letterController;
  late final AnimationController _heartController;

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _revealed = false;
  bool _isPlaying = false;

  Duration _voicePosition = Duration.zero;
  Duration _voiceDuration = Duration.zero;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _completeSubscription;

  @override
  void initState() {
    super.initState();

    _capsuleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    _letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (!mounted) return;

          setState(() {
            _isPlaying = state == PlayerState.playing;
          });
        });

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((duration) {
          if (!mounted) return;

          setState(() {
            _voiceDuration = duration;
          });
        });

    _positionSubscription =
        _audioPlayer.onPositionChanged.listen((position) {
          if (!mounted) return;

          setState(() {
            _voicePosition = position;
          });
        });

    _completeSubscription =
        _audioPlayer.onPlayerComplete.listen((_) {
          if (!mounted) return;

          setState(() {
            _isPlaying = false;
            _voicePosition = Duration.zero;
          });
        });

    _startReveal();
  }

  Future<void> _startReveal() async {
    await Future.delayed(
      const Duration(milliseconds: 350),
    );

    if (!mounted) return;

    await _capsuleController.forward();

    if (!mounted) return;

    setState(() {
      _revealed = true;
    });

    await _letterController.forward();

    if (!mounted) return;

    widget.onOpened?.call();
  }

  @override
  void dispose() {
    _capsuleController.dispose();
    _letterController.dispose();
    _heartController.dispose();

    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _completeSubscription?.cancel();

    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6ECE8),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _LoveLetterBackground(),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(context),

                Expanded(
                  child: _revealed
                      ? _buildOpenedLetter()
                      : _buildOpeningState(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onBack ??
                      () => Navigator.pop(context),
              child: const _CircleButton(
                icon: Icons.arrow_back_rounded,
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    'FUTURE MESSAGE',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _revealed
                        ? 'A letter from then'
                        : 'Something waited for you',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 42),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // OPENING
  // ===========================================================================

  Widget _buildOpeningState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: 650,
        child: Center(
          child: AnimatedBuilder(
            animation: _capsuleController,
            builder: (context, child) {
              final value = Curves.easeInOut.transform(
                _capsuleController.value,
              );

              final scale = 1 + (value * 0.08);

              return Opacity(
                opacity: _capsuleController.value > 0.72
                    ? (1 -
                    ((_capsuleController.value - 0.72) /
                        0.28))
                    .clamp(0.0, 1.0)
                    : 1,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSealedLetter(),

                const SizedBox(height: 34),

                Text(
                  'A LITTLE SURPRISE',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.3,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 11),

                Text(
                  'Someone left this\nfor you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    height: 1.12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  'A little piece of the past\nis finding its way to you.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SEALED LETTER
  // ===========================================================================

  Widget _buildSealedLetter() {
    return AnimatedBuilder(
      animation: _heartController,
      builder: (context, child) {
        final scale =
            1 + (_heartController.value * 0.035);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF251E20),
              Color(0xFF50383C),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.22,
              ),
              blurRadius: 45,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                ),
              ),
            ),

            Container(
              width: 112,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F3),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.18,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                size: 42,
                color: Color(0xFF8E6E6E),
              ),
            ),

            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFFE8B4B8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 21,
                color: Colors.white,
              ),
            ),

            Positioned(
              right: 28,
              top: 27,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8B4B8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // OPENED LETTER
  // ===========================================================================

  Widget _buildOpenedLetter() {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _letterController,
        curve: Curves.easeOut,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          18,
          8,
          18,
          45,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _buildOpenedHero(),

            const SizedBox(height: 18),

            _buildLetterPaper(),

            if (widget.message.photoCount > 0) ...[
              const SizedBox(height: 24),
              _buildPhotoSection(),
            ],

            if (_hasVoiceNote()) ...[
              const SizedBox(height: 24),
              _buildVoiceSection(),
            ],

            const SizedBox(height: 28),

            _buildClosingMessage(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // OPENED HERO
  // ===========================================================================

  Widget _buildOpenedHero() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_rounded,
              size: 29,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'THE WAIT IS OVER',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.2,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'It finally found you.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 27,
              height: 1.15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Written in the past. Meant for today.',
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // LETTER PAPER
  // ===========================================================================

  Widget _buildLetterPaper() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        24,
        22,
        26,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF8),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: const Color(0xFFE4D5CE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.07,
            ),
            blurRadius: 28,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              '♡',
              style: GoogleFonts.playfairDisplay(
                fontSize: 40,
                color: const Color(0xFFE8B4B8),
              ),
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'FOR YOU',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                widget.message.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  height: 1.18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Written ${_formatDate(widget.message.createdAt)}',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 8.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 21),

              Container(
                height: 1,
                color: const Color(0xFFE8DDD7),
              ),

              const SizedBox(height: 23),

              Text(
                widget.message.description,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  height: 1.72,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 26),

              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 13,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      'Kept safe until the right moment.',
                      style:
                      GoogleFonts.playfairDisplay(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PHOTOS
  // ===========================================================================

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'MOMENTS YOU KEPT WITH IT',
          'Little pieces of the story.',
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics:
            const BouncingScrollPhysics(),
            itemCount: widget.message.photoCount,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 11),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showPhotoViewer(index);
                },
                child: Container(
                  width: 165,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFEFE4E0,
                    ),
                    borderRadius:
                    BorderRadius.circular(21),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 15,
                        offset: const Offset(
                          0,
                          7,
                        ),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.photo_outlined,
                          size: 38,
                          color:
                          AppColors.primary,
                        ),
                      ),

                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration:
                          BoxDecoration(
                            color: Colors.black
                                .withValues(
                              alpha: 0.43,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .photo_camera_outlined,
                                size: 12,
                                color:
                                Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${index + 1} / ${widget.message.photoCount}',
                                style:
                                const TextStyle(
                                  fontSize: 9,
                                  color:
                                  Colors.white,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 9),

        Text(
          'Tap a photo to look closer',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 8.5,
            color: AppColors.textDisabled,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // VOICE
  // ===========================================================================

  bool _hasVoiceNote() {
    return widget.message.voiceDuration != null;
  }

  Widget _buildVoiceSection() {
    final total =
    _voiceDuration == Duration.zero
        ? (widget.message.voiceDuration ??
        Duration.zero)
        : _voiceDuration;

    final maxSeconds =
    total.inSeconds <= 0
        ? 1.0
        : total.inSeconds.toDouble();

    final currentSeconds =
    _voicePosition.inSeconds
        .clamp(0, total.inSeconds)
        .toDouble();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'A LITTLE PIECE OF THEIR VOICE',
          'Some memories are better heard.',
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            15,
            16,
            15,
            14,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF292122),
                Color(0xFF4D373A),
              ],
            ),
            borderRadius:
            BorderRadius.circular(23),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.13,
                ),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _toggleVoicePlayback,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration:
                      const BoxDecoration(
                        color: Color(0xFFE8B4B8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A voice note from then',
                          style: GoogleFonts
                              .playfairDisplay(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _isPlaying
                              ? 'Playing now…'
                              : 'Tap play to hear it',
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 8.5,
                            color: Colors.white
                                .withValues(
                              alpha: 0.62,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.graphic_eq_rounded,
                    size: 25,
                    color: Color(0xFFE8B4B8),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape:
                  const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  overlayShape:
                  const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                  activeTrackColor:
                  const Color(0xFFE8B4B8),
                  inactiveTrackColor:
                  Colors.white.withValues(
                    alpha: 0.15,
                  ),
                  thumbColor:
                  const Color(0xFFE8B4B8),
                ),
                child: Slider(
                  min: 0,
                  max: maxSeconds,
                  value: currentSeconds,
                  onChanged: (value) {
                    _audioPlayer.seek(
                      Duration(
                        seconds: value.round(),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(
                        _voicePosition,
                      ),
                      style:
                      _voiceTimeStyle(),
                    ),
                    Text(
                      _formatDuration(total),
                      style:
                      _voiceTimeStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _voiceTimeStyle() {
    return TextStyle(
      fontSize: 8,
      color: Colors.white.withValues(
        alpha: 0.48,
      ),
    );
  }

  Future<void> _toggleVoicePlayback() async {
    final path = widget.message.voicePath;

    if (path == null || path.trim().isEmpty) {
      _showMessage(
        'No voice recording is attached.',
      );
      return;
    }

    try {
      final file = File(path);

      if (!await file.exists()) {
        _showMessage(
          'This voice recording is no longer available.',
        );
        return;
      }

      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(
          DeviceFileSource(path),
        );
      }
    } catch (e) {
      debugPrint(
        'VOICE PLAY ERROR: $e',
      );

      _showMessage(
        'Could not play the voice note.',
      );
    }
  }

  // ===========================================================================
  // PHOTO VIEWER
  // ===========================================================================

  void _showPhotoViewer(int index) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(
        alpha: 0.92,
      ),
      builder: (dialogContext) {
        return GestureDetector(
          onTap: () =>
              Navigator.pop(dialogContext),
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'future-photo-$index',
                      child: Container(
                        margin:
                        const EdgeInsets.all(
                          20,
                        ),
                        height: 520,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                          const Color(0xFF292122),
                          borderRadius:
                          BorderRadius.circular(
                            27,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_outlined,
                            size: 58,
                            color:
                            Color(0xFFE8B4B8),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 16,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pop(
                            dialogContext,
                          ),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 22,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Photo ${index + 1} of ${widget.message.photoCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // CLOSING
  // ===========================================================================

  Widget _buildClosingMessage() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Some things are worth waiting for.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Opened today • ${_formatDate(DateTime.now())}',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8.5,
              color: AppColors.textDisabled,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Just between us.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.7,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textDisabled,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes
        .toString()
        .padLeft(2, '0');

    final seconds =
    (duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

// ===========================================================================
// BACKGROUND
// ===========================================================================

class _LoveLetterBackground extends StatelessWidget {
  const _LoveLetterBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8F5),
                Color(0xFFF4E8E4),
              ],
            ),
          ),
        ),

        Positioned(
          left: -100,
          top: 120,
          child: _BlurCircle(
            size: 240,
            color: const Color(0xFFE8B4B8),
          ),
        ),

        Positioned(
          right: -120,
          bottom: 120,
          child: _BlurCircle(
            size: 270,
            color: const Color(0xFFD7D0E2),
          ),
        ),
      ],
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 48,
        sigmaY: 48,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(
            alpha: 0.17,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ===========================================================================
// CIRCLE BUTTON
// ===========================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.72,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.45),
        ),
      ),
      child: Icon(
        icon,
        size: 19,
        color: AppColors.textPrimary,
      ),
    );
  }
}