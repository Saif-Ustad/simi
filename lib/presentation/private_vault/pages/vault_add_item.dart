import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simi/presentation/private_vault/pages/vault_feature_screen.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class AddToVaultScreen extends StatefulWidget {
  const AddToVaultScreen({
    super.key,
    this.items = const [],
    this.onBack,
    this.onConfirm,
  });

  final List<VaultAddItem> items;
  final VoidCallback? onBack;
  final ValueChanged<List<VaultAddItem>>? onConfirm;

  @override
  State<AddToVaultScreen> createState() => _AddToVaultScreenState();
}

class _AddToVaultScreenState extends State<AddToVaultScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedIds = {};

  late final AnimationController _heroController;

  VaultFeatureType _selectedType = VaultFeatureType.memories;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  List<VaultAddItem> get _filteredItems {
    return widget.items
        .where((item) => item.type == _selectedType)
        .toList();
  }

  List<VaultAddItem> get _selectedItems {
    return widget.items
        .where((item) => _selectedIds.contains(item.id))
        .toList();
  }

  String _titleForType(VaultFeatureType type) {
    switch (type) {
      case VaultFeatureType.memories:
        return 'Memories';
      case VaultFeatureType.privateChat:
        return 'Conversations';
      case VaultFeatureType.specialDates:
        return 'Special Dates';
      case VaultFeatureType.giftWishes:
        return 'Gift Wishes';
      case VaultFeatureType.futureMessages:
        return 'Future Messages';
      case VaultFeatureType.loveNotifications:
        return 'Love Notes';
      case VaultFeatureType.photos:
        return 'Photos';
      case VaultFeatureType.videos:
        return 'Videos';
    }
  }

  String _subtitleForType(VaultFeatureType type) {
    switch (type) {
      case VaultFeatureType.memories:
        return 'Moments worth keeping close';
      case VaultFeatureType.privateChat:
        return 'Conversations meant for two';
      case VaultFeatureType.specialDates:
        return 'Dates that mean something';
      case VaultFeatureType.giftWishes:
        return 'Little things you secretly want';
      case VaultFeatureType.futureMessages:
        return 'Words waiting for the right day';
      case VaultFeatureType.loveNotifications:
        return 'Little reminders of your love';
      case VaultFeatureType.photos:
        return 'Photos only you two should see';
      case VaultFeatureType.videos:
        return 'Your private little movies';
    }
  }

  IconData _iconForType(VaultFeatureType type) {
    switch (type) {
      case VaultFeatureType.memories:
        return Icons.auto_awesome_outlined;
      case VaultFeatureType.privateChat:
        return Icons.chat_bubble_outline_rounded;
      case VaultFeatureType.specialDates:
        return Icons.calendar_today_outlined;
      case VaultFeatureType.giftWishes:
        return Icons.card_giftcard_outlined;
      case VaultFeatureType.futureMessages:
        return Icons.mail_outline_rounded;
      case VaultFeatureType.loveNotifications:
        return Icons.favorite_border_rounded;
      case VaultFeatureType.photos:
        return Icons.photo_library_outlined;
      case VaultFeatureType.videos:
        return Icons.videocam_outlined;
    }
  }

  void _toggleItem(VaultAddItem item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        _selectedIds.add(item.id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      final visibleIds = _filteredItems.map((e) => e.id);

      final allSelected =
      visibleIds.every(_selectedIds.contains);

      if (allSelected) {
        _selectedIds.removeAll(visibleIds);
      } else {
        _selectedIds.addAll(visibleIds);
      }
    });
  }

  void _confirm() {
    if (_selectedItems.isEmpty) return;

    widget.onConfirm?.call(
      List.unmodifiable(_selectedItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _VaultBackground(),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          150,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              _buildHero(),
                              const SizedBox(height: 30),
                              _buildQuestion(),
                              const SizedBox(height: 14),
                              _buildCategories(),
                              const SizedBox(height: 28),
                              _buildItemsHeader(),
                              const SizedBox(height: 12),
                              _buildItems(),
                              const SizedBox(height: 24),
                              _buildPrivacyNote(),
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
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          const SizedBox(width: 10),

          _RoundIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: widget.onBack ??
                    () => Navigator.of(context).pop(),
          ),

          Expanded(
            child: Center(
              child: Text(
                'Private Vault',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          _RoundIconButton(
            icon: Icons.lock_outline_rounded,
            onTap: () {},
          ),

          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HERO
  // ------------------------------------------------------------

  Widget _buildHero() {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, child) {
        final glow = 0.04 + (_heroController.value * 0.05);

        return Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            22,
            22,
            24,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF151313),
                Color(0xFF292122),
                Color(0xFF3A292C),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: glow),
                blurRadius: 35,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedLock(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KEEP IT BETWEEN US',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: const Color(0xFFE8B4B8),
                        letterSpacing: 1.7,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Some things are\njust ours.',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        height: 1.08,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Choose the moments, words and little '
                          'things you want to keep inside your '
                          'private world.',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color:
                        Colors.white.withValues(alpha: 0.62),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLock() {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, child) {
        final scale =
            1 + (_heroController.value * 0.035);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.09),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: const Icon(
          Icons.lock_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // QUESTION
  // ------------------------------------------------------------

  Widget _buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT DO YOU WANT TO KEEP CLOSE?',
          style: AppTextTheme.labelSmall.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.15,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose your private world.',
          style: GoogleFonts.playfairDisplay(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CATEGORIES
  // ------------------------------------------------------------

  Widget _buildCategories() {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: VaultFeatureType.values.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final type = VaultFeatureType.values[index];

          return _CategoryCard(
            title: _titleForType(type),
            icon: _iconForType(type),
            selected: _selectedType == type,
            onTap: () {
              setState(() {
                _selectedType = type;
              });
            },
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // ITEMS HEADER
  // ------------------------------------------------------------

  Widget _buildItemsHeader() {
    final items = _filteredItems;

    final selectedInCategory = items
        .where((item) => _selectedIds.contains(item.id))
        .length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                _titleForType(_selectedType),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _subtitleForType(_selectedType),
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        if (items.isNotEmpty)
          TextButton(
            onPressed: _selectAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              minimumSize: Size.zero,
              tapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              selectedInCategory == items.length
                  ? 'Clear all'
                  : 'Select all',
              style: AppTextTheme.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ITEMS
  // ------------------------------------------------------------

  Widget _buildItems() {
    final items = _filteredItems;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        ...items.map(
              (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _VaultSelectableCard(
              item: item,
              selected:
              _selectedIds.contains(item.id),
              icon: _iconForType(item.type),
              onTap: () => _toggleItem(item),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForType(_selectedType),
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nothing here yet',
            style: GoogleFonts.playfairDisplay(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _subtitleForType(_selectedType),
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PRIVACY
  // ------------------------------------------------------------

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFEC)
            .withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.primary,
            size: 19,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'Private means private. These items will '
                  'only appear inside your protected vault.',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM ACTION
  // ------------------------------------------------------------

  Widget _buildBottomAction() {
    final count = _selectedIds.length;
    final hasSelection = count > 0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16,
          sigmaY: 16,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface
                .withValues(alpha: 0.90),
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.35),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 220,
              ),
              height: 56,
              decoration: BoxDecoration(
                gradient: hasSelection
                    ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF795458),
                    Color(0xFF986F73),
                  ],
                )
                    : null,
                color: hasSelection
                    ? null
                    : AppColors.primary
                    .withValues(alpha: 0.13),
                borderRadius:
                BorderRadius.circular(28),
                boxShadow: hasSelection
                    ? [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: hasSelection
                      ? _confirm
                      : null,
                  borderRadius:
                  BorderRadius.circular(28),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 19,
                        color: hasSelection
                            ? Colors.white
                            : AppColors.textSecondary
                            .withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 9),
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        child: Text(
                          hasSelection
                              ? 'Keep $count '
                              '${count == 1 ? 'thing' : 'things'} private'
                              : 'Choose something to protect',
                          key: ValueKey(
                            hasSelection,
                          ),
                          style: AppTextTheme.labelLarge
                              .copyWith(
                            color: hasSelection
                                ? Colors.white
                                : AppColors
                                .textSecondary
                                .withValues(
                              alpha: 0.55,
                            ),
                            fontWeight:
                            FontWeight.w600,
                          ),
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
}

// ============================================================
// BACKGROUND
// ============================================================

class _VaultBackground extends StatelessWidget {
  const _VaultBackground();

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
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY CARD
// ============================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 88,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outlineVariant
                .withValues(alpha: 0.65),
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary
                  .withValues(alpha: 0.16),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SELECTABLE ITEM
// ============================================================

class _VaultSelectableCard extends StatelessWidget {
  const _VaultSelectableCard({
    required this.item,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final VaultAddItem item;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 0.985 : 1,
      duration: const Duration(milliseconds: 160),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFFCE4EC)
                  : Colors.white,
              borderRadius:
              BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.outlineVariant
                    .withValues(alpha: 0.60),
                width: selected ? 1.3 : 1,
              ),
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: AppColors.primary
                      .withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
                  : null,
            ),
            child: Row(
              children: [
                _buildImage(),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: AppTextTheme.bodyLarge
                            .copyWith(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: AppTextTheme.bodyMedium
                            .copyWith(
                          fontSize: 11,
                          color:
                          AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      if (item.dateLabel != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 12,
                              color:
                              AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.dateLabel!,
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color:
                                AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _buildCheck(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (item.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image(
          image: item.image!,
          width: 62,
          height: 62,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.70)
            : const Color(0xFFF5EFEC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        size: 24,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildCheck() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? AppColors.primary
            : Colors.transparent,
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.outlineVariant,
          width: 1.5,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 160),
        child: selected
            ? const Icon(
          Icons.check_rounded,
          key: ValueKey('checked'),
          size: 17,
          color: Colors.white,
        )
            : const SizedBox(
          key: ValueKey('unchecked'),
        ),
      ),
    );
  }
}

// ============================================================
// ROUND BUTTON
// ============================================================

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
      color: Colors.white.withValues(alpha: 0.65),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}


class VaultAddItem {
  const VaultAddItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.image,
    this.dateLabel,
    this.isAlreadyPrivate = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final VaultFeatureType type;
  final ImageProvider? image;
  final String? dateLabel;

  final bool isAlreadyPrivate;
}