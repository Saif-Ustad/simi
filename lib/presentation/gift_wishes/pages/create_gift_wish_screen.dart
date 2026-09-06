import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_theme.dart';
import 'gift_wishes_home_screen.dart';



// ============================================================
// DATA
// ============================================================

class CreateGiftWishData {
  const CreateGiftWishData({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.owner,
    required this.price,
    required this.note,
    required this.image,
  });

  final String title;
  final String description;
  final String category;
  final GiftWishPriority priority;
  final GiftWishOwner owner;
  final double? price;
  final String note;
  final XFile? image;
}


// ============================================================
// SCREEN
// ============================================================

class CreateGiftWishScreen extends StatefulWidget {
  const CreateGiftWishScreen({
    super.key,
    this.onBack,
    this.onSave,
  });

  final VoidCallback? onBack;
  final ValueChanged<CreateGiftWishData>? onSave;

  @override
  State<CreateGiftWishScreen> createState() =>
      _CreateGiftWishScreenState();
}


// ============================================================
// STATE
// ============================================================

class _CreateGiftWishScreenState extends State<CreateGiftWishScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _descriptionController =
  TextEditingController();

  final TextEditingController _priceController =
  TextEditingController();

  final TextEditingController _noteController =
  TextEditingController();

  GiftWishPriority _priority = GiftWishPriority.wouldLove;

  GiftWishOwner _owner = GiftWishOwner.me;

  String _selectedCategory = 'General';

  XFile? _image;

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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
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


  // ==========================================================
  // ACTIONS
  // ==========================================================

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) return;

      setState(() {
        _image = image;
      });
    } catch (_) {
      _showMessage('Could not open your photos.');
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  void _saveWish() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Give your wish a little name first.');
      return;
    }

    double? price;

    final priceText = _priceController.text.trim();

    if (priceText.isNotEmpty) {
      price = double.tryParse(
        priceText.replaceAll(',', ''),
      );

      if (price == null) {
        _showMessage('Enter a valid price.');
        return;
      }
    }

    final data = CreateGiftWishData(
      title: title,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _priority,
      owner: _owner,
      price: price,
      note: _noteController.text.trim(),
      image: _image,
    );

    widget.onSave?.call(data);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            90,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }


  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _GiftWishBackground(),

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
                  140,
                ),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 560,
                      ),
                      child: _buildContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }


  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 68,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Row(
            children: [
              _CircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: widget.onBack ??
                        () => Navigator.of(context).pop(),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GIFT WISHES',
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        letterSpacing: 2.2,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A little wish',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              _CircleButton(
                icon: Icons.favorite_border_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ==========================================================
  // CONTENT
  // ==========================================================

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHero(),

        const SizedBox(height: 26),

        _buildSectionLabel(
          'WHAT ARE YOU WISHING FOR?',
          'Something you would love to have',
        ),

        const SizedBox(height: 14),

        _buildTitleCard(),

        const SizedBox(height: 24),

        _buildDescriptionCard(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'A LITTLE CATEGORY',
          'Help us keep your wishes organised',
        ),

        const SizedBox(height: 14),

        _buildCategorySelector(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'HOW MUCH DO YOU WANT IT?',
          'No pressure — just a little signal',
        ),

        const SizedBox(height: 14),

        _buildPrioritySelector(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'WHO IS WISHING?',
          'Just so we know whose little wish this is',
        ),

        const SizedBox(height: 14),

        _buildOwnerSelector(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'A ROUGH PRICE',
          'Optional — only if you know',
        ),

        const SizedBox(height: 14),

        _buildPriceCard(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'MAKE IT VISUAL',
          'Add a photo if there is one',
        ),

        const SizedBox(height: 14),

        _buildImageCard(),

        const SizedBox(height: 28),

        _buildSectionLabel(
          'A LITTLE NOTE',
          'Anything else you want your love to know',
        ),

        const SizedBox(height: 14),

        _buildNoteCard(),

        const SizedBox(height: 30),

        _buildPreview(),

        const SizedBox(height: 22),

        _buildPrivacyNote(),
      ],
    );
  }


  // ==========================================================
  // HERO
  // ==========================================================

  Widget _buildHero() {
    return _AnimatedEntry(
      controller: _animationController,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          22,
          24,
          22,
          25,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFCE4EC),
              Color(0xFFF8EDEB),
              Color(0xFFF5EAE8),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 26,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JUST A LITTLE WISH',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.8,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Maybe someday…',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Leave a tiny hint for the person who knows you best.',
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.4,
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


  // ==========================================================
  // TITLE
  // ==========================================================

  Widget _buildTitleCard() {
    return _InputCard(
      child: TextField(
        controller: _titleController,
        onChanged: (_) => setState(() {}),
        textCapitalization: TextCapitalization.sentences,
        style: GoogleFonts.playfairDisplay(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Something I secretly want',
          hintStyle: GoogleFonts.playfairDisplay(
            fontSize: 18,
            color: AppColors.textDisabled,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: 21,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 17,
          ),
        ),
      ),
    );
  }


  // ==========================================================
  // DESCRIPTION
  // ==========================================================

  Widget _buildDescriptionCard() {
    return _InputCard(
      child: TextField(
        controller: _descriptionController,
        onChanged: (_) => setState(() {}),
        textCapitalization: TextCapitalization.sentences,
        maxLines: 4,
        minLines: 3,
        style: AppTextTheme.bodyMedium.copyWith(
          fontSize: 13,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText:
          'Why do you want it? Tell your love a little about it…',
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            fontSize: 13,
            color: AppColors.textDisabled,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }


  // ==========================================================
  // CATEGORY
  // ==========================================================

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in _categories)
          _SelectionChip(
            label: category,
            selected: _selectedCategory == category,
            icon: _categoryIcon(category),
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
      ],
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Tech':
        return Icons.devices_other_rounded;

      case 'Beauty':
        return Icons.spa_outlined;

      case 'Fashion':
        return Icons.checkroom_outlined;

      case 'Books':
        return Icons.menu_book_outlined;

      case 'Travel':
        return Icons.flight_takeoff_rounded;

      case 'Home':
        return Icons.home_outlined;

      case 'Experiences':
        return Icons.auto_awesome_rounded;

      default:
        return Icons.grid_view_rounded;
    }
  }


  // ==========================================================
  // PRIORITY
  // ==========================================================

  Widget _buildPrioritySelector() {
    return Column(
      children: [
        _PriorityOption(
          title: 'Just a thought',
          subtitle: 'I saw it and liked it.',
          icon: Icons.lightbulb_outline_rounded,
          priority: GiftWishPriority.thought,
          selected: _priority == GiftWishPriority.thought,
          onTap: () {
            setState(() {
              _priority = GiftWishPriority.thought;
            });
          },
        ),

        const SizedBox(height: 8),

        _PriorityOption(
          title: 'Would love',
          subtitle: 'This would make me really happy.',
          icon: Icons.favorite_border_rounded,
          priority: GiftWishPriority.wouldLove,
          selected: _priority == GiftWishPriority.wouldLove,
          onTap: () {
            setState(() {
              _priority = GiftWishPriority.wouldLove;
            });
          },
        ),

        const SizedBox(height: 8),

        _PriorityOption(
          title: 'Really want',
          subtitle: 'Okay… this one is special.',
          icon: Icons.favorite_rounded,
          priority: GiftWishPriority.reallyWant,
          selected: _priority == GiftWishPriority.reallyWant,
          onTap: () {
            setState(() {
              _priority = GiftWishPriority.reallyWant;
            });
          },
        ),
      ],
    );
  }


  // ==========================================================
  // OWNER
  // ==========================================================

  Widget _buildOwnerSelector() {
    return Row(
      children: [
        Expanded(
          child: _OwnerCard(
            title: 'Mine',
            subtitle: 'Something I want',
            icon: Icons.person_outline_rounded,
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
          child: _OwnerCard(
            title: 'Love\'s',
            subtitle: 'Something they want',
            icon: Icons.favorite_border_rounded,
            selected: _owner == GiftWishOwner.love,
            onTap: () {
              setState(() {
                _owner = GiftWishOwner.love;
              });
            },
          ),
        ),
      ],
    );
  }


  // ==========================================================
  // PRICE
  // ==========================================================

  Widget _buildPriceCard() {
    return _InputCard(
      child: TextField(
        controller: _priceController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        onChanged: (_) => setState(() {}),
        style: AppTextTheme.bodyLarge.copyWith(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'e.g. 24999',
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textDisabled,
          ),
          prefixText: '₹ ',
          prefixStyle: AppTextTheme.bodyLarge.copyWith(
            fontSize: 15,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: const Icon(
            Icons.sell_outlined,
            size: 20,
            color: AppColors.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 17,
          ),
        ),
      ),
    );
  }


  // ==========================================================
  // IMAGE
  // ==========================================================

  Widget _buildImageCard() {
    if (_image == null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.65,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primary,
                    size: 23,
                  ),
                ),

                const SizedBox(height: 11),

                Text(
                  'Add a photo',
                  style: AppTextTheme.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'A picture makes the wish easier to remember.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 210,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(_image!.path),
            fit: BoxFit.cover,
          ),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.58),
                ],
              ),
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: _CircleButton(
              icon: Icons.close_rounded,
              light: true,
              onTap: _removeImage,
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 17,
                  color: Colors.white,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Wish photo added',
                    style: AppTextTheme.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // NOTE
  // ==========================================================

  Widget _buildNoteCard() {
    return _InputCard(
      child: TextField(
        controller: _noteController,
        onChanged: (_) => setState(() {}),
        textCapitalization: TextCapitalization.sentences,
        maxLines: 4,
        minLines: 3,
        style: AppTextTheme.bodyMedium.copyWith(
          fontSize: 13,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText:
          '“I have wanted this for ages…”\n\nor leave a tiny hint ❤️',
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textDisabled,
            height: 1.5,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(
              left: 14,
              top: 15,
            ),
            child: Icon(
              Icons.edit_note_rounded,
              size: 21,
              color: AppColors.primary,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(
            4,
            15,
            14,
            15,
          ),
        ),
      ),
    );
  }


  // ==========================================================
  // PREVIEW
  // ==========================================================

  Widget _buildPreview() {
    final title = _titleController.text.trim().isEmpty
        ? 'Your little wish'
        : _titleController.text.trim();

    final description =
    _descriptionController.text.trim().isEmpty
        ? 'Something worth remembering.'
        : _descriptionController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF322F2E),
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
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: Color(0xFFF6D9DC),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'WISH PREVIEW',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.7,
                  color: Colors.white.withValues(alpha: 0.58),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.playfairDisplay(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 11,
              height: 1.45,
              color: Colors.white.withValues(alpha: 0.66),
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _PreviewPill(
                icon: _categoryIcon(_selectedCategory),
                label: _selectedCategory,
              ),

              _PreviewPill(
                icon: _priorityIcon(_priority),
                label: _priorityLabel(_priority),
              ),

              _PreviewPill(
                icon: _owner == GiftWishOwner.me
                    ? Icons.person_outline_rounded
                    : Icons.favorite_border_rounded,
                label: _owner == GiftWishOwner.me
                    ? 'Mine'
                    : 'Love\'s',
              ),

              if (_priceController.text.trim().isNotEmpty)
                _PreviewPill(
                  icon: Icons.sell_outlined,
                  label: '₹${_priceController.text.trim()}',
                ),
            ],
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // PRIVACY
  // ==========================================================

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        13,
        15,
        13,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: AppColors.primary,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              'Your wishes stay between you two. '
                  'This is your little place for hints, dreams '
                  'and things worth remembering.',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // BOTTOM ACTION
  // ==========================================================

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _saveWish,
                borderRadius: BorderRadius.circular(29),
                splashColor: Colors.white.withValues(
                  alpha: 0.12,
                ),
                highlightColor: Colors.white.withValues(
                  alpha: 0.06,
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
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
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
                              'Keep this wish',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              GoogleFonts.playfairDisplay(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              'Save it for the right moment',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: AppTextTheme.labelSmall
                                  .copyWith(
                                color: Colors.white
                                    .withValues(alpha: 0.72),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

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
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.14,
                            ),
                          ),
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
    );
  }


  // ==========================================================
  // HELPERS
  // ==========================================================

  Widget _buildSectionLabel(
      String title,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.7,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  IconData _priorityIcon(GiftWishPriority priority) {
    switch (priority) {
      case GiftWishPriority.thought:
        return Icons.lightbulb_outline_rounded;

      case GiftWishPriority.wouldLove:
        return Icons.favorite_border_rounded;

      case GiftWishPriority.reallyWant:
        return Icons.favorite_rounded;
    }
  }

  String _priorityLabel(GiftWishPriority priority) {
    switch (priority) {
      case GiftWishPriority.thought:
        return 'Just a thought';

      case GiftWishPriority.wouldLove:
        return 'Would love';

      case GiftWishPriority.reallyWant:
        return 'Really want';
    }
  }
}


// ============================================================
// INPUT CARD
// ============================================================

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}


