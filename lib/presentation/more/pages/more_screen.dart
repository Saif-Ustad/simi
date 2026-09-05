import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simi/core/config/routes/router.dart';

import '../../../common/widgets/app_profile_avatar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
    this.userPhoto,
  });

  final ImageProvider? userPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildWelcome(),

                    const SizedBox(height: 28),

                    _SectionTitle(
                      title: 'OUR STORY',
                      icon: Icons.favorite_outline_rounded,
                    ),

                    const SizedBox(height: 10),

                    _buildFeatureGroup([
                      _FeatureItem(
                        icon: Icons.photo_library_outlined,
                        title: 'Memories',
                        backgroundColor: const Color(0xFFF6E8EA),
                        onTap: () {
                          debugPrint('Memories');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.calendar_month_outlined,
                        title: 'Special Dates',
                        backgroundColor: const Color(0xFFE8E5F4),
                        onTap: () {
                          debugPrint('Special Dates');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.mail_outline_rounded,
                        title: 'Future Messages',
                        backgroundColor: const Color(0xFFE5E2F2),
                        onTap: () {
                          debugPrint('Future Messages');
                        },
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _SectionTitle(
                      title: 'OUR WELLBEING',
                      icon: Icons.spa_outlined,
                    ),

                    const SizedBox(height: 10),

                    _buildFeatureGroup([
                      _FeatureItem(
                        icon: Icons.mood_outlined,
                        title: 'Mood Journal',
                        backgroundColor: const Color(0xFFF5F5F5),
                        onTap: () {
                          debugPrint('Mood Journal');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.water_drop_outlined,
                        title: 'Period Tracking',
                        backgroundColor: const Color(0xFFFCE4EC),
                        onTap: () {
                          debugPrint('Period Tracking');
                        },
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _SectionTitle(
                      title: 'PRIVATE',
                      icon: Icons.lock_outline_rounded,
                    ),

                    const SizedBox(height: 10),

                    _buildFeatureGroup([
                      _FeatureItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Private Photos Vault',
                        subtitle: 'Requires authentication',
                        backgroundColor: const Color(0xFFE8E4E2),
                        onTap: () {
                          context.push(AppRoutes.privateVault);
                        },
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _SectionTitle(
                      title: 'LOVE',
                      icon: Icons.auto_awesome_outlined,
                    ),

                    const SizedBox(height: 10),

                    _buildFeatureGroup([
                      _FeatureItem(
                        icon: Icons.favorite_border_rounded,
                        title: 'Love Notifications',
                        backgroundColor: const Color(0xFFF6E8EA),
                        onTap: () {
                          debugPrint('Love Notifications');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.card_giftcard_outlined,
                        title: 'Gift Wishlist',
                        backgroundColor: const Color(0xFFEDE8F5),
                        onTap: () {
                          debugPrint('Gift Wishlist');
                        },
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _SectionTitle(
                      title: 'APP',
                      icon: Icons.tune_rounded,
                    ),

                    const SizedBox(height: 10),

                    _buildFeatureGroup([
                      _FeatureItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        backgroundColor: const Color(0xFFEDE9E6),
                        onTap: () {
                          debugPrint('Settings');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        backgroundColor: const Color(0xFFEDE9E6),
                        onTap: () {
                          debugPrint('Notifications');
                        },
                      ),
                      _FeatureItem(
                        icon: Icons.shield_outlined,
                        title: 'Privacy & Security',
                        backgroundColor: const Color(0xFFEDE9E6),
                        onTap: () {
                          debugPrint('Privacy & Security');
                        },
                      ),
                    ]),

                    const SizedBox(height: 28),

                    _buildSignOut(),

                    const SizedBox(height: 12),

                    Center(
                      child: Text(
                        'Made just for two ❤️',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
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

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          AppProfileAvatar(
            image: userPhoto,
            fallbackIcon: Icons.person_outline_rounded,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR SPACE',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.3,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'SIMI',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.outlineVariant,
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WELCOME
  // ============================================================

  Widget _buildWelcome() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'More ❤️',
                  style: AppTextTheme.headlineMedium,
                ),

                const SizedBox(height: 6),

                Text(
                  'Everything that makes your little world yours.',
                  style: AppTextTheme.bodyMediumSecondary,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURE GROUP
  // ============================================================

  Widget _buildFeatureGroup(List<_FeatureItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _FeatureCard(
              item: items[i],
            ),

            if (i != items.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 68),
                child: Divider(
                  height: 1,
                  color: AppColors.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Widget _buildSignOut() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          debugPrint('Sign Out');
        },
        icon: const Icon(
          Icons.logout_rounded,
          size: 17,
        ),
        label: Text(
          'Sign Out',
          style: AppTextTheme.labelLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          foregroundColor: AppColors.primary,
        ),
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),

        const SizedBox(width: 7),

        Text(
          title,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FEATURE ITEM DATA
// ============================================================

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color backgroundColor;
  final VoidCallback onTap;
}

// ============================================================
// FEATURE CARD
// ============================================================

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.item,
  });

  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 19,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    if (item.subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle!,
                        style: AppTextTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}