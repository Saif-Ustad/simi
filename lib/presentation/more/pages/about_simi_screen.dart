import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class AboutSimiScreen extends StatefulWidget {
  const AboutSimiScreen({
    super.key,
    this.version = '1.0.0',
    this.buildNumber = '1',
    this.onBack,
    this.onPrivacy,
    this.onTerms,
    this.onFeedback,
    this.onLicenses,
  });

  final String version;
  final String buildNumber;

  final VoidCallback? onBack;
  final VoidCallback? onPrivacy;
  final VoidCallback? onTerms;
  final VoidCallback? onFeedback;
  final VoidCallback? onLicenses;

  @override
  State<AboutSimiScreen> createState() =>
      _AboutSimiScreenState();
}

class _AboutSimiScreenState
    extends State<AboutSimiScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _AboutBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 45,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildStorySection(),
                _buildMadeForTwo(),
                _buildWhatSimiKeeps(),
                _buildPrivacySection(),
                _buildLinksSection(),
                _buildVersion(),
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

  Widget _buildTopBar(
      BuildContext context,
      ) {
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
            onTap: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'SETTINGS',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'About SIMI',
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '♥',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
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
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            24,
            22,
            25,
          ),
          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF292324),
                Color(0xFF4B383A),
                Color(0xFF60484B),
              ],
            ),
            borderRadius:
            BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.10),
                blurRadius: 25,
                offset:
                const Offset(0, 10),
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
                    width: 58,
                    height: 58,
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.10,
                      ),
                      shape:
                      BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withValues(
                          alpha: 0.13,
                        ),
                      ),
                    ),
                    child:
                    const Center(
                      child: Text(
                        '♥',
                        style: TextStyle(
                          fontSize: 27,
                          color:
                          Color(
                            0xFFE8B4B8,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.08,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        999,
                      ),
                      border: Border.all(
                        color: Colors.white
                            .withValues(
                          alpha: 0.10,
                        ),
                      ),
                    ),
                    child: Text(
                      'VERSION ${widget.version}',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        letterSpacing: 1.1,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white
                            .withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Text(
                'MADE FOR TWO',
                style: AppTextTheme
                    .labelSmall
                    .copyWith(
                  fontSize: 9,
                  letterSpacing: 2,
                  fontWeight:
                  FontWeight.w600,
                  color: const Color(
                    0xFFE8B4B8,
                  ),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'SIMI ❤️',
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 32,
                  fontWeight:
                  FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'A little space for your story, '
                    'your memories, and all the '
                    'things that belong to just you two.',
                style: AppTextTheme.bodyMedium
                    .copyWith(
                  fontSize: 11,
                  height: 1.55,
                  color: Colors.white
                      .withValues(
                    alpha: 0.70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // OUR STORY
  // ===========================================================================

  Widget _buildStorySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.08,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _SectionLabel(
              text: 'WHY SIMI EXISTS',
            ),

            const SizedBox(height: 11),

            Text(
              'Because some things '
                  'deserve their own little world.',
              style: GoogleFonts
                  .playfairDisplay(
                fontSize: 23,
                height: 1.25,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              'SIMI was created to give couples '
                  'a private place to keep the moments '
                  'that make their relationship theirs.',
              style: AppTextTheme.bodyMedium
                  .copyWith(
                fontSize: 11,
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
  // MADE FOR TWO
  // ===========================================================================

  Widget _buildMadeForTwo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.14,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.82),
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color: AppColors
                  .outlineVariant
                  .withValues(alpha: 0.48),
            ),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_outline_rounded,
                  size: 19,
                  color:
                  AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JUST THE TWO OF YOU',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        letterSpacing:
                        1.5,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'SIMI is built around one relationship.',
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w600,
                        color: AppColors
                            .textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'No followers. No audience. '
                          'No public profiles. Just your shared space.',
                      style: AppTextTheme
                          .bodyMedium
                          .copyWith(
                        fontSize: 10,
                        height: 1.5,
                        color: AppColors
                            .textSecondary,
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
  // WHAT SIMI KEEPS
  // ===========================================================================

  Widget _buildWhatSimiKeeps() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.20,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              text: 'YOUR LITTLE WORLD',
            ),

            const SizedBox(height: 7),

            Text(
              'The things that make it yours.',
              style: GoogleFonts
                  .playfairDisplay(
                fontSize: 21,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            _FeatureRow(
              icon: Icons.photo_library_outlined,
              title: 'Memories',
              subtitle:
              'Keep the moments you never want to lose.',
            ),

            const SizedBox(height: 9),

            _FeatureRow(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Love Chat',
              subtitle:
              'Private conversations, just between you.',
            ),

            const SizedBox(height: 9),

            _FeatureRow(
              icon: Icons.calendar_month_outlined,
              title: 'Special Dates',
              subtitle:
              'Remember the days that started everything.',
            ),

            const SizedBox(height: 9),

            _FeatureRow(
              icon: Icons.mail_outline_rounded,
              title: 'Future Messages',
              subtitle:
              'Leave little pieces of today for tomorrow.',
            ),

            const SizedBox(height: 9),

            _FeatureRow(
              icon: Icons.auto_awesome_outlined,
              title: 'SIMI Surprises',
              subtitle:
              'Little things SIMI notices about you two.',
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
        30,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.27,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(19),
          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E2829),
                Color(0xFF493638),
              ],
            ),
            borderRadius:
            BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.09,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child:
                    const Icon(
                      Icons
                          .lock_outline_rounded,
                      size: 19,
                      color: Color(
                        0xFFE8B4B8,
                      ),
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Text(
                      'YOUR SPACE STAYS YOURS',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 9,
                        letterSpacing:
                        1.5,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white
                            .withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                'Private by design.',
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'SIMI is designed around the idea '
                    'that your relationship should have '
                    'a space that belongs only to you two.',
                style: AppTextTheme.bodyMedium
                    .copyWith(
                  fontSize: 10.5,
                  height: 1.55,
                  color: Colors.white
                      .withValues(
                    alpha: 0.68,
                  ),
                ),
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  _PrivacyPill(
                    icon:
                    Icons.lock_outline_rounded,
                    label: 'Private',
                  ),
                  const SizedBox(width: 7),
                  _PrivacyPill(
                    icon:
                    Icons.favorite_border_rounded,
                    label: 'Just yours',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // LINKS
  // ===========================================================================

  Widget _buildLinksSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.34,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              text: 'MORE ABOUT SIMI',
            ),

            const SizedBox(height: 11),

            _LinkTile(
              icon:
              Icons.privacy_tip_outlined,
              title: 'Privacy',
              subtitle:
              'How SIMI handles your private space.',
              onTap: widget.onPrivacy,
            ),

            const SizedBox(height: 9),

            _LinkTile(
              icon:
              Icons.description_outlined,
              title: 'Terms of Use',
              subtitle:
              'The rules for using SIMI.',
              onTap: widget.onTerms,
            ),

            const SizedBox(height: 9),

            _LinkTile(
              icon:
              Icons.chat_bubble_outline_rounded,
              title: 'Send Feedback',
              subtitle:
              'Tell us what would make SIMI better.',
              onTap: widget.onFeedback,
            ),

            const SizedBox(height: 9),

            _LinkTile(
              icon:
              Icons.menu_book_outlined,
              title: 'Open Source Licenses',
              subtitle:
              'Libraries that help power SIMI.',
              onTap: widget.onLicenses,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // VERSION
  // ===========================================================================

  Widget _buildVersion() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'SIMI',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version ${widget.version} · Build ${widget.buildNumber}',
              style: AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 9,
                color:
                AppColors.textDisabled,
              ),
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
        20,
        20,
        20,
        0,
      ),
      child: Column(
        children: [
          Text(
            'Made with love for people who choose each other.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color:
              AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Text(
                'SIMI',
                style: AppTextTheme
                    .labelSmall
                    .copyWith(
                  fontSize: 8,
                  letterSpacing: 1.5,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textDisabled,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '♥',
                style: TextStyle(
                  fontSize: 9,
                  color:
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'JUST BETWEEN US',
                style: AppTextTheme
                    .labelSmall
                    .copyWith(
                  fontSize: 8,
                  letterSpacing: 1.3,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// FEATURE ROW
// =============================================================================

class _FeatureRow
    extends StatelessWidget {
  const _FeatureRow({
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
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.72),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors
              .outlineVariant
              .withValues(alpha: 0.42),
        ),
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
              size: 17,
              color:
              AppColors.primary,
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
                  style: AppTextTheme
                      .labelLarge
                      .copyWith(
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w600,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: AppTextTheme
                      .labelSmall
                      .copyWith(
                    fontSize: 9,
                    height: 1.35,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// LINK TILE
// =============================================================================

class _LinkTile
    extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.78),
          borderRadius:
          BorderRadius.circular(19),
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration:
              const BoxDecoration(
                color: Color(0xFFF5F1F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 17,
                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    title,
                    style: AppTextTheme
                        .labelLarge
                        .copyWith(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w600,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
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

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              size: 11,
              color:
              AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVACY PILL
// =============================================================================

class _PrivacyPill
    extends StatelessWidget {
  const _PrivacyPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.08),
        borderRadius:
        BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color:
            const Color(0xFFE8B4B8),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextTheme
                .labelSmall
                .copyWith(
              fontSize: 8,
              color: Colors.white
                  .withValues(
                alpha: 0.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel
    extends StatelessWidget {
  const _SectionLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        letterSpacing: 1.8,
        fontWeight:
        FontWeight.w600,
        color:
        AppColors.textSecondary,
      ),
    );
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton
    extends StatelessWidget {
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
          color: Colors.white
              .withValues(alpha: 0.78),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color:
          AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _AboutBackground
    extends StatelessWidget {
  const _AboutBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -110,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.07,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 580,
          left: -130,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF6B6D91,
                ).withValues(
                  alpha: 0.035,
                ),
                shape:
                BoxShape.circle,
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

class _AnimatedEntry
    extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.begin,
    required this.child,
  });

  final AnimationController controller;
  final double begin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation =
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        begin,
        (begin + 0.38).clamp(
          0.0,
          1.0,
        ),
        curve:
        Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (
          context,
          child,
          ) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 *
                  (1 -
                      animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}