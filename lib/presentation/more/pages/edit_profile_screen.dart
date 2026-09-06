import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class EditProfileData {
  const EditProfileData({
    required this.name,
    required this.partnerName,
    required this.bio,
    required this.relationshipLabel,
    required this.relationshipStartDate,
    required this.city,
    required this.favoriteMemory,
    required this.profileImage,
    required this.removeProfileImage,
  });

  final String name;
  final String partnerName;
  final String bio;
  final String relationshipLabel;
  final DateTime? relationshipStartDate;
  final String city;
  final String favoriteMemory;
  final XFile? profileImage;
  final bool removeProfileImage;
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.name = 'Saif',
    this.partnerName = 'Love',
    this.bio = 'A little corner of the world, just for us.',
    this.relationshipLabel = 'Together',
    this.relationshipStartDate,
    this.city = '',
    this.favoriteMemory = 'Our first trip together',
    this.profileImage,
    this.onBack,
    this.onSave,
    this.onChangePhoto,
  });

  final String name;
  final String partnerName;
  final String bio;
  final String relationshipLabel;
  final DateTime? relationshipStartDate;
  final String city;
  final String favoriteMemory;
  final ImageProvider? profileImage;

  final VoidCallback? onBack;
  final ValueChanged<EditProfileData>? onSave;
  final VoidCallback? onChangePhoto;

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final TextEditingController _nameController;
  late final TextEditingController _partnerController;
  late final TextEditingController _bioController;
  late final TextEditingController _cityController;
  late final TextEditingController _favoriteMemoryController;

  final ImagePicker _picker = ImagePicker();

  XFile? _newProfileImage;
  bool _removeProfileImage = false;

  late String _relationshipLabel;
  DateTime? _relationshipStartDate;

  final List<String> _relationshipLabels = const [
    'Together',
    'In love',
    'Partners',
    'Forever',
    'My person',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _nameController = TextEditingController(
      text: widget.name,
    );

    _partnerController = TextEditingController(
      text: widget.partnerName,
    );

    _bioController = TextEditingController(
      text: widget.bio,
    );

    _cityController = TextEditingController(
      text: widget.city,
    );

    _favoriteMemoryController =
        TextEditingController(
          text: widget.favoriteMemory,
        );

    _relationshipLabel =
        widget.relationshipLabel;

    _relationshipStartDate =
        widget.relationshipStartDate;
  }

  @override
  void dispose() {
    _animationController.dispose();

    _nameController.dispose();
    _partnerController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _favoriteMemoryController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _EditProfileBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 130,
              ),
              children: [
                _buildTopBar(context),
                _buildHeader(),
                _buildPhotoSection(),
                _buildBasicDetails(),
                _buildRelationshipSection(),
                _buildAboutSection(),
                _buildFavoriteMemory(),
                _buildPreview(),
                _buildPrivacyNote(),
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
              _showDiscardConfirmation(
                context,
              );
            },
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'PROFILE',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Edit your profile',
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

          GestureDetector(
            onTap: () {
              _showDiscardConfirmation(
                context,
              );
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              child: Text(
                'Cancel',
                style:
                AppTextTheme.labelLarge.copyWith(
                  fontSize: 10,
                  color:
                  AppColors.textSecondary,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
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
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'MAKE IT FEEL LIKE YOU',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'A little more personal.',
              style:
              GoogleFonts.playfairDisplay(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'These little details make your SIMI space feel like yours.',
              style:
              AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                height: 1.5,
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
  // PHOTO
  // ===========================================================================

  Widget _buildPhotoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.06,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.82),
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.48),
            ),
          ),
          child: Row(
            children: [
              _buildEditableAvatar(),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROFILE PHOTO',
                      style: AppTextTheme
                          .labelSmall.copyWith(
                        fontSize: 8,
                        letterSpacing: 1.5,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'A photo that feels like you.',
                      style: AppTextTheme
                          .labelLarge.copyWith(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        _SmallAction(
                          label: 'Change',
                          icon:
                          Icons.camera_alt_outlined,
                          onTap: _pickProfilePhoto,
                        ),
                        if (_hasProfileImage) ...[
                          const SizedBox(width: 7),
                          _SmallAction(
                            label: 'Remove',
                            icon:
                            Icons.close_rounded,
                            onTap: _removePhoto,
                          ),
                        ],
                      ],
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

  Widget _buildEditableAvatar() {
    ImageProvider? image;

    if (_newProfileImage != null) {
      image = FileImage(
        File(_newProfileImage!.path),
      );
    } else if (!_removeProfileImage) {
      image = widget.profileImage;
    }

    return Container(
      width: 82,
      height: 82,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFCE4EC),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.65),
        ),
      ),
      child: ClipOval(
        child: image != null
            ? Image(
          image: image,
          fit: BoxFit.cover,
        )
            : Container(
          decoration:
          const BoxDecoration(
            gradient: LinearGradient(
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
              _initial,
              style: GoogleFonts
                  .playfairDisplay(
                fontSize: 31,
                fontWeight:
                FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasProfileImage {
    return _newProfileImage != null ||
        (widget.profileImage != null &&
            !_removeProfileImage);
  }

  String get _initial {
    final name =
    _nameController.text.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name[0].toUpperCase();
  }

  // ===========================================================================
  // BASIC DETAILS
  // ===========================================================================

  Widget _buildBasicDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.12,
        child: _EditSection(
          label: 'THE BASICS',
          child: Column(
            children: [
              _buildTextFieldCard(
                controller: _nameController,
                label: 'Your name',
                hint: 'What should SIMI call you?',
                icon:
                Icons.person_outline_rounded,
                textCapitalization:
                TextCapitalization.words,
              ),

              const SizedBox(height: 12),

              _buildTextFieldCard(
                controller: _partnerController,
                label: 'Partner name',
                hint: 'Your favorite person',
                icon:
                Icons.favorite_border_rounded,
                textCapitalization:
                TextCapitalization.words,
              ),

              const SizedBox(height: 12),

              _buildTextFieldCard(
                controller: _cityController,
                label: 'Location',
                hint: 'Mumbai, Delhi, Pune...',
                icon:
                Icons.location_on_outlined,
                textCapitalization:
                TextCapitalization.words,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldCard({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextCapitalization textCapitalization =
        TextCapitalization.sentences,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.84),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.48),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization:
        textCapitalization,
        style:
        AppTextTheme.bodyLarge.copyWith(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
          hintStyle:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 11,
            color: AppColors.textDisabled,
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.fromLTRB(
            5,
            15,
            15,
            14,
          ),
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
        delay: 0.18,
        child: _EditSection(
          label: 'YOUR STORY',
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'How would you describe the two of you?',
                style:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 10,
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                _relationshipLabels.map(
                      (label) {
                    final selected =
                        _relationshipLabel ==
                            label;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _relationshipLabel =
                              label;
                        });
                      },
                      child: AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 180,
                        ),
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration:
                        BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(999),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors
                                .outlineVariant,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppColors
                                .textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),

              const SizedBox(height: 18),

              GestureDetector(
                onTap: _pickRelationshipDate,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: 0.84),
                    borderRadius:
                    BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors
                          .outlineVariant
                          .withValues(
                        alpha: 0.48,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration:
                        const BoxDecoration(
                          color:
                          Color(0xFFFCE4EC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .calendar_today_outlined,
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
                              'Relationship date',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              _relationshipStartDate ==
                                  null
                                  ? 'Add the day your story began'
                                  : _formatDate(
                                _relationshipStartDate!,
                              ),
                              style: AppTextTheme
                                  .labelLarge
                                  .copyWith(
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                _relationshipStartDate ==
                                    null
                                    ? AppColors
                                    .textDisabled
                                    : AppColors
                                    .textPrimary,
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
        delay: 0.24,
        child: _EditSection(
          label: 'A LITTLE ABOUT YOU',
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.84),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: TextField(
              controller: _bioController,
              maxLines: 4,
              minLines: 3,
              textCapitalization:
              TextCapitalization.sentences,
              style: AppTextTheme.bodyMedium
                  .copyWith(
                fontSize: 11,
                height: 1.5,
                color:
                AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                'Tell your little corner of SIMI something about you...',
                hintStyle: AppTextTheme
                    .bodyMedium.copyWith(
                  fontSize: 11,
                  color:
                  AppColors.textDisabled,
                ),
                prefixIcon: const Padding(
                  padding:
                  EdgeInsets.only(
                    left: 14,
                    right: 3,
                    top: 14,
                  ),
                  child: Align(
                    alignment:
                    Alignment.topCenter,
                    child: Icon(
                      Icons
                          .auto_awesome_outlined,
                      size: 18,
                      color:
                      AppColors.primary,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.fromLTRB(
                  5,
                  15,
                  15,
                  15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // FAVORITE MEMORY
  // ===========================================================================

  Widget _buildFavoriteMemory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.30,
        child: _EditSection(
          label: 'A MEMORY CLOSE TO YOU',
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.84),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.48),
              ),
            ),
            child: TextField(
              controller:
              _favoriteMemoryController,
              maxLines: 2,
              textCapitalization:
              TextCapitalization.sentences,
              style:
              AppTextTheme.bodyMedium.copyWith(
                fontSize: 11,
                color:
                AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                'Our first trip together',
                hintStyle: AppTextTheme
                    .bodyMedium.copyWith(
                  fontSize: 11,
                  color:
                  AppColors.textDisabled,
                ),
                prefixIcon: const Padding(
                  padding:
                  EdgeInsets.only(
                    left: 14,
                    right: 3,
                    top: 14,
                  ),
                  child: Align(
                    alignment:
                    Alignment.topCenter,
                    child: Icon(
                      Icons
                          .favorite_border_rounded,
                      size: 18,
                      color:
                      AppColors.primary,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.fromLTRB(
                  5,
                  15,
                  15,
                  15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // LIVE PREVIEW
  // ===========================================================================

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        delay: 0.36,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'PREVIEW',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
                color:
                AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 11),

            AnimatedBuilder(
              animation: Listenable.merge([
                _nameController,
                _partnerController,
                _bioController,
              ]),
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.fromLTRB(
                    18,
                    19,
                    18,
                    18,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                    const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF332A2B),
                        Color(0xFF5A4144),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _PreviewAvatar(),
                          const SizedBox(
                            width: 11,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  _nameController
                                      .text
                                      .trim()
                                      .isEmpty
                                      ? 'Your name'
                                      : _nameController
                                      .text
                                      .trim(),
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style: GoogleFonts
                                      .playfairDisplay(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    color:
                                    Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '${_relationshipLabel} · ${_partnerController.text.trim().isEmpty ? 'Love' : _partnerController.text.trim()}',
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style: AppTextTheme
                                      .labelSmall
                                      .copyWith(
                                    fontSize: 8.5,
                                    color: Colors
                                        .white
                                        .withValues(
                                      alpha: 0.58,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons
                                .favorite_rounded,
                            size: 15,
                            color:
                            Color(0xFFE8B4B8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.all(
                          12,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.07,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(15),
                        ),
                        child: Text(
                          _bioController.text
                              .trim()
                              .isEmpty
                              ? 'A little corner of the world, just for us.'
                              : _bioController
                              .text
                              .trim(),
                          maxLines: 3,
                          overflow:
                          TextOverflow.ellipsis,
                          style: AppTextTheme
                              .bodyMedium
                              .copyWith(
                            fontSize: 9.5,
                            height: 1.45,
                            color: Colors.white
                                .withValues(
                              alpha: 0.70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
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

  Widget _buildPrivacyNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your profile belongs to your private SIMI space. '
                  'Only you and your partner can see it.',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 8.5,
                height: 1.45,
                color:
                AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM SAVE
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
                onTap: _saveProfile,
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
                        offset:
                        const Offset(0, 8),
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
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.14,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .check_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 13),

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
                              'Save changes',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Keep your little space feeling like you',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
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
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.12,
                          ),
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
  // PHOTO ACTIONS
  // ===========================================================================

  Future<void> _pickProfilePhoto() async {
    try {
      final image =
      await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null || !mounted) {
        return;
      }

      setState(() {
        _newProfileImage = image;
        _removeProfileImage = false;
      });
    } catch (_) {
      _showMessage(
        'Could not open your photos.',
      );
    }
  }

  void _removePhoto() {
    setState(() {
      _newProfileImage = null;
      _removeProfileImage = true;
    });
  }

  // ===========================================================================
  // DATE PICKER
  // ===========================================================================

  Future<void> _pickRelationshipDate() async {
    final now = DateTime.now();

    final picked =
    await showDatePicker(
      context: context,
      initialDate:
      _relationshipStartDate ?? now,
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            const ColorScheme.light(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || picked == null) {
      return;
    }

    setState(() {
      _relationshipStartDate =
          picked;
    });
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  void _saveProfile() {
    final name =
    _nameController.text.trim();

    final partner =
    _partnerController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Please add your name.',
      );
      return;
    }

    if (partner.isEmpty) {
      _showMessage(
        'Please add your partner\'s name.',
      );
      return;
    }

    final data = EditProfileData(
      name: name,
      partnerName: partner,
      bio: _bioController.text.trim(),
      relationshipLabel:
      _relationshipLabel,
      relationshipStartDate:
      _relationshipStartDate,
      city: _cityController.text.trim(),
      favoriteMemory:
      _favoriteMemoryController.text
          .trim(),
      profileImage: _newProfileImage,
      removeProfileImage:
      _removeProfileImage,
    );

    widget.onSave?.call(data);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // ===========================================================================
  // DISCARD
  // ===========================================================================

  void _showDiscardConfirmation(
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

              Container(
                width: 52,
                height: 52,
                decoration:
                const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_off_outlined,
                  size: 23,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                'Leave without saving?',
                style:
                GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'The changes you made will be lost.',
                textAlign: TextAlign.center,
                style:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 10,
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 19),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          sheetContext,
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            25,
                          ),
                          border: Border.all(
                            color: AppColors
                                .outlineVariant,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Keep editing',
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
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration:
                        BoxDecoration(
                          color:
                          AppColors.primary,
                          borderRadius:
                          BorderRadius.circular(
                            25,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Discard',
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
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style:
            AppTextTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          behavior:
          SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            85,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
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
}

// =============================================================================
// EDIT SECTION
// =============================================================================

class _EditSection extends StatelessWidget {
  const _EditSection({
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
            color:
            AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 11),
        child,
      ],
    );
  }
}

// =============================================================================
// SMALL ACTION
// =============================================================================

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F1F0),
          borderRadius:
          BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 11,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textSecondary,
              ),
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
// PREVIEW AVATAR
// =============================================================================

class _PreviewAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Color(0xFFE8B4B8),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        size: 21,
        color: Colors.white,
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

class _EditProfileBackground
    extends StatelessWidget {
  const _EditProfileBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -120,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 48,
              sigmaY: 48,
            ),
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 570,
          left: -130,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: Container(
              width: 280,
              height: 280,
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
        (delay + 0.40).clamp(
          0.0,
          1.0,
        ),
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