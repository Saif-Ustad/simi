import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({
    super.key,
    this.appLockEnabled = true,
    this.biometricEnabled = true,
    this.hideNotificationPreviews = true,
    this.appSwitcherPrivacy = true,
    this.screenshotProtection = true,
    this.privateContentEnabled = true,
    this.analyticsEnabled = false,
    this.crashReportsEnabled = true,
    this.onBack,
    this.onAppLockChanged,
    this.onBiometricChanged,
    this.onNotificationPreviewChanged,
    this.onAppSwitcherPrivacyChanged,
    this.onScreenshotProtectionChanged,
    this.onPrivateContentChanged,
    this.onAnalyticsChanged,
    this.onCrashReportsChanged,
    this.onChangePin,
    this.onManagePrivateContent,
    this.onExportData,
    this.onDeleteAccount,
  });

  final bool appLockEnabled;
  final bool biometricEnabled;
  final bool hideNotificationPreviews;
  final bool appSwitcherPrivacy;
  final bool screenshotProtection;
  final bool privateContentEnabled;
  final bool analyticsEnabled;
  final bool crashReportsEnabled;

  final VoidCallback? onBack;

  final ValueChanged<bool>? onAppLockChanged;
  final ValueChanged<bool>? onBiometricChanged;
  final ValueChanged<bool>? onNotificationPreviewChanged;
  final ValueChanged<bool>? onAppSwitcherPrivacyChanged;
  final ValueChanged<bool>? onScreenshotProtectionChanged;
  final ValueChanged<bool>? onPrivateContentChanged;
  final ValueChanged<bool>? onAnalyticsChanged;
  final ValueChanged<bool>? onCrashReportsChanged;

  final VoidCallback? onChangePin;
  final VoidCallback? onManagePrivateContent;
  final VoidCallback? onExportData;
  final VoidCallback? onDeleteAccount;

  @override
  State<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState
    extends State<PrivacySecurityScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late bool _appLockEnabled;
  late bool _biometricEnabled;
  late bool _hideNotificationPreviews;
  late bool _appSwitcherPrivacy;
  late bool _screenshotProtection;
  late bool _privateContentEnabled;
  late bool _analyticsEnabled;
  late bool _crashReportsEnabled;

  @override
  void initState() {
    super.initState();

    _appLockEnabled = widget.appLockEnabled;
    _biometricEnabled = widget.biometricEnabled;
    _hideNotificationPreviews =
        widget.hideNotificationPreviews;
    _appSwitcherPrivacy = widget.appSwitcherPrivacy;
    _screenshotProtection = widget.screenshotProtection;
    _privateContentEnabled =
        widget.privateContentEnabled;
    _analyticsEnabled = widget.analyticsEnabled;
    _crashReportsEnabled =
        widget.crashReportsEnabled;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _PrivacyBackground(),
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
                _buildHero(),
                _buildSecuritySection(),
                _buildPrivacySection(),
                _buildPrivateContentSection(),
                _buildDataSection(),
                _buildDangerSection(),
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
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Privacy & Security',
                  style: GoogleFonts.playfairDisplay(
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
              Icons.shield_outlined,
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
            23,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF211D1D),
                Color(0xFF3B2D2F),
                Color(0xFF5A4144),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.13,
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
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.09),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 21,
                      color: Color(0xFFE8B4B8),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR PRIVATE SPACE',
                        style: AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 8,
                          letterSpacing: 1.7,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          const Color(0xFFE8B4B8),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Protected by SIMI',
                        style:
                        AppTextTheme.labelSmall
                            .copyWith(
                          fontSize: 9,
                          color: Colors.white
                              .withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 21),
              Text(
                'What you keep between\nyou two stays yours.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 25,
                  height: 1.14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Control how SIMI protects your '
                    'memories, conversations and private moments.',
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
  // SECURITY
  // ===========================================================================

  Widget _buildSecuritySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.08,
        child: _SettingsSection(
          label: 'APP SECURITY',
          children: [
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'App Lock',
              subtitle:
              'Require protection when opening SIMI.',
              value: _appLockEnabled,
              onChanged: (value) {
                setState(() {
                  _appLockEnabled = value;
                });

                widget.onAppLockChanged?.call(value);
              },
            ),

            _SettingsDivider(),

            _SettingsTile(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric unlock',
              subtitle:
              'Use fingerprint or face recognition.',
              value: _biometricEnabled,
              enabled: _appLockEnabled,
              onChanged: (value) {
                setState(() {
                  _biometricEnabled = value;
                });

                widget.onBiometricChanged?.call(value);
              },
            ),

            _SettingsDivider(),

            _ActionTile(
              icon: Icons.pin_outlined,
              title: 'Change PIN',
              subtitle:
              'Update the PIN used to protect SIMI.',
              enabled: _appLockEnabled,
              onTap: () {
                widget.onChangePin?.call();

                if (widget.onChangePin == null) {
                  _showChangePinSheet(context);
                }
              },
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
        delay: 0.14,
        child: _SettingsSection(
          label: 'PRIVACY',
          children: [
            _SettingsTile(
              icon: Icons.visibility_off_outlined,
              title: 'Hide notification previews',
              subtitle:
              'Keep message contents out of notifications.',
              value: _hideNotificationPreviews,
              onChanged: (value) {
                setState(() {
                  _hideNotificationPreviews = value;
                });

                widget.onNotificationPreviewChanged
                    ?.call(value);
              },
            ),

            _SettingsDivider(),

            _SettingsTile(
              icon: Icons.apps_outlined,
              title: 'App switcher privacy',
              subtitle:
              'Hide SIMI content in recent apps.',
              value: _appSwitcherPrivacy,
              onChanged: (value) {
                setState(() {
                  _appSwitcherPrivacy = value;
                });

                widget.onAppSwitcherPrivacyChanged
                    ?.call(value);
              },
            ),

            _SettingsDivider(),

            _SettingsTile(
              icon: Icons.no_photography_outlined,
              title: 'Screenshot protection',
              subtitle:
              'Prevent sensitive screens from being captured.',
              value: _screenshotProtection,
              onChanged: (value) {
                setState(() {
                  _screenshotProtection = value;
                });

                widget.onScreenshotProtectionChanged
                    ?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PRIVATE CONTENT
  // ===========================================================================

  Widget _buildPrivateContentSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.20,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'PRIVATE CONTENT',
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
              child: Column(
                children: [
                  Row(
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
                          Icons.favorite_border_rounded,
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
                              'Private content',
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Control how SIMI treats the things '
                                  'you choose to keep private.',
                              style: AppTextTheme
                                  .bodyMedium
                                  .copyWith(
                                fontSize: 9.5,
                                height: 1.45,
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.56,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _SmallSwitch(
                        value:
                        _privateContentEnabled,
                        onChanged: (value) {
                          setState(() {
                            _privateContentEnabled =
                                value;
                          });

                          widget
                              .onPrivateContentChanged
                              ?.call(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      widget.onManagePrivateContent
                          ?.call();

                      if (widget
                          .onManagePrivateContent ==
                          null) {
                        _showPrivateContentSheet(
                          context,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.07),
                        borderRadius:
                        BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white
                              .withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.tune_rounded,
                            size: 16,
                            color: Color(0xFFE8B4B8),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Manage private content',
                              style: AppTextTheme
                                  .labelLarge
                                  .copyWith(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons
                                .arrow_forward_ios_rounded,
                            size: 10,
                            color: Colors.white54,
                          ),
                        ],
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
  // DATA
  // ===========================================================================

  Widget _buildDataSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.27,
        child: _SettingsSection(
          label: 'DATA & PERSONALIZATION',
          children: [
            _SettingsTile(
              icon: Icons.insights_outlined,
              title: 'Anonymous analytics',
              subtitle:
              'Help improve SIMI with non-personal usage data.',
              value: _analyticsEnabled,
              onChanged: (value) {
                setState(() {
                  _analyticsEnabled = value;
                });

                widget.onAnalyticsChanged
                    ?.call(value);
              },
            ),

            _SettingsDivider(),

            _SettingsTile(
              icon: Icons.bug_report_outlined,
              title: 'Crash reports',
              subtitle:
              'Send technical reports when something goes wrong.',
              value: _crashReportsEnabled,
              onChanged: (value) {
                setState(() {
                  _crashReportsEnabled = value;
                });

                widget.onCrashReportsChanged
                    ?.call(value);
              },
            ),

            _SettingsDivider(),

            _ActionTile(
              icon: Icons.download_outlined,
              title: 'Export my data',
              subtitle:
              'Get a copy of the information stored in SIMI.',
              onTap: () {
                widget.onExportData?.call();

                if (widget.onExportData == null) {
                  _showExportSheet(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DANGER ZONE
  // ===========================================================================

  Widget _buildDangerSection() {
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
              label: 'DANGER ZONE',
            ),
            const SizedBox(height: 11),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F6),
                borderRadius:
                BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFE7C7C9),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _showDeleteAccountConfirmation(
                    context,
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 41,
                      height: 41,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
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
                            'Delete all SIMI data',
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
                            'Permanently remove your memories, '
                                'messages and personal data.',
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 8.8,
                              height: 1.35,
                              color:
                              AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primary,
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
  // CHANGE PIN
  // ===========================================================================

  void _showChangePinSheet(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _SimpleSheet(
          icon: Icons.pin_outlined,
          title: 'Change your PIN',
          subtitle:
          'Choose a new PIN to protect your private space.',
          buttonLabel: 'Continue',
          onPressed: () {
            Navigator.pop(sheetContext);
            _showComingSoon(
              context,
              'PIN change',
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // PRIVATE CONTENT SHEET
  // ===========================================================================

  void _showPrivateContentSheet(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _SimpleSheet(
          icon: Icons.favorite_border_rounded,
          title: 'Private content',
          subtitle:
          'SIMI treats your private memories, chats '
              'and moments as content that belongs only to you two.',
          buttonLabel: 'Got it',
          onPressed: () {
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  // ===========================================================================
  // EXPORT
  // ===========================================================================

  void _showExportSheet(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _SimpleSheet(
          icon: Icons.download_outlined,
          title: 'Export your data',
          subtitle:
          'Your export will contain the information '
              'available in your SIMI account.',
          buttonLabel: 'Start export',
          onPressed: () {
            Navigator.pop(sheetContext);

            _showComingSoon(
              context,
              'Data export',
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  void _showDeleteAccountConfirmation(
      BuildContext context,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
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
              const SizedBox(height: 22),
              Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Delete everything?',
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'This permanently removes your SIMI data. '
                    'This cannot be undone.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 10,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);

                    widget.onDeleteAccount?.call();

                    if (widget.onDeleteAccount ==
                        null) {
                      _showComingSoon(
                        context,
                        'Account deletion',
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Delete my SIMI data',
                  ),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                  },
                  style:
                  OutlinedButton.styleFrom(
                    foregroundColor:
                    AppColors.textPrimary,
                    side: BorderSide(
                      color: AppColors
                          .outlineVariant
                          .withValues(alpha: 0.7),
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Keep everything',
                  ),
                ),
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
        delay: 0.40,
        child: Column(
          children: [
            const Icon(
              Icons.favorite_rounded,
              size: 15,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Your story belongs to you.',
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
              'SIMI • Privacy & Security',
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
            borderRadius:
            BorderRadius.circular(23),
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
// SETTINGS TILE
// =============================================================================

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
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
              color: enabled && value
                  ? const Color(0xFFFCE4EC)
                  : const Color(0xFFF2EFED),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: enabled && value
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
// ACTION TILE
// =============================================================================

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            15,
            12,
            13,
            12,
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
                      style: AppTextTheme.labelLarge
                          .copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
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
                      style: AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 8.7,
                        height: 1.35,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
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
// SIMPLE SHEET
// =============================================================================

class _SimpleSheet extends StatelessWidget {
  const _SimpleSheet({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

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
          const _SheetHandle(),
          const SizedBox(height: 22),
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 23,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style:
            AppTextTheme.bodyMedium.copyWith(
              fontSize: 10,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor:
                AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(26),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ),
          const SizedBox(height: 4),
        ],
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

class _PrivacyBackground
    extends StatelessWidget {
  const _PrivacyBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 80,
          right: -110,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 48,
              sigmaY: 48,
            ),
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 470,
          left: -120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: Container(
              width: 260,
              height: 260,
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