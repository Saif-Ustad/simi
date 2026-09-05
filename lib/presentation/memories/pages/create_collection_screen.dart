import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class CreateCollectionScreen extends StatefulWidget {
  const CreateCollectionScreen({
    super.key,
    this.onSave,
  });

  final ValueChanged<CreateCollectionData>? onSave;

  @override
  State<CreateCollectionScreen> createState() =>
      _CreateCollectionScreenState();
}

class _CreateCollectionScreenState
    extends State<CreateCollectionScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _descriptionController =
  TextEditingController();

  final TextEditingController _tagController =
  TextEditingController();

  XFile? _coverPhoto;

  final List<String> _tags = [];

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // COVER PHOTO
  // ===========================================================================

  Future<void> _pickCoverPhoto() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null || !mounted) return;

      setState(() {
        _coverPhoto = image;
      });
    } catch (_) {
      _showMessage('Could not open your photos.');
    }
  }

  void _removeCoverPhoto() {
    setState(() {
      _coverPhoto = null;
    });
  }

  // ===========================================================================
  // TAGS
  // ===========================================================================

  void _addTag() {
    final value = _tagController.text.trim();

    if (value.isEmpty) return;

    if (_tags.any(
          (tag) => tag.toLowerCase() == value.toLowerCase(),
    )) {
      _tagController.clear();
      return;
    }

    setState(() {
      _tags.add(value);
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  void _createCollection() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage('Give your collection a name first.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final data = CreateCollectionData(
      name: name,
      description: _descriptionController.text.trim(),
      coverPhoto: _coverPhoto,
      tags: List.unmodifiable(_tags),
    );

    widget.onSave?.call(data);

    if (!mounted) return;

    Navigator.of(context).pop(data);
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _CollectionBackground(),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    150,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _buildTopBar(),

                            const SizedBox(height: 26),

                            _buildIntro(),

                            const SizedBox(height: 24),

                            _buildCoverSection(),

                            const SizedBox(height: 24),

                            _buildNameSection(),

                            const SizedBox(height: 18),

                            _buildDescriptionSection(),

                            const SizedBox(height: 18),

                            _buildTagsSection(),

                            const SizedBox(height: 24),

                            _buildPreview(),

                            const SizedBox(height: 18),

                            _buildPrivacyNote(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar() {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),

        const Spacer(),

        Text(
          'NEW COLLECTION',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.7,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),

        const Spacer(),

        const SizedBox(width: 42),
      ],
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A little place\nfor a lot of memories.',
          style: GoogleFonts.playfairDisplay(
            fontSize: 31,
            height: 1.12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Create a collection for the moments you want '
              'to keep together.',
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 13,
            height: 1.55,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // COVER
  // ===========================================================================

  Widget _buildCoverSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'THE COVER',
          title: 'Choose its first impression',
        ),

        const SizedBox(height: 14),

        GestureDetector(
          onTap: _pickCoverPhoto,
          child: Container(
            height: 210,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EBE8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.55,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _coverPhoto == null
                ? _buildEmptyCover()
                : _buildSelectedCover(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCover() {
    return Stack(
      children: [
        Positioned(
          top: -40,
          right: -25,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFE8B4B8)
                  .withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Positioned(
          bottom: -55,
          left: -30,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFF6B6D91)
                  .withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 25,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                'Add a cover photo',
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Choose a photo from your device',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCover() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(_coverPhoto!.path),
          fit: BoxFit.cover,
        ),

        // Soft editorial gradient.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.42),
              ],
            ),
          ),
        ),

        Positioned(
          left: 16,
          bottom: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo_outlined,
                  size: 14,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'Cover selected',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 14,
          right: 14,
          child: Row(
            children: [
              _CoverActionButton(
                icon: Icons.edit_outlined,
                onTap: _pickCoverPhoto,
              ),
              const SizedBox(width: 8),
              _CoverActionButton(
                icon: Icons.close_rounded,
                onTap: _removeCoverPhoto,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // NAME
  // ===========================================================================

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'NAME IT',
          title: 'Give this chapter a name',
        ),

        const SizedBox(height: 13),

        Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            12,
            14,
            12,
          ),
          decoration: _cardDecoration(),
          child: TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Our travels',
              hintStyle: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDisabled,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(
                8,
                4,
                8,
                4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DESCRIPTION
  // ===========================================================================

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'A FEW WORDS',
          title: 'What belongs here?',
        ),

        const SizedBox(height: 13),

        Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            12,
            14,
            12,
          ),
          decoration: _cardDecoration(),
          child: TextField(
            controller: _descriptionController,
            minLines: 4,
            maxLines: 7,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            style: AppTextTheme.bodyLarge.copyWith(
              fontSize: 14,
              height: 1.55,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:
              'Trips we took, little adventures, '
                  'places we discovered...',
              hintStyle: AppTextTheme.bodyMedium.copyWith(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textDisabled,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(
                8,
                4,
                8,
                4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAGS
  // ===========================================================================

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'REMEMBER IT BY',
          title: 'Add a few tags',
        ),

        const SizedBox(height: 13),

        Container(
          padding: const EdgeInsets.fromLTRB(
            15,
            14,
            7,
            13,
          ),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.only(
                  left: 13,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant
                        .withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '#',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        textInputAction:
                        TextInputAction.done,
                        onSubmitted: (_) => _addTag(),
                        style:
                        AppTextTheme.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText:
                          'travel, beach, anniversary...',
                          hintStyle:
                          AppTextTheme.bodyMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.textDisabled,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                          const EdgeInsets.fromLTRB(
                            6,
                            5,
                            6,
                            5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: _addTag,
                        customBorder: const CircleBorder(),
                        child: const SizedBox(
                          width: 38,
                          height: 38,
                          child: Icon(
                            Icons.add_rounded,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: _tags.map(_buildTag).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 5),

          GestureDetector(
            onTap: () => _removeTag(tag),
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PREVIEW
  // ===========================================================================

  Widget _buildPreview() {
    final name = _nameController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'A LITTLE PREVIEW',
          title: 'This is how it will feel',
        ),

        const SizedBox(height: 13),

        Container(
          height: 132,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFEEE5E1),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 128,
                child: _coverPhoto == null
                    ? Container(
                  color: const Color(0xFFF3E7E5),
                  child: const Center(
                    child: Icon(
                      Icons.photo_outlined,
                      size: 26,
                      color: AppColors.primary,
                    ),
                  ),
                )
                    : Image.file(
                  File(_coverPhoto!.path),
                  fit: BoxFit.cover,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    15,
                    14,
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty
                            ? 'Our collection'
                            : name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 19,
                          height: 1.15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 13,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '0 memories',
                            style:
                            AppTextTheme.labelSmall.copyWith(
                              fontSize: 9,
                              color:
                              AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: AppColors.primary,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              'Your collections are private to the two of you.',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9.5,
                height: 1.35,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM BUTTON
  // ===========================================================================

  Widget _buildBottomButton() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 16,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed:
              _isSaving ? null : _createCollection,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                AppColors.primary.withValues(alpha: 0.55),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.create_new_folder_outlined,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Create collection',
                    style:
                    AppTextTheme.labelLarge.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // CARD STYLE
  // ===========================================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.outlineVariant.withValues(
          alpha: 0.55,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 18,
          offset: const Offset(0, 7),
        ),
      ],
    );
  }
}

// =============================================================================
// DATA MODEL
// =============================================================================

class CreateCollectionData {
  const CreateCollectionData({
    required this.name,
    required this.description,
    required this.coverPhoto,
    required this.tags,
  });

  final String name;
  final String description;
  final XFile? coverPhoto;
  final List<String> tags;
}

// =============================================================================
// SECTION HEADING
// =============================================================================

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
  });

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
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
      color: Colors.white.withValues(alpha: 0.85),
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
// COVER ACTION
// =============================================================================

class _CoverActionButton extends StatelessWidget {
  const _CoverActionButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.38),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _CollectionBackground extends StatelessWidget {
  const _CollectionBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 430,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.045),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}