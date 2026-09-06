import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

enum SpecialDateDefaultReminder {
  oneDay,
  threeDays,
  oneWeek,
  twoWeeks,
  oneMonth,
}

class SpecialDateSettingsScreen extends StatefulWidget {
  const SpecialDateSettingsScreen({
    super.key,
    this.notificationsEnabled = true,
    this.defaultReminder = SpecialDateDefaultReminder.oneWeek,
    this.yearlyDatesEnabled = true,
    this.countdownEnabled = true,
    this.showPastDates = true,
    this.onBack,
    this.onNotificationsChanged,
    this.onDefaultReminderChanged,
    this.onYearlyDatesChanged,
    this.onCountdownChanged,
    this.onShowPastDatesChanged,
    this.onClearPastDates,
  });

  final bool notificationsEnabled;
  final SpecialDateDefaultReminder defaultReminder;
  final bool yearlyDatesEnabled;
  final bool countdownEnabled;
  final bool showPastDates;

  final VoidCallback? onBack;
  final ValueChanged<bool>? onNotificationsChanged;
  final ValueChanged<SpecialDateDefaultReminder>?
  onDefaultReminderChanged;
  final ValueChanged<bool>? onYearlyDatesChanged;
  final ValueChanged<bool>? onCountdownChanged;
  final ValueChanged<bool>? onShowPastDatesChanged;
  final VoidCallback? onClearPastDates;

  @override
  State<SpecialDateSettingsScreen> createState() =>
      _SpecialDateSettingsScreenState();
}

