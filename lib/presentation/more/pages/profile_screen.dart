import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.name = 'Saif',
    this.partnerName = 'Love',
    this.initial = 'S',
    this.bio = 'A little corner of the world, just for us.',
    this.relationshipLabel = 'Together',
    this.relationshipStartDate,
    this.city = '',
    this.favoriteMemory = 'Our first trip together',
    this.memoriesCount = 24,
    this.specialDatesCount = 6,
    this.giftWishesCount = 8,
    this.photosCount = 42,
    this.profileImage,
    this.onBack,
    this.onEditProfile,
    this.onChangePhoto,
    this.onRelationshipTap,
  });

  final String name;
  final String partnerName;
  final String initial;
  final String bio;
  final String relationshipLabel;
  final DateTime? relationshipStartDate;
  final String city;
  final String favoriteMemory;

  final int memoriesCount;
  final int specialDatesCount;
  final int giftWishesCount;
  final int photosCount;

  final ImageProvider? profileImage;

  final VoidCallback? onBack;
  final VoidCallback? onEditProfile;
  final VoidCallback? onChangePhoto;
  final VoidCallback? onRelationshipTap;

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
            child: _ProfileBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 125,
              ),
              children: [
                _buildTopBar(context),
                _buildProfileHero(),
                _buildStoryStats(),
                _buildAboutSection(),
                _buildRelationshipSection(),
                _buildPersonalSection(),
                _buildPrivacyCard(),
                _buildFooter(),
              ],
            ),
          ),

          _buildBottomAction(context),
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
                  'Your Profile',
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
          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: () {
              _showProfileOptions(context);
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PROFILE HERO
  // ===========================================================================

  Widget _buildProfileHero() {
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
            20,
            24,
            20,
            23,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF332A2B),
                Color(0xFF5A4144),
                Color(0xFF765457),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
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
            children: [
              _buildAvatar(),
              const SizedBox(height: 15),

              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    widget.relationshipLabel,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: Colors.white
                          .withValues(alpha: 0.62),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 4,
                    height: 4,
                    decoration:
                    const BoxDecoration(
                      color: Color(0xFFE8B4B8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    widget.partnerName,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: Colors.white
                          .withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 17),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  widget.bio,
                  textAlign: TextAlign.center,
                  style:
                  AppTextTheme.bodyMedium.copyWith(
                    fontSize: 11,
                    height: 1.5,
                    color: Colors.white
                        .withValues(alpha: 0.72),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.09),
                  borderRadius:
                  BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 12,
                      color: Color(0xFFE8B4B8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'PRIVATE PROFILE',
                      style: AppTextTheme
                          .labelSmall.copyWith(
                        fontSize: 8,
                        letterSpacing: 1.2,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white
                            .withValues(alpha: 0.72),
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
  // AVATAR
  // ===========================================================================

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: widget.onChangePhoto,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 94,
            height: 94,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: widget.profileImage != null
                  ? Image(
                image: widget.profileImage!,
                fit: BoxFit.cover,
              )
                  : Container(
                decoration:
                const BoxDecoration(
                  gradient:
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8B4B8),
                      Color(0xFF9A7477),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.initial
                        .toUpperCase(),
                    style: GoogleFonts
                        .playfairDisplay(
                      fontSize: 36,
                      fontWeight:
                      FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: -2,
            bottom: 2,
            child: Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF5A4144),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 13,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STORY STATS
  // ===========================================================================

  Widget _buildStoryStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.08,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.82),
            borderRadius:
            BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.48),
            ),
          ),
          child: Row(
            children: [
              _StoryStat(
                value: widget.memoriesCount,
                label: 'Memories',
              ),
              _StatDivider(),
              _StoryStat(
                value: widget.specialDatesCount,
                label: 'Special dates',
              ),
              _StatDivider(),
              _StoryStat(
                value: widget.photosCount,
                label: 'Photos',
              ),
            ],
          ),
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
        delay: 0.14,
        child: _ProfileSection(
          label: 'A LITTLE ABOUT YOU',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.82),
              borderRadius:
              BorderRadius.circular(23),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration:
                  const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    widget.bio,
                    style: AppTextTheme.bodyMedium
                        .copyWith(
                      fontSize: 11,
                      height: 1.55,
                      color:
                      AppColors.textPrimary,
                    ),
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
  // RELATIONSHIP
  // ===========================================================================

  Widget _buildRelationshipSection() {
    final startDate =
        widget.relationshipStartDate;

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
        child: _ProfileSection(
          label: 'YOUR STORY',
          child: GestureDetector(
            onTap: widget.onRelationshipTap,
            child: Container(
              width: double.infinity,
              padding:
              const EdgeInsets.fromLTRB(
                17,
                16,
                15,
                16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF322F2E),
                borderRadius:
                BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.08),
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
                          Icons.favorite_rounded,
                          size: 19,
                          color:
                          Color(0xFFE8B4B8),
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
                              widget.relationshipLabel,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.partnerName,
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.52,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons
                            .arrow_forward_ios_rounded,
                        size: 11,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                  if (startDate != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.06),
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .calendar_today_outlined,
                            size: 14,
                            color:
                            Color(0xFFE8B4B8),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your story began on '
                                  '${_formatDate(startDate)}',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.64,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PERSONAL DETAILS
  // ===========================================================================

  Widget _buildPersonalSection() {
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
        child: _ProfileSection(
          label: 'PERSONAL DETAILS',
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.82),
              borderRadius:
              BorderRadius.circular(23),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Name',
                  value: widget.name,
                ),
                _DetailDivider(),
                _DetailRow(
                  icon: Icons.favorite_border_rounded,
                  label: 'Partner',
                  value: widget.partnerName,
                ),
                if (widget.city
                    .trim()
                    .isNotEmpty) ...[
                  _DetailDivider(),
                  _DetailRow(
                    icon:
                    Icons.location_on_outlined,
                    label: 'Location',
                    value: widget.city,
                  ),
                ],
                _DetailDivider(),
                _DetailRow(
                  icon: Icons
                      .auto_awesome_outlined,
                  label: 'Favorite memory',
                  value:
                  widget.favoriteMemory,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacyCard() {
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: const Color(0xFFF7EFEE),
            borderRadius:
            BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE8D6D4),
            ),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration:
                const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Just between you two.',
                      style: GoogleFonts
                          .playfairDisplay(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your profile is private and only '
                          'visible inside your SIMI space.',
                      style: AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 9,
                        height: 1.4,
                        color:
                        AppColors.textSecondary,
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
  // BOTTOM ACTION
  // ===========================================================================

  Widget _buildBottomAction(
      BuildContext context,
      ) {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 14,
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
                horizontal: 6,
              ),
              child: GestureDetector(
                onTap: widget.onEditProfile,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient:
                    const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF765457),
                        Color(0xFF966E72),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(29),
                    border: Border.all(
                      color: Colors.white
                          .withValues(alpha: 0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 12,
                        offset:
                        const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 7),
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white
                                .withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit your profile',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Make this little space feel like you',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors.white
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
                        const EdgeInsets.only(
                          right: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 2),
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
  // OPTIONS
  // ===========================================================================

  void _showProfileOptions(
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
              const SizedBox(height: 21),

              Text(
                'Your profile',
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'A few things you can do with your profile.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 19),

              _SheetAction(
                icon: Icons.edit_outlined,
                title: 'Edit profile',
                subtitle:
                'Update your personal details',
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onEditProfile?.call();
                },
              ),

              const SizedBox(height: 9),

              _SheetAction(
                icon: Icons.camera_alt_outlined,
                title: 'Change profile photo',
                subtitle:
                'Choose a new photo',
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onChangePhoto?.call();
                },
              ),

              const SizedBox(height: 9),

              _SheetAction(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle:
                'Your profile is private',
                onTap: () {
                  Navigator.pop(sheetContext);
                },
              ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // ===========================================================================
  // FOOTER
  // ===========================================================================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        32,
        30,
        8,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'This is your little corner of SIMI.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PROFILE SECTION
// =============================================================================

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 11),
        child,
      ],
    );
  }
}

// =============================================================================
// STORY STAT
// =============================================================================

class _StoryStat extends StatelessWidget {
  const _StoryStat({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: GoogleFonts.playfairDisplay(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DIVIDERS
// =============================================================================

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 29,
      color: AppColors.outlineVariant
          .withValues(alpha: 0.55),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 62,
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
// DETAIL ROW
// =============================================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
      padding: const EdgeInsets.fromLTRB(
        15,
        12,
        13,
        12,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
            const BoxDecoration(
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
            child: Text(
              label,
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style:
              AppTextTheme.labelLarge.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
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
// SHEET ACTION
// =============================================================================

class _SheetAction extends StatelessWidget {
  const _SheetAction({
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
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(17),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.48),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration:
              const BoxDecoration(
                color: Color(0xFFFCE4EC),
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
                    style: AppTextTheme
                        .labelLarge.copyWith(
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
                    style: AppTextTheme
                        .labelSmall.copyWith(
                      fontSize: 8.5,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 10,
              color: AppColors.textSecondary,
            ),
          ],
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

class _ProfileBackground
    extends StatelessWidget {
  const _ProfileBackground();

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
                    .withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 520,
          left: -130,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: Container(
              width: 270,
              height: 270,
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