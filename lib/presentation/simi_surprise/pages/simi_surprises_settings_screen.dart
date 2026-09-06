import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class SimiSurprisesSettingsScreen extends StatefulWidget {
  const SimiSurprisesSettingsScreen({
    super.key,
    this.surprisesEnabled = true,
    this.memoriesEnabled = true,
    this.chatEnabled = true,
    this.periodEnabled = true,
    this.specialDatesEnabled = true,
    this.futureMessagesEnabled = true,
    this.moodJournalEnabled = true,
    this.giftWishesEnabled = true,
    this.notificationEnabled = true,
    this.onBack,
    this.onSurprisesChanged,
    this.onMemoriesChanged,
    this.onChatChanged,
    this.onPeriodChanged,
    this.onSpecialDatesChanged,
    this.onFutureMessagesChanged,
    this.onMoodJournalChanged,
    this.onGiftWishesChanged,
    this.onNotificationChanged,
  });

  final bool surprisesEnabled;

  final bool memoriesEnabled;
  final bool chatEnabled;
  final bool periodEnabled;
  final bool specialDatesEnabled;
  final bool futureMessagesEnabled;
  final bool moodJournalEnabled;
  final bool giftWishesEnabled;

  final bool notificationEnabled;

  final VoidCallback? onBack;

  final ValueChanged<bool>? onSurprisesChanged;
  final ValueChanged<bool>? onMemoriesChanged;
  final ValueChanged<bool>? onChatChanged;
  final ValueChanged<bool>? onPeriodChanged;
  final ValueChanged<bool>? onSpecialDatesChanged;
  final ValueChanged<bool>? onFutureMessagesChanged;
  final ValueChanged<bool>? onMoodJournalChanged;
  final ValueChanged<bool>? onGiftWishesChanged;
  final ValueChanged<bool>? onNotificationChanged;

  @override
  State<SimiSurprisesSettingsScreen> createState() =>
      _SimiSurprisesSettingsScreenState();
}

