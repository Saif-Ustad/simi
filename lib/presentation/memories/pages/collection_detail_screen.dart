import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'edit_collection_screen.dart';
import 'memories_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  const CollectionDetailScreen({
    super.key,
    required this.collection,
    required this.memories,
    this.onMemoryTap,
    this.onAddMemory,
    this.onCollectionUpdated,
    this.onCollectionDeleted,
  });

  final MemoryFolder collection;

  final List<MemoryItem> memories;

  final ValueChanged<MemoryItem>? onMemoryTap;

  final VoidCallback? onAddMemory;

  final ValueChanged<MemoryFolder>? onCollectionUpdated;

  final VoidCallback? onCollectionDeleted;

  @override
  State<CollectionDetailScreen> createState() =>
      _CollectionDetailScreenState();
}

class _CollectionDetailScreenState
    extends State<CollectionDetailScreen> {
  late MemoryFolder _collection;

  @override
  void initState() {
    super.initState();
    _collection = widget.collection;
  }

  List<MemoryItem> get _collectionMemories {
    final result = widget.memories
        .where(
          (memory) =>
      memory.folder.toLowerCase() ==
          _collection.name.toLowerCase(),
    )
        .toList();

    result.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _CollectionBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHero(),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  130,
                ),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 560,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _buildCollectionInfo(),

                          const SizedBox(height: 28),

                          _buildMemoriesHeader(),

                          const SizedBox(height: 14),

                          if (_collectionMemories.isEmpty)
                            _buildEmptyState()
                          else
                            _buildMemoryList(),
                        ],
                      ),
                    ),
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

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    return SizedBox(
      height: 390,
      child: Stack(
        children: [
          Positioned.fill(
            child: _collection.coverImage != null
                ? Image(
              image: _collection.coverImage!,
              fit: BoxFit.cover,
            )
                : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5DDE0),
                    Color(0xFFE9DCE8),
                    Color(0xFFD9D9E9),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.collections_bookmark_outlined,
                  size: 58,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.28),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  stops: const [
                    0,
                    0.45,
                    1,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                0,
              ),
              child: Row(
                children: [
                  _HeroButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  const Spacer(),

                  _HeroButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: _showOptions,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 22,
            right: 22,
            bottom: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.18,
                        ),
                        borderRadius:
                        BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.25,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.collections_bookmark_outlined,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'COLLECTION',
                            style: AppTextTheme.labelSmall
                                .copyWith(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  _collection.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 34,
                    height: 1.08,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  '${_collectionMemories.length} '
                      '${_collectionMemories.length == 1 ? 'memory' : 'memories'}',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: Colors.white.withValues(
                      alpha: 0.88,
                    ),
                    fontSize: 12,
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
  // COLLECTION INFORMATION
  // ===========================================================================

  Widget _buildCollectionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_collection.description.trim().isNotEmpty) ...[
          Text(
            'ABOUT THIS COLLECTION',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            _collection.description,
            style: AppTextTheme.bodyLarge.copyWith(
              fontSize: 15,
              height: 1.65,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 18),
        ],

        Row(
          children: [
            _InfoPill(
              icon: Icons.photo_library_outlined,
              label:
              '${_collectionMemories.length} memories',
            ),

            const SizedBox(width: 8),

            if (_collection.createdAt != null)
              _InfoPill(
                icon: Icons.calendar_today_outlined,
                label:
                'Since ${_formatDate(_collection.createdAt!)}',
              ),
          ],
        ),

        if (_collection.tags.isNotEmpty) ...[
          const SizedBox(height: 17),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: _collection.tags.map(
                  (tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                  child: Text(
                    '#$tag',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // MEMORY HEADER
  // ===========================================================================

  Widget _buildMemoriesHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'THE MOMENTS',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Everything we kept',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        if (_collectionMemories.isNotEmpty)
          Text(
            '${_collectionMemories.length} moments',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  // ===========================================================================
  // MEMORY LIST
  // ===========================================================================

  Widget _buildMemoryList() {
    return Column(
      children: [
        ..._collectionMemories.map(
              (memory) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: _CollectionMemoryCard(
                memory: memory,
                onTap: () {
                  widget.onMemoryTap?.call(memory);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        36,
        24,
        36,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.78,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories_outlined,
              size: 31,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'This story is still waiting.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Add your first memory to this collection '
                'and give it something beautiful to hold.',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: widget.onAddMemory,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
              ),
              label: Text(
                'Add first memory',
                style:
                AppTextTheme.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM BAR
  // ===========================================================================

  Widget _buildBottomBar() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 18,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(maxWidth: 560),
            child: Container(
              height: 62,
              padding:
              const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.94,
                ),
                borderRadius:
                BorderRadius.circular(31),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.65),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.09,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _BottomAction(
                      icon: Icons.edit_outlined,
                      label: 'Edit collection',
                      onTap: _editCollection,
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.outlineVariant
                        .withValues(alpha: 0.55),
                  ),

                  Expanded(
                    child: _BottomAction(
                      icon: Icons.add_rounded,
                      label: 'Add memory',
                      filled: true,
                      onTap: widget.onAddMemory,
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
  // EDIT
  // ===========================================================================

  Future<void> _editCollection() async {
    final result =
    await Navigator.of(context).push<MemoryFolder>(
      MaterialPageRoute(
        builder: (_) => EditCollectionScreen(
          collection: _collection,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _collection = result;
    });

    widget.onCollectionUpdated?.call(result);
  }

  // ===========================================================================
  // OPTIONS
  // ===========================================================================

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (sheetContext) {
        return _CollectionOptionsSheet(
          onEdit: () {
            Navigator.pop(sheetContext);
            _editCollection();
          },
          onDelete: () {
            Navigator.pop(sheetContext);
            _confirmDelete();
          },
        );
      },
    );
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  Future<void> _confirmDelete() async {
    final shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Delete collection?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'The collection will be removed. '
                'Your memories should only be deleted if '
                'your data layer explicitly does that.',
            style: AppTextTheme.bodyMedium.copyWith(
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                AppColors.primary,
              ),
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    widget.onCollectionDeleted?.call();

    Navigator.of(context).pop();
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

    return '${date.day} ${months[date.month - 1]} '
        '${date.year}';
  }
}

// =============================================================================
// MEMORY CARD
// =============================================================================

class _CollectionMemoryCard extends StatelessWidget {
  const _CollectionMemoryCard({
    required this.memory,
    required this.onTap,
  });

  final MemoryItem memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final image = memory.displayImage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.86,
            ),
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(18),
                  child: SizedBox(
                    width: 102,
                    height: 102,
                    child: image != null
                        ? Image(
                      image: image,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color:
                      const Color(0xFFF3E9E7),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color:
                        AppColors.primary,
                        size: 27,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(memory.date),
                          style: AppTextTheme.labelSmall
                              .copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color:
                            AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          memory.title,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style:
                          GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            height: 1.15,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            AppColors.textPrimary,
                          ),
                        ),

                        if (memory.description
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(height: 5),

                          Text(
                            memory.description,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            AppTextTheme.bodyMedium
                                .copyWith(
                              fontSize: 11,
                              height: 1.4,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            if (memory.location.trim().isNotEmpty) ...[
                              const Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  memory.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextTheme.labelSmall.copyWith(
                                    fontSize: 9,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],

                            const Spacer(),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11,
                              color: AppColors.primary,
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

    return '${date.day} ${months[date.month - 1]} '
        '${date.year}';
  }
}

// =============================================================================
// OPTIONS SHEET
// =============================================================================

class _CollectionOptionsSheet
    extends StatelessWidget {
  const _CollectionOptionsSheet({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20,
      ),
      decoration:
      const BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration:
              BoxDecoration(
                color: AppColors
                    .outlineVariant,
                borderRadius:
                BorderRadius.circular(
                  999,
                ),
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            _SheetAction(
              icon: Icons.edit_outlined,
              title:
              'Edit collection',
              subtitle:
              'Change name, cover or details',
              onTap: onEdit,
            ),

            const SizedBox(
              height: 8,
            ),

            _SheetAction(
              icon:
              Icons.delete_outline_rounded,
              title:
              'Delete collection',
              subtitle:
              'Remove this collection',
              destructive: true,
              onTap: onDelete,
            ),

            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SMALL WIDGETS
// =============================================================================

class _HeroButton
    extends StatelessWidget {
  const _HeroButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black
          .withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder:
        const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _InfoPill
    extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration:
      BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.75),
        borderRadius:
        BorderRadius.circular(999),
        border: Border.all(
          color: AppColors
              .outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style:
            AppTextTheme.labelSmall
                .copyWith(
              fontSize: 9,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAction
    extends StatelessWidget {
  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(26),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style:
                AppTextTheme.labelLarge
                    .copyWith(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w600,
                  color: AppColors
                      .textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetAction
    extends StatelessWidget {
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
    final iconColor = destructive
        ? Colors.red.shade700
        : AppColors.primary;

    return Material(
      color: Colors.white
          .withValues(alpha: 0.75),
      borderRadius:
      BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(20),
        child: Padding(
          padding:
          const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                BoxDecoration(
                  color: destructive
                      ? Colors.red
                      .withValues(
                    alpha: 0.08,
                  )
                      : const Color(
                    0xFFFCE4EC,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: iconColor,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style:
                      AppTextTheme
                          .labelLarge
                          .copyWith(
                        fontWeight:
                        FontWeight.w600,
                        color: destructive
                            ? Colors.red
                            .shade700
                            : AppColors
                            .textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      subtitle,
                      style:
                      AppTextTheme
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
                size: 12,
                color:
                AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionBackground
    extends StatelessWidget {
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
              decoration:
              BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFFCE4EC,
                ).withValues(
                  alpha: 0.45,
                ),
              ),
            ),
          ),
          Positioned(
            top: 470,
            left: -110,
            child: Container(
              width: 220,
              height: 220,
              decoration:
              BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFECEAF3,
                ).withValues(
                  alpha: 0.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}