// ============================================================
// SELECTION CHIP
// ============================================================

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.72),
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
                icon,
                size: 13,
                color: selected
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: selected
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// PRIORITY OPTION
// ============================================================

class _PriorityOption extends StatelessWidget {
  const _PriorityOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.priority,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final GiftWishPriority priority;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFCE4EC)
                : Colors.white.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.38)
                  : AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFFF5EFED),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? Colors.white
                      : AppColors.textSecondary,
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
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: Colors.white,
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


// ============================================================
// OWNER CARD
// ============================================================

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(
            14,
            15,
            12,
            15,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFCE4EC)
                : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFFF5EFED),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: selected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 12,
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
      ),
    );
  }
}


// ============================================================
// PREVIEW PILL
// ============================================================

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 150,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: const Color(0xFFF6D9DC),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8.5,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// CIRCLE BUTTON
// ============================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.light = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: light
                ? Colors.black.withValues(alpha: 0.30)
                : Colors.white.withValues(alpha: 0.76),
            shape: BoxShape.circle,
            border: Border.all(
              color: light
                  ? Colors.white.withValues(alpha: 0.22)
                  : AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: light
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}


// ============================================================
// BACKGROUND
// ============================================================

class _GiftWishBackground extends StatelessWidget {
  const _GiftWishBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 90,
            right: -80,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.45,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 510,
            left: -100,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8).withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 160,
            right: -70,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91).withValues(
                  alpha: 0.035,
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


// ============================================================
// ANIMATION
// ============================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.child,
  });

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(
          controller.value,
        );

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              16 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}