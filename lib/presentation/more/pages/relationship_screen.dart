import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class RelationshipData {
  const RelationshipData({
    required this.partnerName,
    required this.relationshipLabel,
    required this.relationshipStartDate,
    required this.firstMeetingDate,
    required this.firstDate,
    required this.privateNote,
  });

  final String partnerName;
  final String relationshipLabel;
  final DateTime? relationshipStartDate;
  final DateTime? firstMeetingDate;
  final DateTime? firstDate;
  final String privateNote;
}

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({
    super.key,
    this.partnerName = 'Love',
    this.relationshipLabel = 'Together',
    this.relationshipStartDate,
    this.firstMeetingDate,
    this.firstDate,
    this.privateNote = '',
    this.onBack,
    this.onSave,
  });

  final String partnerName;
  final String relationshipLabel;
  final DateTime? relationshipStartDate;
  final DateTime? firstMeetingDate;
  final DateTime? firstDate;
  final String privateNote;

  final VoidCallback? onBack;
  final ValueChanged<RelationshipData>? onSave;

  @override
  State<RelationshipScreen> createState() =>
      _RelationshipScreenState();
}

class _RelationshipScreenState
    extends State<RelationshipScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final TextEditingController _partnerController;
  late final TextEditingController _privateNoteController;

  late String _relationshipLabel;

  DateTime? _relationshipStartDate;
  DateTime? _firstMeetingDate;
  DateTime? _firstDate;

  final List<String> _relationshipLabels = const [
    'Together',
    'In love',
    'Partners',
    'Forever',
    'My person',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _partnerController = TextEditingController(
      text: widget.partnerName,
    );

    _privateNoteController = TextEditingController(
      text: widget.privateNote,
    );

    _relationshipLabel =
        widget.relationshipLabel;

    _relationshipStartDate =
        widget.relationshipStartDate;

    _firstMeetingDate =
        widget.firstMeetingDate;

    _firstDate = widget.firstDate;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _partnerController.dispose();
    _privateNoteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _RelationshipBackground(),
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
                _buildPartnerSection(),
                _buildRelationshipType(),
                _buildImportantDates(),
                _buildDurationCard(),
                _buildPrivateNote(),
                _buildPrivacyCard(),
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

  Widget _buildTopBar(
      BuildContext context,
      ) {
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
            onTap: () => context.pop(),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'SETTINGS',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Relationship',
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 17,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR LITTLE STORY',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight:
                FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'The two of you.',
              style:
              GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tell SIMI the little details that make your relationship yours.',
              style:
              AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                height: 1.5,
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
  // PARTNER
  // ===========================================================================

  Widget _buildPartnerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.07,
        child: _Section(
          label: 'YOUR PERSON',
          child: Container(
            padding:
            const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.84),
              borderRadius:
              BorderRadius.circular(23),
              border: Border.all(
                color: AppColors
                    .outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration:
                  const BoxDecoration(
                    gradient:
                    LinearGradient(
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color(0xFFE8B4B8),
                        Color(0xFF9B7478),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partner name',
                        style: AppTextTheme
                            .labelSmall
                            .copyWith(
                          fontSize: 8.5,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      TextField(
                        controller:
                        _partnerController,
                        textCapitalization:
                        TextCapitalization
                            .words,
                        style: GoogleFonts
                            .playfairDisplay(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w600,
                          color: AppColors
                              .textPrimary,
                        ),
                        decoration:
                        const InputDecoration(
                          isDense: true,
                          border:
                          InputBorder.none,
                          contentPadding:
                          EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.edit_outlined,
                  size: 15,
                  color:
                  AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // RELATIONSHIP TYPE
  // ===========================================================================

  Widget _buildRelationshipType() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.13,
        child: _Section(
          label: 'HOW YOU DESCRIBE IT',
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Choose the words that feel most like you two.',
                style:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 10,
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                _relationshipLabels.map(
                      (label) {
                    final selected =
                        _relationshipLabel ==
                            label;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _relationshipLabel =
                              label;
                        });
                      },
                      child:
                      AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 180,
                        ),
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration:
                        BoxDecoration(
                          color: selected
                              ? AppColors
                              .primary
                              : Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(999),
                          border: Border.all(
                            color: selected
                                ? AppColors
                                .primary
                                : AppColors
                                .outlineVariant,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppColors
                                .textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // IMPORTANT DATES
  // ===========================================================================

  Widget _buildImportantDates() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.19,
        child: _Section(
          label: 'THE DATES THAT MATTER',
          child: Column(
            children: [
              _DateCard(
                icon:
                Icons.favorite_rounded,
                title:
                'Relationship started',
                subtitle:
                'Your anniversary',
                date:
                _relationshipStartDate,
                onTap: () =>
                    _pickDate(
                      type:
                      _DateType.relationship,
                    ),
                onClear: _relationshipStartDate ==
                    null
                    ? null
                    : () {
                  setState(() {
                    _relationshipStartDate =
                    null;
                  });
                },
              ),

              const SizedBox(height: 10),

              _DateCard(
                icon:
                Icons.auto_awesome_rounded,
                title:
                'First met',
                subtitle:
                'Where your story began',
                date:
                _firstMeetingDate,
                onTap: () =>
                    _pickDate(
                      type:
                      _DateType.firstMeeting,
                    ),
                onClear: _firstMeetingDate ==
                    null
                    ? null
                    : () {
                  setState(() {
                    _firstMeetingDate =
                    null;
                  });
                },
              ),

              const SizedBox(height: 10),

              _DateCard(
                icon:
                Icons.favorite_border_rounded,
                title:
                'First date',
                subtitle:
                'The beginning of something',
                date: _firstDate,
                onTap: () =>
                    _pickDate(
                      type: _DateType.firstDate,
                    ),
                onClear: _firstDate == null
                    ? null
                    : () {
                  setState(() {
                    _firstDate = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DURATION
  // ===========================================================================

  Widget _buildDurationCard() {
    if (_relationshipStartDate ==
        null) {
      return const SizedBox.shrink();
    }

    final duration =
    _relationshipDuration(
      _relationshipStartDate!,
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
        delay: 0.25,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.fromLTRB(
            17,
            17,
            17,
            16,
          ),
          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF332A2B),
                Color(0xFF5A4144),
              ],
            ),
            borderRadius:
            BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white
                        .withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons
                      .favorite_rounded,
                  size: 20,
                  color:
                  Color(0xFFE8B4B8),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'YOU TWO HAVE BEEN',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        letterSpacing:
                        1.5,
                        color: Colors
                            .white
                            .withValues(
                          alpha: 0.52,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      duration,
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 19,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '♡',
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 25,
                  color:
                  const Color(
                    0xFFE8B4B8,
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
  // PRIVATE NOTE
  // ===========================================================================

  Widget _buildPrivateNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.30,
        child: _Section(
          label: 'A NOTE FOR SIMI',
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.84),
              borderRadius:
              BorderRadius.circular(22),
              border: Border.all(
                color: AppColors
                    .outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: TextField(
              controller:
              _privateNoteController,
              maxLines: 4,
              minLines: 3,
              textCapitalization:
              TextCapitalization
                  .sentences,
              style:
              AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                height: 1.5,
                color:
                AppColors.textPrimary,
              ),
              decoration:
              InputDecoration(
                hintText:
                'Something about your relationship you want SIMI to remember...',
                hintStyle:
                AppTextTheme.bodyMedium
                    .copyWith(
                  fontSize: 10.5,
                  height: 1.4,
                  color:
                  AppColors.textDisabled,
                ),
                prefixIcon:
                const Padding(
                  padding:
                  EdgeInsets.only(
                    left: 14,
                    right: 3,
                    top: 14,
                  ),
                  child: Align(
                    alignment:
                    Alignment.topCenter,
                    child: Icon(
                      Icons
                          .auto_awesome_outlined,
                      size: 18,
                      color:
                      AppColors.primary,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.fromLTRB(
                  5,
                  15,
                  15,
                  15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacyCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.35,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: const Color(0xFF332A2B),
            borderRadius:
            BorderRadius.circular(23),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 17,
                  color:
                  Color(0xFFE8B4B8),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JUST BETWEEN YOU TWO',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        letterSpacing:
                        1.5,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white
                            .withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your relationship details stay inside your private SIMI space.',
                      style: AppTextTheme
                          .bodyMedium
                          .copyWith(
                        fontSize: 10,
                        height: 1.45,
                        color: Colors.white
                            .withValues(
                          alpha: 0.70,
                        ),
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
                  decoration: BoxDecoration(
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
                    border: Border.all(
                      color: Colors.white
                          .withValues(
                        alpha: 0.15,
                      ),
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
                        const Offset(
                          0,
                          8,
                        ),
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
                        child:
                        const Icon(
                          Icons
                              .favorite_rounded,
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
                              'Save your story',
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
                              'Keep these little details close',
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
                        child:
                        const Icon(
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
  // DATE PICKER
  // ===========================================================================

  Future<void> _pickDate({
    required _DateType type,
  }) async {
    final now = DateTime.now();

    DateTime? current;

    switch (type) {
      case _DateType.relationship:
        current =
            _relationshipStartDate;
        break;

      case _DateType.firstMeeting:
        current =
            _firstMeetingDate;
        break;

      case _DateType.firstDate:
        current = _firstDate;
        break;
    }

    final picked =
    await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (
          context,
          child,
          ) {
        return Theme(
          data:
          Theme.of(context).copyWith(
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

    if (!mounted || picked == null) {
      return;
    }

    setState(() {
      switch (type) {
        case _DateType.relationship:
          _relationshipStartDate =
              picked;
          break;

        case _DateType.firstMeeting:
          _firstMeetingDate = picked;
          break;

        case _DateType.firstDate:
          _firstDate = picked;
          break;
      }
    });
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  void _save() {
    final partner =
    _partnerController.text.trim();

    if (partner.isEmpty) {
      _showMessage(
        'Please add your partner\'s name.',
      );
      return;
    }

    final data = RelationshipData(
      partnerName: partner,
      relationshipLabel:
      _relationshipLabel,
      relationshipStartDate:
      _relationshipStartDate,
      firstMeetingDate:
      _firstMeetingDate,
      firstDate: _firstDate,
      privateNote:
      _privateNoteController.text.trim(),
    );

    widget.onSave?.call(data);

    if (mounted) {
      context.pop();
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _relationshipDuration(
      DateTime start,
      ) {
    final now = DateTime.now();

    int years =
        now.year - start.year;

    int months =
        now.month - start.month;

    int days =
        now.day - start.day;

    if (days < 0) {
      months--;

      final previousMonth =
      DateTime(
        now.year,
        now.month,
        0,
      );

      days +=
          previousMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    if (years > 0) {
      if (months > 0) {
        return '$years years, $months months';
      }

      return '$years ${years == 1 ? 'year' : 'years'}';
    }

    if (months > 0) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    }

    return '$days ${days == 1 ? 'day' : 'days'}';
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

  void _showMessage(
      String message,
      ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style:
            AppTextTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          behavior:
          SnackBarBehavior.floating,
          margin:
          const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            85,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }
}

// =============================================================================
// DATE TYPE
// =============================================================================

enum _DateType {
  relationship,
  firstMeeting,
  firstDate,
}

// =============================================================================
// DATE CARD
// =============================================================================

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.onTap,
    this.onClear,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.84),
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.48),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration:
              const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
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
                    title,
                    style: AppTextTheme
                        .labelLarge
                        .copyWith(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w600,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    date == null
                        ? subtitle
                        : _formatDate(date!),
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: AppTextTheme
                        .labelSmall
                        .copyWith(
                      fontSize: 9,
                      color: date == null
                          ? AppColors
                          .textDisabled
                          : AppColors
                          .textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Padding(
                  padding:
                  EdgeInsets.all(7),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color:
                    AppColors
                        .textSecondary,
                  ),
                ),
              ),

            const SizedBox(width: 3),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              size: 11,
              color:
              AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(
      DateTime date,
      ) {
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
}

// =============================================================================
// SECTION
// =============================================================================

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.8,
            fontWeight:
            FontWeight.w600,
            color:
            AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 11),
        child,
      ],
    );
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton
    extends StatelessWidget {
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
          color: Colors.white
              .withValues(alpha: 0.78),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color:
          AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _RelationshipBackground
    extends StatelessWidget {
  const _RelationshipBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 120,
          right: -120,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.08,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 620,
          left: -130,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF6B6D91,
                ).withValues(
                  alpha: 0.035,
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

// =============================================================================
// ANIMATION
// =============================================================================

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
        (delay + 0.40).clamp(
          0.0,
          1.0,
        ),
        curve:
        Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (
          context,
          child,
          ) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 *
                  (1 -
                      animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}