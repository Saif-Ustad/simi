import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class CreateMemoryScreen extends StatefulWidget {
  const CreateMemoryScreen({
    super.key,
    this.collections = const [],
    this.onSave,
    this.onCreateCollection,
  });

  final List<String> collections;

  final void Function(CreateMemoryData data)? onSave;

  final void Function(String name)? onCreateCollection;

  @override
  State<CreateMemoryScreen> createState() => _CreateMemoryScreenState();
}

class _CreateMemoryScreenState extends State<CreateMemoryScreen> {
  final _titleController = TextEditingController();
  final _storyController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final List<XFile> _photos = [];
  final List<String> _tags = [];
  final List<String> _localCollections = [];

  DateTime _selectedDate = DateTime.now();

  String? _selectedCollection;

  int _coverIndex = 0;

  @override
  void initState() {
    super.initState();

    _localCollections.addAll(widget.collections);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _storyController.dispose();
    _locationController.dispose();
    _tagController.dispose();

    super.dispose();
  }

  bool get _canSave {
    return _titleController.text.trim().isNotEmpty;
  }

  XFile? get _coverPhoto {
    if (_photos.isEmpty) return null;

    if (_coverIndex >= _photos.length) {
      return _photos.first;
    }

    return _photos[_coverIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _CreateMemoryBackground(),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildTopBar(context),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    150,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildIntro(),
                      const SizedBox(height: 30),

                      _buildPhotoSection(),
                      const SizedBox(height: 34),

                      _buildStorySection(),
                      const SizedBox(height: 30),

                      _buildDetailsSection(),
                      const SizedBox(height: 30),

                      _buildCollectionSection(),
                      const SizedBox(height: 30),

                      _buildTagsSection(),
                      const SizedBox(height: 28),

                      _buildPrivateCard(),
                    ]),
                  ),
                ),
              ],
            ),

            _buildSaveBar(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            _RoundIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),

            const Spacer(),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CREATE',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Memory',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const Spacer(),

            const SizedBox(width: 42),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Keep this\nmoment close.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  height: 1.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
                right: 4,
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: AppColors.primary.withValues(alpha: 0.32),
                size: 34,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'A little place for a moment that means something.',
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // PHOTOS
  // ===========================================================================

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: 'THE MOMENT',
          title: 'Add your photos',
          trailing: _photos.isEmpty
              ? 'Optional'
              : '${_photos.length} ${_photos.length == 1 ? 'photo' : 'photos'}',
        ),

        const SizedBox(height: 13),

        if (_photos.isEmpty)
          _buildEmptyPhotoCard()
        else
          _buildPhotoGallery(),

        const SizedBox(height: 10),

        Row(
          children: [
            const Icon(
              Icons.auto_awesome_outlined,
              size: 13,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Choose a cover photo that tells the story at a glance.',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyPhotoCard() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: _pickPhotos,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 235,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFEEF2),
                Color(0xFFF8E6E3),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -30,
                child: _SoftCircle(
                  size: 125,
                  color: Colors.white.withValues(alpha: 0.42),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -45,
                child: _SoftCircle(
                  size: 130,
                  color: AppColors.primary.withValues(alpha: 0.07),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Add photos',
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Choose from your device',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
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

  Widget _buildPhotoGallery() {
    return Column(
      children: [
        if (_coverPhoto != null)
          GestureDetector(
            onTap: () => _showPhotoPreview(_coverPhoto!),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 285,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(_coverPhoto!.path),
                      fit: BoxFit.cover,
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.04),
                            Colors.black.withValues(alpha: 0.10),
                            Colors.black.withValues(alpha: 0.58),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 14,
                      left: 14,
                      child: _PhotoBadge(
                        icon: Icons.star_rounded,
                        label: 'COVER',
                      ),
                    ),

                    Positioned(
                      top: 14,
                      right: 14,
                      child: _SmallGlassButton(
                        icon: Icons.fullscreen_rounded,
                        onTap: () => _showPhotoPreview(_coverPhoto!),
                      ),
                    ),

                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 17,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Your memory starts here',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          _SmallGlassButton(
                            icon: Icons.edit_outlined,
                            onTap: _showCoverSelector,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 10),

        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _photos.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == _photos.length) {
                return _buildAddMorePhotoButton();
              }

              return _buildThumbnail(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(int index) {
    final isCover = index == _coverIndex;

    return GestureDetector(
      onTap: () => _showPhotoPreview(_photos[index]),
      onLongPress: () => _showPhotoOptions(index),
      child: Stack(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: isCover
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                File(_photos[index].path),
                fit: BoxFit.cover,
              ),
            ),
          ),

          if (isCover)
            Positioned(
              left: 6,
              top: 6,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),

          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => _removePhoto(index),
              child: Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMorePhotoButton() {
    return GestureDetector(
      onTap: _pickPhotos,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFFFCE4EC),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.65),
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 24,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Future<void> _pickPhotos() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 90,
      );

      if (images.isEmpty) return;

      setState(() {
        _photos.addAll(images);

        if (_photos.length == images.length) {
          _coverIndex = 0;
        }
      });
    } catch (e) {
      _showMessage('Could not open your photos.');
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);

      if (_photos.isEmpty) {
        _coverIndex = 0;
      } else if (_coverIndex == index) {
        _coverIndex = 0;
      } else if (_coverIndex > index) {
        _coverIndex--;
      }
    });
  }

  void _showPhotoOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _PhotoOptionsSheet(
          isCover: index == _coverIndex,
          onSetCover: () {
            Navigator.pop(sheetContext);

            setState(() {
              _coverIndex = index;
            });
          },
          onDelete: () {
            Navigator.pop(sheetContext);
            _removePhoto(index);
          },
        );
      },
    );
  }

  void _showCoverSelector() {
    if (_photos.length <= 1) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CoverSelectorSheet(
          photos: _photos,
          selectedIndex: _coverIndex,
          onSelected: (index) {
            setState(() {
              _coverIndex = index;
            });

            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  void _showPhotoPreview(XFile photo) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: InteractiveViewer(
              child: Image.file(
                File(photo.path),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // STORY
  // ===========================================================================

  Widget _buildStorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'YOUR STORY',
          title: 'Put the moment into words',
        ),

        const SizedBox(height: 15),

        // MEMORY TITLE
        Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'MEMORY TITLE',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _titleController,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Our first trip...',
                  hintStyle: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  isDense: true,

                  // Inner breathing room for the title
                  contentPadding: const EdgeInsets.fromLTRB(
                    8,
                    4,
                    8,
                    4,
                  ),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Give this little moment a name you’ll remember.',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // STORY
        Container(
          padding: const EdgeInsets.fromLTRB(18, 17, 18, 13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3EEF4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'THE STORY',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  Text(
                    'Optional',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _storyController,
                minLines: 6,
                maxLines: 9,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                style: AppTextTheme.bodyLarge.copyWith(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                  'Tell the story...\n\nWhat happened? How did you feel? What made this moment special?',
                  hintStyle: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    height: 1.55,
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  isDense: true,

                  // Inner breathing room for the story
                  contentPadding: const EdgeInsets.fromLTRB(
                    8,
                    4,
                    8,
                    4,
                  ),
                ),
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Write it the way you would tell them.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DETAILS
  // ===========================================================================

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'LITTLE DETAILS',
          title: 'When & where',
        ),

        const SizedBox(height: 13),

        Row(
          children: [
            Expanded(
              child: _DetailCard(
                icon: Icons.calendar_today_outlined,
                eyebrow: 'DATE',
                value: _formatDate(_selectedDate),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DetailCard(
                icon: Icons.location_on_outlined,
                eyebrow: 'LOCATION',
                value: _locationController.text.isEmpty
                    ? 'Add place'
                    : _locationController.text,
                onTap: _editLocation,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result == null) return;

    setState(() {
      _selectedDate = result;
    });
  }

  Future<void> _editLocation() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _LocationSheet(
          initialValue: _locationController.text,
        );
      },
    );

    if (result == null) return;

    setState(() {
      _locationController.text = result;
    });
  }

  // ===========================================================================
  // COLLECTION
  // ===========================================================================

  Widget _buildCollectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'ORGANIZE',
          title: 'Where should this live?',
        ),

        const SizedBox(height: 13),

        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Column(
            children: [
              if (_localCollections.isEmpty)
                _buildEmptyCollection()
              else
                ..._localCollections.map(_buildCollectionItem),

              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.outlineVariant,
              ),

              _buildAddCollectionButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCollection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.folder_open_outlined,
              size: 19,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No collection yet',
                  style: AppTextTheme.labelLarge.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Create one for this memory.',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(String collection) {
    final selected = _selectedCollection == collection;

    return Material(
      color: selected
          ? const Color(0xFFFCE4EC)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCollection = selected ? null : collection;
          });
        },
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : const Color(0xFFF7EFED),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.folder_rounded,
                  size: 18,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  collection,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCollectionButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showCreateCollection,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(23),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            14,
            12,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create collection',
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Give similar memories a home',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outlineVariant,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateCollection() async {
    final name = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return const _CreateCollectionSheet();
      },
    );

    if (!mounted || name == null) return;

    final collection = name.trim();

    if (collection.isEmpty) return;

    setState(() {
      if (!_localCollections.contains(collection)) {
        _localCollections.add(collection);
      }

      _selectedCollection = collection;
    });

    widget.onCreateCollection?.call(collection);
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
          title: 'Add some tags',
        ),

        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sell_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add tags',
                          style: AppTextTheme.labelLarge.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Help you find this memory later',
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 13, right: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.45),
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

                    const SizedBox(width: 5),

                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addTag(),
                        textCapitalization: TextCapitalization.words,
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'travel, date night, beach...',
                          hintStyle: AppTextTheme.bodyMedium.copyWith(
                            fontSize: 12,
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

                    const SizedBox(width: 12),

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
                const SizedBox(height: 14),

                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: _tags.map(_buildTag).toList(),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Press + or Enter after each tag.',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
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
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              setState(() {
                _tags.remove(tag);
              });
            },
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

  void _addTag() {
    final tag = _tagController.text.trim().replaceFirst('#', '');

    if (tag.isEmpty || _tags.contains(tag)) return;

    setState(() {
      _tags.add(tag);
      _tagController.clear();
    });
  }

  // ===========================================================================
  // PRIVATE
  // ===========================================================================

  Widget _buildPrivateCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Just for the two of you',
                  style: AppTextTheme.labelLarge.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Private memories belong in your little world.',
                  style: AppTextTheme.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  Widget _buildSaveBar() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 13,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              height: 70,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.55),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Material(
                color: _canSave
                    ? AppColors.primary
                    : AppColors.textDisabled,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: _canSave ? _saveMemory : null,
                  borderRadius: BorderRadius.circular(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'Save this memory',
                        style: AppTextTheme.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
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

  void _saveMemory() {
    final data = CreateMemoryData(
      title: _titleController.text.trim(),
      description: _storyController.text.trim(),
      date: _selectedDate,
      location: _locationController.text.trim(),
      collection: _selectedCollection,
      tags: List.unmodifiable(_tags),
      photos: List.unmodifiable(_photos),
      coverPhoto: _coverPhoto,
    );

    widget.onSave?.call(data);

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// =============================================================================
// DATA
// =============================================================================

class CreateMemoryData {
  const CreateMemoryData({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.collection,
    required this.tags,
    required this.photos,
    required this.coverPhoto,
  });

  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? collection;
  final List<String> tags;

  final List<XFile> photos;
  final XFile? coverPhoto;
}

// =============================================================================
// SECTION HEADING
// =============================================================================

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// TEXT FIELD
// =============================================================================

class _PremiumTextField extends StatelessWidget {
  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLines,
    this.minLines,
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        textInputAction: textInputAction,
        onChanged: onChanged,
        style: AppTextTheme.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DETAIL CARD
// =============================================================================

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.eyebrow,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String eyebrow;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.80),
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 11,
                        color: AppColors.textPrimary,
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
}

// =============================================================================
// LOCATION SHEET
// =============================================================================

class _LocationSheet extends StatelessWidget {
  const _LocationSheet({
    required this.initialValue,
  });

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: initialValue,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Where did it happen?',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Goa, Mumbai, our favourite café...',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    controller.text.trim(),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text('Save location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CREATE COLLECTION SHEET
// =============================================================================

class _CreateCollectionSheet extends StatefulWidget {
  const _CreateCollectionSheet();

  @override
  State<_CreateCollectionSheet> createState() =>
      _CreateCollectionSheetState();
}

class _CreateCollectionSheetState
    extends State<_CreateCollectionSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createCollection() {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      return;
    }

    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          20 + bottomInset,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),

            const SizedBox(height: 22),

            // ---------------------------------------------------------------
            // HEADER
            // ---------------------------------------------------------------
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.create_new_folder_outlined,
                    color: AppColors.primary,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a collection',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Give your memories a little home.',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------------
            // COLLECTION NAME
            // ---------------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _createCollection(),
                style: AppTextTheme.bodyLarge.copyWith(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Our Travels',
                  hintStyle: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  prefixIcon: const Icon(
                    Icons.folder_outlined,
                    color: AppColors.primary,
                    size: 21,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // CREATE BUTTON
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _createCollection,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 19,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Create collection',
                      style: AppTextTheme.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
// =============================================================================
// COVER SELECTOR
// =============================================================================

class _CoverSelectorSheet extends StatelessWidget {
  const _CoverSelectorSheet({
    required this.photos,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<XFile> photos;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 21),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose your cover',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pick the photo that represents this memory.',
                style: AppTextTheme.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final selected = index == selectedIndex;

                return GestureDetector(
                  onTap: () => onSelected(index),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(photos[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (selected)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      if (selected)
                        const Positioned(
                          right: 7,
                          top: 7,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
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
}

// =============================================================================
// PHOTO OPTIONS
// =============================================================================

class _PhotoOptionsSheet extends StatelessWidget {
  const _PhotoOptionsSheet({
    required this.isCover,
    required this.onSetCover,
    required this.onDelete,
  });

  final bool isCover;
  final VoidCallback onSetCover;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 20),
            _SheetAction(
              icon: Icons.favorite_border_rounded,
              title: isCover
                  ? 'Current cover photo'
                  : 'Set as cover',
              onTap: isCover ? () => Navigator.pop(context) : onSetCover,
              disabled: isCover,
            ),
            _SheetAction(
              icon: Icons.delete_outline_rounded,
              title: 'Remove photo',
              destructive: true,
              onTap: onDelete,
            ),
          ],
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
    required this.onTap,
    this.destructive = false,
    this.disabled = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? Colors.redAccent
        : disabled
        ? AppColors.textDisabled
        : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: destructive
                      ? const Color(0xFFFFEBEE)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: color,
                ),
              ),
              const SizedBox(width: 13),
              Text(
                title,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: destructive
                      ? Colors.redAccent
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textSecondary.withValues(
                  alpha: 0.65,
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
// SMALL WIDGETS
// =============================================================================

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
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
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _SmallGlassButton extends StatelessWidget {
  const _SmallGlassButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.32),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _PhotoBadge extends StatelessWidget {
  const _PhotoBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

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

// =============================================================================
// BACKGROUND
// =============================================================================

class _CreateMemoryBackground extends StatelessWidget {
  const _CreateMemoryBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -65,
            child: _SoftCircle(
              size: 230,
              color: const Color(0xFFFCE4EC).withValues(alpha: 0.52),
            ),
          ),
          Positioned(
            top: 430,
            left: -110,
            child: _SoftCircle(
              size: 210,
              color: const Color(0xFFE8B4B8).withValues(alpha: 0.09),
            ),
          ),
        ],
      ),
    );
  }
}