import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/home_bottom_navigation.dart';
import '../../../core/config/theme/app_colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

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
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                32,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      'More ❤️',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _SectionLabel(
                      title: 'RELATIONSHIP',
                    ),

                    const SizedBox(height: 8),

                    _FeatureCard(
                      icon: Icons.water_drop_outlined,
                      title: 'Period Tracking',
                      backgroundColor:
                      const Color(0xFFFCE4EC),
                      onTap: () {
                        debugPrint('Period Tracking');
                      },
                    ),

                    _FeatureCard(
                      icon: Icons.calendar_month_outlined,
                      title: 'Special Dates',
                      backgroundColor:
                      const Color(0xFFE8E5F4),
                      onTap: () {
                        debugPrint('Special Dates');
                      },
                    ),

                    _FeatureCard(
                      icon: Icons.mail_outline_rounded,
                      title: 'Future Messages',
                      backgroundColor:
                      const Color(0xFFE5E2F2),
                      onTap: () {
                        debugPrint('Future Messages');
                      },
                    ),

                    const SizedBox(height: 20),

                    _SectionLabel(
                      title: 'PRIVATE',
                    ),

                    const SizedBox(height: 8),

                    _FeatureCard(
                      icon: Icons.lock_outline_rounded,
                      title: 'Private Photos Vault',
                      subtitle: 'Requires authentication',
                      backgroundColor:
                      const Color(0xFFE8E4E2),
                      onTap: () {
                        debugPrint('Private Photos Vault');
                      },
                    ),

                    const SizedBox(height: 20),

                    _SectionLabel(
                      title: 'LOVE',
                    ),

                    const SizedBox(height: 8),

                    _FeatureCard(
                      icon: Icons.favorite_border_rounded,
                      title: 'Love Notifications',
                      backgroundColor:
                      const Color(0xFFF6E8EA),
                      onTap: () {
                        debugPrint('Love Notifications');
                      },
                    ),

                    _FeatureCard(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Gift Wishlist',
                      backgroundColor:
                      const Color(0xFFEDE8F5),
                      onTap: () {
                        debugPrint('Gift Wishlist');
                      },
                    ),

                    const SizedBox(height: 20),

                    _SectionLabel(
                      title: 'APP',
                    ),

                    const SizedBox(height: 8),

                    _FeatureCard(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      backgroundColor:
                      const Color(0xFFEDE9E6),
                      onTap: () {
                        debugPrint('Settings');
                      },
                    ),

                    _FeatureCard(
                      icon: Icons.shield_outlined,
                      title: 'Privacy & Security',
                      backgroundColor:
                      const Color(0xFFEDE9E6),
                      onTap: () {
                        debugPrint('Privacy & Security');
                      },
                    ),

                    _FeatureCard(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      backgroundColor:
                      const Color(0xFFEDE9E6),
                      onTap: () {
                        debugPrint('Notifications');
                      },
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          debugPrint('Sign Out');
                        },
                        child: Text(
                          'Sign Out',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
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

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Center(
              child: Text(
                'My Love',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                  ),
                  child: Icon(
                    icon,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.outlineVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}