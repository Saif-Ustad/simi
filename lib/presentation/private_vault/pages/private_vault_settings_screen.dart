import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PrivateVaultSettingsScreen extends StatefulWidget {
  const PrivateVaultSettingsScreen({
    super.key,
    this.biometricEnabled = true,
    this.hidePreviews = true,
    this.appSwitcherPrivacy = true,
    this.privateNotifications = true,
    this.autoLock = VaultAutoLock.immediately,
    this.onBack,
    this.onLockNow,
    this.onChangePin,
    this.onBiometricChanged,
    this.onHidePreviewsChanged,
    this.onPrivateNotificationsChanged,
    this.onAutoLockChanged,
    this.onClearCache,
    this.onDeleteVault,
    this.onAppSwitcherPrivacyChanged,
  });

  final bool biometricEnabled;
  final bool hidePreviews;
  final bool appSwitcherPrivacy;
  final bool privateNotifications;
  final VaultAutoLock autoLock;

  final VoidCallback? onBack;
  final VoidCallback? onLockNow;
  final VoidCallback? onChangePin;

  final ValueChanged<bool>? onBiometricChanged;
  final ValueChanged<bool>? onHidePreviewsChanged;
  final ValueChanged<bool>? onAppSwitcherPrivacyChanged;
  final ValueChanged<bool>? onPrivateNotificationsChanged;

  final ValueChanged<VaultAutoLock>? onAutoLockChanged;

  final VoidCallback? onClearCache;
  final VoidCallback? onDeleteVault;

  @override
  State<PrivateVaultSettingsScreen> createState() =>
      _PrivateVaultSettingsScreenState();
}

