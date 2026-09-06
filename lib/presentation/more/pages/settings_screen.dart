import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simi/core/config/routes/router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.userName = 'You',
    this.partnerName = 'Love',
    this.userInitial = 'Y',
    this.partnerInitial = 'L',
    this.onBack,
    this.onProfile,
    this.onNotifications,
    this.onPrivacySecurity,
    this.onAppearance,
    this.onRelationship,
    this.onDataStorage,
    this.onAbout,
    this.onHelp,
    this.onFeedback,
    this.onLogout,
  });

  final String userName;
  final String partnerName;
  final String userInitial;
  final String partnerInitial;

  final VoidCallback? onBack;
  final VoidCallback? onProfile;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacySecurity;
  final VoidCallback? onAppearance;
  final VoidCallback? onRelationship;
  final VoidCallback? onDataStorage;
  final VoidCallback? onAbout;
  final VoidCallback? onHelp;
  final VoidCallback? onFeedback;
  final VoidCallback? onLogout;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  // App-level preferences.
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  bool _showPartnerActivity = true;
  bool _autoPlayMedia = true;

  String _appearance = 'System';

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
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              children: [
                _buildTopBar(context),
                _buildProfileHeader(),
                _buildAccountSection(),
                _buildPreferencesSection(),
                _buildRelationshipSection(),
                _buildPrivacySection(),
                _buildDataSection(),
                _buildSupportSection(),
                _buildAboutSection(),
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
                  'Settings',
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
              color: Colors.white.withValues(
                alpha: 0.78,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.50),
              ),
            ),
            child: const Icon(
              Icons.tune_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PROFILE HEADER
  // ===========================================================================

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0,
        child: GestureDetector(
          onTap: widget.onProfile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF322829),
                  Color(0xFF604447),
                ],
              ),
              borderRadius: BorderRadius.circular(27),
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
            child: Row(
              children: [
                _ProfileAvatar(
                  initial: widget.userInitial,
                  large: true,
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            widget.userName,
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: Colors.white
                                  .withValues(
                                alpha: 0.58,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.favorite_rounded,
                            size: 9,
                            color: Color(0xFFE8B4B8),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.partnerName,
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: Colors.white
                                  .withValues(
                                alpha: 0.58,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.10,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: Colors.white,
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
  // ACCOUNT
  // ===========================================================================

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.08,
        child: _SettingsSection(
          label: 'YOUR ACCOUNT',
          children: [
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Profile',
              subtitle:
              'Your name, photo and relationship profile.',
              onTap: widget.onProfile,
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle:
              'Choose what SIMI should remind you about.',
              onTap: widget.onNotifications,
              trailing: const _NavigationArrow(),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy & Security',
              subtitle:
              'Keep your little world private.',
              onTap: widget.onPrivacySecurity,
              trailing: const _NavigationArrow(),
              darkIcon: true,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PREFERENCES
  // ===========================================================================

  Widget _buildPreferencesSection() {
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
          label: 'APP PREFERENCES',
          children: [
            _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle:
              'Light, dark or follow your device.',
              onTap: () {
                _showAppearanceSheet(context);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _appearance,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const _NavigationArrow(),
                ],
              ),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.volume_up_outlined,
              title: 'Sound effects',
              subtitle:
              'Little sounds throughout SIMI.',
              trailing: _SmallSwitch(
                value: _soundEffects,
                onChanged: (value) {
                  setState(() {
                    _soundEffects = value;
                  });
                },
              ),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.vibration_rounded,
              title: 'Haptic feedback',
              subtitle:
              'Gentle feedback when you interact.',
              trailing: _SmallSwitch(
                value: _hapticFeedback,
                onChanged: (value) {
                  setState(() {
                    _hapticFeedback = value;
                  });
                },
              ),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.play_circle_outline_rounded,
              title: 'Auto-play media',
              subtitle:
              'Automatically play supported media.',
              trailing: _SmallSwitch(
                value: _autoPlayMedia,
                onChanged: (value) {
                  setState(() {
                    _autoPlayMedia = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // RELATIONSHIP
  // ===========================================================================

  Widget _buildRelationshipSection() {
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
        child: _SettingsSection(
          label: 'YOUR LITTLE WORLD',
          children: [
            _SettingsTile(
              icon: Icons.favorite_border_rounded,
              title: 'Relationship',
              subtitle:
              'Your partner and relationship details.',
              onTap: widget.onRelationship,
              trailing: const _NavigationArrow(),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.people_outline_rounded,
              title: 'Partner activity',
              subtitle:
              'Show activity shared between you.',
              trailing: _SmallSwitch(
                value: _showPartnerActivity,
                onChanged: (value) {
                  setState(() {
                    _showPartnerActivity = value;
                  });
                },
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
        delay: 0.26,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              label: 'PRIVACY',
            ),

            const SizedBox(height: 11),

            GestureDetector(
              onTap: widget.onPrivacySecurity,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.09,
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
                        Icons.shield_outlined,
                        size: 20,
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
                            'Your space is yours.',
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Manage app lock, private content, '
                                'data permissions and what appears '
                                'outside SIMI.',
                            style: AppTextTheme.bodyMedium
                                .copyWith(
                              fontSize: 10,
                              height: 1.5,
                              color: Colors.white
                                  .withValues(
                                alpha: 0.57,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 7),

                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: Color(0xFFE8B4B8),
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
        delay: 0.32,
        child: _SettingsSection(
          label: 'DATA & STORAGE',
          children: [
            _SettingsTile(
              icon: Icons.storage_outlined,
              title: 'Data & Storage',
              subtitle:
              'Manage your SIMI data and storage.',
              onTap: widget.onDataStorage,
              trailing: const _NavigationArrow(),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.download_outlined,
              title: 'Export your data',
              subtitle:
              'Keep a copy of your memories and information.',
              onTap: () {
                _showExportDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SUPPORT
  // ===========================================================================

  Widget _buildSupportSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.38,
        child: _SettingsSection(
          label: 'SUPPORT',
          children: [
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle:
              'Answers, guides and getting help.',
              onTap: widget.onHelp,
              trailing: const _NavigationArrow(),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Send feedback',
              subtitle:
              'Tell us what could make SIMI better.',
              onTap: widget.onFeedback,
              trailing: const _NavigationArrow(),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // ABOUT
  // ===========================================================================

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.44,
        child: _SettingsSection(
          label: 'ABOUT SIMI',
          children: [
            _SettingsTile(
              icon: Icons.auto_awesome_outlined,
              title: 'About SIMI',
              subtitle:
              'The little space you built together.',
              onTap: widget.onAbout,
              trailing: const _NavigationArrow(),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle:
              'The rules for using SIMI.',
              onTap: () {
                context.push(AppRoutes.termsOfService);
              },
              trailing: const _NavigationArrow(),
            ),
            _SettingsDivider(),
            _SettingsTile(
              icon: Icons.policy_outlined,
              title: 'Privacy Policy',
              subtitle:
              'How SIMI handles your information.',
              onTap: widget.onPrivacySecurity,
              trailing: const _NavigationArrow(),
            ),
          ],
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
        30,
        36,
        30,
        10,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.50,
        child: Column(
          children: [
            const Icon(
              Icons.favorite_rounded,
              size: 16,
              color: AppColors.primary,
            ),

            const SizedBox(height: 9),

            Text(
              'Made for the two of you.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'SIMI • Version 1.0.0',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                letterSpacing: 0.8,
                color: AppColors.textDisabled,
              ),
            ),

            const SizedBox(height: 22),

            if (widget.onLogout != null)
              GestureDetector(
                onTap: () {
                  _showLogoutDialog(context);
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE8EA),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Sign out',
                    style: AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFA8555D),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // APPEARANCE SHEET
  // ===========================================================================

  void _showAppearanceSheet(BuildContext context) {
    const options = [
      'System',
      'Light',
      'Dark',
    ];

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

              Text(
                'Appearance',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Choose how SIMI feels on your screen.',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              ...options.map(
                    (option) => Padding(
                  padding:
                  const EdgeInsets.only(bottom: 9),
                  child: _ChoiceTile(
                    icon: _appearanceIcon(option),
                    title: option,
                    selected:
                    _appearance == option,
                    onTap: () {
                      setState(() {
                        _appearance = option;
                      });

                      Navigator.pop(sheetContext);
                    },
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

  IconData _appearanceIcon(String value) {
    switch (value) {
      case 'Light':
        return Icons.light_mode_outlined;

      case 'Dark':
        return Icons.dark_mode_outlined;

      default:
        return Icons.brightness_auto_outlined;
    }
  }

  // ===========================================================================
  // EXPORT
  // ===========================================================================

  void _showExportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_outlined,
                    color: AppColors.primary,
                    size: 23,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Export your story',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Create a private copy of your SIMI '
                      'data. This may take a little while.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 11,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);

                      _showComingSoon(
                        context,
                        'Data export',
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor:
                      AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Start export',
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Not now',
                    style: AppTextTheme.labelLarge
                        .copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // LOGOUT
  // ===========================================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE8EA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFA8555D),
                    size: 22,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Leave SIMI for now?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Your memories and private space '
                      'will stay here.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 11,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      widget.onLogout?.call();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFA8555D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Sign out',
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Stay in SIMI',
                    style: AppTextTheme.labelLarge
                        .copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HELPER
  // ===========================================================================

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
// SETTINGS TILE
// =============================================================================

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.darkIcon = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool darkIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            15,
            13,
            13,
            13,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: darkIcon
                      ? const Color(0xFFE9E4E2)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: darkIcon
                      ? AppColors.textPrimary
                      : AppColors.primary,
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
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8.8,
                        height: 1.35,
                        color: AppColors.textSecondary,
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
// SMALL SWITCH
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
// NAVIGATION ARROW
// =============================================================================

class _NavigationArrow extends StatelessWidget {
  const _NavigationArrow();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_forward_ios_rounded,
      size: 12,
      color: AppColors.textSecondary,
    );
  }
}

// =============================================================================
// PROFILE AVATAR
// =============================================================================

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.initial,
    this.large = false,
  });

  final String initial;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 54.0 : 40.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE8B4B8),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.30,
          ),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial.isEmpty
            ? '?'
            : initial.substring(0, 1).toUpperCase(),
        style: GoogleFonts.playfairDisplay(
          fontSize: large ? 22 : 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// CHOICE TILE
// =============================================================================

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFCE4EC)
              : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected
                ? AppColors.primary
                .withValues(alpha: 0.45)
                : AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white
                    : const Color(0xFFF7F1F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 17,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                title,
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 19,
                color: AppColors.primary,
              )
            else
              const Icon(
                Icons.circle_outlined,
                size: 19,
                color: AppColors.outlineVariant,
              ),
          ],
        ),
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
// BACKGROUND
// =============================================================================

class _SettingsBackground extends StatelessWidget {
  const _SettingsBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 90,
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
          top: 470,
          left: -100,
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