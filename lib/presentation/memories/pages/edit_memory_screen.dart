import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'memories_screen.dart';

class EditMemoryScreen extends StatefulWidget {
  const EditMemoryScreen({
    super.key,
    required this.memory,
    this.collections = const [],
    this.onSave,
    this.onDelete,
  });

  final MemoryItem memory;
  final List<String> collections;

  final ValueChanged<EditMemoryData>? onSave;
  final VoidCallback? onDelete;

  @override
  State<EditMemoryScreen> createState() => _EditMemoryScreenState();
}

class _EditMemoryScreenState extends State<EditMemoryScreen> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _titleController;
  late final TextEditingController _storyController;
  late final TextEditingController _locationController;
  late final TextEditingController _tagController;

  late DateTime _selectedDate;
  late String? _selectedCollection;

  final List<String> _tags = [];
  final List<XFile> _newPhotos = [];

  // Existing ImageProviders are kept separately because they may be
  // AssetImage/FileImage/etc. and are not necessarily XFile objects.
  final List<ImageProvider> _existingPhotos = [];

  int _newCoverIndex = 0;
  int? _existingCoverIndex;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.memory.title,
    );

    _storyController = TextEditingController(
      text: widget.memory.description,
    );

    _locationController = TextEditingController(
      text: widget.memory.location,
    );

    _tagController = TextEditingController();

    _selectedDate = widget.memory.date;
    _selectedCollection = widget.memory.folder;

    _tags.addAll(widget.memory.tags);

    _existingPhotos.addAll(widget.memory.images);

    // If the memory has a cover image, keep it at the front of the
    // existing photo list if it isn't already there.
    if (widget.memory.coverImage != null) {
      final cover = widget.memory.coverImage!;

      final existingIndex = _existingPhotos.indexWhere(
            (image) => image == cover,
      );

      if (existingIndex >= 0) {
        _existingCoverIndex = existingIndex;
      } else {
        _existingPhotos.insert(0, cover);
        _existingCoverIndex = 0;
      }
    } else if (_existingPhotos.isNotEmpty) {
      _existingCoverIndex = 0;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _storyController.dispose();
    _locationController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // PHOTOS
  // ===========================================================================

  Future<void> _pickPhotos() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 90,
      );

      if (images.isEmpty || !mounted) return;

      setState(() {
        _newPhotos.addAll(images);

        if (_existingPhotos.isEmpty && _newPhotos.length == images.length) {
          _newCoverIndex = 0;
          _existingCoverIndex = null;
        }
      });
    } catch (_) {
      _showMessage('Could not open your photos.');
    }
  }

  void _removeExistingPhoto(int index) {
    setState(() {
      _existingPhotos.removeAt(index);

      if (_existingPhotos.isEmpty) {
        _existingCoverIndex = null;
      } else if (_existingCoverIndex == index) {
        _existingCoverIndex = 0;
      } else if (_existingCoverIndex != null &&
          _existingCoverIndex! > index) {
        _existingCoverIndex = _existingCoverIndex! - 1;
      }
    });
  }

  void _removeNewPhoto(int index) {
    setState(() {
      _newPhotos.removeAt(index);

      if (_newPhotos.isEmpty) {
        _newCoverIndex = 0;
      } else if (_newCoverIndex == index) {
        _newCoverIndex = 0;
      } else if (_newCoverIndex > index) {
        _newCoverIndex--;
      }
    });
  }

  void _setExistingCover(int index) {
    setState(() {
      _existingCoverIndex = index;
    });
  }

  void _setNewCover(int index) {
    setState(() {
      _existingCoverIndex = null;
      _newCoverIndex = index;
    });
  }

  // ===========================================================================
  // DATE
  // ===========================================================================

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  // ===========================================================================
  // TAGS
  // ===========================================================================

  void _addTag() {
    final tag = _tagController.text.trim();

    if (tag.isEmpty) return;

    final exists = _tags.any(
          (item) => item.toLowerCase() == tag.toLowerCase(),
    );

    if (exists) {
      _tagController.clear();
      return;
    }

    setState(() {
      _tags.add(tag);
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

  Future<void> _save() async {
    if (_saving) return;

    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Give this memory a title first.');
      return;
    }

    setState(() {
      _saving = true;
    });

    ImageProvider? coverImage;

    if (_existingCoverIndex != null &&
        _existingCoverIndex! >= 0 &&
        _existingCoverIndex! < _existingPhotos.length) {
      coverImage = _existingPhotos[_existingCoverIndex!];
    } else if (_newPhotos.isNotEmpty &&
        _newCoverIndex >= 0 &&
        _newCoverIndex < _newPhotos.length) {
      coverImage = FileImage(
        File(_newPhotos[_newCoverIndex].path),
      );
    }

    final data = EditMemoryData(
      originalMemory: widget.memory,
      title: title,
      description: _storyController.text.trim(),
      date: _selectedDate,
      location: _locationController.text.trim(),
      collection: _selectedCollection,
      tags: List.unmodifiable(_tags),
      existingPhotos: List.unmodifiable(_existingPhotos),
      newPhotos: List.unmodifiable(_newPhotos),
      coverImage: coverImage,
    );

    widget.onSave?.call(data);

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Delete this memory?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This memory will be removed from your collection.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Keep it',
                style: AppTextTheme.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8D555C),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    widget.onDelete?.call();

    if (!mounted) return;

    Navigator.of(context).pop();
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
          const _EditMemoryBackground(),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildTopBar(),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    14,
                    20,
                    150,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 560,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntro(),
                            const SizedBox(height: 26),
                            _buildStorySection(),
                            const SizedBox(height: 26),
                            _buildDateLocationSection(),
                            const SizedBox(height: 26),
                            _buildCollectionSection(),
                            const SizedBox(height: 26),
                            _buildPhotosSection(),
                            const SizedBox(height: 26),
                            _buildTagsSection(),
                            const SizedBox(height: 32),
                            _buildDeleteButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildSaveBar(),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  'EDIT MEMORY',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Keep the story beautiful',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: _showMoreOptions,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF4F2),
            Color(0xFFF5EEF2),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 21,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A LITTLE POLISH',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update this moment without losing what made it special.',
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    height: 1.45,
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

  // ===========================================================================
  // STORY
  // ===========================================================================

  Widget _buildStorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'YOUR STORY',
          title: 'What do you want to remember?',
        ),
        const SizedBox(height: 14),

        _PremiumFieldCard(
          icon: Icons.auto_awesome_rounded,
          iconBackground: const Color(0xFFFCE4EC),
          iconColor: AppColors.primary,
          label: 'MEMORY TITLE',
          child: TextField(
            controller: _titleController,
            maxLines: 1,
            textInputAction: TextInputAction.next,
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
              contentPadding: const EdgeInsets.fromLTRB(
                8,
                4,
                8,
                4,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        _PremiumFieldCard(
          icon: Icons.edit_note_rounded,
          iconBackground: const Color(0xFFF3EEF4),
          iconColor: AppColors.secondary,
          label: 'THE STORY',
          trailing: 'OPTIONAL',
          child: TextField(
            controller: _storyController,
            minLines: 7,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            style: AppTextTheme.bodyLarge.copyWith(
              fontSize: 14,
              height: 1.6,
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
              contentPadding: const EdgeInsets.fromLTRB(
                8,
                4,
                8,
                4,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

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
    );
  }

  // ===========================================================================
  // DATE + LOCATION
  // ===========================================================================

  Widget _buildDateLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'THE DETAILS',
          title: 'When & where',
        ),
        const SizedBox(height: 14),

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
    final collections = <String>[
      ...widget.collections,
    ];

    if (_selectedCollection != null &&
        _selectedCollection!.trim().isNotEmpty &&
        !collections.contains(_selectedCollection)) {
      collections.insert(0, _selectedCollection!);
    }

    if (collections.isEmpty) {
      return _buildSimpleCollectionCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'BELONGS TO',
          title: 'Choose a collection',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
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
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: collections.map((collection) {
              final selected = _selectedCollection == collection;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCollection = collection;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFFFF8F6),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected
                            ? Icons.check_rounded
                            : Icons.folder_outlined,
                        size: 14,
                        color: selected
                            ? Colors.white
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        collection,
                        style: AppTextTheme.labelLarge.copyWith(
                          fontSize: 11,
                          color: selected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleCollectionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          eyebrow: 'BELONGS TO',
          title: 'Collection',
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.folder_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _selectedCollection ?? 'No collection',
                  style: AppTextTheme.labelLarge.copyWith(
                    color: AppColors.textPrimary,
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
  // PHOTOS
  // ===========================================================================

  Widget _buildPhotosSection() {
    final totalPhotos =
        _existingPhotos.length + _newPhotos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: _SectionHeading(
                eyebrow: 'VISUAL MEMORIES',
                title: 'Your photos',
              ),
            ),
            if (totalPhotos > 0)
              Text(
                '$totalPhotos ${totalPhotos == 1 ? 'photo' : 'photos'}',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        if (totalPhotos > 0) ...[
          SizedBox(
            height: 154,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                ...List.generate(
                  _existingPhotos.length,
                      (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _PhotoTile(
                      image: _existingPhotos[index],
                      isCover: _existingCoverIndex == index,
                      onTap: () => _setExistingCover(index),
                      onDelete: () => _removeExistingPhoto(index),
                    ),
                  ),
                ),
                ...List.generate(
                  _newPhotos.length,
                      (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _NewPhotoTile(
                      file: _newPhotos[index],
                      isCover: _existingCoverIndex == null &&
                          _newCoverIndex == index,
                      onTap: () => _setNewCover(index),
                      onDelete: () => _removeNewPhoto(index),
                    ),
                  ),
                ),
                _AddPhotoTile(
                  onTap: _pickPhotos,
                ),
              ],
            ),
          ),
        ] else
          _PhotoEmptyState(
            onTap: _pickPhotos,
          ),

        const SizedBox(height: 10),

        Text(
          'Tap a photo to make it the cover.',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9.5,
            color: AppColors.textSecondary,
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
          title: 'Add some tags',
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            14,
            10,
            14,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
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
                    child: Text(
                      'Edit your tags',
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: _tags.map(_buildTag).toList(),
                ),
              ],

              const SizedBox(height: 14),

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
                    color: AppColors.outlineVariant.withValues(
                      alpha: 0.45,
                    ),
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
                        textCapitalization:
                        TextCapitalization.words,
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText:
                          'add another tag...',
                          hintStyle:
                          AppTextTheme.bodyMedium.copyWith(
                            fontSize: 12,
                            color:
                            AppColors.textDisabled,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                          const EdgeInsets.fromLTRB(
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
                        customBorder:
                        const CircleBorder(),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.only(
        left: 11,
        right: 7,
        top: 7,
        bottom: 7,
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
            style: AppTextTheme.labelLarge.copyWith(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
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
  // DELETE BUTTON
  // ===========================================================================

  Widget _buildDeleteButton() {
    return Center(
      child: TextButton.icon(
        onPressed: _confirmDelete,
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: 17,
        ),
        label: const Text('Delete this memory'),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF8D555C),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SAVE BAR
  // ===========================================================================

  Widget _buildSaveBar() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 560,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(
                      alpha: 0.55,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      AppColors.primary.withValues(
                        alpha: 0.55,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
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
                          Icons.check_rounded,
                          size: 19,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Save changes',
                          style:
                          AppTextTheme.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  // ===========================================================================
  // MORE
  // ===========================================================================

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
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
                const SizedBox(height: 18),
                _SheetAction(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete memory',
                  subtitle: 'Remove this memory permanently',
                  destructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          100,
        ),
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

class EditMemoryData {
  const EditMemoryData({
    required this.originalMemory,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.collection,
    required this.tags,
    required this.existingPhotos,
    required this.newPhotos,
    required this.coverImage,
  });

  final MemoryItem originalMemory;

  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? collection;

  final List<String> tags;

  final List<ImageProvider> existingPhotos;
  final List<XFile> newPhotos;

  final ImageProvider? coverImage;
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
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            height: 1.15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PREMIUM FIELD CARD
// =============================================================================

class _PremiumFieldCard extends StatelessWidget {
  const _PremiumFieldCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.child,
    this.trailing,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        13,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.55,
          ),
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
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: iconColor,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    color: AppColors.textDisabled,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// =============================================================================
// DETAIL BUTTON
// =============================================================================

class _DetailButton extends StatelessWidget {
  const _DetailButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        letterSpacing: 1,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      AppTextTheme.labelLarge.copyWith(
                        fontSize: 11,
                        color:
                        AppColors.textPrimary,
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
// LOCATION FIELD
// =============================================================================

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        9,
        12,
        9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFF3EEF4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 1,
              style: AppTextTheme.labelLarge.copyWith(
                fontSize: 11,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'LOCATION',
                labelStyle:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  letterSpacing: 1,
                  color: AppColors.textSecondary,
                ),
                hintText: 'Goa',
                hintStyle:
                AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                const EdgeInsets.only(
                  top: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PHOTO TILE - EXISTING
// =============================================================================

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.image,
    required this.isCover,
    required this.onTap,
    required this.onDelete,
  });

  final ImageProvider image;
  final bool isCover;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 138,
            height: 154,
            padding: EdgeInsets.all(isCover ? 3 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: isCover
                  ? Border.all(
                color: AppColors.primary,
                width: 2,
              )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                isCover ? 19 : 22,
              ),
              child: Image(
                image: image,
                width: 138,
                height: 154,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (isCover)
          Positioned(
            left: 9,
            bottom: 9,
            child: _CoverBadge(),
          ),
        Positioned(
          right: 7,
          top: 7,
          child: _DeletePhotoButton(
            onTap: onDelete,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PHOTO TILE - NEW
// =============================================================================

class _NewPhotoTile extends StatelessWidget {
  const _NewPhotoTile({
    required this.file,
    required this.isCover,
    required this.onTap,
    required this.onDelete,
  });

  final XFile file;
  final bool isCover;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 138,
            height: 154,
            padding: EdgeInsets.all(isCover ? 3 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: isCover
                  ? Border.all(
                color: AppColors.primary,
                width: 2,
              )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                isCover ? 19 : 22,
              ),
              child: Image.file(
                File(file.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (isCover)
          Positioned(
            left: 9,
            bottom: 9,
            child: _CoverBadge(),
          ),
        Positioned(
          right: 7,
          top: 7,
          child: _DeletePhotoButton(
            onTap: onDelete,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ADD PHOTO TILE
// =============================================================================

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 138,
        height: 154,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 21,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add photos',
              style: AppTextTheme.labelLarge.copyWith(
                fontSize: 11,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY PHOTO STATE
// =============================================================================

class _PhotoEmptyState extends StatelessWidget {
  const _PhotoEmptyState({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 28,
              color: AppColors.primary,
            ),
            const SizedBox(height: 9),
            Text(
              'Add photos to this memory',
              style: GoogleFonts.playfairDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Tap to choose from your device',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// COVER BADGE
// =============================================================================

class _CoverBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 11,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            'COVER',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DELETE PHOTO
// =============================================================================

class _DeletePhotoButton extends StatelessWidget {
  const _DeletePhotoButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 16,
          color: Colors.white,
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
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.82),
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
// SHEET ACTION
// =============================================================================

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? const Color(0xFF8D555C)
        : AppColors.textPrimary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 3,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: destructive
              ? const Color(0xFFF9E7E9)
              : const Color(0xFFFCE4EC),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: destructive
              ? const Color(0xFF8D555C)
              : AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: AppTextTheme.labelLarge.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextTheme.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      onTap: onTap,
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
      width: 42,
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

class _EditMemoryBackground extends StatelessWidget {
  const _EditMemoryBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.42,
                ),
              ),
            ),
          ),
          Positioned(
            top: 360,
            left: -130,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF3EEF4).withValues(
                  alpha: 0.50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



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
        0,
        0,
        0,
        0 + MediaQuery.viewInsetsOf(context).bottom,
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

