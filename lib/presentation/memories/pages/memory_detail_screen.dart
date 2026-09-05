import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'memories_screen.dart';

class MemoryDetailScreen extends StatefulWidget {
  const MemoryDetailScreen({
    super.key,
    required this.memory,
    this.onEdit,
    this.onDelete,
  });

  final MemoryItem memory;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  bool _showFullDescription = false;

  String get _monthName {
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

    return months[widget.memory.date.month - 1];
  }

  String get _formattedDate {
    return '${widget.memory.date.day} $_monthName ${widget.memory.date.year}';
  }

  String get _shortDate {
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

    return '${widget.memory.date.day} ${months[widget.memory.date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final images = <ImageProvider>[
      if (widget.memory.coverImage != null)
        widget.memory.coverImage!,
      ...widget.memory.images,
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _MemoryDetailBackground(),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildTopBar(context),
                ),

                SliverToBoxAdapter(
                  child: _buildHeroImage(images),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    24,
                    20,
                    120,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateAndFolder(),
                            const SizedBox(height: 12),
                            _buildTitle(),
                            const SizedBox(height: 16),
                            _buildDescription(),
                            if (widget.memory.tags.isNotEmpty) ...[
                              const SizedBox(height: 22),
                              _buildTags(),
                            ],
                            if (widget.memory.location.isNotEmpty) ...[
                              const SizedBox(height: 22),
                              _buildLocation(),
                            ],
                            const SizedBox(height: 28),
                            _buildMemoryInfo(),
                            const SizedBox(height: 28),
                            _buildLoveNote(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            _buildBottomActions(context),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),

          const Spacer(),

          Text(
            'MEMORY',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),

          const Spacer(),

          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: () => _showOptions(context),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HERO IMAGE
  // ===========================================================================

  Widget _buildHeroImage(List<ImageProvider> images) {
    final image = images.isNotEmpty ? images.first : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          child: GestureDetector(
            onTap: image == null
                ? null
                : () => _openImageViewer(images),
            child: Container(
              height: 360,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: image != null
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: image,
                    fit: BoxFit.cover,
                  ),

                  Positioned(
                    top: 18,
                    right: 18,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  // Bottom cinematic gradient.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x55000000),
                        ],
                        stops: [0.55, 1],
                      ),
                    ),
                  ),

                  Positioned(
                    left: 18,
                    bottom: 16,
                    child: _ImageBadge(
                      icon: Icons.photo_library_outlined,
                      text: images.length == 1
                          ? '1 photo'
                          : '${images.length} photos',
                    ),
                  ),

