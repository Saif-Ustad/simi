import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    this.notificationsEnabled = true,
    this.loveMessages = true,
    this.specialDates = true,
    this.memories = true,
    this.futureMessages = true,
    this.moodUpdates = true,
    this.giftWishes = true,
    this.simiSurprises = true,
    this.notificationPreview = true,
    this.sound = true,
    this.vibration = true,
    this.onBack,
    this.onNotificationsChanged,
    this.onLoveMessagesChanged,
    this.onSpecialDatesChanged,
    this.onMemoriesChanged,
    this.onFutureMessagesChanged,
    this.onMoodUpdatesChanged,
    this.onGiftWishesChanged,
    this.onSimiSurprisesChanged,
    this.onPreviewChanged,
    this.onSoundChanged,
    this.onVibrationChanged,
  });

  final bool notificationsEnabled;
  final bool loveMessages;
  final bool specialDates;
  final bool memories;
  final bool futureMessages;
  final bool moodUpdates;
  final bool giftWishes;
  final bool simiSurprises;
  final bool notificationPreview;
  final bool sound;
  final bool vibration;

  final VoidCallback? onBack;

  final ValueChanged<bool>? onNotificationsChanged;
  final ValueChanged<bool>? onLoveMessagesChanged;
  final ValueChanged<bool>? onSpecialDatesChanged;
  final ValueChanged<bool>? onMemoriesChanged;
  final ValueChanged<bool>? onFutureMessagesChanged;
  final ValueChanged<bool>? onMoodUpdatesChanged;
  final ValueChanged<bool>? onGiftWishesChanged;
  final ValueChanged<bool>? onSimiSurprisesChanged;
  final ValueChanged<bool>? onPreviewChanged;
  final ValueChanged<bool>? onSoundChanged;
  final ValueChanged<bool>? onVibrationChanged;

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _notificationsEnabled;
  late bool _loveMessages;
  late bool _specialDates;
  late bool _memories;
  late bool _futureMessages;
  late bool _moodUpdates;
  late bool _giftWishes;
  late bool _simiSurprises;
  late bool _notificationPreview;
  late bool _sound;
  late bool _vibration;

  @override
  void initState() {
    super.initState();

    _notificationsEnabled =
        widget.notificationsEnabled;
    _loveMessages = widget.loveMessages;
    _specialDates = widget.specialDates;
    _memories = widget.memories;
    _futureMessages = widget.futureMessages;
    _moodUpdates = widget.moodUpdates;
    _giftWishes = widget.giftWishes;
    _simiSurprises = widget.simiSurprises;
    _notificationPreview =
        widget.notificationPreview;
    _sound = widget.sound;
    _vibration = widget.vibration;

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
            child: _NotificationsBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildMasterControl(),
                _buildNotificationTypes(),
                _buildDeliverySection(),
                _buildPrivacySection(),
                _buildQuietHoursInfo(),
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
                  'SIMI',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Notifications',
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.45),
              ),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 19,
              color: AppColors.primary,
            ),
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
        delay: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            21,
            23,
            21,
            22,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF302728),
                Color(0xFF604447),
                Color(0xFF3A2C2E),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.12,
                ),
                blurRadius: 24,
                offset: const Offset(0, 10),
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
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      size: 20,
                      color: Color(0xFFF2CDD0),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Text(
                    'YOUR LITTLE REMINDERS',
                    style: AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 8,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE8B4B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 21),
              Text(
                'Only the things\nworth interrupting you for.',
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 25,
                  height: 1.13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Choose what SIMI should gently '
                    'bring back to your attention.',
                style:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.white
                      .withValues(alpha: 0.60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MASTER CONTROL
  // ===========================================================================

  Widget _buildMasterControl() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.08,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            16,
            15,
            13,
            15,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.84,
            ),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.48),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  color: _notificationsEnabled
                      ? const Color(0xFFFCE4EC)
                      : const Color(0xFFF0ECEA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _notificationsEnabled
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  size: 19,
                  color: _notificationsEnabled
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style:
                      AppTextTheme.labelLarge
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _notificationsEnabled
                          ? 'SIMI can gently keep you in the loop.'
                          : 'All SIMI notifications are paused.',
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 9,
                        height: 1.35,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SmallSwitch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });

                  widget.onNotificationsChanged
                      ?.call(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // NOTIFICATION TYPES
  // ===========================================================================

  Widget _buildNotificationTypes() {
    final enabled = _notificationsEnabled;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.14,
        child: _SettingsSection(
          label: 'WHAT SIMI CAN TELL YOU',
          children: [
            _NotificationTile(
              icon: Icons.favorite_border_rounded,
              title: 'Love messages',
              subtitle:
              'Messages and little moments from your partner.',
              value: _loveMessages,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _loveMessages = value;
                });
                widget.onLoveMessagesChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.event_outlined,
              title: 'Special dates',
              subtitle:
              'Upcoming anniversaries, birthdays and moments.',
              value: _specialDates,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _specialDates = value;
                });
                widget.onSpecialDatesChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.photo_camera_outlined,
              title: 'Memories',
              subtitle:
              'Little reminders to revisit your story.',
              value: _memories,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _memories = value;
                });
                widget.onMemoriesChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.mail_outline_rounded,
              title: 'Future messages',
              subtitle:
              'When a message you wrote becomes ready.',
              value: _futureMessages,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _futureMessages = value;
                });
                widget.onFutureMessagesChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon:
              Icons.sentiment_satisfied_alt_outlined,
              title: 'Mood Journal',
              subtitle:
              'Shared moods and gentle check-ins.',
              value: _moodUpdates,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _moodUpdates = value;
                });
                widget.onMoodUpdatesChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.card_giftcard_outlined,
              title: 'Gift Wishes',
              subtitle:
              'Little reminders about wishes worth remembering.',
              value: _giftWishes,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _giftWishes = value;
                });
                widget.onGiftWishesChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.auto_awesome_rounded,
              title: 'SIMI Surprises',
              subtitle:
              'Meaningful patterns and moments SIMI notices.',
              value: _simiSurprises,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _simiSurprises = value;
                });
                widget.onSimiSurprisesChanged
                    ?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DELIVERY
  // ===========================================================================

  Widget _buildDeliverySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.22,
        child: _SettingsSection(
          label: 'HOW THEY ARRIVE',
          children: [
            _NotificationTile(
              icon: Icons.visibility_outlined,
              title: 'Notification previews',
              subtitle:
              'Show message details in your notifications.',
              value: _notificationPreview,
              enabled: enabledForDelivery,
              onChanged: (value) {
                setState(() {
                  _notificationPreview = value;
                });
                widget.onPreviewChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.volume_up_outlined,
              title: 'Notification sound',
              subtitle:
              'Play a sound when SIMI sends something.',
              value: _sound,
              enabled: enabledForDelivery,
              onChanged: (value) {
                setState(() {
                  _sound = value;
                });
                widget.onSoundChanged
                    ?.call(value);
              },
            ),
            _SettingsDivider(),
            _NotificationTile(
              icon: Icons.vibration_rounded,
              title: 'Vibration',
              subtitle:
              'Use gentle vibration for notifications.',
              value: _vibration,
              enabled: enabledForDelivery,
              onChanged: (value) {
                setState(() {
                  _vibration = value;
                });
                widget.onVibrationChanged
                    ?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool get enabledForDelivery =>
      _notificationsEnabled;

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.30,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'NOTIFICATION PRIVACY',
            ),
            const SizedBox(height: 11),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFF322F2E),
                borderRadius:
                BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.10,
                    ),
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
                          .withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 19,
                      color: Color(0xFFE8B4B8),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          _notificationPreview
                              ? 'Private by default.'
                              : 'Extra private.',
                          style: GoogleFonts
                              .playfairDisplay(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _notificationPreview
                              ? 'Message previews can appear on your '
                              'lock screen according to your device settings.'
                              : 'SIMI will hide the contents of notifications '
                              'and only show that something is waiting.',
                          style: AppTextTheme.bodyMedium
                              .copyWith(
                            fontSize: 9.5,
                            height: 1.5,
                            color: Colors.white
                                .withValues(
                              alpha: 0.58,
                            ),
                          ),
                        ),
                      ],
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
  // QUIET HOURS
  // ===========================================================================

  Widget _buildQuietHoursInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.36,
        child: GestureDetector(
          onTap: () {
            _showQuietHoursSheet(context);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.76,
              ),
              borderRadius:
              BorderRadius.circular(21),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EEF4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.nightlight_outlined,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiet hours',
                        style:
                        AppTextTheme.labelLarge
                            .copyWith(
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Decide when SIMI should stay quiet.',
                        style: AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 9,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // QUIET HOURS SHEET
  // ===========================================================================

  void _showQuietHoursSheet(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
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

              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0EEF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_outlined,
                  color: AppColors.secondary,
                  size: 23,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                'Quiet hours',
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'SIMI will stay quiet during this time.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 19),

              _TimeChoice(
                title: 'Night',
                subtitle: '10:00 PM — 8:00 AM',
                icon: Icons.bedtime_outlined,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showComingSoon(
                    context,
                    'Night quiet hours',
                  );
                },
              ),

              const SizedBox(height: 9),

              _TimeChoice(
                title: 'Custom',
                subtitle: 'Choose your own hours',
                icon: Icons.schedule_outlined,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showComingSoon(
                    context,
                    'Custom quiet hours',
                  );
                },
              ),

              const SizedBox(height: 9),

              _TimeChoice(
                title: 'Off',
                subtitle: 'Allow notifications anytime',
                icon: Icons.notifications_active_outlined,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showComingSoon(
                    context,
                    'Quiet hours disabled',
                  );
                },
              ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        34,
        30,
        10,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.42,
        child: Column(
          children: [
            const Icon(
              Icons.favorite_rounded,
              size: 15,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Only the reminders that matter.',
              textAlign: TextAlign.center,
              style:
              GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'SIMI • Notifications',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                letterSpacing: 0.8,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(
      BuildContext context,
      String feature,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature will be connected soon.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
      ),
    );
  }
}

// =============================================================================
// SETTINGS SECTION
// =============================================================================

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: label),
        const SizedBox(height: 11),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.82,
            ),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.48),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// NOTIFICATION TILE
