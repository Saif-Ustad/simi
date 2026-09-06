import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class EditSpecialDateData {
  const EditSpecialDateData({
    required this.originalCategory,
    required this.title,
    required this.description,
    required this.date,
    required this.repeatsYearly,
    required this.reminderDays,
    required this.note,
  });

  final SpecialDateCategory originalCategory;
  final String title;
  final String description;
  final DateTime date;
  final bool repeatsYearly;
  final int reminderDays;
  final String note;
}

class EditSpecialDateScreen extends StatefulWidget {
  const EditSpecialDateScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.repeatsYearly,
    required this.reminderDays,
    required this.note,
    this.onBack,
    this.onSave,
    this.onDelete,
  });

  final SpecialDateCategory category;
  final String title;
  final String description;
  final DateTime date;
  final bool repeatsYearly;
  final int reminderDays;
  final String note;

  final VoidCallback? onBack;
  final ValueChanged<EditSpecialDateData>? onSave;
  final VoidCallback? onDelete;

  @override
  State<EditSpecialDateScreen> createState() =>
      _EditSpecialDateScreenState();
}

class _EditSpecialDateScreenState
    extends State<EditSpecialDateScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _noteController;

  late DateTime _selectedDate;
  late bool _repeatsYearly;
  late int _reminderDays;

  late final AnimationController _animationController;

  final List<int> _reminderOptions = const [
    1,
    3,
    7,
    14,
    30,
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.title,
    );

    _descriptionController = TextEditingController(
      text: widget.description,
    );

    _noteController = TextEditingController(
      text: widget.note,
    );

    _selectedDate = widget.date;
    _repeatsYearly = widget.repeatsYearly;
    _reminderDays = widget.reminderDays;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // CATEGORY
  // ===========================================================================

  _CategoryInfo get _categoryInfo {
    switch (widget.category) {
      case SpecialDateCategory.anniversary:
        return const _CategoryInfo(
          label: 'Anniversary',
          emoji: '❤️',
          icon: Icons.favorite_rounded,
        );

      case SpecialDateCategory.birthday:
        return const _CategoryInfo(
          label: 'Birthday',
          emoji: '🎂',
          icon: Icons.cake_outlined,
        );

      case SpecialDateCategory.firstMeeting:
        return const _CategoryInfo(
          label: 'First Meeting',
          emoji: '✨',
          icon: Icons.people_outline_rounded,
        );

      case SpecialDateCategory.firstDate:
        return const _CategoryInfo(
          label: 'First Date',
          emoji: '💕',
          icon: Icons.favorite_border_rounded,
        );

      case SpecialDateCategory.firstKiss:
        return const _CategoryInfo(
          label: 'First Kiss',
          emoji: '💋',
          icon: Icons.face_retouching_natural_rounded,
        );

      case SpecialDateCategory.firstTrip:
        return const _CategoryInfo(
          label: 'First Trip',
          emoji: '✈️',
          icon: Icons.flight_takeoff_rounded,
        );

      case SpecialDateCategory.customMoment:
        return const _CategoryInfo(
          label: 'Custom Moment',
          emoji: '🌷',
          icon: Icons.auto_awesome_rounded,
        );
    }
  }

  // ===========================================================================
  // DATE HELPERS
  // ===========================================================================

  String _monthName(int month) {
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

    return months[month - 1];
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[weekday - 1];
  }

  String get _formattedDate {
    return '${_selectedDate.day} '
        '${_monthName(_selectedDate.month)} '
        '${_selectedDate.year}';
  }

  // ===========================================================================
  // DATE PICKER
  // ===========================================================================

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              surface: AppColors.surface,
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
      _selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  void _save() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Give this special date a name.');
      return;
    }

    final data = EditSpecialDateData(
      originalCategory: widget.category,
      title: title,
      description: _descriptionController.text.trim(),
      date: _selectedDate,
      repeatsYearly: _repeatsYearly,
      reminderDays: _reminderDays,
      note: _noteController.text.trim(),
    );

    widget.onSave?.call(data);
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Remove this moment?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This special date will be removed from your '
                'Special Dates. This cannot be undone.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            18,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Keep it',
                style: AppTextTheme.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                'Remove',
                style: AppTextTheme.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      widget.onDelete?.call();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
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
            child: _EditBackground(),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 145,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  _buildHeader(),
                  _buildTitleSection(),
                  _buildDescriptionSection(),
                  _buildDateSection(),
                  _buildRepeatSection(),
                  _buildReminderSection(),
                  _buildNoteSection(),
                  _buildPreview(),
                  _buildPrivacyNote(),
                ],
              ),
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        0,
      ),
      child: SizedBox(
        height: 55,
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onBack ??
                      () => Navigator.of(context).pop(),
              child: const _CircleButton(
                icon: Icons.arrow_back_rounded,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPECIAL DATES',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Edit this moment',
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
              onTap: _confirmDelete,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
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
        28,
        20,
        22,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final value = Curves.easeOut.transform(
            _animationController.value,
          );

          return Opacity(
            opacity: _animationController.value,
            child: Transform.translate(
              offset: Offset(
                0,
                15 * (1 - value),
              ),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _categoryInfo.emoji,
                    style: const TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAKE IT FEEL RIGHT',
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A little change.',
                        style:
                        GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Sometimes a moment just needs a tiny '
                  'adjustment. Keep everything exactly how '
                  'you want it.',
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TITLE
  // ===========================================================================

  Widget _buildTitleSection() {
    return _Section(
      label: 'THE MOMENT',
      subtitle: 'Give it a name you will remember.',
      child: _TextFieldCard(
        controller: _titleController,
        hintText: 'Our Anniversary',
        icon: Icons.favorite_border_rounded,
        maxLines: 1,
      ),
    );
  }

  // ===========================================================================
  // DESCRIPTION
  // ===========================================================================

  Widget _buildDescriptionSection() {
    return _Section(
      label: 'A LITTLE STORY',
      subtitle: 'What makes this day special?',
      child: _TextFieldCard(
        controller: _descriptionController,
        hintText: 'The day we promised to keep choosing each other.',
        icon: Icons.edit_note_rounded,
        maxLines: 4,
      ),
    );
  }

  // ===========================================================================
  // DATE
  // ===========================================================================

  Widget _buildDateSection() {
    return _Section(
      label: 'THE DATE',
      subtitle: 'When should we remember it?',
      child: GestureDetector(
        onTap: _pickDate,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.55),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 57,
                height: 57,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      _monthName(_selectedDate.month)
                          .substring(0, 3)
                          .toUpperCase(),
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedDate.day}',
                      style:
                      GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formattedDate,
                      style:
                      GoogleFonts.playfairDisplay(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _weekdayName(
                        _selectedDate.weekday,
                      ),
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.edit_outlined,
                size: 17,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // REPEAT
  // ===========================================================================

  Widget _buildRepeatSection() {
    return _Section(
      label: 'REPEAT',
      subtitle: 'Should this moment return every year?',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.repeat_rounded,
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
                    'Every year',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Remember this date every year.',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Switch(
              value: _repeatsYearly,
              onChanged: (value) {
                setState(() {
                  _repeatsYearly = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // REMINDER
  // ===========================================================================

  Widget _buildReminderSection() {
    return _Section(
      label: 'REMINDER',
      subtitle: 'Choose when SIMI should remind you.',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1F0),
              borderRadius: BorderRadius.circular(20),
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
                  child: const Icon(
                    Icons.notifications_none_rounded,
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
                        'REMIND ME',
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _reminderLabel(_reminderDays),
                        style:
                        GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _reminderOptions.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final days =
                _reminderOptions[index];

                final selected =
                    days == _reminderDays;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _reminderDays = days;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.white
                          .withValues(alpha: 0.85),
                      borderRadius:
                      BorderRadius.circular(999),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    child: Text(
                      _shortReminderLabel(days),
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
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

  String _reminderLabel(int days) {
    switch (days) {
      case 1:
        return '1 day before';

      case 3:
        return '3 days before';

      case 7:
        return '1 week before';

      case 14:
        return '2 weeks before';

      case 30:
        return '1 month before';

      default:
        return '$days days before';
    }
  }

  String _shortReminderLabel(int days) {
    switch (days) {
      case 1:
        return '1 day';

      case 3:
        return '3 days';

      case 7:
        return '1 week';

      case 14:
        return '2 weeks';

      case 30:
        return '1 month';

      default:
        return '$days days';
    }
  }

  // ===========================================================================
  // NOTE
  // ===========================================================================

  Widget _buildNoteSection() {
    return _Section(
      label: 'PRIVATE NOTE',
      subtitle: 'Something only the two of you need to know.',
      child: _TextFieldCard(
        controller: _noteController,
        hintText:
        'Maybe we should celebrate with dinner...',
        icon: Icons.lock_outline_rounded,
        maxLines: 4,
      ),
    );
  }

  // ===========================================================================
  // PREVIEW
  // ===========================================================================

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF211A1B),
              Color(0xFF49383A),
              Color(0xFF73575A),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _categoryInfo.emoji,
                  style: const TextStyle(
                    fontSize: 19,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'A LITTLE PREVIEW',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white
                        .withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 19),

            Text(
              _titleController.text.trim().isEmpty
                  ? 'A beautiful moment'
                  : _titleController.text.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 23,
                height: 1.12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              _formattedDate,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: Colors.white
                    .withValues(alpha: 0.68),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              height: 1,
              color: Colors.white
                  .withValues(alpha: 0.09),
            ),

            const SizedBox(height: 13),

            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 14,
                  color: Color(0xFFE8B4B8),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Reminder ${_shortReminderLabel(_reminderDays)} before',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: Colors.white
                          .withValues(alpha: 0.68),
                    ),
                  ),
                ),
                if (_repeatsYearly)
                  const Icon(
                    Icons.repeat_rounded,
                    size: 14,
                    color: Color(0xFFE8B4B8),
                  ),
              ],
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
        28,
        25,
        28,
        10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 17,
            color: AppColors.primary,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              'Your special dates are private to your '
                  'relationship. They are just between you two.',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                height: 1.45,
                color: AppColors.textSecondary,
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
      bottom: 12,
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _save,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
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
              border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary
                      .withValues(alpha: 0.23),
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
                  child: const Icon(
                    Icons.check_rounded,
                    size: 22,
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
                        'Save changes',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        GoogleFonts.playfairDisplay(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Keep this moment exactly right',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          color: Colors.white
                              .withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 42,
                  height: 42,
                  margin:
                  const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: 0.12),
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
    );
  }
}

// =============================================================================
// SECTION
// =============================================================================

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.subtitle,
    required this.child,
  });

  final String label;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        10,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 2,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.7,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// =============================================================================
// TEXT FIELD CARD
// =============================================================================

class _TextFieldCard extends StatelessWidget {
  const _TextFieldCard({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization:
        TextCapitalization.sentences,
        style: AppTextTheme.bodyLarge.copyWith(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textDisabled,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 14,
              right: 8,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          prefixIconConstraints:
          const BoxConstraints(
            minWidth: 42,
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.fromLTRB(
            8,
            16,
            14,
            16,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// CATEGORY INFO
// =============================================================================

class _CategoryInfo {
  const _CategoryInfo({
    required this.label,
    required this.emoji,
    required this.icon,
  });

  final String label;
  final String emoji;
  final IconData icon;
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 17,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _EditBackground extends StatelessWidget {
  const _EditBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -90,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.70),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 390,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 70,
            right: -90,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}