class _PrivateVaultSettingsScreenState
    extends State<PrivateVaultSettingsScreen> {
  late bool _biometricEnabled;
  late bool _hidePreviews;
  late bool _appSwitcherPrivacy;
  late bool _privateNotifications;
  late VaultAutoLock _autoLock;

  @override
  void initState() {
    super.initState();

    _biometricEnabled = widget.biometricEnabled;
    _hidePreviews = widget.hidePreviews;
    _appSwitcherPrivacy = widget.appSwitcherPrivacy;
    _privateNotifications = widget.privateNotifications;
    _autoLock = widget.autoLock;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildTopBar(context),
          ),

          SliverToBoxAdapter(
            child: _buildHeader(),
          ),

          SliverToBoxAdapter(
            child: _buildSecurityHero(),
          ),

          SliverToBoxAdapter(
            child: _buildSecuritySection(),
          ),

          SliverToBoxAdapter(
            child: _buildPrivacySection(),
          ),

          SliverToBoxAdapter(
            child: _buildNotificationSection(),
          ),

          SliverToBoxAdapter(
            child: _buildDataSection(),
          ),

          SliverToBoxAdapter(
            child: _buildDangerSection(),
          ),

          SliverToBoxAdapter(
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ??
                      () => Navigator.of(context).pop(),
            ),

            const Spacer(),

            Text(
              'Vault Settings',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const Spacer(),

            const SizedBox(
              width: 42,
              height: 42,
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
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIVATE SPACE',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your privacy,\nexactly your way.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              height: 1.12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Control how your private world is protected, '
                'hidden and kept between the two of you.',
            style: AppTextTheme.bodyMedium.copyWith(
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECURITY HERO
  // ===========================================================================

  Widget _buildSecurityHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF171515),
              Color(0xFF302727),
              Color(0xFF3C2D2F),
            ],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 22,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Color(0xFFE8B4B8),
                size: 27,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VAULT PROTECTED',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE8B4B8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Your private world is locked.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Only you can open it.',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.58),
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
  // SECURITY
  // ===========================================================================

  Widget _buildSecuritySection() {
    return _SettingsSection(
      title: 'SECURITY',
      children: [
        _SettingsTile(
          icon: Icons.lock_outline_rounded,
          title: 'Lock vault now',
          subtitle: 'Secure the vault immediately',
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          onTap: () {
            widget.onLockNow?.call();
          },
        ),

        _SettingsTile(
          icon: Icons.pin_outlined,
          title: 'Change PIN',
          subtitle: 'Update your private vault PIN',
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          onTap: () {
            widget.onChangePin?.call();
          },
        ),

        _SettingsTile(
          icon: Icons.fingerprint_rounded,
          title: 'Biometric unlock',
          subtitle: 'Use fingerprint or face recognition',
          trailing: Switch(
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() {
                _biometricEnabled = value;
              });

              widget.onBiometricChanged?.call(value);
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ),

        _SettingsTile(
          icon: Icons.timer_outlined,
          title: 'Auto-lock',
          subtitle: _autoLock.label,
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          onTap: _showAutoLockPicker,
        ),
      ],
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacySection() {
    return _SettingsSection(
      title: 'PRIVACY',
      children: [
        _SettingsTile(
          icon: Icons.visibility_off_outlined,
          title: 'Hide previews',
          subtitle: 'Keep private content out of previews',
          trailing: Switch(
            value: _hidePreviews,
            onChanged: (value) {
              setState(() {
                _hidePreviews = value;
              });

              widget.onHidePreviewsChanged?.call(value);
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ),

        _SettingsTile(
          icon: Icons.phone_android_outlined,
          title: 'App switcher privacy',
          subtitle: 'Hide vault content from recent apps',
          trailing: Switch(
            value: _appSwitcherPrivacy,
            onChanged: (value) {
              setState(() {
                _appSwitcherPrivacy = value;
              });

              widget.onHidePreviewsChanged?.call(value);
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ),

        _SettingsTile(
          icon: Icons.lock_person_outlined,
          title: 'Private content',
          subtitle: 'Memories, chats and intimate content stay protected',
          trailing: const Icon(
            Icons.verified_user_outlined,
            size: 19,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // NOTIFICATIONS
  // ===========================================================================

  Widget _buildNotificationSection() {
    return _SettingsSection(
      title: 'NOTIFICATIONS',
      children: [
        _SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'Private notifications',
          subtitle: 'Receive notifications from vault features',
          trailing: Switch(
            value: _privateNotifications,
            onChanged: (value) {
              setState(() {
                _privateNotifications = value;
              });

              widget.onPrivateNotificationsChanged?.call(value);
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ),

        _SettingsTile(
          icon: Icons.visibility_off_outlined,
          title: 'Notification previews',
          subtitle: 'Show only “You have something private”',
          trailing: const Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DATA
  // ===========================================================================

  Widget _buildDataSection() {
    return _SettingsSection(
      title: 'DATA & STORAGE',
      children: [
        _SettingsTile(
          icon: Icons.storage_outlined,
          title: 'Vault storage',
          subtitle: 'See how much private space is being used',
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          onTap: () {
            _showStorageInfo(context);
          },
        ),

        _SettingsTile(
          icon: Icons.cleaning_services_outlined,
          title: 'Clear temporary data',
          subtitle: 'Remove cached private thumbnails and files',
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          onTap: () {
            _confirmClearCache(context);
          },
        ),

        _SettingsTile(
          icon: Icons.download_outlined,
          title: 'Export vault',
          subtitle: 'Create a private backup of your vault',
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: AppColors.textDisabled,
          ),
          onTap: () {
            _showComingSoon(
              context,
              'Vault export will be connected next.',
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // DANGER
  // ===========================================================================

  Widget _buildDangerSection() {
    return _SettingsSection(
      title: 'DANGER ZONE',
      children: [
        _SettingsTile(
          icon: Icons.delete_sweep_outlined,
          title: 'Delete all vault data',
          subtitle: 'Permanently remove everything inside the vault',
          destructive: true,
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: Colors.red,
          ),
          onTap: () {
            _confirmDeleteVault(context);
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Just between us.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'SIMI Private Vault',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.2,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // AUTO LOCK
  // ===========================================================================

  void _showAutoLockPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
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
                'Auto-lock vault',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Choose when your private space should lock.',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              ...VaultAutoLock.values.map(
                    (option) {
                  final selected = option == _autoLock;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: selected
                          ? const Color(0xFFFCE4EC)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          setState(() {
                            _autoLock = option;
                          });

                          widget.onAutoLockChanged?.call(option);

                          Navigator.pop(sheetContext);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                option.icon,
                                size: 19,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option.label,
                                  style: AppTextTheme.labelLarge.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 19,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // STORAGE
  // ===========================================================================

  void _showStorageInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.78,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _SheetHandle(),

                  const SizedBox(height: 20),

                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storage_outlined,
                      color: AppColors.primary,
                      size: 25,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Vault storage',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Your private content is stored securely on this device.',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Storage card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        _StorageRow(
                          label: 'Photos',
                          value: '12.4 MB',
                        ),
                        _StorageRow(
                          label: 'Videos',
                          value: '48.7 MB',
                        ),
                        _StorageRow(
                          label: 'Other',
                          value: '3.2 MB',
                        ),
                        const Divider(height: 20),
                        _StorageRow(
                          label: 'Total',
                          value: '64.3 MB',
                          bold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Privacy information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC).withValues(
                        alpha: 0.55,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your private content stays inside the vault '
                                'and is protected by your security settings.',
                            style: AppTextTheme.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text('Done'),
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
  // CONFIRMATIONS
  // ===========================================================================

  void _confirmClearCache(BuildContext context) {
    _showConfirmDialog(
      context,
      title: 'Clear temporary data?',
      message:
      'Temporary thumbnails and cached files will be removed. '
          'Your private memories will remain safe.',
      confirmLabel: 'Clear',
      onConfirm: () {
        widget.onClearCache?.call();
      },
    );
  }

  void _confirmDeleteVault(BuildContext context) {
    _showConfirmDialog(
      context,
      title: 'Delete everything?',
      message:
      'This permanently removes all content from your Private Vault. '
          'This action cannot be undone.',
      confirmLabel: 'Delete everything',
      destructive: true,
      onConfirm: () {
        widget.onDeleteVault?.call();
      },
    );
  }

  void _showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmLabel,
        required VoidCallback onConfirm,
        bool destructive = false,
      }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            message,
            style: AppTextTheme.bodyMedium.copyWith(
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onConfirm();
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                destructive ? Colors.red : AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// =============================================================================
// ENUM
// =============================================================================

enum VaultAutoLock {
  immediately,
  afterOneMinute,
  afterFiveMinutes,
  afterFifteenMinutes,
  never,
}

extension VaultAutoLockExtension on VaultAutoLock {
  String get label {
    switch (this) {
      case VaultAutoLock.immediately:
        return 'Immediately';
      case VaultAutoLock.afterOneMinute:
        return 'After 1 minute';
      case VaultAutoLock.afterFiveMinutes:
        return 'After 5 minutes';
      case VaultAutoLock.afterFifteenMinutes:
        return 'After 15 minutes';
      case VaultAutoLock.never:
        return 'Never';
    }
  }

  IconData get icon {
    switch (this) {
      case VaultAutoLock.immediately:
        return Icons.lock_outline_rounded;
      case VaultAutoLock.afterOneMinute:
        return Icons.looks_one_outlined;
      case VaultAutoLock.afterFiveMinutes:
        return Icons.looks_5_outlined;
      case VaultAutoLock.afterFifteenMinutes:
        return Icons.timer_outlined;
      case VaultAutoLock.never:
        return Icons.lock_open_outlined;
    }
  }
}

// =============================================================================
// SETTINGS SECTION
// =============================================================================

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 66),
                      child: Divider(
                        height: 1,
                        color: AppColors.outlineVariant.withValues(
                          alpha: 0.42,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
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
    this.trailing,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final iconColor =
    destructive ? Colors.red : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            14,
            13,
            12,
            13,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: destructive
                      ? const Color(0xFFFFEEEE)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 13,
                        color: destructive
                            ? Colors.red.shade400
                            : AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9.5,
                        height: 1.3,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// STORAGE ROW
// =============================================================================

class _StorageRow extends StatelessWidget {
  const _StorageRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextTheme.labelLarge.copyWith(
              fontSize: 12,
              fontWeight:
              bold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
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
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.78),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 19,
            color: AppColors.textPrimary,
          ),
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
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}