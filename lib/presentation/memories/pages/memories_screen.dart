// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_text_theme.dart';
//
// class MemoriesScreen extends StatefulWidget {
//   const MemoriesScreen({
//     super.key,
//     this.memories = const [],
//     this.onMemoryTap,
//     this.onCreateMemory,
//     this.onFolderTap,
//   });
//
//   final List<MemoryItem> memories;
//   final ValueChanged<MemoryItem>? onMemoryTap;
//   final VoidCallback? onCreateMemory;
//   final ValueChanged<MemoryFolder>? onFolderTap;
//
//   @override
//   State<MemoriesScreen> createState() => _MemoriesScreenState();
// }
//
// class _MemoriesScreenState extends State<MemoriesScreen>
//     with SingleTickerProviderStateMixin {
//   MemoryViewMode _viewMode = MemoryViewMode.timeline;
//
//   late final AnimationController _switchController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _switchController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
//
//   @override
//   void dispose() {
//     _switchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//
//       floatingActionButton: _viewMode == MemoryViewMode.timeline
//           ? _buildAddMemoryButton()
//           : null,
//
//       floatingActionButtonLocation:
//       FloatingActionButtonLocation.endFloat,
//
//       body: SafeArea(
//         bottom: false,
//         child: Stack(
//           children: [
//             const _MemoriesBackground(),
//
//             CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(
//                     20,
//                     14,
//                     20,
//                     130,
//                   ),
//                   sliver: SliverToBoxAdapter(
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(
//                           maxWidth: 520,
//                         ),
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//                             _buildHeader(),
//
//                             const SizedBox(height: 24),
//
//                             _buildViewSwitcher(),
//
//                             const SizedBox(height: 28),
//
//                             AnimatedSwitcher(
//                               duration: const Duration(
//                                 milliseconds: 280,
//                               ),
//                               child: _viewMode ==
//                                   MemoryViewMode.timeline
//                                   ? _buildTimeline()
//                                   : _buildCollections(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // HEADER
//   // ===========================================================================
//
//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'OUR STORY',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 9,
//                       letterSpacing: 2,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primary,
//                     ),
//                   ),
//
//                   const SizedBox(height: 5),
//
//                   Text(
//                     'Our memories',
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 30,
//                       height: 1.15,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // No plus icon here.
//             // The only add action is the floating button.
//             _MemoryCount(
//               count: widget.memories.length,
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 8),
//
//         Text(
//           widget.memories.isEmpty
//               ? 'A place for all the little moments that became yours.'
//               : 'A collection of moments worth remembering.',
//           style: AppTextTheme.bodyMedium.copyWith(
//             fontSize: 12,
//             height: 1.45,
//             color: AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ===========================================================================
//   // MOMENTS / COLLECTIONS SWITCH
//   // ===========================================================================
//
//   Widget _buildViewSwitcher() {
//     final isMoments = _viewMode == MemoryViewMode.timeline;
//
//     return Center(
//       child: Container(
//         height: 52,
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha: 0.72),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.55,
//             ),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.035),
//               blurRadius: 18,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               children: [
//                 // Animated selected background
//                 AnimatedAlign(
//                   duration: const Duration(milliseconds: 320),
//                   curve: Curves.easeOutCubic,
//                   alignment: isMoments
//                       ? Alignment.centerLeft
//                       : Alignment.centerRight,
//                   child: FractionallySizedBox(
//                     widthFactor: 0.5,
//                     heightFactor: 1,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF795458),
//                             Color(0xFF956C70),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(14),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.primary.withValues(
//                               alpha: 0.20,
//                             ),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _MemoryModeButton(
//                         icon: Icons.auto_awesome_rounded,
//                         label: 'Moments',
//                         selected: isMoments,
//                         onTap: () {
//                           setState(() {
//                             _viewMode = MemoryViewMode.timeline;
//                           });
//                         },
//                       ),
//                     ),
//
//                     Expanded(
//                       child: _MemoryModeButton(
//                         icon: Icons.photo_library_rounded,
//                         label: 'Albums',
//                         selected: !isMoments,
//                         onTap: () {
//                           setState(() {
//                             _viewMode = MemoryViewMode.folders;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // TIMELINE
//   // ===========================================================================
//
//   Widget _buildTimeline() {
//     if (widget.memories.isEmpty) {
//       return const _EmptyMemories();
//     }
//
//     final memories = [...widget.memories]
//       ..sort(
//             (a, b) => b.date.compareTo(a.date),
//       );
//
//     final grouped = <int, List<MemoryItem>>{};
//
//     for (final memory in memories) {
//       grouped.putIfAbsent(
//         memory.date.year,
//             () => [],
//       );
//
//       grouped[memory.date.year]!.add(memory);
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         for (final entry in grouped.entries) ...[
//           _TimelineYear(
//             year: entry.key,
//           ),
//
//           const SizedBox(height: 18),
//
//           ...List.generate(
//             entry.value.length,
//                 (index) {
//               final memory = entry.value[index];
//
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: index == entry.value.length - 1
//                       ? 34
//                       : 22,
//                 ),
//                 child: _MemoryTimelineItem(
//                   memory: memory,
//                   isLast: index == entry.value.length - 1,
//                   onTap: () {
//                     widget.onMemoryTap?.call(memory);
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ],
//     );
//   }
//
//   // ===========================================================================
//   // COLLECTIONS
//   // ===========================================================================
//
//   Widget _buildCollections() {
//     final folders = _createFolders();
//
//     if (folders.isEmpty) {
//       return const _EmptyCollections();
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'YOUR ALBUMS',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 9,
//                       letterSpacing: 1.7,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Little chapters of us',
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 19,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Text(
//               '${folders.length} albums',
//               style: AppTextTheme.labelSmall.copyWith(
//                 fontSize: 9,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 18),
//
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: folders.length,
//           gridDelegate:
//           const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 14,
//             childAspectRatio: 0.78,
//           ),
//           itemBuilder: (context, index) {
//             final folder = folders[index];
//
//             return _AlbumCard(
//               folder: folder,
//               onTap: () {
//                 widget.onFolderTap?.call(folder);
//               },
//             );
//           },
//         ),
//
//         const SizedBox(height: 16),
//
//         _CreateAlbumCard(
//           onTap: () {
//             // Later:
//             // context.push(AppRoutes.createAlbum);
//           },
//         ),
//       ],
//     );
//   }
//
//   List<MemoryFolder> _createFolders() {
//     final map = <String, List<MemoryItem>>{};
//
//     for (final memory in widget.memories) {
//       map.putIfAbsent(
//         memory.folder,
//             () => [],
//       ).add(memory);
//     }
//
//     return map.entries.map((entry) {
//       final items = entry.value;
//
//       return MemoryFolder(
//         name: entry.key,
//         count: items.length,
//         coverImage: items
//             .where((e) => e.image != null)
//             .map((e) => e.image)
//             .firstOrNull,
//       );
//     }).toList();
//   }
//
//   // ===========================================================================
//   // ADD MEMORY
//   // ===========================================================================
//
//   Widget _buildAddMemoryButton() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(999),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withValues(alpha: 0.22),
//             blurRadius: 18,
//             offset: const Offset(0, 7),
//           ),
//         ],
//       ),
//       child: FloatingActionButton.extended(
//         onPressed: widget.onCreateMemory,
//         backgroundColor: AppColors.primary,
//         foregroundColor: AppColors.onPrimary,
//         elevation: 0,
//         highlightElevation: 0,
//         extendedIconLabelSpacing: 7,
//         shape: const StadiumBorder(),
//         icon: Container(
//           width: 28,
//           height: 28,
//           decoration: BoxDecoration(
//             color: AppColors.onPrimary.withValues(alpha: 0.14),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.add_rounded,
//             size: 17,
//           ),
//         ),
//         label: Text(
//           'Add a memory',
//           style: AppTextTheme.buttonPrimary.copyWith(
//             color: AppColors.onPrimary,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // =============================================================================
// // MEMORY COUNT
// // =============================================================================
//
// class _MemoryCount extends StatelessWidget {
//   const _MemoryCount({
//     required this.count,
//   });
//
//   final int count;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           '$count',
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: AppColors.primary,
//           ),
//         ),
//         Text(
//           count == 1 ? 'memory' : 'memories',
//           style: AppTextTheme.labelSmall.copyWith(
//             fontSize: 9,
//             color: AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // =============================================================================
// // MEMORY TAB
// // =============================================================================
//
// class _MemoryTab extends StatelessWidget {
//   const _MemoryTab({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 4,
//         ),
//         child: Text(
//           label,
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 16,
//             fontWeight: selected
//                 ? FontWeight.w600
//                 : FontWeight.w400,
//             color: selected
//                 ? AppColors.textPrimary
//                 : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // YEAR
// // =============================================================================
//
// class _TimelineYear extends StatelessWidget {
//   const _TimelineYear({
//     required this.year,
//   });
//
//   final int year;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: const BoxDecoration(
//             color: AppColors.primaryContainer,
//             shape: BoxShape.circle,
//           ),
//         ),
//
//         const SizedBox(width: 8),
//
//         Text(
//           '$year',
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 19,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//
//         const SizedBox(width: 12),
//
//         Expanded(
//           child: Container(
//             height: 1,
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // =============================================================================
// // TIMELINE ITEM
// // =============================================================================
//
// class _MemoryTimelineItem extends StatelessWidget {
//   const _MemoryTimelineItem({
//     required this.memory,
//     required this.isLast,
//     required this.onTap,
//   });
//
//   final MemoryItem memory;
//   final bool isLast;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ---------------------------------------------------------------
//         // Timeline rail
//         // ---------------------------------------------------------------
//
//         SizedBox(
//           width: 28,
//           child: Column(
//             children: [
//               Container(
//                 width: 12,
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: AppColors.primary,
//                     width: 2,
//                   ),
//                 ),
//                 child: Center(
//                   child: Container(
//                     width: 4,
//                     height: 4,
//                     decoration: const BoxDecoration(
//                       color: AppColors.primary,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ),
//
//               if (!isLast)
//                 Container(
//                   width: 1,
//                   height: memory.image != null
//                       ? 260
//                       : 155,
//                   margin: const EdgeInsets.only(
//                     top: 5,
//                   ),
//                   color: AppColors.outlineVariant.withValues(
//                     alpha: 0.65,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//
//         const SizedBox(width: 10),
//
//         // ---------------------------------------------------------------
//         // Memory
//         // ---------------------------------------------------------------
//
//         Expanded(
//           child: GestureDetector(
//             onTap: onTap,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Date
//                 Row(
//                   children: [
//                     Text(
//                       _formatDate(memory.date),
//                       style: AppTextTheme.labelSmall.copyWith(
//                         fontSize: 9,
//                         letterSpacing: 0.5,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                       ),
//                     ),
//
//                     if (memory.location.isNotEmpty) ...[
//                       const SizedBox(width: 8),
//
//                       Container(
//                         width: 3,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           color: AppColors.textDisabled,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//
//                       const SizedBox(width: 7),
//
//                       Flexible(
//                         child: Text(
//                           memory.location,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppTextTheme.labelSmall.copyWith(
//                             fontSize: 9,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//
//                 const SizedBox(height: 7),
//
//                 // Card
//                 Container(
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(
//                       alpha: 0.82,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: AppColors.outlineVariant.withValues(
//                         alpha: 0.55,
//                       ),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(
//                           alpha: 0.035,
//                         ),
//                         blurRadius: 18,
//                         offset: const Offset(0, 7),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       if (memory.image != null)
//                         AspectRatio(
//                           aspectRatio: 1.65,
//                           child: Image(
//                             image: memory.image!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(
//                           15,
//                           14,
//                           15,
//                           15,
//                         ),
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               memory.title,
//                               style: GoogleFonts.playfairDisplay(
//                                 fontSize: 19,
//                                 height: 1.2,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.textPrimary,
//                               ),
//                             ),
//
//                             const SizedBox(height: 6),
//
//                             Text(
//                               memory.description,
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               style: AppTextTheme.bodyMedium.copyWith(
//                                 fontSize: 11,
//                                 height: 1.5,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//
//                             if (memory.tags.isNotEmpty) ...[
//                               const SizedBox(height: 11),
//
//                               Wrap(
//                                 spacing: 5,
//                                 children: memory.tags
//                                     .take(3)
//                                     .map(
//                                       (tag) => _MemoryTag(
//                                     label: tag,
//                                   ),
//                                 )
//                                     .toList(),
//                               ),
//                             ],
//
//                             const SizedBox(height: 12),
//
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.auto_stories_outlined,
//                                   size: 12,
//                                   color: AppColors.textSecondary,
//                                 ),
//
//                                 const SizedBox(width: 5),
//
//                                 Text(
//                                   memory.folder,
//                                   style: AppTextTheme.labelSmall.copyWith(
//                                     fontSize: 9,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//
//                                 const Spacer(),
//
//                                 const Icon(
//                                   Icons.arrow_forward_rounded,
//                                   size: 16,
//                                   color: AppColors.primary,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//
//     return '${months[date.month - 1]} ${date.day}';
//   }
// }
//
// // =============================================================================
// // TAG
// // =============================================================================
//
// class _MemoryTag extends StatelessWidget {
//   const _MemoryTag({
//     required this.label,
//   });
//
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7EFEC),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         label,
//         style: AppTextTheme.labelSmall.copyWith(
//           fontSize: 8,
//           color: AppColors.textSecondary,
//         ),
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // EMPTY MEMORIES
// // =============================================================================
//
// class _EmptyMemories extends StatelessWidget {
//   const _EmptyMemories();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 12,
//       ),
//       child: Column(
//         children: [
//           // Decorative memory "frame"
//           SizedBox(
//             height: 235,
//             width: double.infinity,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Positioned(
//                   left: 18,
//                   top: 22,
//                   child: Transform.rotate(
//                     angle: -0.07,
//                     child: _MemoryPaper(
//                       width: 125,
//                       height: 160,
//                       opacity: 0.55,
//                     ),
//                   ),
//                 ),
//
//                 Positioned(
//                   right: 20,
//                   top: 10,
//                   child: Transform.rotate(
//                     angle: 0.07,
//                     child: _MemoryPaper(
//                       width: 125,
//                       height: 160,
//                       opacity: 0.45,
//                     ),
//                   ),
//                 ),
//
//                 _MemoryPaper(
//                   width: 155,
//                   height: 190,
//                   opacity: 1,
//                   front: true,
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 4),
//
//           Text(
//             'Nothing here yet',
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 24,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 7),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 32,
//             ),
//             child: Text(
//               'Every relationship has a collection of little moments. '
//                   'Start saving yours here.',
//               textAlign: TextAlign.center,
//               style: AppTextTheme.bodyMedium.copyWith(
//                 fontSize: 12,
//                 height: 1.55,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           Text(
//             'Your first memory is waiting.',
//             style: AppTextTheme.labelSmall.copyWith(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               fontStyle: FontStyle.italic,
//               color: AppColors.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // EMPTY PAPER
// // =============================================================================
//
// class _MemoryPaper extends StatelessWidget {
//   const _MemoryPaper({
//     required this.width,
//     required this.height,
//     required this.opacity,
//     this.front = false,
//   });
//
//   final double width;
//   final double height;
//   final double opacity;
//   final bool front;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: front
//             ? Colors.white
//             : const Color(0xFFF3E8E5),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(
//             alpha: opacity * 0.65,
//           ),
//         ),
//         boxShadow: front
//             ? [
//           BoxShadow(
//             color: Colors.black.withValues(
//               alpha: 0.06,
//             ),
//             blurRadius: 20,
//             offset: const Offset(0, 9),
//           ),
//         ]
//             : null,
//       ),
//       child: front
//           ? Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: const BoxDecoration(
//               color: Color(0xFFFCE4EC),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.favorite_border_rounded,
//               size: 25,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           Text(
//             'Your story',
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(height: 4),
//
//           Text(
//             'begins here',
//             style: AppTextTheme.labelSmall.copyWith(
//               fontSize: 9,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       )
//           : null,
//     );
//   }
// }
//
// // =============================================================================
// // COLLECTION CARD
// // =============================================================================
//
// class _AlbumCard extends StatelessWidget {
//   const _AlbumCard({
//     required this.folder,
//     required this.onTap,
//   });
//
//   final MemoryFolder folder;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.055),
//               blurRadius: 18,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // -----------------------------------------------------------
//             // Cover image
//             // -----------------------------------------------------------
//
//             if (folder.coverImage != null)
//               Image(
//                 image: folder.coverImage!,
//                 fit: BoxFit.cover,
//               )
//             else
//               Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFFFCE4EC),
//                       Color(0xFFF4E8E5),
//                     ],
//                   ),
//                 ),
//                 child: const Center(
//                   child: Icon(
//                     Icons.favorite_border_rounded,
//                     size: 34,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ),
//
//             // -----------------------------------------------------------
//             // Dark image gradient
//             // -----------------------------------------------------------
//
//             Positioned.fill(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withValues(alpha: 0.03),
//                       Colors.black.withValues(alpha: 0.76),
//                     ],
//                     stops: const [
//                       0.35,
//                       0.55,
//                       1,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             // -----------------------------------------------------------
//             // Memory count
//             // -----------------------------------------------------------
//
//             Positioned(
//               top: 10,
//               right: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withValues(alpha: 0.28),
//                   borderRadius: BorderRadius.circular(999),
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.22),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.photo_library_outlined,
//                       size: 10,
//                       color: Colors.white,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${folder.count}',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // -----------------------------------------------------------
//             // Album information
//             // -----------------------------------------------------------
//
//             Positioned(
//               left: 13,
//               right: 13,
//               bottom: 13,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     folder.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 18,
//                       height: 1.15,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   Text(
//                     folder.count == 1
//                         ? '1 memory'
//                         : '${folder.count} memories',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 9,
//                       color: Colors.white.withValues(alpha: 0.82),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // -----------------------------------------------------------
//             // Small arrow
//             // -----------------------------------------------------------
//
//             Positioned(
//               right: 12,
//               bottom: 13,
//               child: Container(
//                 width: 25,
//                 height: 25,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.16),
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.20),
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.arrow_forward_rounded,
//                   size: 13,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // EMPTY COLLECTIONS
// // =============================================================================
//
// class _EmptyCollections extends StatelessWidget {
//   const _EmptyCollections();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 35,
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 74,
//             height: 74,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFCE4EC),
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: const Icon(
//               Icons.auto_stories_outlined,
//               size: 30,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           Text(
//             'Your collections will appear here',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 21,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 7),
//
//           Text(
//             'Once you have memories, you can organize them '
//                 'into beautiful little chapters.',
//             textAlign: TextAlign.center,
//             style: AppTextTheme.bodyMedium.copyWith(
//               fontSize: 12,
//               height: 1.5,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // BACKGROUND
// // =============================================================================
//
// class _MemoriesBackground extends StatelessWidget {
//   const _MemoriesBackground();
//
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Stack(
//         children: [
//           Positioned(
//             top: -100,
//             right: -90,
//             child: Container(
//               width: 240,
//               height: 240,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFFFCE4EC).withValues(
//                   alpha: 0.45,
//                 ),
//               ),
//             ),
//           ),
//
//           Positioned(
//             top: 420,
//             left: -110,
//             child: Container(
//               width: 220,
//               height: 220,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFFECEAF3).withValues(
//                   alpha: 0.35,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // MODELS
// // =============================================================================
//
// enum MemoryViewMode {
//   timeline,
//   folders,
// }
//
// class MemoryItem {
//   const MemoryItem({
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.folder,
//     this.location = '',
//     this.image,
//     this.tags = const [],
//   });
//
//   final String title;
//   final String description;
//   final DateTime date;
//   final String folder;
//   final String location;
//   final ImageProvider? image;
//   final List<String> tags;
// }
//
// class MemoryFolder {
//   const MemoryFolder({
//     required this.name,
//     required this.count,
//     this.coverImage,
//   });
//
//   final String name;
//   final int count;
//   final ImageProvider? coverImage;
// }
//
// class _MemoryModeButton extends StatelessWidget {
//   const _MemoryModeButton({
//     required this.icon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final IconData icon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Center(
//         child: AnimatedDefaultTextStyle(
//           duration: const Duration(milliseconds: 220),
//           style: AppTextTheme.labelLarge.copyWith(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: selected
//                 ? Colors.white
//                 : AppColors.textSecondary,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedScale(
//                 scale: selected ? 1 : 0.92,
//                 duration: const Duration(milliseconds: 220),
//                 child: Icon(
//                   icon,
//                   size: 15,
//                   color: selected
//                       ? Colors.white
//                       : AppColors.textSecondary,
//                 ),
//               ),
//
//               const SizedBox(width: 6),
//
//               Text(label),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class _CreateAlbumCard extends StatelessWidget {
//   const _CreateAlbumCard({
//     required this.onTap,
//   });
//
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 76,
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8EEEC),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: AppColors.primary.withValues(
//               alpha: 0.14,
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 15),
//
//             Container(
//               width: 42,
//               height: 42,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFCE4EC),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.add_rounded,
//                 size: 19,
//                 color: AppColors.primary,
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Create a new album',
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//
//                   const SizedBox(height: 2),
//
//                   Text(
//                     'Give your memories a little home',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 9,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Padding(
//               padding: EdgeInsets.only(right: 15),
//               child: Icon(
//                 Icons.arrow_forward_rounded,
//                 size: 17,
//                 color: AppColors.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({
    super.key,
    this.memories = const [],
    this.onMemoryTap,
    this.onCreateMemory,
    this.onFolderTap,
  });

  final List<MemoryItem> memories;
  final ValueChanged<MemoryItem>? onMemoryTap;
  final VoidCallback? onCreateMemory;
  final ValueChanged<MemoryFolder>? onFolderTap;

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen>
    with SingleTickerProviderStateMixin {
  MemoryViewMode _viewMode = MemoryViewMode.timeline;

  late final AnimationController _switchController;

  @override
  void initState() {
    super.initState();

    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      floatingActionButton: _viewMode == MemoryViewMode.timeline
          ? _buildAddMemoryButton()
          : null,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _MemoriesBackground(),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    14,
                    20,
                    130,
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
                            _buildHeader(),

                            const SizedBox(height: 24),

                            _buildViewSwitcher(),

                            const SizedBox(height: 28),

                            AnimatedSwitcher(
                              duration: const Duration(
                                milliseconds: 280,
                              ),
                              child: _viewMode ==
                                  MemoryViewMode.timeline
                                  ? _buildTimeline()
                                  : _buildCollections(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR STORY',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Our memories',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // No plus icon here.
            // The only add action is the floating button.
            _MemoryCount(
              count: widget.memories.length,
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          widget.memories.isEmpty
              ? 'A place for all the little moments that became yours.'
              : 'A collection of moments worth remembering.',
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            height: 1.45,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MOMENTS / COLLECTIONS SWITCH
  // ===========================================================================

  Widget _buildViewSwitcher() {
    final isMoments = _viewMode == MemoryViewMode.timeline;

    return Center(
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.55,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Animated selected background
                AnimatedAlign(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  alignment: isMoments
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF795458),
                            Color(0xFF956C70),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.20,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: _MemoryModeButton(
                        icon: Icons.auto_awesome_rounded,
                        label: 'Moments',
                        selected: isMoments,
                        onTap: () {
                          setState(() {
                            _viewMode = MemoryViewMode.timeline;
                          });
                        },
                      ),
                    ),

                    Expanded(
                      child: _MemoryModeButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Albums',
                        selected: !isMoments,
                        onTap: () {
                          setState(() {
                            _viewMode = MemoryViewMode.folders;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // TIMELINE
  // ===========================================================================

  Widget _buildTimeline() {
    if (widget.memories.isEmpty) {
      return const _EmptyMemories();
    }

    final memories = [...widget.memories]
      ..sort(
            (a, b) => b.date.compareTo(a.date),
      );

    final grouped = <int, List<MemoryItem>>{};

    for (final memory in memories) {
      grouped.putIfAbsent(
        memory.date.year,
            () => [],
      );

      grouped[memory.date.year]!.add(memory);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in grouped.entries) ...[
          _TimelineYear(
            year: entry.key,
          ),

          const SizedBox(height: 18),

          ...List.generate(
            entry.value.length,
                (index) {
              final memory = entry.value[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == entry.value.length - 1
                      ? 34
                      : 22,
                ),
                child: _MemoryTimelineItem(
                  memory: memory,
                  isLast: index == entry.value.length - 1,
                  onTap: () {
                    widget.onMemoryTap?.call(memory);
                  },
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // COLLECTIONS
  // ===========================================================================

  Widget _buildCollections() {
    final folders = _createFolders();

    if (folders.isEmpty) {
      return _EmptyCollections(
        onCreateCollection: () {
          // Later: open Create Collection page
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR ALBUMS',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Little chapters of us',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '${folders.length} albums',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: folders.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final folder = folders[index];

            return _AlbumCard(
              folder: folder,
              onTap: () {
                widget.onFolderTap?.call(folder);
              },
            );
          },
        ),

        const SizedBox(height: 16),

        _CreateAlbumCard(
          onTap: () {
            // Later:
            context.push(AppRoutes.createCollection);
          },
        ),
      ],
    );
  }

  // List<MemoryFolder> _createFolders() {
  //   final map = <String, List<MemoryItem>>{};
  //
  //   for (final memory in widget.memories) {
  //     map.putIfAbsent(
  //       memory.folder,
  //           () => [],
  //     ).add(memory);
  //   }
  //
  //   return map.entries.map((entry) {
  //     final items = entry.value;
  //
  //     ImageProvider? albumCover;
  //
  //     // 1. Prefer an explicitly selected cover image.
  //     for (final memory in items) {
  //       if (memory.coverImage != null) {
  //         albumCover = memory.coverImage;
  //         break;
  //       }
  //     }
  //
  //     // 2. If no cover exists, use the first available image.
  //     albumCover ??= items
  //         .map((memory) => memory.displayImage)
  //         .whereType<ImageProvider>()
  //         .firstOrNull;
  //
  //     // 3. If there are no images at all,
  //     //    albumCover remains null and the heart placeholder is shown.
  //     return MemoryFolder(
  //       name: entry.key,
  //       count: items.length,
  //       coverImage: albumCover,
  //       description: '',
  //       tags: const [],
  //       createdAt: items.isNotEmpty
  //           ? items.map((e) => e.date).reduce(
  //             (a, b) => a.isBefore(b) ? a : b,
  //       )
  //           : null,
  //     );
  //   }).toList();
  // }

  List<MemoryFolder> _createFolders() {
    final map = <String, List<MemoryItem>>{};

    for (final memory in widget.memories) {
      map.putIfAbsent(memory.folder, () => []).add(memory);
    }

    return map.entries.map((entry) {
      final items = entry.value;

      ImageProvider? albumCover;

      // 1. Prefer explicit cover image.
      for (final memory in items) {
        if (memory.coverImage != null) {
          albumCover = memory.coverImage;
          break;
        }
      }

      // 2. Fallback to any available memory image.
      if (albumCover == null) {
        for (final memory in items) {
          final image = memory.displayImage;

          if (image != null) {
            albumCover = image;
            break;
          }
        }
      }

      return MemoryFolder(
        name: entry.key,
        count: items.length,
        coverImage: albumCover,
      );
    }).toList();
  }

  // ===========================================================================
  // ADD MEMORY
  // ===========================================================================

  Widget _buildAddMemoryButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: widget.onCreateMemory,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        extendedIconLabelSpacing: 7,
        shape: const StadiumBorder(),
        icon: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.onPrimary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 17,
          ),
        ),
        label: Text(
          'Add a memory',
          style: AppTextTheme.buttonPrimary.copyWith(
            color: AppColors.onPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}


// =============================================================================
// MEMORY COUNT
// =============================================================================

class _MemoryCount extends StatelessWidget {
  const _MemoryCount({
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Text(
          count == 1 ? 'memory' : 'memories',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// MEMORY TAB
// =============================================================================

class _MemoryTab extends StatelessWidget {
  const _MemoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w400,
            color: selected
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// YEAR
// =============================================================================

class _TimelineYear extends StatelessWidget {
  const _TimelineYear({
    required this.year,
  });

  final int year;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        Text(
          '$year',
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            height: 1,
            color: AppColors.outlineVariant.withValues(
              alpha: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// TIMELINE ITEM
// =============================================================================

class _MemoryTimelineItem extends StatelessWidget {
  const _MemoryTimelineItem({
    required this.memory,
    required this.isLast,
    required this.onTap,
  });

  final MemoryItem memory;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final image = memory.displayImage;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------------------------------------------
        // Timeline rail
        // ---------------------------------------------------------------

        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              if (!isLast)
                Container(
                  width: 1,
                  height: memory.displayImage != null
                      ? 260
                      : 155,
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  color: AppColors.outlineVariant.withValues(
                    alpha: 0.65,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // ---------------------------------------------------------------
        // Memory
        // ---------------------------------------------------------------

        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Row(
                  children: [
                    Text(
                      _formatDate(memory.date),
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    if (memory.location.isNotEmpty) ...[
                      const SizedBox(width: 8),

                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.textDisabled,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 7),

                      Flexible(
                        child: Text(
                          memory.location,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.labelSmall.copyWith(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 7),

                // Card
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.82,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(
                        alpha: 0.55,
                      ),
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
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      if (image != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.65,
                            child: Image(
                              image: image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          15,
                          14,
                          15,
                          15,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              memory.title,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 19,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              memory.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.bodyMedium.copyWith(
                                fontSize: 11,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            if (memory.tags.isNotEmpty) ...[
                              const SizedBox(height: 11),

                              Wrap(
                                spacing: 5,
                                children: memory.tags
                                    .take(3)
                                    .map(
                                      (tag) => _MemoryTag(
                                    label: tag,
                                  ),
                                )
                                    .toList(),
                              ),
                            ],

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Icon(
                                  Icons.auto_stories_outlined,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  memory.folder,
                                  style: AppTextTheme.labelSmall.copyWith(
                                    fontSize: 9,
                                    color: AppColors.textSecondary,
                                  ),
                                ),

                                const Spacer(),

                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

    return '${months[date.month - 1]} ${date.day}';
  }
}

// =============================================================================
// TAG
// =============================================================================

class _MemoryTag extends StatelessWidget {
  const _MemoryTag({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EFEC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextTheme.labelSmall.copyWith(
          fontSize: 8,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY MEMORIES
// =============================================================================

class _EmptyMemories extends StatelessWidget {
  const _EmptyMemories();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
      ),
      child: Column(
        children: [
          // Decorative memory "frame"
          SizedBox(
            height: 235,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 18,
                  top: 22,
                  child: Transform.rotate(
                    angle: -0.07,
                    child: _MemoryPaper(
                      width: 125,
                      height: 160,
                      opacity: 0.55,
                    ),
                  ),
                ),

                Positioned(
                  right: 20,
                  top: 10,
                  child: Transform.rotate(
                    angle: 0.07,
                    child: _MemoryPaper(
                      width: 125,
                      height: 160,
                      opacity: 0.45,
                    ),
                  ),
                ),

                _MemoryPaper(
                  width: 155,
                  height: 190,
                  opacity: 1,
                  front: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Nothing here yet',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 7),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Text(
              'Every relationship has a collection of little moments. '
                  'Start saving yours here.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Your first memory is waiting.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EMPTY PAPER
// =============================================================================

class _MemoryPaper extends StatelessWidget {
  const _MemoryPaper({
    required this.width,
    required this.height,
    required this.opacity,
    this.front = false,
  });

  final double width;
  final double height;
  final double opacity;
  final bool front;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: front
            ? Colors.white
            : const Color(0xFFF3E8E5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: opacity * 0.65,
          ),
        ),
        boxShadow: front
            ? [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ]
            : null,
      ),
      child: front
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 25,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Your story',
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'begins here',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      )
          : null,
    );
  }
}

// =============================================================================
// COLLECTION CARD
// =============================================================================

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({
    required this.folder,
    required this.onTap,
  });

  final MemoryFolder folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // -----------------------------------------------------------
            // Cover image
            // -----------------------------------------------------------

            if (folder.coverImage != null)
              Image(
                image: folder.coverImage!,
                fit: BoxFit.cover,
              )
            else
              Container(
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
                child: const Center(
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 34,
                    color: AppColors.primary,
                  ),
                ),
              ),

            // -----------------------------------------------------------
            // Dark image gradient
            // -----------------------------------------------------------

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.03),
                      Colors.black.withValues(alpha: 0.76),
                    ],
                    stops: const [
                      0.35,
                      0.55,
                      1,
                    ],
                  ),
                ),
              ),
            ),

            // -----------------------------------------------------------
            // Memory count
            // -----------------------------------------------------------

            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      size: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${folder.count}',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------------------
            // Album information
            // -----------------------------------------------------------

            Positioned(
              left: 13,
              right: 13,
              bottom: 13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folder.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    folder.count == 1
                        ? '1 memory'
                        : '${folder.count} memories',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------
            // Small arrow
            // -----------------------------------------------------------

            Positioned(
              right: 12,
              bottom: 13,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY COLLECTIONS
// =============================================================================

class _EmptyCollections extends StatelessWidget {
  const _EmptyCollections({
    required this.onCreateCollection,
  });

  final VoidCallback onCreateCollection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 35,
      ),
      child: Column(
        children: [
          // Illustration
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.auto_stories_outlined,
              size: 30,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Create your first collection',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 7),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'Give your memories a little home. '
                  'Create a collection first, then add your special moments to it.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Create collection button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCreateCollection,
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF795458),
                      Color(0xFF956C70),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.14,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Text(
                      'Create Collection',
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'You can always create more later.',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
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
// BACKGROUND
// =============================================================================

class _MemoriesBackground extends StatelessWidget {
  const _MemoriesBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -90,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC).withValues(
                  alpha: 0.45,
                ),
              ),
            ),
          ),

          Positioned(
            top: 420,
            left: -110,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFECEAF3).withValues(
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

// =============================================================================
// MODELS
// =============================================================================

enum MemoryViewMode {
  timeline,
  folders,
}

class MemoryItem {
  const MemoryItem({
    required this.title,
    required this.description,
    required this.date,
    required this.folder,
    this.location = '',
    this.coverImage,
    this.images = const [],
    this.tags = const [],
  });

  final String title;
  final String description;
  final DateTime date;
  final String folder;
  final String location;

  // Specifically selected cover photo.
  final ImageProvider? coverImage;

  // Other photos attached to this memory.
  final List<ImageProvider> images;

  final List<String> tags;

  // Image that should be displayed on cards.
  ImageProvider? get displayImage {
    if (coverImage != null) {
      return coverImage;
    }

    if (images.isNotEmpty) {
      return images.first;
    }

    return null;
  }
}


class MemoryFolder {
  const MemoryFolder({
    required this.name,
    required this.count,
    this.coverImage,
    this.description = '',
    this.tags = const [],
    this.createdAt,
  });

  final String name;
  final int count;
  final ImageProvider? coverImage;

  final String description;
  final List<String> tags;
  final DateTime? createdAt;
}

class _MemoryModeButton extends StatelessWidget {
  const _MemoryModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 220),
          style: AppTextTheme.labelLarge.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : AppColors.textSecondary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1 : 0.92,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  icon,
                  size: 15,
                  color: selected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),

              const SizedBox(width: 6),

              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}


class _CreateAlbumCard extends StatelessWidget {
  const _CreateAlbumCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFFF8EEEC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withValues(
              alpha: 0.14,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),

            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a new album',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Give your memories a little home',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

