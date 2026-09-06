import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

enum FutureMessageDefaultReminder {
  oneDay,
  threeDays,
  oneWeek,
  twoWeeks,
  oneMonth,
}

class FutureMessageSettingsScreen extends StatefulWidget {
  const FutureMessageSettingsScreen({
    super.key,
    this.notificationsEnabled = true,
    this.defaultReminder =
        FutureMessageDefaultReminder.oneWeek,
    this.notificationPreview = true,
    this.autoMarkAsOpened = true,
    this.saveAttachments = true,
    this.onBack,
    this.onNotificationsChanged,
    this.onDefaultReminderChanged,
    this.onNotificationPreviewChanged,
    this.onAutoMarkAsOpenedChanged,
    this.onSaveAttachmentsChanged,
    this.onClearAttachments,
  });

  final bool notificationsEnabled;
  final FutureMessageDefaultReminder defaultReminder;

  final bool notificationPreview;
  final bool autoMarkAsOpened;
  final bool saveAttachments;

  final VoidCallback? onBack;

  final ValueChanged<bool>? onNotificationsChanged;

  final ValueChanged<FutureMessageDefaultReminder>?
  onDefaultReminderChanged;

  final ValueChanged<bool>? onNotificationPreviewChanged;

  final ValueChanged<bool>? onAutoMarkAsOpenedChanged;

  final ValueChanged<bool>? onSaveAttachmentsChanged;

  final VoidCallback? onClearAttachments;

  @override
  State<FutureMessageSettingsScreen> createState() =>
      _FutureMessageSettingsScreenState();
}

