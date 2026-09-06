import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({
    super.key,
    this.lastUpdated = 'September 7, 2026',
    this.onBack,
    this.onPrivacy,
    this.onContact,
  });

  final String lastUpdated;

  final VoidCallback? onBack;
  final VoidCallback? onPrivacy;
  final VoidCallback? onContact;

  @override
  State<TermsOfServiceScreen> createState() =>
      _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState
    extends State<TermsOfServiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
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
            child: _TermsBackground(),
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
                _buildIntroduction(),
                _buildSection(
                  number: '01',
                  title: 'Acceptance of Terms',
                  child: _acceptanceContent(),
                  delay: 0.13,
                ),
                _buildSection(
                  number: '02',
                  title: 'Using SIMI',
                  child: _usingSimiContent(),
                  delay: 0.18,
                ),
                _buildSection(
                  number: '03',
                  title: 'Your Account',
                  child: _accountContent(),
                  delay: 0.23,
                ),
                _buildSection(
                  number: '04',
                  title: 'Your Content',
                  child: _contentContent(),
                  delay: 0.28,
                ),
                _buildPrivateContent(),
                _buildSection(
                  number: '05',
                  title: 'SIMI Insights',
                  child: _insightsContent(),
                  delay: 0.33,
                ),
                _buildSection(
                  number: '06',
                  title: 'Notifications',
                  child: _notificationsContent(),
                  delay: 0.38,
                ),
                _buildSection(
                  number: '07',
                  title: 'Acceptable Use',
                  child: _acceptableUseContent(),
                  delay: 0.43,
                ),
                _buildSection(
                  number: '08',
                  title: 'Data & Deletion',
                  child: _dataContent(),
                  delay: 0.48,
                ),
                _buildSection(
                  number: '09',
                  title: 'Changes to SIMI',
                  child: _changesContent(),
                  delay: 0.53,
                ),
                _buildSection(
                  number: '10',
                  title: 'Disclaimer',
                  child: _disclaimerContent(),
                  delay: 0.58,
                ),
                _buildContactCard(),
                _buildPrivacyLink(),
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
                  'ABOUT SIMI',
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
                  'Terms of Service',
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
              color: Color(0xFFF5F1F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 17,
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
            23,
            22,
            24,
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
                blurRadius: 24,
                offset:
                const Offset(0, 9),
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
                    width: 52,
                    height: 52,
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.09,
                      ),
                      shape:
                      BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child:
                    const Icon(
                      Icons
                          .description_outlined,
                      size: 22,
                      color: Color(
                        0xFFE8B4B8,
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
                    ),
                    child: Text(
                      'LEGAL',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        letterSpacing: 1.3,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white
                            .withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 23),

              Text(
                'TERMS OF SERVICE',
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
                'The little rules.',
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 29,
                  fontWeight:
                  FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'A simple guide to using SIMI '
                    'and keeping your little world safe.',
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

              const SizedBox(height: 17),

              Row(
                children: [
                  const Icon(
                    Icons.update_rounded,
                    size: 12,
                    color: Color(
                      0xFFE8B4B8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Last updated ${widget.lastUpdated}',
                    style: AppTextTheme
                        .labelSmall
                        .copyWith(
                      fontSize: 8.5,
                      color: Colors.white
                          .withValues(
                        alpha: 0.55,
                      ),
                    ),
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
  // INTRO
  // ===========================================================================

  Widget _buildIntroduction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.07,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'A QUICK NOTE',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight:
                FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              'SIMI is a private space built for two.',
              style: GoogleFonts
                  .playfairDisplay(
                fontSize: 21,
                height: 1.25,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'By using SIMI, you agree to these '
                  'terms. They are here to make sure '
                  'everyone can use the app safely '
                  'and understand what SIMI provides.',
              style: AppTextTheme.bodyMedium
                  .copyWith(
                fontSize: 10.5,
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
  // GENERIC SECTION
  // ===========================================================================

  Widget _buildSection({
    required String number,
    required String title,
    required Widget child,
    required double delay,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: delay,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 29,
                  height: 29,
                  decoration:
                  const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts
                        .playfairDisplay(
                      fontSize: 19,
                      fontWeight:
                      FontWeight.w600,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            child,
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION CONTENT
  // ===========================================================================

  Widget _acceptanceContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'By creating an account or using SIMI, '
              'you agree to these Terms of Service '
              'and any policies referenced here.',
        ),
        _paragraph(
          'If you do not agree with these terms, '
              'please do not use SIMI.',
        ),
      ],
    );
  }

  Widget _usingSimiContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'SIMI provides private relationship '
              'features including memories, private '
              'conversations, special dates, future '
              'messages, mood journaling and other '
              'personal tools.',
        ),
        _paragraph(
          'Features may change, improve, be '
              'temporarily unavailable, or be removed '
              'as SIMI evolves.',
        ),
      ],
    );
  }

  Widget _accountContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'You are responsible for maintaining '
              'the security of your account and any '
              'authentication information associated '
              'with it.',
        ),
        _paragraph(
          'Please do not share your password, PIN '
              'or other access credentials with anyone '
              'you do not trust.',
        ),
        _paragraph(
          'You are responsible for activity that '
              'occurs through your account.',
        ),
      ],
    );
  }

  Widget _contentContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'You retain ownership of the photos, '
              'messages, memories, notes and other '
              'content you add to SIMI.',
        ),
        _paragraph(
          'You are responsible for making sure '
              'you have the right to upload or share '
              'content through the app.',
        ),
        _paragraph(
          'You grant SIMI only the permissions '
              'reasonably necessary to provide the '
              'features you choose to use.',
        ),
      ],
    );
  }

  // ===========================================================================
  // PRIVATE CONTENT
  // ===========================================================================

  Widget _buildPrivateContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.31,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(18),
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
            BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.08,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child:
                    const Icon(
                      Icons
                          .lock_outline_rounded,
                      size: 18,
                      color: Color(
                        0xFFE8B4B8,
                      ),
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Text(
                      'PRIVATE CONTENT',
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
                          alpha: 0.60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                'Some things are meant to stay between you two.',
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Features such as Private Vault are '
                    'designed to give you additional '
                    'privacy controls. You are still '
                    'responsible for protecting your '
                    'device and account credentials.',
                style: AppTextTheme.bodyMedium
                    .copyWith(
                  fontSize: 10,
                  height: 1.55,
                  color: Colors.white
                      .withValues(
                    alpha: 0.67,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _insightsContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'Some SIMI features may analyze '
              'information you have entered or saved '
              'in order to provide personalized '
              'experiences and insights.',
        ),
        _paragraph(
          'SIMI insights are intended for '
              'entertainment, reflection and personal '
              'organization. They should not be '
              'treated as professional medical, '
              'financial or other expert advice.',
        ),
      ],
    );
  }

  Widget _notificationsContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'SIMI may send notifications when you '
              'enable them, including reminders, '
              'future-message alerts, special-date '
              'reminders and other app activity.',
        ),
        _paragraph(
          'You can control available notification '
              'settings through the app and your '
              'device settings.',
        ),
      ],
    );
  }

  Widget _acceptableUseContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'You agree not to use SIMI to break '
              'the law, harm another person, interfere '
              'with the service, or attempt to gain '
              'unauthorized access to another account.',
        ),
        _paragraph(
          'You must not use SIMI to distribute '
              'malware, abuse the service, impersonate '
              'others, or upload content that you do '
              'not have permission to use.',
        ),
      ],
    );
  }

  Widget _dataContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'You may have tools available in SIMI '
              'to manage or delete your account and '
              'personal content.',
        ),
        _paragraph(
          'Deletion may be permanent and some '
              'information may not be recoverable '
              'after it has been removed.',
        ),
        _paragraph(
          'Where applicable, certain information '
              'may need to be retained for legitimate '
              'legal, security or operational reasons.',
        ),
      ],
    );
  }

  Widget _changesContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'SIMI may be updated from time to time. '
              'We may add, change, suspend or remove '
              'features as the service develops.',
        ),
        _paragraph(
          'If these terms change materially, the '
              'updated version will be made available '
              'through the app or another appropriate '
              'channel.',
        ),
      ],
    );
  }

  Widget _disclaimerContent() {
    return _LegalCard(
      children: [
        _paragraph(
          'SIMI is provided on an availability '
              'basis and we do not guarantee that '
              'the service will always be uninterrupted '
              'or error-free.',
        ),
        _paragraph(
          'SIMI is a relationship and personal '
              'organization application. It is not a '
              'replacement for professional advice '
              'or emergency services.',
        ),
      ],
    );
  }

  // ===========================================================================
  // CONTACT
  // ===========================================================================

  Widget _buildContactCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.63,
        child: GestureDetector(
          onTap: widget.onContact,
          child: Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.82),
              borderRadius:
              BorderRadius.circular(22),
              border: Border.all(
                color: AppColors
                    .outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration:
                  const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child:
                  const Icon(
                    Icons
                        .mail_outline_rounded,
                    size: 19,
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
                        'Questions?',
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
                        height: 3,
                      ),
                      Text(
                        'Get in touch with the SIMI team.',
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
                  AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PRIVACY LINK
  // ===========================================================================

  Widget _buildPrivacyLink() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        19,
        20,
        0,
      ),
      child: GestureDetector(
        onTap: widget.onPrivacy,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: const Color(
              0xFFF5F1F0,
            ),
            borderRadius:
            BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              const Icon(
                Icons
                    .privacy_tip_outlined,
                size: 16,
                color:
                AppColors.primary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Read our Privacy Policy',
                  style: AppTextTheme
                      .labelLarge
                      .copyWith(
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons
                    .arrow_forward_rounded,
                size: 15,
                color:
                AppColors.primary,
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
        0,
      ),
      child: Column(
        children: [
          Text(
            'By continuing to use SIMI, '
                'you agree to these terms.',
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall
                .copyWith(
              fontSize: 9,
              height: 1.45,
              color:
              AppColors.textDisabled,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'SIMI',
            style:
            GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight:
              FontWeight.w600,
              color:
              AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Text(
                'MADE FOR TWO',
                style: AppTextTheme
                    .labelSmall
                    .copyWith(
                  fontSize: 7.5,
                  letterSpacing: 1.4,
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
                  fontSize: 7.5,
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

  // ===========================================================================
  // PARAGRAPH
  // ===========================================================================

  Widget _paragraph(String text) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 11,
      ),
      child: Text(
        text,
        style:
        AppTextTheme.bodyMedium.copyWith(
          fontSize: 10.5,
          height: 1.58,
          color:
          AppColors.textSecondary,
        ),
      ),
    );
  }
}

// =============================================================================
// LEGAL CARD
// =============================================================================

class _LegalCard extends StatelessWidget {
  const _LegalCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        5,
      ),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.76),
        borderRadius:
        BorderRadius.circular(21),
        border: Border.all(
          color: AppColors
              .outlineVariant
              .withValues(alpha: 0.42),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: children,
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

class _TermsBackground
    extends StatelessWidget {
  const _TermsBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -120,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.055,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 670,
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
                  alpha: 0.03,
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
        (begin + 0.34).clamp(
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
              13 *
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