class _SimiSurprisesSettingsScreenState
    extends State<SimiSurprisesSettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _surprisesEnabled;

  late bool _memoriesEnabled;
  late bool _chatEnabled;
  late bool _periodEnabled;
  late bool _specialDatesEnabled;
  late bool _futureMessagesEnabled;
  late bool _moodJournalEnabled;
  late bool _giftWishesEnabled;

  late bool _notificationEnabled;

  String _quietHours = '10:30 PM – 7:00 AM';

  String _notificationStyle = 'A little surprise';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _surprisesEnabled = widget.surprisesEnabled;

    _memoriesEnabled = widget.memoriesEnabled;
    _chatEnabled = widget.chatEnabled;
    _periodEnabled = widget.periodEnabled;
    _specialDatesEnabled = widget.specialDatesEnabled;
    _futureMessagesEnabled =
        widget.futureMessagesEnabled;
    _moodJournalEnabled = widget.moodJournalEnabled;
    _giftWishesEnabled = widget.giftWishesEnabled;

    _notificationEnabled =
        widget.notificationEnabled;
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
            child: _SettingsBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 45,
              ),
              children: [
                _buildTopBar(context),
                _buildHeader(),
                _buildMainSwitch(),
                _buildWhatSimiCanNotice(),
                _buildNotifications(),
                _buildQuietHours(),
                _buildPrivacy(),
                _buildFooter(),
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
                const SizedBox(height: 3),
                Text(
                  'Make it feel like you.',
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
              'A LITTLE MAGIC',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Let SIMI notice\nthe little things.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 29,
                height: 1.10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'SIMI quietly looks at the things you '
              'choose to share and finds little moments '
              'worth bringing back to you.',
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
  // MAIN SWITCH
  // ===========================================================================

  Widget _buildMainSwitch() {
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
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF302526),
                Color(0xFF594044),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.10,
                ),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8B4B8)
                      .withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 21,
                  color: Color(0xFFF6D9DC),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIMI Surprises',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _surprisesEnabled
                          ? 'SIMI is looking for little moments.'
                          : 'SIMI is keeping things quiet.',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: Colors.white
                            .withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),

              Switch.adaptive(
                value: _surprisesEnabled,
                onChanged: _toggleSurprises,
                activeColor: Colors.white,
                activeTrackColor:
                    const Color(0xFFB98288),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSurprises(bool value) {
    setState(() {
      _surprisesEnabled = value;
    });

    widget.onSurprisesChanged?.call(value);
  }

  // ===========================================================================
  // WHAT SIMI CAN NOTICE
  // ===========================================================================

  Widget _buildWhatSimiCanNotice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.18,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'WHAT SIMI CAN NOTICE',
            ),

            const SizedBox(height: 5),

            Text(
              'Choose what becomes part of the magic.',
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.82,
                ),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.50),
                ),
              ),
              child: Column(
                children: [
                  _FeatureSettingTile(
                    icon: Icons.photo_camera_outlined,
                    iconBackground:
                        const Color(0xFFFCE4EC),
                    title: 'Memories',
                    subtitle:
                        'Old moments and little anniversaries.',
                    value: _memoriesEnabled,
                    onChanged: (value) {
                      setState(() {
                        _memoriesEnabled = value;
                      });
                      widget.onMemoriesChanged
                          ?.call(value);
                    },
                  ),
                  const _SettingDivider(),

                  _FeatureSettingTile(
                    icon:
                        Icons.chat_bubble_outline_rounded,
                    iconBackground:
                        const Color(0xFFE9E8F2),
                    title: 'Love Chat',
                    subtitle:
                        'Topics you keep coming back to.',
                    value: _chatEnabled,
                    onChanged: (value) {
                      setState(() {
                        _chatEnabled = value;
                      });
                      widget.onChatChanged?.call(value);
                    },
                  ),
                  const _SettingDivider(),

                  _FeatureSettingTile(
                    icon: Icons.calendar_month_outlined,
                    iconBackground:
                        const Color(0xFFFCE4EC),
                    title: 'Period',
                    subtitle:
                        'Helpful reminders around your rhythm.',
                    value: _periodEnabled,
                    onChanged: (value) {
                      setState(() {
                        _periodEnabled = value;
                      });
                      widget.onPeriodChanged
                          ?.call(value);
                    },
                  ),
                  const _SettingDivider(),

                  _FeatureSettingTile(
                    icon: Icons.event_outlined,
                    iconBackground:
                        const Color(0xFFF6E9E4),
                    title: 'Special Dates',
                    subtitle:
                        'Moments that deserve remembering.',
                    value: _specialDatesEnabled,
                    onChanged: (value) {
                      setState(() {
                        _specialDatesEnabled = value;
                      });
                      widget.onSpecialDatesChanged
                          ?.call(value);
                    },
                  ),
                  const _SettingDivider(),

                  _FeatureSettingTile(
                    icon:
                        Icons.mark_email_unread_outlined,
                    iconBackground:
                        const Color(0xFFE9E8F2),
                    title: 'Future Messages',
                    subtitle:
                        'Messages waiting for the right day.',
                    value: _futureMessagesEnabled,
                    onChanged: (value) {
                      setState(() {
                        _futureMessagesEnabled = value;
                      });
                      widget.onFutureMessagesChanged
                          ?.call(value);
                    },
                  ),
                  const _SettingDivider(),

                  _FeatureSettingTile(
                    icon:
                        Icons.sentiment_satisfied_alt_outlined,
                    iconBackground:
                        const Color(0xFFF1F0EF),
                    title: 'Mood Journal',
                    subtitle:
                        'Patterns in the moods you save.',
                    value: _moodJournalEnabled,
                    onChanged: (value) {
                      setState(() {
                        _moodJournalEnabled = value;
                      });
                      widget.onMoodJournalChanged
                          ?.call(value);
                    },
                  ),
                  const _SettingDivider(),

                  _FeatureSettingTile(
                    icon:
                        Icons.card_giftcard_outlined,
                    iconBackground:
                        const Color(0xFFF8E8E9),
                    title: 'Gift Wishes',
                    subtitle:
                        'Little wishes you may have forgotten.',
                    value: _giftWishesEnabled,
                    onChanged: (value) {
                      setState(() {
                        _giftWishesEnabled = value;
                      });
                      widget.onGiftWishesChanged
                          ?.call(value);
                    },
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
  // NOTIFICATIONS
  // ===========================================================================

  Widget _buildNotifications() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.26,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'HOW SIMI SHOULD REACH YOU',
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.82,
                ),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.50),
                ),
              ),
              child: Column(
                children: [
                  _SimpleSettingTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Surprise notifications',
                    subtitle:
                        'Let SIMI gently interrupt your day.',
                    trailing: Switch.adaptive(
                      value: _notificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationEnabled = value;
                        });

                        widget.onNotificationChanged
                            ?.call(value);
                      },
                      activeColor: Colors.white,
                      activeTrackColor:
                          AppColors.primary,
                    ),
                  ),

                  const _SettingDivider(),

                  _SimpleSettingTile(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Notification style',
                    subtitle: _notificationStyle,
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _showNotificationStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationStyle() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _ChoiceSheet(
          title: 'How should SIMI surprise you?',
          subtitle:
              'Pick the feeling you want from a notification.',
          options: const [
            'A little surprise',
            'Quiet and simple',
            'Show me the reason',
          ],
          selected: _notificationStyle,
          onSelected: (value) {
            setState(() {
              _notificationStyle = value;
            });
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  // ===========================================================================
  // QUIET HOURS
  // ===========================================================================

  Widget _buildQuietHours() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.34,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'QUIET HOURS',
            ),

            const SizedBox(height: 5),

            Text(
              'SIMI will save the surprise for later.',
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: _showQuietHours,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.82,
                  ),
                  borderRadius:
                      BorderRadius.circular(21),
                  border: Border.all(
                    color: AppColors.outlineVariant
                        .withValues(alpha: 0.50),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAE9F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        size: 19,
                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sleep time',
                            style:
                                AppTextTheme.labelLarge
                                    .copyWith(
                              fontSize: 11.5,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _quietHours,
                            style:
                                AppTextTheme.labelSmall
                                    .copyWith(
                              fontSize: 9.5,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color:
                          AppColors.textSecondary,
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

  void _showQuietHours() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _ChoiceSheet(
          title: 'Quiet hours',
          subtitle:
              'No surprise notifications during this time.',
          options: const [
            '10:30 PM – 7:00 AM',
            '11:00 PM – 7:00 AM',
            '11:30 PM – 7:30 AM',
            '12:00 AM – 8:00 AM',
          ],
          selected: _quietHours,
          onSelected: (value) {
            setState(() {
              _quietHours = value;
            });
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacy() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.42,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            18,
            19,
            18,
            19,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF292324),
            borderRadius: BorderRadius.circular(24),
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
                    alpha: 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: Color(0xFFF6D9DC),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR DATA STAYS YOURS',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8.5,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                            .withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'SIMI only uses activity that you '
                      'already choose to keep inside the app. '
                      'Your private moments are never used '
                      'to create surprises outside SIMI.',
                      style:
                          AppTextTheme.bodyMedium.copyWith(
                        fontSize: 10.5,
                        height: 1.55,
                        color: Colors.white
                            .withValues(alpha: 0.68),
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
  // FOOTER
  // ===========================================================================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: Column(
        children: [
          Text(
            'The best surprises are the ones you didn\'t ask for.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'SIMI • little things, noticed.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              letterSpacing: 1.5,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// FEATURE SETTING
// =============================================================================

class _FeatureSettingTile extends StatelessWidget {
  const _FeatureSettingTile({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        8,
        12,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
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
                  title,
                  style:
                      AppTextTheme.labelLarge.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.8,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SIMPLE SETTING
// =============================================================================

class _SimpleSettingTile extends StatelessWidget {
  const _SimpleSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          14,
          12,
          13,
          12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
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
                    title,
                    style:
                        AppTextTheme.labelLarge.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTextTheme.labelSmall.copyWith(
                      fontSize: 8.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            trailing,
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DIVIDER
// =============================================================================

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 65,
      endIndent: 14,
      color: AppColors.outlineVariant
          .withValues(alpha: 0.35),
    );
  }
}

// =============================================================================
// CHOICE SHEET
// =============================================================================

class _ChoiceSheet extends StatelessWidget {
  const _ChoiceSheet({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius:
                  BorderRadius.circular(999),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9.5,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 18),

          ...options.map(
            (option) {
              final isSelected =
                  option == selected;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 9,
                ),
                child: GestureDetector(
                  onTap: () => onSelected(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFCE4EC)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(17),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outlineVariant
                                .withValues(
                                alpha: 0.50,
                              ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextTheme
                                .labelLarge
                                .copyWith(
                              fontSize: 11.5,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
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

          const SizedBox(height: 3),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
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

class _SettingsBackground extends StatelessWidget {
  const _SettingsBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -90,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 35,
              sigmaY: 35,
            ),
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          top: 580,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.045),
                shape: BoxShape.circle,
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
        (delay + 0.45).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}