// =============================================================================

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = enabled && value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        15,
        12,
        13,
        12,
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration:
            const Duration(milliseconds: 180),
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFFFCE4EC)
                  : const Color(0xFFF2EFED),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: active
                  ? AppColors.primary
                  : AppColors.textDisabled,
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
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  AppTextTheme.labelLarge.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? AppColors.textPrimary
                        : AppColors.textDisabled,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.7,
                    height: 1.35,
                    color: enabled
                        ? AppColors.textSecondary
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          IgnorePointer(
            ignoring: !enabled,
            child: Opacity(
              opacity: enabled ? 1 : 0.45,
              child: _SmallSwitch(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SWITCH
// =============================================================================

class _SmallSwitch extends StatelessWidget {
  const _SmallSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor:
      AppColors.outlineVariant,
      materialTapTargetSize:
      MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// =============================================================================
// TIME CHOICE
// =============================================================================

class _TimeChoice extends StatelessWidget {
  const _TimeChoice({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(17),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F1F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 17,
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
                    AppTextTheme.labelLarge
                        .copyWith(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style:
                    AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 8.8,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 11,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DIVIDER
// =============================================================================

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 65,
      ),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: AppColors.outlineVariant
            .withValues(alpha: 0.40),
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
        borderRadius:
        BorderRadius.circular(999),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _NotificationsBackground
    extends StatelessWidget {
  const _NotificationsBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 80,
          right: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 45,
              sigmaY: 45,
            ),
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
        ),
        Positioned(
          top: 500,
          left: -110,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
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
        (delay + 0.40).clamp(0.0, 1.0),
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