class _SpecialDateSettingsScreenState
    extends State<SpecialDateSettingsScreen>
    with SingleTickerProviderStateMixin {
  late bool _notificationsEnabled;
  late SpecialDateDefaultReminder _defaultReminder;
  late bool _yearlyDatesEnabled;
  late bool _countdownEnabled;
  late bool _showPastDates;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _notificationsEnabled = widget.notificationsEnabled;
    _defaultReminder = widget.defaultReminder;
    _yearlyDatesEnabled = widget.yearlyDatesEnabled;
    _countdownEnabled = widget.countdownEnabled;
    _showPastDates = widget.showPastDates;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
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
            child: _SettingsBackground(),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  _buildHeader(),
                  _buildNotificationSection(),
                  _buildReminderSection(),
                  _buildDisplaySection(),
                  _buildPrivacySection(),
                  _buildDataSection(),
                  _buildFooter(),
                ],
              ),
            ),
          ),
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
                mainAxisAlignment:
                MainAxisAlignment.center,
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
                    'Settings',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 19,
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
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAKE IT YOURS',
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
                        'Your little preferences.',
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
              'Choose how SIMI remembers the moments '
                  'that matter to both of you.',
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
  // NOTIFICATIONS
  // ===========================================================================

  Widget _buildNotificationSection() {
    return _SettingsSection(
      label: 'NOTIFICATIONS',
      subtitle: 'Never accidentally miss your little moments.',
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Special date reminders',
            subtitle: 'Let SIMI remind you before a special date.',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });

                widget.onNotificationsChanged?.call(
                  value,
                );
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // REMINDERS
  // ===========================================================================

  Widget _buildReminderSection() {
    return _SettingsSection(
      label: 'DEFAULT REMINDER',
      subtitle: 'Used when you create a new special date.',
      child: GestureDetector(
        onTap: () => _showReminderPicker(context),
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
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remind me',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _reminderLabel(_defaultReminder),
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _reminderLabel(
      SpecialDateDefaultReminder reminder,
      ) {
    switch (reminder) {
      case SpecialDateDefaultReminder.oneDay:
        return '1 day before';

      case SpecialDateDefaultReminder.threeDays:
        return '3 days before';

      case SpecialDateDefaultReminder.oneWeek:
        return '1 week before';

      case SpecialDateDefaultReminder.twoWeeks:
        return '2 weeks before';

      case SpecialDateDefaultReminder.oneMonth:
        return '1 month before';
    }
  }

  // ===========================================================================
  // DISPLAY
  // ===========================================================================

  Widget _buildDisplaySection() {
    return _SettingsSection(
      label: 'DISPLAY',
      subtitle: 'Choose what you want to see.',
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.repeat_rounded,
            title: 'Yearly moments',
            subtitle:
            'Show recurring dates every year.',
            trailing: Switch(
              value: _yearlyDatesEnabled,
              onChanged: (value) {
                setState(() {
                  _yearlyDatesEnabled = value;
                });

                widget.onYearlyDatesChanged?.call(
                  value,
                );
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.timer_outlined,
            title: 'Show countdowns',
            subtitle:
            'Display countdowns for upcoming dates.',
            trailing: Switch(
              value: _countdownEnabled,
              onChanged: (value) {
                setState(() {
                  _countdownEnabled = value;
                });

                widget.onCountdownChanged?.call(
                  value,
                );
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.history_rounded,
            title: 'Show past dates',
            subtitle:
            'Keep memories of moments that have passed.',
            trailing: Switch(
              value: _showPastDates,
              onChanged: (value) {
                setState(() {
                  _showPastDates = value;
                });

                widget.onShowPastDatesChanged?.call(
                  value,
                );
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacySection() {
    return _SettingsSection(
      label: 'PRIVACY',
      subtitle: 'Your moments belong only to you two.',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF211A1B),
              Color(0xFF49383A),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 19,
                color: Color(0xFFE8B4B8),
              ),
            ),
            const SizedBox(width: 12),
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
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: const Color(0xFFE8B4B8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Your special dates stay private.',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'SIMI keeps these moments inside your '
                        'private relationship space.',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      height: 1.45,
                      color: Colors.white
                          .withValues(alpha: 0.62),
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
  // DATA
  // ===========================================================================

  Widget _buildDataSection() {
    return _SettingsSection(
      label: 'DATA',
      subtitle: 'Keep your Special Dates tidy.',
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showClearPastDialog(context),
            child: _ActionTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Clear past dates',
              subtitle:
              'Remove dates that are no longer relevant.',
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        28,
        32,
        28,
        20,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(height: 9),
          Text(
            'Some dates deserve to be remembered.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Special Dates · SIMI ❤️',
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
  // REMINDER PICKER
  // ===========================================================================

  void _showReminderPicker(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SheetHandle(),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primary,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Default reminder',
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color:
                              AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Choose your usual reminder time.',
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
                  ],
                ),

                const SizedBox(height: 18),

                ...SpecialDateDefaultReminder.values.map(
                      (reminder) {
                    final selected =
                        reminder == _defaultReminder;

                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _defaultReminder = reminder;
                          });

                          widget
                              .onDefaultReminderChanged
                              ?.call(reminder);

                          Navigator.of(sheetContext).pop();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 180,
                          ),
                          width: double.infinity,
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFCE4EC)
                                : Colors.white,
                            borderRadius:
                            BorderRadius.circular(17),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors
                                  .outlineVariant,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _reminderLabel(
                                    reminder,
                                  ),
                                  style: AppTextTheme
                                      .bodyMedium
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: AppColors
                                        .textPrimary,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 19,
                                  color:
                                  AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // CLEAR PAST DATES
  // ===========================================================================

  void _showClearPastDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Clear past dates?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This will remove past special dates from '
                'your list. Your recurring dates will not be '
                'affected.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: AppTextTheme.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.onClearPastDates?.call();
              },
              child: Text(
                'Clear',
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
  }
}

// =============================================================================
// SETTINGS SECTION
// =============================================================================

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
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
        12,
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
// SETTINGS TILE
// =============================================================================

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        15,
        14,
        10,
        14,
      ),
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
              color: Color(0xFFF7F1F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.5,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          trailing,
        ],
      ),
    );
  }
}

// =============================================================================
// ACTION TILE
// =============================================================================

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
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
              color: Color(0xFFF7F1F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
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
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.5,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 21,
            color: AppColors.primary,
          ),
        ],
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
// SHEET HANDLE
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

// =============================================================================
// BACKGROUND
// =============================================================================

class _SettingsBackground extends StatelessWidget {
  const _SettingsBackground();

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
            bottom: 80,
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