                  const Positioned(
                    right: 18,
                    bottom: 16,
                    child: _ImageBadge(
                      icon: Icons.fullscreen_rounded,
                      text: 'View',
                    ),
                  ),
                ],
              )
                  : const _MemoryImagePlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DATE + FOLDER
  // ===========================================================================

  Widget _buildDateAndFolder() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(
              alpha: 0.45,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                _formattedDate,
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        if (widget.memory.folder.isNotEmpty)
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.auto_stories_outlined,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    widget.memory.folder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
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
  // TITLE
  // ===========================================================================

  Widget _buildTitle() {
    return Text(
      widget.memory.title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ===========================================================================
  // DESCRIPTION
  // ===========================================================================

  Widget _buildDescription() {
    final description = widget.memory.description;

    final isLong = description.length > 220;

    final displayedText = isLong && !_showFullDescription
        ? '${description.substring(0, 220)}...'
        : description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayedText,
          style: AppTextTheme.bodyLarge.copyWith(
            fontSize: 15,
            height: 1.7,
            color: AppColors.textSecondary,
          ),
        ),

        if (isLong)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showFullDescription = !_showFullDescription;
                });
              },
              child: Text(
                _showFullDescription ? 'Show less' : 'Read more',
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
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

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          icon: Icons.sell_outlined,
          text: 'LITTLE DETAILS',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.memory.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              child: Text(
                '#$tag',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================================================================
  // LOCATION
  // ===========================================================================

  Widget _buildLocation() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.65),
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
            child: const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHERE IT HAPPENED',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.memory.location,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
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
  // MEMORY INFO
  // ===========================================================================

  Widget _buildMemoryInfo() {
    final imageCount = widget.memory.images.length +
        (widget.memory.coverImage != null ? 1 : 0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF322F2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoItem(
              icon: Icons.calendar_month_outlined,
              label: 'DATE',
              value: _shortDate,
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _InfoItem(
              icon: Icons.photo_library_outlined,
              label: 'PHOTOS',
              value: '$imageCount',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _InfoItem(
              icon: Icons.auto_stories_outlined,
              label: 'ALBUM',
              value: widget.memory.folder.isEmpty
                  ? 'None'
                  : widget.memory.folder,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // LOVE NOTE
  // ===========================================================================

  Widget _buildLoveNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC).withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 19,
            color: AppColors.primary,
          ),

          const SizedBox(height: 10),

          Text(
            'A little piece of us',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Some moments deserve to be remembered forever.',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 11,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM ACTIONS
  // ===========================================================================

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 18,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: _MemoryBottomBar(
            onFavorite: () {
              // Later: save favorite state.
            },
            onMore: () => _showOptions(context),
          ),
        ),
      ),
    );
  }
  // ===========================================================================
  // IMAGE VIEWER
  // ===========================================================================

  void _openImageViewer(List<ImageProvider> images) {
    if (images.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _MemoryImageViewer(
          images: images,
        ),
      ),
    );
  }

  // ===========================================================================
  // OPTIONS
  // ===========================================================================

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
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
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Memory options',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _PremiumSheetAction(
                  icon: Icons.edit_outlined,
                  title: 'Edit memory',
                  subtitle: 'Make changes to this memory',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onEdit?.call();
                  },
                ),

                _PremiumSheetAction(
                  icon: Icons.favorite_border_rounded,
                  title: 'Keep this close',
                  subtitle: 'Add this memory to your favorites',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    // Later: favorite memory.
                  },
                ),

                _PremiumSheetAction(
                  icon: Icons.ios_share_rounded,
                  title: 'Share memory',
                  subtitle: 'Send this little moment to someone',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    // Later: implement sharing.
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    height: 1,
                    color: AppColors.outlineVariant,
                  ),
                ),

                _PremiumSheetAction(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete memory',
                  subtitle: 'Remove this memory permanently',
                  destructive: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onDelete?.call();
                  },
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
      color: Colors.white.withValues(alpha: 0.78),
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
// IMAGE BADGE
// =============================================================================

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

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
            size: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PLACEHOLDER
// =============================================================================

class _MemoryImagePlaceholder extends StatelessWidget {
  const _MemoryImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFCE4EC),
            Color(0xFFF4E8E5),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            size: 34,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// INFO ITEM
// =============================================================================

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 17,
          color: const Color(0xFFE8B4B8),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 7,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}

// =============================================================================
// BOTTOM ACTION
// =============================================================================

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextTheme.labelLarge.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
// SHEET ACTION
// =============================================================================

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: destructive
              ? const Color(0xFFFFEBEE)
              : const Color(0xFFFCE4EC),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: destructive
              ? Colors.redAccent
              : AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: AppTextTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: destructive
              ? Colors.redAccent
              : AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

// =============================================================================
// IMAGE VIEWER
// =============================================================================

class _MemoryImageViewer extends StatefulWidget {
  const _MemoryImageViewer({
    required this.images,
  });

  final List<ImageProvider> images;

  @override
  State<_MemoryImageViewer> createState() => _MemoryImageViewerState();
}

class _MemoryImageViewerState extends State<_MemoryImageViewer> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Image(
                    image: widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _ViewerButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    '${_currentPage + 1} / ${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ViewerButton extends StatelessWidget {
  const _ViewerButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _MemoryDetailBackground extends StatelessWidget {
  const _MemoryDetailBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 80,
            right: -90,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(
                  alpha: 0.10,
                ),
              ),
            ),
          ),
          Positioned(
            top: 520,
            left: -110,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryBottomBar extends StatelessWidget {
  const _MemoryBottomBar({
    required this.onFavorite,
    required this.onMore,
  });

  final VoidCallback onFavorite;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),

          Expanded(
            child: Material(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(26),
              child: InkWell(
                onTap: onFavorite,
                borderRadius: BorderRadius.circular(26),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 19,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Keep this close',
                        style: AppTextTheme.labelLarge.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onMore,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 21,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 2),
        ],
      ),
    );
  }
}

class _PremiumSheetAction extends StatelessWidget {
  const _PremiumSheetAction({
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
        ? Colors.redAccent
        : AppColors.primary;

    final iconBackground = destructive
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFFCE4EC);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 11,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: destructive
                            ? Colors.redAccent
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

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