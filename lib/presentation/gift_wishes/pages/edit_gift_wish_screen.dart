import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_theme.dart';
import 'gift_wishes_home_screen.dart';


class EditGiftWishData {
  const EditGiftWishData({
    required this.originalWish,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.owner,
    required this.price,
    required this.note,
    required this.image,
    required this.removeImage,
  });

  final GiftWishItem originalWish;

  final String title;
  final String description;
  final String category;
  final GiftWishPriority priority;
  final GiftWishOwner owner;
  final double? price;
  final String note;

  final XFile? image;
  final bool removeImage;
}

class EditGiftWishScreen extends StatefulWidget {
  const EditGiftWishScreen({
    super.key,
    required this.wish,
    this.onBack,
    this.onSave,
    this.onDelete,
  });

  final GiftWishItem wish;

  final VoidCallback? onBack;
  final ValueChanged<EditGiftWishData>? onSave;
  final VoidCallback? onDelete;

  @override
  State<EditGiftWishScreen> createState() =>
      _EditGiftWishScreenState();
}

class _EditGiftWishScreenState
    extends State<EditGiftWishScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _noteController;

  late GiftWishPriority _priority;
  late GiftWishOwner _owner;
  late String _selectedCategory;

  XFile? _newImage;
  bool _removeImage = false;

  final List<String> _categories = const [
    'General',
    'Tech',
    'Beauty',
    'Fashion',
    'Books',
    'Travel',
    'Home',
    'Experiences',
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.wish.title,
    );

    _descriptionController = TextEditingController(
      text: widget.wish.description,
    );

    _priceController = TextEditingController(
      text: widget.wish.price == null
          ? ''
          : widget.wish.price!.toStringAsFixed(0),
    );

    _noteController = TextEditingController(
      text: widget.wish.note ?? '',
    );

    _priority = widget.wish.priority;
    _owner = widget.wish.owner;

    _selectedCategory = _categories.contains(
      widget.wish.category,
    )
        ? widget.wish.category
        : 'General';

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // IMAGE
  // ---------------------------------------------------------------------------

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) return;

      setState(() {
        _newImage = image;
        _removeImage = false;
      });
    } catch (_) {
      _showMessage('Could not open your photos.');
    }
  }

  void _removeWishImage() {
    setState(() {
      _newImage = null;
      _removeImage = true;
    });
  }

  // ---------------------------------------------------------------------------
  // SAVE
  // ---------------------------------------------------------------------------

  void _saveWish() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Give your wish a little name first.');
      return;
    }

    final priceText = _priceController.text.trim();

    double? price;

    if (priceText.isNotEmpty) {
      price = double.tryParse(
        priceText.replaceAll(',', ''),
      );

      if (price == null || price < 0) {
        _showMessage('Please enter a valid price.');
        return;
      }
    }

    final data = EditGiftWishData(
      originalWish: widget.wish,
      title: title,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _priority,
      owner: _owner,
      price: price,
      note: _noteController.text.trim(),
      image: _newImage,
      removeImage: _removeImage,
    );

    widget.onSave?.call(data);

    Navigator.of(context).pop();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            'Let this wish go?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'This little wish will be removed from your collection.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            18,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Keep it',
                style: AppTextTheme.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _EditBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(),
              ),

              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  130,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.05,
                        child: _buildTitleSection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.12,
                        child: _buildDescriptionSection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.19,
                        child: _buildCategorySection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.26,
                        child: _buildPrioritySection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.33,
                        child: _buildOwnerSection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.40,
                        child: _buildPriceSection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.47,
                        child: _buildImageSection(),
                      ),

                      const SizedBox(height: 20),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.54,
                        child: _buildNoteSection(),
                      ),

                      const SizedBox(height: 22),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.61,
                        child: _buildPreview(),
                      ),

                      const SizedBox(height: 22),

                      _AnimatedEntry(
                        controller: _animationController,
                        delay: 0.68,
                        child: _buildPrivacyNote(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          _buildBottomBar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          12,
          18,
          6,
        ),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack ??
                      () => Navigator.of(context).pop(),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                children: [
                  Text(
                    'GIFT WISHES',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.1,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Edit your wish',
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
              icon: Icons.delete_outline_rounded,
              onTap: _confirmDelete,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        12,
        22,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MAKE IT FEEL RIGHT',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'A little change.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 29,
              height: 1.12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Update the details of this little wish.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TITLE
  // ---------------------------------------------------------------------------

  Widget _buildTitleSection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'WISH NAME',
            title: 'What should we call it?',
            icon: Icons.edit_outlined,
          ),
          const SizedBox(height: 14),
          _TextFieldBox(
            controller: _titleController,
            hintText: 'Something I would love',
            maxLines: 1,
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESCRIPTION
  // ---------------------------------------------------------------------------

  Widget _buildDescriptionSection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'THE LITTLE STORY',
            title: 'Why do you want it?',
            icon: Icons.favorite_border_rounded,
          ),
          const SizedBox(height: 14),
          _TextFieldBox(
            controller: _descriptionController,
            hintText:
            'Tell the story behind this little wish...',
            maxLines: 5,
            minLines: 4,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY
  // ---------------------------------------------------------------------------

  Widget _buildCategorySection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'CATEGORY',
            title: 'Where does it belong?',
            icon: Icons.folder_outlined,
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in _categories)
                _ChoiceChip(
                  label: category,
                  selected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIORITY
  // ---------------------------------------------------------------------------

  Widget _buildPrioritySection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'HOW MUCH DO I WANT IT?',
            title: 'Set the feeling',
            icon: Icons.favorite_border_rounded,
          ),
          const SizedBox(height: 14),

          _PriorityOption(
            icon: Icons.favorite_border_rounded,
            title: 'Just a thought',
            subtitle: 'A tiny hint.',
            selected: _priority == GiftWishPriority.thought,
            onTap: () {
              setState(() {
                _priority = GiftWishPriority.thought;
              });
            },
          ),

          const SizedBox(height: 8),

          _PriorityOption(
            icon: Icons.favorite_rounded,
            title: 'Would love',
            subtitle: 'This would make me really happy.',
            selected:
            _priority == GiftWishPriority.wouldLove,
            onTap: () {
              setState(() {
                _priority = GiftWishPriority.wouldLove;
              });
            },
          ),

          const SizedBox(height: 8),

          _PriorityOption(
            icon: Icons.auto_awesome_rounded,
            title: 'Really want',
            subtitle: 'Okay, this one is special.',
            selected:
            _priority == GiftWishPriority.reallyWant,
            onTap: () {
              setState(() {
                _priority = GiftWishPriority.reallyWant;
              });
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OWNER
  // ---------------------------------------------------------------------------

  Widget _buildOwnerSection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'WHO IS THIS FOR?',
            title: 'Whose wish is it?',
            icon: Icons.people_outline_rounded,
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _OwnerOption(
                  icon: Icons.person_outline_rounded,
                  title: 'Mine',
                  subtitle: 'A wish for me',
                  selected: _owner == GiftWishOwner.me,
                  onTap: () {
                    setState(() {
                      _owner = GiftWishOwner.me;
                    });
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _OwnerOption(
                  icon: Icons.favorite_border_rounded,
                  title: "Love's",
                  subtitle: 'A wish for Love',
                  selected: _owner == GiftWishOwner.love,
                  onTap: () {
                    setState(() {
                      _owner = GiftWishOwner.love;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRICE
  // ---------------------------------------------------------------------------

  Widget _buildPriceSection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'OPTIONAL',
            title: 'Add a price',
            icon: Icons.currency_rupee_rounded,
          ),
          const SizedBox(height: 6),
          Text(
            'Just for reference. No pressure attached.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          _TextFieldBox(
            controller: _priceController,
            hintText: '0',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction: TextInputAction.next,
            prefix: const Padding(
              padding: EdgeInsets.only(
                left: 14,
                right: 4,
              ),
              child: Text(
                '₹',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // IMAGE
  // ---------------------------------------------------------------------------

  Widget _buildImageSection() {
    final hasOriginalImage =
        widget.wish.image != null && !_removeImage;

    final hasNewImage = _newImage != null;

    return _EditCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(4),
            child: _SectionHeader(
              eyebrow: 'A VISUAL LITTLE HINT',
              title: 'Wish image',
              icon: Icons.image_outlined,
            ),
          ),

          const SizedBox(height: 14),

          if (hasNewImage)
            _buildNewImage()
          else if (hasOriginalImage)
            _buildOriginalImage()
          else
            _buildImagePlaceholder(),
        ],
      ),
    );
  }

  Widget _buildOriginalImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 210,
            child: Image(
              image: widget.wish.image!,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 12,
            top: 12,
            child: _ImageBadge(
              label: 'CURRENT IMAGE',
            ),
          ),

          Positioned(
            right: 10,
            bottom: 10,
            child: Row(
              children: [
                _ImageActionButton(
                  icon: Icons.refresh_rounded,
                  label: 'Change',
                  onTap: _pickImage,
                ),
                const SizedBox(width: 7),
                _ImageActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove',
                  onTap: _removeWishImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 210,
            child: Image.file(
              File(_newImage!.path),
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 12,
            top: 12,
            child: _ImageBadge(
              label: 'NEW IMAGE',
            ),
          ),

          Positioned(
            right: 10,
            bottom: 10,
            child: Row(
              children: [
                _ImageActionButton(
                  icon: Icons.refresh_rounded,
                  label: 'Change',
                  onTap: _pickImage,
                ),
                const SizedBox(width: 7),
                _ImageActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove',
                  onTap: _removeWishImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F1F0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.7,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Add a new image',
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Something that reminds you of it',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NOTE
  // ---------------------------------------------------------------------------

  Widget _buildNoteSection() {
    return _EditCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'JUST BETWEEN US',
            title: 'A private little note',
            icon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: 6),
          Text(
            'Add something only the two of you need to know.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          _TextFieldBox(
            controller: _noteController,
            hintText:
            'Maybe remember the size, colour, or why I loved it...',
            maxLines: 4,
            minLines: 3,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PREVIEW
  // ---------------------------------------------------------------------------

  Widget _buildPreview() {
    final title = _titleController.text.trim().isEmpty
        ? 'Something I would love'
        : _titleController.text.trim();

    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, _) {
        final currentTitle =
        _titleController.text.trim().isEmpty
            ? 'Something I would love'
            : _titleController.text.trim();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            19,
            20,
            19,
            20,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E2526),
                Color(0xFF493638),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      size: 17,
                      color: Color(0xFFF4D7DA),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'A LITTLE WISH',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.7,
                      color: Colors.white.withValues(
                        alpha: 0.62,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                currentTitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  height: 1.12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.09,
                      ),
                      borderRadius: BorderRadius.circular(
                        999,
                      ),
                    ),
                    child: Text(
                      _selectedCategory,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        color: Colors.white.withValues(
                          alpha: 0.70,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Flexible(
                    child: Text(
                      _priorityText(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: Colors.white.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _priorityText() {
    switch (_priority) {
      case GiftWishPriority.thought:
        return 'Just a thought';

      case GiftWishPriority.wouldLove:
        return 'Would love';

      case GiftWishPriority.reallyWant:
        return 'Really want';
    }
  }

  // ---------------------------------------------------------------------------
  // PRIVACY
  // ---------------------------------------------------------------------------

  Widget _buildPrivacyNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFCE4EC),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Your wishes stay between you two. Edit anything you like — '
                'the little details are yours to keep.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM BAR
  // ---------------------------------------------------------------------------

  Widget _buildBottomBar() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 14,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveWish,
                  borderRadius: BorderRadius.circular(29),
                  splashColor: Colors.white.withValues(
                    alpha: 0.12,
                  ),
                  child: Ink(
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF765457),
                          Color(0xFF966E72),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.15,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: 0.24,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
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
                            color: Colors.white.withValues(
                              alpha: 0.14,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 23,
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
                                'Save changes',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Keep this little wish just right',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.labelSmall.copyWith(
                                  fontSize: 9.5,
                                  color: Colors.white.withValues(
                                    alpha: 0.70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(
                            right: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.12,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
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
      ),
    );
  }
}

// =============================================================================
// COMPONENTS
// =============================================================================

class _EditBackground extends StatelessWidget {
  const _EditBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.48,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 500,
            left: -120,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9F2).withValues(
                  alpha: 0.38,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditCard extends StatelessWidget {
  const _EditCard({
    required this.child,
    this.padding = const EdgeInsets.all(17),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.60,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
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

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.keyboardType,
    this.prefix,
  });

  final TextEditingController controller;
  final String hintText;

  final int maxLines;
  final int? minLines;

  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.60,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: AppTextTheme.bodyLarge.copyWith(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textDisabled,
          ),
          prefixIcon: prefix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : const Color(0xFFF7F1F0),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9.5,
              fontWeight: selected
                  ? FontWeight.w600
                  : FontWeight.w500,
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  const _PriorityOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFCE4EC)
                : const Color(0xFFFAF7F6),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.30)
                  : AppColors.outlineVariant.withValues(
                alpha: 0.50,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : const Color(0xFFF1EBEA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
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
                      title,
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnerOption extends StatelessWidget {
  const _OwnerOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFCE4EC)
                : const Color(0xFFFAF7F6),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.30)
                  : AppColors.outlineVariant.withValues(
                alpha: 0.50,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                title,
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageActionButton extends StatelessWidget {
  const _ImageActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.46),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      color: Colors.white.withValues(alpha: 0.80),
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

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
    this.delay = 0,
  });

  final AnimationController controller;
  final Widget child;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        1,
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