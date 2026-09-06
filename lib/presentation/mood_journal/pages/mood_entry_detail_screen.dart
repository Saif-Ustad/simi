import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'mood_journal_home_screen.dart';

class MoodEntryDetailScreen extends StatefulWidget {
  const MoodEntryDetailScreen({
    super.key,
    required this.date,
    this.entry,
    this.onBack,
    this.onEdit,
    this.onDelete,
    this.onAddMood,
  });

  final DateTime date;
  final MoodEntry? entry;

  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddMood;

  @override
  State<MoodEntryDetailScreen> createState() =>
      _MoodEntryDetailScreenState();
}

class _MoodEntryDetailScreenState
    extends State<MoodEntryDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  bool get _hasMood => widget.entry != null;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                bottom: 125,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                if (_hasMood) ...[
                  _buildMoodSummary(),
                  _buildNote(),
                  _buildIntensity(),
                  _buildSharing(),
                  _buildJournalReflection(),
                ] else
                  _buildEmptyState(),
              ],
            ),
          ),

          if (_hasMood)
            _buildBottomAction()
          else
            _buildAddAction(),
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
        16,
        4,
        16,
        0,
      ),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  Navigator.of(context).pop();
                }
              },
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
                    'MOOD JOURNAL',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A day in your story',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: _showOptions,
              child: const _CircleButton(
                icon: Icons.more_horiz_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    final entry = widget.entry;
    final info = entry == null
        ? null
        : _MoodInfo.fromMood(entry.mood);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.02,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            22,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D2728),
                Color(0xFF493638),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.13,
                ),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                _dateHeading(),
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: Colors.white.withValues(
                    alpha: 0.58,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _formatDate(widget.date),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 19),

              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: info?.background.withValues(
                    alpha: 0.22,
                  ) ??
                      Colors.white.withValues(
                        alpha: 0.09,
                      ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    info?.emoji ?? '🌷',
                    style: const TextStyle(
                      fontSize: 47,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 13),

              Text(
                info?.label ?? 'No mood yet',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                entry == null
                    ? 'A little space waiting for you.'
                    : _moodSubtitle(entry.mood),
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8.5,
                  height: 1.45,
                  color: Colors.white.withValues(
                    alpha: 0.60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SUMMARY
  // ===========================================================================

  Widget _buildMoodSummary() {
    final entry = widget.entry!;
    final info = _MoodInfo.fromMood(entry.mood);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _MoodSummaryCard(
                icon: _moodEmoji(entry.mood),
                label: 'MOOD',
                value: info.label,
                background: const Color(0xFFFCE8EA),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _MoodSummaryCard(
                iconWidget: _IntensityIndicator(
                  intensity: entry.intensity,
                ),
                label: 'ENERGY',
                value: _intensityLabel(entry.intensity),
                background: const Color(0xFFF3EFF8),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _MoodSummaryCard(
                iconWidget: Icon(
                  entry.isShared
                      ? Icons.favorite_rounded
                      : Icons.lock_outline_rounded,
                  size: 20,
                  color: entry.isShared
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                label: 'SHARED',
                value: entry.isShared ? 'With Love' : 'Just me',
                background: const Color(0xFFF4F1EF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _intensityLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Very low';
      case 2:
        return 'Low';
      case 3:
        return 'Balanced';
      case 4:
        return 'High';
      case 5:
        return 'Very high';
      default:
        return 'Balanced';
    }
  }

  // ===========================================================================
  // NOTE
  // ===========================================================================

  Widget _buildNote() {
    final note = widget.entry!.note.trim();

    if (note.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.16,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'WHAT WAS ON YOUR MIND',
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                18,
                19,
                18,
                19,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.82,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(
                    alpha: 0.42,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      size: 17,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Text(
                      note,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
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
  // INTENSITY
  // ===========================================================================

  Widget _buildIntensity() {
    final intensity = widget.entry!.intensity;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.21,
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.76,
            ),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.4,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _SectionLabel(
                    title: 'FEELING INTENSITY',
                  ),
                  const Spacer(),
                  Text(
                    _intensityLabel(intensity),
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: List.generate(
                  5,
                      (index) {
                    final selected =
                        index < intensity;

                    return Expanded(
                      child: Container(
                        height: 8,
                        margin: EdgeInsets.only(
                          right: index == 4 ? 0 : 5,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : const Color(0xFFE8E1DF),
                          borderRadius:
                          BorderRadius.circular(999),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'A little',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 7.5,
                      color: AppColors.textDisabled,
                    ),
                  ),
                  Text(
                    'A lot',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 7.5,
                      color: AppColors.textDisabled,
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
  // SHARING
  // ===========================================================================

  Widget _buildSharing() {
    final shared = widget.entry!.isShared;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.26,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: shared
                ? const Color(0xFFFCE4EC).withValues(
              alpha: 0.62,
            )
                : Colors.white.withValues(
              alpha: 0.72,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: shared
                  ? const Color(0xFFE8B4B8)
                  : AppColors.outlineVariant.withValues(
                alpha: 0.4,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  shared
                      ? Icons.favorite_rounded
                      : Icons.lock_outline_rounded,
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
                      shared
                          ? 'Love can see this'
                          : 'This stayed with you',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      shared
                          ? 'You chose to share this little feeling.'
                          : 'This mood is private to you.',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8.5,
                        color: AppColors.textSecondary,
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

  // ===========================================================================
  // REFLECTION
  // ===========================================================================

  Widget _buildJournalReflection() {
    final entry = widget.entry!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.31,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            19,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF7EFED),
                Color(0xFFF1E7E5),
              ],
            ),
            borderRadius: BorderRadius.circular(23),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: AppColors.primary,
              ),

              const SizedBox(height: 10),

              Text(
                _reflectionText(
                  entry.mood,
                  entry.intensity,
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'A small moment worth remembering.',
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.12,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            24,
            32,
            24,
            30,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.76,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.4,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '🌷',
                    style: TextStyle(
                      fontSize: 33,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Nothing written here yet.',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Some days deserve a little note.\n'
                    'How did this day feel?',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: GestureDetector(
                onTap: widget.onEdit,
                child: Container(
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.08,
                        ),
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
                          color: Colors.white.withValues(
                            alpha: 0.14,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 20,
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
                              'Change this feeling',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Keep your journal up to date',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: AppTextTheme.labelSmall.copyWith(
                                fontSize: 9,
                                color: Colors.white.withValues(
                                  alpha: 0.72,
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
                        const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddAction() {
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
              child: GestureDetector(
                onTap: widget.onAddMood,
                child: Container(
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
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
                          color: Colors.white.withValues(
                            alpha: 0.14,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 23,
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
                              'Add your mood',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'A tiny note about today',
                              style: AppTextTheme.labelSmall.copyWith(
                                fontSize: 9,
                                color: Colors.white.withValues(
                                  alpha: 0.72,
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
                        const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
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
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // OPTIONS
  // ===========================================================================

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
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
              const _SheetHandle(),

              const SizedBox(height: 20),

              Text(
                'This little day',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Keep your journal exactly how you want it.',
                textAlign: TextAlign.center,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              if (_hasMood)
                _SheetAction(
                  icon: Icons.edit_outlined,
                  title: 'Edit mood',
                  subtitle: 'Change the feeling or note',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onEdit?.call();
                  },
                ),

              if (_hasMood)
                const SizedBox(height: 9),

              if (_hasMood)
                _SheetAction(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete this entry',
                  subtitle: 'Remove this mood from your journal',
                  destructive: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDelete();
                  },
                ),

              if (!_hasMood)
                _SheetAction(
                  icon: Icons.add_rounded,
                  title: 'Add a mood',
                  subtitle: 'Write something about this day',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onAddMood?.call();
                  },
                ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Remove this mood?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This little moment will be removed from your mood journal.',
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
              child: const Text('Keep it'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete?.call();
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _dateHeading() {
    final today = DateTime.now();

    if (_sameDate(widget.date, today)) {
      return 'TODAY';
    }

    final yesterday =
    today.subtract(const Duration(days: 1));

    if (_sameDate(widget.date, yesterday)) {
      return 'YESTERDAY';
    }

    return _weekdayName(widget.date.weekday)
        .toUpperCase();
  }

  bool _sameDate(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
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

  String _weekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[weekday - 1];
  }

  // String _intensityLabel(int intensity) {
  //   switch (intensity) {
  //     case 1:
  //       return 'Very light';
  //     case 2:
  //       return 'A little';
  //     case 3:
  //       return 'Just right';
  //     case 4:
  //       return 'Strong';
  //     case 5:
  //       return 'Very strong';
  //     default:
  //       return 'Just right';
  //   }
  // }

  String _moodSubtitle(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return 'A bright little moment in your day.';

      case MoodType.loved:
        return 'Feeling close, warm and connected.';

      case MoodType.calm:
        return 'Everything feels a little quieter.';

      case MoodType.normal:
        return 'Nothing too high, nothing too low.';

      case MoodType.sad:
        return 'Some days simply feel a little heavier.';

      case MoodType.angry:
        return 'Something felt a little too much today.';

      case MoodType.tired:
        return 'Maybe today just needed a little softness.';
    }
  }

  String _reflectionText(
      MoodType mood,
      int intensity,
      ) {
    switch (mood) {
      case MoodType.happy:
        return intensity >= 4
            ? 'You had one of those beautifully bright days.'
            : 'A little happiness found its way into today.';

      case MoodType.loved:
        return 'There was a little more warmth in your world today.';

      case MoodType.calm:
        return 'Some days do not need much. Quiet can be enough.';

      case MoodType.normal:
        return 'An ordinary day is still part of your story.';

      case MoodType.sad:
        return 'It is okay to have days that feel a little heavier.';

      case MoodType.angry:
        return 'Whatever today held, you made space for the feeling.';

      case MoodType.tired:
        return 'Rest is part of the story too. Be gentle with yourself.';
    }
  }
}

// ===========================================================================
// SUMMARY CARD
// ===========================================================================

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.fromLTRB(
        10,
        12,
        8,
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.78,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.38,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.playfairDisplay(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 7,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// MOOD INFO
// ===========================================================================

class _MoodInfo {
  const _MoodInfo({
    required this.emoji,
    required this.label,
    required this.background,
  });

  final String emoji;
  final String label;
  final Color background;

  static _MoodInfo fromMood(
      MoodType mood,
      ) {
    switch (mood) {
      case MoodType.happy:
        return const _MoodInfo(
          emoji: '😊',
          label: 'Happy',
          background: Color(0xFFFFF2CC),
        );

      case MoodType.loved:
        return const _MoodInfo(
          emoji: '🥰',
          label: 'Loved',
          background: Color(0xFFFCE4EC),
        );

      case MoodType.calm:
        return const _MoodInfo(
          emoji: '😌',
          label: 'Calm',
          background: Color(0xFFE8F3F1),
        );

      case MoodType.normal:
        return const _MoodInfo(
          emoji: '😐',
          label: 'Normal',
          background: Color(0xFFF1F1F1),
        );

      case MoodType.sad:
        return const _MoodInfo(
          emoji: '😔',
          label: 'Low',
          background: Color(0xFFE8EAF6),
        );

      case MoodType.angry:
        return const _MoodInfo(
          emoji: '😡',
          label: 'Angry',
          background: Color(0xFFFDE2E2),
        );

      case MoodType.tired:
        return const _MoodInfo(
          emoji: '😴',
          label: 'Tired',
          background: Color(0xFFEDE7F6),
        );
    }
  }
}

// ===========================================================================
// SECTION LABEL
// ===========================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.7,
        color: AppColors.textSecondary,
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
          color: AppColors.outlineVariant.withValues(
            alpha: 0.45,
          ),
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

// ===========================================================================
// SHEET
// ===========================================================================

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
    final iconColor = destructive
        ? const Color(0xFF9B555B)
        : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.75,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.4,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: destructive
                    ? const Color(0xFFFDECEC)
                    : const Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 11,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// BACKGROUND
// ===========================================================================

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

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
                Color(0xFFF4EBE8),
              ],
            ),
          ),
        ),

        Positioned(
          left: -100,
          top: 120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          right: -110,
          bottom: 120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFD8D5E5).withValues(
                  alpha: 0.14,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// ANIMATION
// ===========================================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.delay,
    required this.child,
  });

  final AnimationController controller;
  final double delay;
  final Widget child;

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
      child: child,
    );
  }
}


class _MoodSummaryCard extends StatelessWidget {
  const _MoodSummaryCard({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.value,
    required this.background,
  });

  final String? icon;
  final Widget? iconWidget;
  final String label;
  final String value;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.fromLTRB(
        12,
        13,
        10,
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget ??
                Text(
                  icon ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
          ),

          const Spacer(),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}


class _IntensityIndicator extends StatelessWidget {
  const _IntensityIndicator({
    required this.intensity,
  });

  final int intensity;

  @override
  Widget build(BuildContext context) {
    final value = intensity.clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        5,
            (index) {
          final active = index < value;

          return Container(
            width: 4,
            height: 7 + (index * 2.0),
            margin: EdgeInsets.only(
              right: index == 4 ? 0 : 2,
            ),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary
                  : AppColors.outlineVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        },
      ),
    );
  }
}

String _moodEmoji(MoodType mood) {
  switch (mood) {
    case MoodType.happy:
      return '😊';
    case MoodType.loved:
      return '🥰';
    case MoodType.calm:
      return '😌';
    case MoodType.normal:
      return '🙂';
    case MoodType.sad:
      return '😔';
    case MoodType.angry:
      return '😤';
    case MoodType.tired:
      return '😴';
  }
}