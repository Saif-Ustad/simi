import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'create_future_message_screen.dart';

class FutureMessageReviewScreen extends StatefulWidget {
  const FutureMessageReviewScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onEdit,
    this.onSeal,
  });

  final CreateFutureMessageData data;

  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onSeal;

  @override
  State<FutureMessageReviewScreen> createState() =>
      _FutureMessageReviewScreenState();
}

class _FutureMessageReviewScreenState
    extends State<FutureMessageReviewScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _ReviewBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 150,
              ),
              children: [
                _buildTopBar(context),
                // _buildProgress(),
                _buildIntro(),
                _buildCapsuleHero(),
                _buildMessagePreview(),
                _buildOpeningDetails(),
                _buildAttachments(),
                _buildPrivacyCard(),
                _buildFinalMessage(),
              ],
            ),
          ),

          _buildBottomActions(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

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
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ready to Seal',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const Spacer(),

          _CircleButton(
            icon: Icons.lock_outline_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROGRESS
  // ---------------------------------------------------------------------------

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Row(
        children: [
          ...List.generate(
            4,
            (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 3 ? 0 : 5,
                  ),
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(999),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INTRO
  // ---------------------------------------------------------------------------

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        18,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'ONE LAST LOOK',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Ready to seal?',
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                height: 1.1,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Review your little capsule before '
              'locking it away in your private space.',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CAPSULE HERO
  // ---------------------------------------------------------------------------

  Widget _buildCapsuleHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.08,
        child: Container(
          width: double.infinity,
          height: 230,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF2DFE1),
                Color(0xFFEBD9DC),
                Color(0xFFF7ECEB),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.08,
                ),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -35,
                top: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.28,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                left: -45,
                bottom: -60,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.22,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 104,
                      height: 82,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.82),
                        borderRadius:
                            BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment:
                                Alignment.topCenter,
                            child: ClipPath(
                              clipper:
                                  _EnvelopeFlapClipper(),
                              child: Container(
                                height: 42,
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      Color(0xFFF9EEEC),
                                ),
                              ),
                            ),
                          ),

                          Center(
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_outline_rounded,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'A message for later',
                      style:
                          GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'sealed with love ❤️',
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
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MESSAGE PREVIEW
  // ---------------------------------------------------------------------------

  Widget _buildMessagePreview() {
    final message = widget.data.message.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.15,
        child: _ReviewCard(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _SectionLabel(
                title: 'YOUR MESSAGE',
                trailing: 'EDIT',
                onTrailingTap: widget.onEdit,
              ),

              const SizedBox(height: 14),

              Text(
                widget.data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              if (message.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCFB),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outlineVariant
                          .withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    message,
                    maxLines: 7,
                    overflow: TextOverflow.fade,
                    style:
                        AppTextTheme.bodyMedium.copyWith(
                      fontSize: 12.5,
                      height: 1.65,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                Text(
                  'No written message — just the '
                  'little memories attached to it.',
                  style:
                      AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    color:
                        AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OPENING DETAILS
  // ---------------------------------------------------------------------------

  Widget _buildOpeningDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.21,
        child: _ReviewCard(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _SectionLabel(
                title: 'OPENS WHEN',
                trailing: 'EDIT',
                onTrailingTap: widget.onEdit,
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F0EF),
                  borderRadius:
                      BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
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
                            _formatDate(
                              widget.data.openDate,
                            ),
                            style:
                                GoogleFonts.playfairDisplay(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatTime(
                              widget.data.openTime,
                            ),
                            style:
                                AppTextTheme.labelSmall
                                    .copyWith(
                              fontSize: 9,
                              color:
                                  AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.10),
                        borderRadius:
                            BorderRadius.circular(999),
                      ),
                      child: Text(
                        'LOCKED',
                        style:
                            AppTextTheme.labelSmall
                                .copyWith(
                          fontSize: 7.5,
                          fontWeight:
                              FontWeight.w600,
                          letterSpacing: 0.8,
                          color:
                              AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.lock_clock_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'It will remain hidden until this moment.',
                      style:
                          AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color:
                            AppColors.textSecondary,
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

  // ---------------------------------------------------------------------------
  // ATTACHMENTS
  // ---------------------------------------------------------------------------

  Widget _buildAttachments() {
    final photos = widget.data.photos;
    final voiceNote = widget.data.voiceNote;
    final hasVoice = voiceNote != null;

    if (photos.isEmpty && !hasVoice) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.27,
        child: _ReviewCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionLabel(
                title: 'KEPT WITH IT',
              ),

              const SizedBox(height: 13),

              if (photos.isNotEmpty)
                _buildPhotos(photos),

              if (photos.isNotEmpty && hasVoice)
                const SizedBox(height: 11),

              if (hasVoice)
                _buildVoiceRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotos(List<dynamic> photos) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: photos.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final photo = photos[index];

          return ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.file(
              File(photo.path),
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoiceRow() {
    final voiceNote = widget.data.voiceNote;

    if (voiceNote == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F1F1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              size: 19,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice note',
                  style: AppTextTheme.labelLarge.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'A little piece of your voice',
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

          const Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIVACY
  // ---------------------------------------------------------------------------

  Widget _buildPrivacyCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.33,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF332A2B),
            borderRadius: BorderRadius.circular(21),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.09,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JUST BETWEEN US',
                      style:
                          AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        fontWeight:
                            FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white
                            .withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Once sealed, this capsule stays '
                      'private until it opens.',
                      style:
                          GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        height: 1.35,
                        fontWeight:
                            FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'No one else gets to peek inside.',
                      style:
                          AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: Colors.white
                            .withValues(alpha: 0.55),
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

  // ---------------------------------------------------------------------------
  // FINAL MESSAGE
  // ---------------------------------------------------------------------------

  Widget _buildFinalMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        24,
        30,
        0,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Some things are worth waiting for.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTIONS
  // ---------------------------------------------------------------------------

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
                    onTap: widget.onSeal,
                    child: Container(
                      width: double.infinity,
                      height: 57,
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
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.13,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              size: 19,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Seal Capsule',
                                  style: GoogleFonts
                                      .playfairDisplay(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Lock it away until the right moment',
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: AppTextTheme
                                      .labelSmall
                                      .copyWith(
                                    fontSize: 9,
                                    color: Colors.white
                                        .withValues(
                                      alpha: 0.68,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 42,
                            height: 42,
                            margin:
                                const EdgeInsets.only(
                              right: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.12,
                              ),
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

                  // const SizedBox(height: 7),
                  //
                  // GestureDetector(
                  //   onTap: widget.onEdit,
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 43,
                  //     decoration: BoxDecoration(
                  //       color: AppColors.surface
                  //           .withValues(alpha: 0.90),
                  //       borderRadius:
                  //           BorderRadius.circular(22),
                  //       border: Border.all(
                  //         color: AppColors.primary
                  //             .withValues(alpha: 0.45),
                  //       ),
                  //     ),
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       'Edit Contents',
                  //       style:
                  //           AppTextTheme.labelLarge.copyWith(
                  //         fontSize: 11,
                  //         color: AppColors.primary,
                  //         fontWeight:
                  //             FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

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

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final minute = time.minute
        .toString()
        .padLeft(2, '0');

    final period =
        time.period == DayPeriod.am
            ? 'AM'
            : 'PM';

    return '$hour:$minute $period';
  }
}

// =============================================================================
// REVIEW CARD
// =============================================================================

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
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
          alpha: 0.84,
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.48),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style:
                  AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
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
            alpha: 0.74,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
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
// ENVELOPE FLAP
// =============================================================================

class _EnvelopeFlapClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height * 0.72);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
    this.delay = 0,
  });

  final AnimationController controller;
  final Widget child;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        1,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 * (1 - value),
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

class _ReviewBackground
    extends StatelessWidget {
  const _ReviewBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -80,
            child: _SoftCircle(
              size: 210,
              color: const Color(0xFFE8B4B8),
            ),
          ),
          Positioned(
            top: 430,
            left: -100,
            child: _SoftCircle(
              size: 220,
              color: const Color(0xFFDCD9E8),
            ),
          ),
          Positioned(
            bottom: 90,
            right: -80,
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
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
    );
  }
}