import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({
    super.key,
    this.appVersion = '1.0.0',
    this.onBack,
    this.onContactSupport,
    this.onReportProblem,
    this.onSendFeedback,
  });

  final String appVersion;

  final VoidCallback? onBack;
  final VoidCallback? onContactSupport;
  final VoidCallback? onReportProblem;
  final VoidCallback? onSendFeedback;

  @override
  State<HelpSupportScreen> createState() =>
      _HelpSupportScreenState();
}

class _HelpSupportScreenState
    extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      category: 'Getting Started',
      question: 'How do I get started with SIMI?',
      answer:
      'SIMI is designed for two people. Start by completing your profile and relationship details, then explore Memories, Love Chat, Special Dates and the other spaces created for your relationship.',
    ),
    _FaqItem(
      category: 'Account',
      question: 'How do I change my profile?',
      answer:
      'Open Settings, tap your profile and choose Edit Profile. You can update your name, photo, birthday and other available profile information from there.',
    ),
    _FaqItem(
      category: 'Memories',
      question: 'How do I add a memory?',
      answer:
      'Open Memories and tap the add button. You can add photos, a title, your story, location, date, tags and a collection for the memory.',
    ),
    _FaqItem(
      category: 'Memories',
      question: 'Can I organize memories into collections?',
      answer:
      'Yes. Collections give your memories their own little homes. You can create collections such as Trips, Celebrations, Anniversaries or anything that feels meaningful to you.',
    ),
    _FaqItem(
      category: 'Love Chat',
      question: 'What is Love Chat?',
      answer:
      'Love Chat gives you private conversations organized around different topics. You can create conversations for things like your future, late-night thoughts, dreams and memories.',
    ),
    _FaqItem(
      category: 'Special Dates',
      question: 'How do Special Dates work?',
      answer:
      'Special Dates lets you save meaningful moments such as your anniversary, first date, first meeting or another date that matters to both of you. You can also enable reminders and yearly repetition.',
    ),
    _FaqItem(
      category: 'Future Messages',
      question: 'What are Future Messages?',
      answer:
      'Future Messages are little notes you write now and choose to open later. You can attach photos or a voice note and seal the message until the date you choose.',
    ),
    _FaqItem(
      category: 'Gift Wishes',
      question: 'What are Gift Wishes?',
      answer:
      'Gift Wishes lets you quietly keep track of things you would love, things your partner might like, and experiences you want to remember for the right moment.',
    ),
    _FaqItem(
      category: 'Private Vault',
      question: 'What is Private Vault?',
      answer:
      'Private Vault is a protected space for intimate SIMI content. It can contain private memories, private conversations, special dates, future messages, photos and videos.',
    ),
    _FaqItem(
      category: 'Period & Mood',
      question: 'Can I manage my period and moods in SIMI?',
      answer:
      'SIMI includes personal tools for tracking your cycle and recording moods. These features are designed for personal organization and reflection and are not a replacement for professional medical advice.',
    ),
    _FaqItem(
      category: 'Privacy',
      question: 'How can I protect my private content?',
      answer:
      'Use the privacy and security settings available in SIMI and keep your device, account credentials and any vault authentication information secure.',
    ),
    _FaqItem(
      category: 'Troubleshooting',
      question: 'Something is not working. What should I do?',
      answer:
      'First try closing and reopening SIMI and make sure you are using the latest available version. If the problem continues, contact support and tell us what happened, what you were doing and which screen was affected.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _searchController.addListener(
      _onSearchChanged,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery =
          _searchController.text.trim().toLowerCase();
    });
  }

  List<_FaqItem> get _filteredFaqs {
    if (_searchQuery.isEmpty) {
      return _faqs;
    }

    return _faqs.where((faq) {
      return faq.question
          .toLowerCase()
          .contains(_searchQuery) ||
          faq.answer
              .toLowerCase()
              .contains(_searchQuery) ||
          faq.category
              .toLowerCase()
              .contains(_searchQuery);
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _SupportBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 135,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildSearch(),
                _buildQuickHelp(),
                _buildFaqHeader(faqs),
                if (faqs.isEmpty)
                  _buildNoResults()
                else
                  ...List.generate(
                    faqs.length,
                        (index) {
                      return _buildFaqCard(
                        faqs[index],
                        index,
                      );
                    },
                  ),
                _buildStillNeedHelp(),
                _buildSupportFooter(),
              ],
            ),
          ),

          _buildBottomAction(),
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
                  'Help & Support',
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
            child: const Icon(
              Icons.support_agent_outlined,
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
                          .favorite_border_rounded,
                      size: 23,
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
                      'WE\'RE HERE',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8,
                        letterSpacing: 1.4,
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

              const SizedBox(height: 22),

              Text(
                'HELP & SUPPORT',
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
                'We\'ve got you.',
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
                'Find an answer, learn how something '
                    'works, or reach out when you need us.',
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
  // SEARCH
  // ===========================================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.08,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.82),
            borderRadius:
            BorderRadius.circular(19),
            border: Border.all(
              color: AppColors
                  .outlineVariant
                  .withValues(alpha: 0.48),
            ),
          ),
          child: TextField(
            controller:
            _searchController,
            textInputAction:
            TextInputAction.search,
            style: AppTextTheme.bodyMedium
                .copyWith(
              fontSize: 11,
              color:
              AppColors.textPrimary,
            ),
            decoration:
            InputDecoration(
              prefixIcon:
              const Icon(
                Icons.search_rounded,
                size: 19,
                color:
                AppColors.primary,
              ),
              suffixIcon:
              _searchQuery.isEmpty
                  ? null
                  : GestureDetector(
                onTap: _clearSearch,
                child: const Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: AppColors
                      .textSecondary,
                ),
              ),
              hintText:
              'Search for help...',
              hintStyle:
              AppTextTheme.bodyMedium
                  .copyWith(
                fontSize: 10.5,
                color:
                AppColors.textDisabled,
              ),
              border:
              InputBorder.none,
              contentPadding:
              const EdgeInsets
                  .symmetric(
                horizontal: 10,
                vertical: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // QUICK HELP
  // ===========================================================================

  Widget _buildQuickHelp() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.13,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              text: 'QUICK HELP',
            ),

            const SizedBox(height: 11),

            Row(
              children: [
                Expanded(
                  child: _QuickHelpCard(
                    icon:
                    Icons.play_circle_outline_rounded,
                    title: 'Getting started',
                    subtitle: 'New to SIMI?',
                    onTap: () {
                      _showGettingStarted();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickHelpCard(
                    icon:
                    Icons.security_outlined,
                    title: 'Privacy',
                    subtitle: 'Keep things safe',
                    onTap: () {
                      _showPrivacyHelp();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // FAQ HEADER
  // ===========================================================================

  Widget _buildFaqHeader(
      List<_FaqItem> faqs,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        10,
      ),
      child: Row(
        children: [
          const Expanded(
            child: _SectionLabel(
              text: 'FREQUENTLY ASKED',
            ),
          ),
          Text(
            '${faqs.length} ${faqs.length == 1 ? 'answer' : 'answers'}',
            style: AppTextTheme.labelSmall
                .copyWith(
              fontSize: 8.5,
              color:
              AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FAQ CARD
  // ===========================================================================

  Widget _buildFaqCard(
      _FaqItem faq,
      int index,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        9,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin:
        (0.18 + index * 0.035)
            .clamp(0.0, 0.68),
        child: _FaqCard(
          faq: faq,
        ),
      ),
    );
  }

  // ===========================================================================
  // NO RESULTS
  // ===========================================================================

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.76),
          borderRadius:
          BorderRadius.circular(22),
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration:
              const BoxDecoration(
                color: Color(0xFFF5F1F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 23,
                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(height: 13),

            Text(
              'Nothing here yet.',
              style: GoogleFonts
                  .playfairDisplay(
                fontSize: 19,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Try another search or talk to us directly.',
              textAlign: TextAlign.center,
              style: AppTextTheme
                  .labelSmall
                  .copyWith(
                fontSize: 9,
                height: 1.45,
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
  // STILL NEED HELP
  // ===========================================================================

  Widget _buildStillNeedHelp() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.60,
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
                Color(0xFFFCE4EC),
                Color(0xFFF8EDEB),
              ],
            ),
            borderRadius:
            BorderRadius.circular(23),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child:
                const Icon(
                  Icons
                      .support_agent_rounded,
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
                      'Still need help?',
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w600,
                        color: AppColors
                            .textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'That\'s okay. Send us a message '
                          'and we\'ll help you figure it out.',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 9.5,
                        height: 1.45,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),

                    const SizedBox(height: 13),

                    GestureDetector(
                      onTap: widget
                          .onContactSupport,
                      child: Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .primary,
                          borderRadius:
                          BorderRadius
                              .circular(
                            999,
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons
                                  .mail_outline_rounded,
                              size: 14,
                              color:
                              Colors.white,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              'Contact support',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                Colors.white,
                              ),
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
      ),
    );
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildSupportFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap:
            widget.onReportProblem,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons
                      .bug_report_outlined,
                  size: 14,
                  color:
                  AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Report a problem',
                  style: AppTextTheme
                      .labelSmall
                      .copyWith(
                    fontSize: 9,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),

          Text(
            'SIMI ${widget.appVersion}',
            style: AppTextTheme.labelSmall
                .copyWith(
              fontSize: 8,
              color:
              AppColors.textDisabled,
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
  // BOTTOM ACTION
  // ===========================================================================

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 540,
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: GestureDetector(
                onTap:
                widget.onSendFeedback,
                child: Container(
                  height: 58,
                  decoration:
                  BoxDecoration(
                    gradient:
                    const LinearGradient(
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color(0xFF765457),
                        Color(0xFF966E72),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      29,
                    ),
                    border: Border.all(
                      color: Colors.white
                          .withValues(
                        alpha: 0.14,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.22,
                        ),
                        blurRadius: 20,
                        offset:
                        const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),

                      Container(
                        width: 46,
                        height: 46,
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.13,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child:
                        const Icon(
                          Icons
                              .chat_bubble_outline_rounded,
                          size: 20,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 13,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              'Couldn\'t find it?',
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Send us a message',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors
                                    .white
                                    .withValues(
                                  alpha: 0.68,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 42,
                        height: 42,
                        margin:
                        const EdgeInsets
                            .only(
                          right: 4,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.11,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child:
                        const Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 19,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // QUICK HELP SHEETS
  // ===========================================================================

  void _showGettingStarted() {
    _showInfoSheet(
      title: 'Getting started',
      subtitle: 'A tiny tour of SIMI.',
      icon: Icons.play_circle_outline_rounded,
      children: const [
        _InfoStep(
          number: '01',
          title: 'Complete your space',
          text:
          'Set up your profile and relationship so SIMI feels like yours.',
        ),
        _InfoStep(
          number: '02',
          title: 'Keep your moments',
          text:
          'Start with a memory, special date or little wish.',
        ),
        _InfoStep(
          number: '03',
          title: 'Make it yours',
          text:
          'Explore the private spaces and settings that fit your relationship.',
        ),
      ],
    );
  }

  void _showPrivacyHelp() {
    _showInfoSheet(
      title: 'Keeping SIMI private',
      subtitle: 'A few simple things matter.',
      icon: Icons.security_outlined,
      children: const [
        _InfoStep(
          number: '01',
          title: 'Protect your account',
          text:
          'Use a strong password and keep your authentication details private.',
        ),
        _InfoStep(
          number: '02',
          title: 'Use Private Vault',
          text:
          'Keep intimate SIMI content in the protected space when appropriate.',
        ),
        _InfoStep(
          number: '03',
          title: 'Check privacy settings',
          text:
          'Review previews, notifications and other privacy controls from Settings.',
        ),
      ],
    );
  }

  void _showInfoSheet({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          constraints:
          const BoxConstraints(
            maxHeight: 620,
          ),
          padding:
          const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: SingleChildScrollView(
            physics:
            const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                const _SheetHandle(),

                const SizedBox(height: 21),

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFFFCE4EC),
                        shape:
                        BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 22,
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
                            title,
                            style: GoogleFonts
                                .playfairDisplay(
                              fontSize: 23,
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
                  ],
                ),

                const SizedBox(height: 20),

                ...children,

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(
                        sheetContext,
                      ).pop();
                    },
                    child: Container(
                      decoration:
                      BoxDecoration(
                        color:
                        AppColors.primary,
                        borderRadius:
                        BorderRadius
                            .circular(
                          26,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Got it',
                          style: AppTextTheme
                              .labelLarge
                              .copyWith(
                            fontSize: 11,
                            color:
                            Colors.white,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
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
}

// =============================================================================
// FAQ MODEL
// =============================================================================

class _FaqItem {
  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });

  final String category;
  final String question;
  final String answer;
}

// =============================================================================
// FAQ CARD
// =============================================================================

class _FaqCard extends StatefulWidget {
  const _FaqCard({
    required this.faq,
  });

  final _FaqItem faq;

  @override
  State<_FaqCard> createState() =>
      _FaqCardState();
}

class _FaqCardState
    extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(
          alpha: _expanded
              ? 0.92
              : 0.76,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: _expanded
              ? AppColors.primary
              .withValues(
            alpha: 0.22,
          )
              : AppColors
              .outlineVariant
              .withValues(
            alpha: 0.43,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
        borderRadius:
        BorderRadius.circular(20),
        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(
            15,
            14,
            13,
            14,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration:
                    const BoxDecoration(
                      color:
                      Color(0xFFFCE4EC),
                      shape:
                      BoxShape.circle,
                    ),
                    child:
                    const Icon(
                      Icons
                          .question_mark_rounded,
                      size: 15,
                      color:
                      AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          widget.faq.category
                              .toUpperCase(),
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 7.5,
                            letterSpacing:
                            1.1,
                            fontWeight:
                            FontWeight.w600,
                            color: AppColors
                                .primary,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.faq.question,
                          style: AppTextTheme
                              .labelLarge
                              .copyWith(
                            fontSize: 11,
                            height: 1.35,
                            fontWeight:
                            FontWeight.w600,
                            color: AppColors
                                .textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  AnimatedRotation(
                    turns:
                    _expanded ? 0.5 : 0,
                    duration:
                    const Duration(
                      milliseconds: 200,
                    ),
                    child:
                    const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      size: 19,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                ],
              ),

              AnimatedCrossFade(
                duration:
                const Duration(
                  milliseconds: 180,
                ),
                crossFadeState:
                _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild:
                const SizedBox.shrink(),
                secondChild: Padding(
                  padding:
                  const EdgeInsets
                      .fromLTRB(
                    42,
                    11,
                    8,
                    2,
                  ),
                  child: Text(
                    widget.faq.answer,
                    style: AppTextTheme
                        .bodyMedium
                        .copyWith(
                      fontSize: 10,
                      height: 1.58,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// QUICK HELP CARD
// =============================================================================

class _QuickHelpCard
    extends StatelessWidget {
  const _QuickHelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.78),
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.44),
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
                size: 18,
                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: AppTextTheme
                        .labelLarge
                        .copyWith(
                      fontSize: 10,
                      fontWeight:
                      FontWeight.w600,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: AppTextTheme
                        .labelSmall
                        .copyWith(
                      fontSize: 8.5,
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
    );
  }
}

// =============================================================================
// INFO STEP
// =============================================================================

class _InfoStep
    extends StatelessWidget {
  const _InfoStep({
    required this.number,
    required this.title,
    required this.text,
  });

  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 9,
      ),
      padding:
      const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.72),
        borderRadius:
        BorderRadius.circular(17),
        border: Border.all(
          color: AppColors
              .outlineVariant
              .withValues(alpha: 0.38),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
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
                  fontSize: 7.5,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

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
                    fontSize: 10.5,
                    fontWeight:
                    FontWeight.w600,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppTextTheme
                      .labelSmall
                      .copyWith(
                    fontSize: 9,
                    height: 1.45,
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
// SHEET HANDLE
// =============================================================================

class _SheetHandle
    extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors
            .outlineVariant
            .withValues(alpha: 0.7),
        borderRadius:
        BorderRadius.circular(999),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _SupportBackground
    extends StatelessWidget {
  const _SupportBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 110,
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
          top: 700,
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