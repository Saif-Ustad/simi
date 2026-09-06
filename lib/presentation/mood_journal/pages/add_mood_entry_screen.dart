import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

import 'mood_journal_home_screen.dart';

class AddMoodEntryData {
  const AddMoodEntryData({
    required this.date,
    required this.mood,
    required this.intensity,
    required this.note,
    required this.isShared,
  });

  final DateTime date;
  final MoodType mood;
  final int intensity;
  final String note;
  final bool isShared;
}

class AddMoodEntryScreen extends StatefulWidget {
  const AddMoodEntryScreen({
    super.key,
    this.initialDate,
    this.initialMood,
    this.initialIntensity = 3,
    this.initialNote = '',
    this.initialIsShared = false,
    this.onBack,
    this.onSave,
  });

  final DateTime? initialDate;
  final MoodType? initialMood;
  final int initialIntensity;
  final String initialNote;
  final bool initialIsShared;

  final VoidCallback? onBack;
  final ValueChanged<AddMoodEntryData>? onSave;

  @override
  State<AddMoodEntryScreen> createState() =>
      _AddMoodEntryScreenState();
}

class _AddMoodEntryScreenState
    extends State<AddMoodEntryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late DateTime _selectedDate;
  late MoodType _selectedMood;
  late int _intensity;
  late bool _isShared;

  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    _selectedDate =
        widget.initialDate ?? DateTime.now();

    _selectedMood =
        widget.initialMood ?? MoodType.happy;

    _intensity =
        widget.initialIntensity.clamp(1, 5);

    _isShared =
        widget.initialIsShared;

    _noteController =
        TextEditingController(
          text: widget.initialNote,
        );

    _animationController =
    AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 750),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _AddMoodBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 130,
              ),
              children: [
                _buildTopBar(context),
                _buildHeader(),
                _buildDateSection(),
                _buildMoodSection(),
                _buildIntensitySection(),
                _buildNoteSection(),
                _buildSharingSection(),
                _buildPreview(),
                _buildPrivacyNote(),
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
                    style:
                    AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 8,
                      fontWeight:
                      FontWeight.w600,
                      letterSpacing: 1.8,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A little check-in',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      AppColors.textPrimary,
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
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    final info =
    _MoodInfo.fromMood(
      _selectedMood,
    );

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
        child: Column(
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: info.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: info.background
                        .withValues(
                      alpha: 0.5,
                    ),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  child: Text(
                    info.emoji,
                    key: ValueKey(
                      _selectedMood,
                    ),
                    style:
                    const TextStyle(
                      fontSize: 48,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'HOW ARE YOU FEELING?',
              style:
              AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 8.5,
                fontWeight:
                FontWeight.w600,
                letterSpacing: 1.8,
                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(height: 5),

            AnimatedSwitcher(
              duration:
              const Duration(
                milliseconds: 220,
              ),
              child: Text(
                info.label,
                key: ValueKey(
                  _selectedMood,
                ),
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 27,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              _moodDescription(
                _selectedMood,
              ),
              textAlign: TextAlign.center,
              style:
              AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 9,
                height: 1.45,
                color:
                AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DATE
  // ===========================================================================

  Widget _buildDateSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.08,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'WHEN WAS THIS?',
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                decoration:
                BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.82,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    19,
                  ),
                  border: Border.all(
                    color: AppColors
                        .outlineVariant
                        .withValues(
                      alpha: 0.45,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFFFCE4EC),
                        shape:
                        BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons
                            .calendar_today_outlined,
                        size: 17,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            _dateLabel(),
                            style: GoogleFonts
                                .playfairDisplay(
                              fontSize: 16,
                              fontWeight:
                              FontWeight
                                  .w600,
                              color:
                              AppColors
                                  .textPrimary,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            _formatDate(
                              _selectedDate,
                            ),
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 8.5,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      size: 20,
                      color:
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MOOD
  // ===========================================================================

  Widget _buildMoodSection() {
    final moods = MoodType.values;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.13,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'CHOOSE YOUR MOOD',
            ),

            const SizedBox(height: 10),

            Container(
              padding:
              const EdgeInsets.all(10),
              decoration:
              BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.72,
                ),
                borderRadius:
                BorderRadius.circular(
                  22,
                ),
                border: Border.all(
                  color: AppColors
                      .outlineVariant
                      .withValues(
                    alpha: 0.4,
                  ),
                ),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: moods.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.92,
                ),
                itemBuilder:
                    (context, index) {
                  final mood = moods[index];

                  return _MoodChoice(
                    mood: mood,
                    selected:
                    mood ==
                        _selectedMood,
                    onTap: () {
                      setState(() {
                        _selectedMood =
                            mood;
                      });
                    },
                  );
                },
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

  Widget _buildIntensitySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.18,
        child: Container(
          padding:
          const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            15,
          ),
          decoration:
          BoxDecoration(
            color: Colors.white
                .withValues(
              alpha: 0.76,
            ),
            borderRadius:
            BorderRadius.circular(21),
            border: Border.all(
              color: AppColors
                  .outlineVariant
                  .withValues(
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
                    title: 'HOW STRONG WAS IT?',
                  ),
                  const Spacer(),
                  Text(
                    _intensityLabel(),
                    style: AppTextTheme
                        .labelSmall
                        .copyWith(
                      fontSize: 9,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children:
                List.generate(
                  5,
                      (index) {
                    final value =
                        index + 1;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _intensity =
                                value;
                          });
                        },
                        child:
                        AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds:
                            180,
                          ),
                          height: 42,
                          margin:
                          EdgeInsets.only(
                            right:
                            index == 4
                                ? 0
                                : 6,
                          ),
                          decoration:
                          BoxDecoration(
                            color: value <=
                                _intensity
                                ? const Color(
                              0xFFFCE4EC,
                            )
                                : const Color(
                              0xFFF5F1EF,
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                            border:
                            Border.all(
                              color: value <=
                                  _intensity
                                  ? const Color(
                                0xFFE8B4B8,
                              )
                                  : Colors
                                  .transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$value',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 10,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color: value <=
                                    _intensity
                                    ? AppColors
                                    .primary
                                    : AppColors
                                    .textDisabled,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // NOTE
  // ===========================================================================

  Widget _buildNoteSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.23,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'A LITTLE NOTE',
            ),

            const SizedBox(height: 6),

            Text(
              'You can keep it simple.',
              style:
              AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 8.5,
                color:
                AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              decoration:
              BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.82,
                ),
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: AppColors
                      .outlineVariant
                      .withValues(
                    alpha: 0.42,
                  ),
                ),
              ),
              child: TextField(
                controller:
                _noteController,
                maxLines: 5,
                minLines: 4,
                textCapitalization:
                TextCapitalization
                    .sentences,
                style: AppTextTheme
                    .bodyMedium
                    .copyWith(
                  fontSize: 12,
                  height: 1.5,
                  color:
                  AppColors.textPrimary,
                ),
                decoration:
                InputDecoration(
                  hintText:
                  'What is on your mind today?',
                  hintStyle: AppTextTheme
                      .bodyMedium
                      .copyWith(
                    fontSize: 12,
                    color:
                    AppColors.textDisabled,
                  ),
                  border:
                  InputBorder.none,
                  contentPadding:
                  const EdgeInsets
                      .all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SHARE
  // ===========================================================================

  Widget _buildSharingSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.28,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isShared = !_isShared;
            });
          },
          child: AnimatedContainer(
            duration:
            const Duration(
              milliseconds: 200,
            ),
            padding:
            const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _isShared
                  ? const Color(
                0xFFFCE4EC,
              ).withValues(
                alpha: 0.65,
              )
                  : Colors.white
                  .withValues(
                alpha: 0.72,
              ),
              borderRadius:
              BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: _isShared
                    ? const Color(
                  0xFFE8B4B8,
                )
                    : AppColors
                    .outlineVariant
                    .withValues(
                  alpha: 0.4,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration:
                  const BoxDecoration(
                    color:
                    Colors.white,
                    shape:
                    BoxShape.circle,
                  ),
                  child: Icon(
                    _isShared
                        ? Icons.favorite_rounded
                        : Icons
                        .favorite_border_rounded,
                    size: 19,
                    color:
                    AppColors.primary,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'Share with Love',
                        style: GoogleFonts
                            .playfairDisplay(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          AppColors
                              .textPrimary,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        _isShared
                            ? 'Love will be able to see this mood.'
                            : 'Keep this little feeling just for you.',
                        maxLines: 2,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style: AppTextTheme
                            .labelSmall
                            .copyWith(
                          fontSize: 8.5,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 200,
                  ),
                  width: 45,
                  height: 27,
                  padding:
                  const EdgeInsets.all(
                    3,
                  ),
                  decoration:
                  BoxDecoration(
                    color: _isShared
                        ? AppColors
                        .primary
                        : const Color(
                      0xFFE4DCDA,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      999,
                    ),
                  ),
                  child:
                  AnimatedAlign(
                    duration:
                    const Duration(
                      milliseconds: 200,
                    ),
                    alignment: _isShared
                        ? Alignment
                        .centerRight
                        : Alignment
                        .centerLeft,
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration:
                      const BoxDecoration(
                        color:
                        Colors.white,
                        shape:
                        BoxShape.circle,
                      ),
                    ),
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
  // PREVIEW
  // ===========================================================================

  Widget _buildPreview() {
    final info =
    _MoodInfo.fromMood(
      _selectedMood,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.33,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'A LITTLE PREVIEW',
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient:
                const LinearGradient(
                  begin:
                  Alignment.topLeft,
                  end:
                  Alignment.bottomRight,
                  colors: [
                    Color(0xFF2D2728),
                    Color(0xFF493638),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(
                  23,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(
                      alpha: 0.12,
                    ),
                    blurRadius: 20,
                    offset:
                    const Offset(0, 8),
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
                        width: 38,
                        height: 38,
                        decoration:
                        BoxDecoration(
                          color: info
                              .background
                              .withValues(
                            alpha: 0.22,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            info.emoji,
                            style:
                            const TextStyle(
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              info.label,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 16,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              _formatDate(
                                _selectedDate,
                              ),
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 8,
                                color: Colors
                                    .white
                                    .withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_isShared)
                        const Icon(
                          Icons
                              .favorite_rounded,
                          size: 15,
                          color: Color(
                            0xFFE8B4B8,
                          ),
                        ),
                    ],
                  ),

                  if (_noteController
                      .text
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '"${_noteController.text.trim()}"',
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 13,
                        height: 1.45,
                        fontStyle:
                        FontStyle.italic,
                        color: Colors.white
                            .withValues(
                          alpha: 0.88,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Text(
                        'Mood Journal',
                        style: AppTextTheme
                            .labelSmall
                            .copyWith(
                          fontSize: 7.5,
                          letterSpacing:
                          1.2,
                          color: Colors.white
                              .withValues(
                            alpha: 0.42,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'just a little piece of today',
                        style: AppTextTheme
                            .labelSmall
                            .copyWith(
                          fontSize: 7,
                          color: Colors.white
                              .withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ],
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
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacyNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        10,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 12,
            color: AppColors.textDisabled,
          ),
          const SizedBox(width: 5),
          Text(
            _isShared
                ? 'Shared only with your Love'
                : 'Private to you',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              color:
              AppColors.textDisabled,
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
            constraints:
            const BoxConstraints(
              maxWidth: 540,
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: GestureDetector(
                onTap: _save,
                child: Container(
                  height: 58,
                  decoration:
                  BoxDecoration(
                    gradient:
                    const LinearGradient(
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color(0xFF765457),
                        Color(0xFF966E72),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      29,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 20,
                        offset:
                        const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 12,
                        offset:
                        const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),

                      Container(
                        width: 46,
                        height: 46,
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.14,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .favorite_border_rounded,
                          size: 21,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 13,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              'Save this feeling',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Keep a little piece of today',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors
                                    .white
                                    .withValues(
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
                        const EdgeInsets
                            .only(
                          right: 4,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.12,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 19,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 2,
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
  // ACTIONS
  // ===========================================================================

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked =
    await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(
        now.year - 2,
      ),
      lastDate: now,
      builder: (
          context,
          child,
          ) {
        return Theme(
          data: Theme.of(context)
              .copyWith(
            colorScheme:
            const ColorScheme.light(
              primary:
              AppColors.primary,
              surface:
              AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = picked;
    });
  }

  void _save() {
    final data = AddMoodEntryData(
      date: _selectedDate,
      mood: _selectedMood,
      intensity: _intensity,
      note: _noteController.text.trim(),
      isShared: _isShared,
    );

    widget.onSave?.call(data);

    if (widget.onSave == null) {
      Navigator.of(context).pop(data);
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _dateLabel() {
    final today = DateTime.now();

    if (_sameDate(
      _selectedDate,
      today,
    )) {
      return 'Today';
    }

    final yesterday =
    today.subtract(
      const Duration(days: 1),
    );

    if (_sameDate(
      _selectedDate,
      yesterday,
    )) {
      return 'Yesterday';
    }

    return _weekdayName(
      _selectedDate.weekday,
    );
  }

  String _formatDate(
      DateTime date,
      ) {
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

  bool _sameDate(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _intensityLabel() {
    switch (_intensity) {
      case 1:
        return 'Very light';
      case 2:
        return 'A little';
      case 3:
        return 'Just right';
      case 4:
        return 'Strong';
      case 5:
        return 'Very strong';
      default:
        return 'Just right';
    }
  }

  String _moodDescription(
      MoodType mood,
      ) {
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
        return 'Something is sitting a little heavily today.';

      case MoodType.tired:
        return 'Maybe today just needs a little softness.';
    }
  }
}

// ===========================================================================
// MOOD CHOICE
// ===========================================================================

class _MoodChoice extends StatelessWidget {
  const _MoodChoice({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final MoodType mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final info =
    _MoodInfo.fromMood(mood);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),
        decoration: BoxDecoration(
          color: selected
              ? info.background
              : const Color(
            0xFFF8F4F2,
          ),
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? info.background
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              info.emoji,
              style:
              const TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              info.label,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style:
              AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 7.5,
                fontWeight:
                selected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: selected
                    ? AppColors
                    .textPrimary
                    : AppColors
                    .textSecondary,
              ),
            ),

            if (selected) ...[
              const SizedBox(height: 3),
              Container(
                width: 4,
                height: 4,
                decoration:
                const BoxDecoration(
                  color:
                  AppColors.primary,
                  shape:
                  BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
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
          background:
          Color(0xFFFFF2CC),
        );

      case MoodType.loved:
        return const _MoodInfo(
          emoji: '🥰',
          label: 'Loved',
          background:
          Color(0xFFFCE4EC),
        );

      case MoodType.calm:
        return const _MoodInfo(
          emoji: '😌',
          label: 'Calm',
          background:
          Color(0xFFE8F3F1),
        );

      case MoodType.normal:
        return const _MoodInfo(
          emoji: '😐',
          label: 'Normal',
          background:
          Color(0xFFF1F1F1),
        );

      case MoodType.sad:
        return const _MoodInfo(
          emoji: '😔',
          label: 'Low',
          background:
          Color(0xFFE8EAF6),
        );

      case MoodType.angry:
        return const _MoodInfo(
          emoji: '😡',
          label: 'Angry',
          background:
          Color(0xFFFDE2E2),
        );

      case MoodType.tired:
        return const _MoodInfo(
          emoji: '😴',
          label: 'Tired',
          background:
          Color(0xFFEDE7F6),
        );
    }
  }
}

// ===========================================================================
// CIRCLE BUTTON
// ===========================================================================

class _CircleButton
    extends StatelessWidget {
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
          color: AppColors
              .outlineVariant
              .withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Icon(
        icon,
        size: 19,
        color:
        AppColors.textPrimary,
      ),
    );
  }
}

// ===========================================================================
// SECTION LABEL
// ===========================================================================

class _SectionLabel
    extends StatelessWidget {
  const _SectionLabel({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
      AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.7,
        color:
        AppColors.textSecondary,
      ),
    );
  }
}

// ===========================================================================
// BACKGROUND
// ===========================================================================

class _AddMoodBackground
    extends StatelessWidget {
  const _AddMoodBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration:
          const BoxDecoration(
            gradient:
            LinearGradient(
              begin:
              Alignment.topCenter,
              end:
              Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8F5),
                Color(0xFFF4EBE8),
              ],
            ),
          ),
        ),

        Positioned(
          left: -100,
          top: 110,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 230,
              height: 230,
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.13,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          right: -110,
          bottom: 100,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(
              width: 250,
              height: 250,
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFD8D5E5,
                ).withValues(
                  alpha: 0.14,
                ),
                shape:
                BoxShape.circle,
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

class _AnimatedEntry
    extends StatelessWidget {
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
    final animation =
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        1,
        curve:
        Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder:
          (context, child) {
        final value =
            animation.value;

        return Opacity(
          opacity: value,
          child:
          Transform.translate(
            offset: Offset(
              0,
              15 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}