class _FutureMessageSettingsScreenState
    extends State<FutureMessageSettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _notificationsEnabled;
  late bool _notificationPreview;
  late bool _autoMarkAsOpened;
  late bool _saveAttachments;

  late FutureMessageDefaultReminder _defaultReminder;

  @override
  void initState() {
    super.initState();

    _notificationsEnabled =
        widget.notificationsEnabled;

    _notificationPreview =
        widget.notificationPreview;

    _autoMarkAsOpened =
        widget.autoMarkAsOpened;

    _saveAttachments =
        widget.saveAttachments;

    _defaultReminder =
        widget.defaultReminder;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 750,
      ),
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
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              children: [
                _buildTopBar(context),

                _buildHeader(),

                _buildSecurityHero(),

                _buildNotificationsSection(),

                _buildOpeningSection(),

                _buildPrivacySection(),

                _buildAttachmentsSection(),

                _buildStorageSection(),

                _buildPrivacyMessage(),

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
                    'FUTURE MESSAGES',
                    style:
                    AppTextTheme.labelSmall.copyWith(
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
                    'Settings',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.05,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'MAKE THE WAIT FEEL RIGHT',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight:
                FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your little rules\nfor the future.',
              style:
              GoogleFonts.playfairDisplay(
                fontSize: 31,
                height: 1.12,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Choose how your time capsules wait, '
                  'open, and find their way back to you.',
              style:
              AppTextTheme.bodyMedium.copyWith(
                fontSize: 11.5,
                height: 1.55,
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
  // SECURITY HERO
  // ===========================================================================

  Widget _buildSecurityHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.10,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF211B1C),
                Color(0xFF453335),
                Color(0xFF5B4043),
              ],
            ),
            borderRadius:
            BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.12,
                ),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -25,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration:
                  BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(
                      0xFFE8B4B8,
                    ).withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration:
                    BoxDecoration(
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
                      Icons.schedule_rounded,
                      size: 23,
                      color: Color(
                        0xFFE8B4B8,
                      ),
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'TIME CAPSULES PROTECTED',
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 8,
                            fontWeight:
                            FontWeight.w600,
                            letterSpacing: 1.4,
                            color: Colors.white
                                .withValues(
                              alpha: 0.58,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Just between us.',
                          style:
                          GoogleFonts
                              .playfairDisplay(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Positioned(
                right: 2,
                bottom: 0,
                child: Icon(
                  Icons.favorite_rounded,
                  size: 17,
                  color: Color(0xFFE8B4B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // NOTIFICATIONS
  // ===========================================================================

  Widget _buildNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.16,
        child: _SettingsGroup(
          title: 'NOTIFICATIONS',
          subtitle:
          'Know when something is waiting for you.',
          children: [
            _SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Capsule reminders',
              subtitle:
              'Remind me when a message is ready.',
              trailing: Switch(
                value: _notificationsEnabled,
                activeColor: Colors.white,
                activeTrackColor:
                AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled =
                        value;
                  });

                  widget
                      .onNotificationsChanged
                      ?.call(value);
                },
              ),
            ),

            const _TileDivider(),

            _SettingsTile(
              icon: Icons.visibility_outlined,
              title: 'Notification previews',
              subtitle:
              'Show the message title in notifications.',
              trailing: Switch(
                value: _notificationPreview,
                activeColor: Colors.white,
                activeTrackColor:
                AppColors.primary,
                onChanged:
                _notificationsEnabled
                    ? (value) {
                  setState(() {
                    _notificationPreview =
                        value;
                  });

                  widget
                      .onNotificationPreviewChanged
                      ?.call(value);
                }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // OPENING
  // ===========================================================================

  Widget _buildOpeningSection() {
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
        child: _SettingsGroup(
          title: 'OPENING',
          subtitle:
          'Decide how your future messages behave.',
          children: [
            _SettingsTile(
              icon: Icons.alarm_outlined,
              title: 'Default reminder',
              subtitle:
              _reminderLabel(
                _defaultReminder,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.textDisabled,
              ),
              onTap: () {
                _showReminderPicker(
                  context,
                );
              },
            ),

            const _TileDivider(),

            _SettingsTile(
              icon: Icons.mark_email_read_outlined,
              title: 'Mark as opened',
              subtitle:
              'Automatically mark a capsule as opened.',
              trailing: Switch(
                value: _autoMarkAsOpened,
                activeColor: Colors.white,
                activeTrackColor:
                AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _autoMarkAsOpened =
                        value;
                  });

                  widget
                      .onAutoMarkAsOpenedChanged
                      ?.call(value);
                },
              ),
            ),

            const _TileDivider(),

            _SettingsTile(
              icon: Icons.calendar_month_outlined,
              title: 'Ready date',
              subtitle:
              'Messages stay sealed until their date.',
              trailing: const _SmallStatusPill(
                text: 'ENABLED',
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
        delay: 0.28,
        child: _SettingsGroup(
          title: 'PRIVACY',
          subtitle:
          'Because some words are meant for two.',
          children: [
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Private messages',
              subtitle:
              'Your capsules belong only to you two.',
              trailing:
              const _SmallStatusPill(
                text: 'PRIVATE',
              ),
            ),

            const _TileDivider(),

            _SettingsTile(
              icon:
              Icons.notifications_off_outlined,
              title: 'Hide message content',
              subtitle:
              'Never show the actual message outside the app.',
              trailing: const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // ATTACHMENTS
  // ===========================================================================

  Widget _buildAttachmentsSection() {
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
        child: _SettingsGroup(
          title: 'ATTACHMENTS',
          subtitle:
          'Keep the little extras safe too.',
          children: [
            _SettingsTile(
              icon: Icons.photo_library_outlined,
              title: 'Save attachments',
              subtitle:
              'Keep photos and voice notes with capsules.',
              trailing: Switch(
                value: _saveAttachments,
                activeColor: Colors.white,
                activeTrackColor:
                AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _saveAttachments =
                        value;
                  });

                  widget
                      .onSaveAttachmentsChanged
                      ?.call(value);
                },
              ),
            ),

            const _TileDivider(),

            _SettingsTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Clear temporary files',
              subtitle:
              'Remove cached attachment files.',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.textDisabled,
              ),
              onTap: () {
                _showClearAttachments(
                  context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // STORAGE
  // ===========================================================================

  Widget _buildStorageSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.40,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'STORAGE',
            ),

            const SizedBox(height: 11),

            GestureDetector(
              onTap: () {
                _showStorageInfo(
                  context,
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.76,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    21,
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
                      width: 44,
                      height: 44,
                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storage_outlined,
                        size: 20,
                        color:
                        AppColors.primary,
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
                            'Capsule storage',
                            style: AppTextTheme
                                .labelLarge
                                .copyWith(
                              fontSize: 12,
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
                            'Photos, recordings & attachments',
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Text(
                      'View',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 5),

                    const Icon(
                      Icons
                          .arrow_forward_ios_rounded,
                      size: 11,
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
  // ROMANTIC PRIVACY MESSAGE
  // ===========================================================================

  Widget _buildPrivacyMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.46,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.fromLTRB(
            20,
            22,
            20,
            22,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE4EC)
                .withValues(
              alpha: 0.62,
            ),
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE8B4B8)
                  .withValues(
                alpha: 0.35,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 18,
                  color:
                  AppColors.primary,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Some things are worth waiting for.',
                textAlign: TextAlign.center,
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  fontStyle:
                  FontStyle.italic,
                  fontWeight:
                  FontWeight.w500,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Every capsule stays here until '
                    'the moment you chose.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.labelSmall
                    .copyWith(
                  fontSize: 9,
                  height: 1.5,
                  color:
                  AppColors.textSecondary,
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
        28,
        20,
        20,
      ),
      child: Column(
        children: [
          Text(
            'JUST BETWEEN US.',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight:
              FontWeight.w600,
              letterSpacing: 2,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'SIMI • Future Messages',
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
  // REMINDER PICKER
  // ===========================================================================

  void _showReminderPicker(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          decoration:
          const BoxDecoration(
            color: AppColors.surface,
            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              const _SheetHandle(),

              const SizedBox(height: 22),

              Text(
                'Default reminder',
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'When should SIMI remind you?',
                style:
                AppTextTheme.labelSmall
                    .copyWith(
                  fontSize: 9,
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              ...FutureMessageDefaultReminder
                  .values
                  .map(
                    (reminder) {
                  final selected =
                      reminder ==
                          _defaultReminder;

                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child:
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _defaultReminder =
                              reminder;
                        });

                        widget
                            .onDefaultReminderChanged
                            ?.call(reminder);

                        Navigator.pop(
                          sheetContext,
                        );
                      },
                      child: Container(
                        width:
                        double.infinity,
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 15,
                          vertical: 14,
                        ),
                        decoration:
                        BoxDecoration(
                          color: selected
                              ? const Color(
                            0xFFFCE4EC,
                          )
                              : Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            17,
                          ),
                          border: Border.all(
                            color: selected
                                ? const Color(
                              0xFFE8B4B8,
                            )
                                : AppColors
                                .outlineVariant
                                .withValues(
                              alpha: 0.45,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons
                                  .radio_button_checked_rounded
                                  : Icons
                                  .radio_button_off_rounded,
                              size: 19,
                              color: selected
                                  ? AppColors
                                  .primary
                                  : AppColors
                                  .textDisabled,
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            Expanded(
                              child: Text(
                                _reminderLabel(
                                  reminder,
                                ),
                                style: AppTextTheme
                                    .labelLarge
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                  color: AppColors
                                      .textPrimary,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons
                                    .favorite_rounded,
                                size: 14,
                                color: AppColors
                                    .primary,
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
        );
      },
    );
  }

  // ===========================================================================
  // STORAGE SHEET
  // ===========================================================================

  void _showStorageInfo(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.68,
          child: Container(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              20,
            ),
            decoration:
            const BoxDecoration(
              color: AppColors.surface,
              borderRadius:
              BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              physics:
              const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  const Center(
                    child: _SheetHandle(),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Capsule storage',
                    style: GoogleFonts
                        .playfairDisplay(
                      fontSize: 24,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Everything attached to your '
                        'future messages lives here.',
                    style: AppTextTheme
                        .bodyMedium
                        .copyWith(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _StorageRow(
                    icon:
                    Icons.photo_outlined,
                    label: 'Photos',
                    value: '0 MB',
                  ),

                  _StorageRow(
                    icon:
                    Icons.mic_none_rounded,
                    label: 'Voice notes',
                    value: '0 MB',
                  ),

                  _StorageRow(
                    icon:
                    Icons.videocam_outlined,
                    label: 'Videos',
                    value: '0 MB',
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(
                      15,
                    ),
                    decoration:
                    BoxDecoration(
                      color: const Color(
                        0xFFF7F0EE,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        17,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color:
                          AppColors.primary,
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Expanded(
                          child: Text(
                            'Storage is used only for '
                                'attachments kept with your capsules.',
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              height: 1.45,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(
                          sheetContext,
                        ),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration:
                      BoxDecoration(
                        color:
                        AppColors.primary,
                        borderRadius:
                        BorderRadius.circular(
                          26,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Done',
                          style: AppTextTheme
                              .labelLarge
                              .copyWith(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // CLEAR ATTACHMENTS
  // ===========================================================================

  void _showClearAttachments(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            24,
          ),
          decoration:
          const BoxDecoration(
            color: AppColors.surface,
            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              const _SheetHandle(),

              const SizedBox(height: 22),

              Container(
                width: 54,
                height: 54,
                decoration:
                const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cleaning_services_outlined,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Clear temporary files?',
                textAlign: TextAlign.center,
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'This removes cached copies only. '
                    'Your saved capsules stay safe.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.bodyMedium
                    .copyWith(
                  fontSize: 10.5,
                  height: 1.5,
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pop(
                            sheetContext,
                          ),
                      child: Container(
                        height: 50,
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            25,
                          ),
                          border: Border.all(
                            color: AppColors
                                .outlineVariant,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: AppTextTheme
                                .labelLarge
                                .copyWith(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                              color: AppColors
                                  .textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          sheetContext,
                        );

                        widget
                            .onClearAttachments
                            ?.call();

                        _showMessage(
                          'Temporary files cleared.',
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration:
                        BoxDecoration(
                          color:
                          AppColors.primary,
                          borderRadius:
                          BorderRadius
                              .circular(
                            25,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Clear files',
                            style: AppTextTheme
                                .labelLarge
                                .copyWith(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _reminderLabel(
      FutureMessageDefaultReminder value,
      ) {
    switch (value) {
      case FutureMessageDefaultReminder.oneDay:
        return '1 day before';

      case FutureMessageDefaultReminder.threeDays:
        return '3 days before';

      case FutureMessageDefaultReminder.oneWeek:
        return '1 week before';

      case FutureMessageDefaultReminder.twoWeeks:
        return '2 weeks before';

      case FutureMessageDefaultReminder.oneMonth:
        return '1 month before';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }
}

// ===========================================================================
// SETTINGS GROUP
// ===========================================================================

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          title: title,
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textDisabled,
          ),
        ),

        const SizedBox(height: 11),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.76,
            ),
            borderRadius:
            BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(
                alpha: 0.45,
              ),
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

// ===========================================================================
// SETTINGS TILE
// ===========================================================================

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.fromLTRB(
        15,
        14,
        13,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
            const BoxDecoration(
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
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
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

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: AppTextTheme
                      .labelSmall
                      .copyWith(
                    fontSize: 8.5,
                    height: 1.3,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }

    return GestureDetector(
      onTap: onTap,
      behavior:
      HitTestBehavior.opaque,
      child: child,
    );
  }
}

// ===========================================================================
// DIVIDER
// ===========================================================================

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 64,
      ),
      child: Divider(
        height: 1,
        thickness: 0.7,
        color: AppColors.outlineVariant
            .withValues(
          alpha: 0.45,
        ),
      ),
    );
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
        letterSpacing: 1.8,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ===========================================================================
// SMALL STATUS PILL
// ===========================================================================

class _SmallStatusPill extends StatelessWidget {
  const _SmallStatusPill({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius:
        BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTextTheme.labelSmall.copyWith(
          fontSize: 7.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ===========================================================================
// STORAGE ROW
// ===========================================================================

class _StorageRow extends StatelessWidget {
  const _StorageRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              label,
              style:
              AppTextTheme.labelLarge.copyWith(
                fontSize: 11,
                color:
                AppColors.textPrimary,
              ),
            ),
          ),

          Text(
            value,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight:
              FontWeight.w600,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
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
              .withValues(
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
// SHEET HANDLE
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
        borderRadius:
        BorderRadius.circular(999),
      ),
    );
  }
}

// ===========================================================================
// BACKGROUND
// ===========================================================================

class _SettingsBackground
    extends StatelessWidget {
  const _SettingsBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration:
          const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8F5),
                Color(0xFFF4E9E5),
              ],
            ),
          ),
        ),

        Positioned(
          left: -100,
          top: 160,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration:
              BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.15,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          right: -120,
          bottom: 120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(
              width: 260,
              height: 260,
              decoration:
              BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFD9D5E4,
                ).withValues(
                  alpha: 0.15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// ANIMATED ENTRY
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
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value =
            animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              18 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}