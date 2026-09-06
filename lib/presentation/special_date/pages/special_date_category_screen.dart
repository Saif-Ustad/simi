// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_text_theme.dart';
// import 'special_dates_home_screen.dart';
//
// /// UI information used to display a category.
// ///
// /// IMPORTANT:
// /// This is NOT your domain category enum.
// /// Your existing SpecialDateCategory enum remains the source of truth.
// class SpecialDateCategoryInfo {
//   const SpecialDateCategoryInfo({
//     required this.category,
//     required this.name,
//     required this.subtitle,
//     required this.icon,
//     required this.count,
//     this.emoji,
//     this.accent,
//   });
//
//   final SpecialDateCategory category;
//   final String name;
//   final String subtitle;
//   final IconData icon;
//   final int count;
//   final String? emoji;
//   final Color? accent;
// }
//
// class SpecialDateCategoryScreen extends StatefulWidget {
//   const SpecialDateCategoryScreen({
//     super.key,
//     this.categories = const [],
//     this.onBack,
//     this.onCategoryTap,
//     this.onAddDate,
//   });
//
//   final List<SpecialDateCategoryInfo> categories;
//
//   final VoidCallback? onBack;
//
//   final ValueChanged<SpecialDateCategoryInfo>? onCategoryTap;
//
//   final VoidCallback? onAddDate;
//
//   @override
//   State<SpecialDateCategoryScreen> createState() =>
//       _SpecialDateCategoryScreenState();
// }
//
// class _SpecialDateCategoryScreenState
//     extends State<SpecialDateCategoryScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController;
//
//   String _searchQuery = '';
//
//   bool _showSearch = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   List<SpecialDateCategoryInfo> get _filteredCategories {
//     final query = _searchQuery.trim().toLowerCase();
//
//     if (query.isEmpty) {
//       return widget.categories;
//     }
//
//     return widget.categories.where((category) {
//       return category.name.toLowerCase().contains(query) ||
//           category.subtitle.toLowerCase().contains(query);
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final categories = _filteredCategories;
//
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: Stack(
//         children: [
//           const Positioned.fill(
//             child: _CategoryBackground(),
//           ),
//
//           SafeArea(
//             bottom: false,
//             child: ListView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.only(
//                 bottom: 140,
//               ),
//               children: [
//                 _buildTopBar(context),
//
//                 const SizedBox(height: 8),
//
//                 _buildHero(),
//
//                 const SizedBox(height: 20),
//
//                 _buildInsightCard(),
//
//                 const SizedBox(height: 22),
//
//                 _buildSearch(),
//
//                 const SizedBox(height: 18),
//
//                 if (categories.isEmpty)
//                   _buildEmptyState()
//                 else
//                   _buildCategoryList(),
//               ],
//             ),
//           ),
//
//           if (widget.onAddDate != null)
//             _buildBottomAction(),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // TOP BAR
//   // ===========================================================================
//
//   Widget _buildTopBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         20,
//         8,
//         20,
//         0,
//       ),
//       child: Row(
//         children: [
//           _CircleButton(
//             icon: Icons.arrow_back_rounded,
//             onTap: widget.onBack ??
//                     () {
//                   Navigator.of(context).maybePop();
//                 },
//           ),
//
//           const SizedBox(width: 12),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'SPECIAL DATES',
//                   style: AppTextTheme.labelSmall.copyWith(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.8,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 Text(
//                   'Our little calendar',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           _CircleButton(
//             icon: _showSearch
//                 ? Icons.close_rounded
//                 : Icons.search_rounded,
//             onTap: () {
//               setState(() {
//                 _showSearch = !_showSearch;
//
//                 if (!_showSearch) {
//                   _searchQuery = '';
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // HERO
//   // ===========================================================================
//
//   Widget _buildHero() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Container(
//         height: 205,
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF302325),
//               Color(0xFF554043),
//               Color(0xFF76595D),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.10),
//               blurRadius: 22,
//               offset: const Offset(0, 9),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Top right glow.
//             Positioned(
//               right: -45,
//               top: -55,
//               child: Container(
//                 width: 170,
//                 height: 170,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withValues(
//                     alpha: 0.055,
//                   ),
//                 ),
//               ),
//             ),
//
//             // Bottom left glow.
//             Positioned(
//               left: -55,
//               bottom: -80,
//               child: Container(
//                 width: 190,
//                 height: 190,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color(0xFFE8B4B8).withValues(
//                     alpha: 0.10,
//                   ),
//                 ),
//               ),
//             ),
//
//             // Floating hearts.
//             const Positioned(
//               right: 28,
//               top: 28,
//               child: Icon(
//                 Icons.favorite_rounded,
//                 size: 14,
//                 color: Color(0xFFF6D9DC),
//               ),
//             ),
//
//             Positioned(
//               right: 58,
//               top: 53,
//               child: Icon(
//                 Icons.favorite_rounded,
//                 size: 8,
//                 color: Colors.white.withValues(
//                   alpha: 0.30,
//                 ),
//               ),
//             ),
//
//             Positioned(
//               left: 30,
//               bottom: 28,
//               child: Icon(
//                 Icons.auto_awesome_rounded,
//                 size: 13,
//                 color: Colors.white.withValues(
//                   alpha: 0.24,
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 22,
//                 20,
//                 22,
//                 20,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _HeroLabel(
//                     icon: Icons.favorite_border_rounded,
//                     text: 'THE DAYS WE NEVER FORGET',
//                   ),
//
//                   const Spacer(),
//
//                   Text(
//                     'Every little date\nhas a story.',
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 29,
//                       height: 1.08,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   Text(
//                     'The moments that quietly became part of us.',
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextTheme.bodyMedium.copyWith(
//                       fontSize: 10.5,
//                       height: 1.45,
//                       color: Colors.white.withValues(
//                         alpha: 0.70,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // INSIGHT
//   // ===========================================================================
//
//   Widget _buildInsightCard() {
//     final total = widget.categories.fold<int>(
//       0,
//           (sum, category) => sum + category.count,
//     );
//
//     final categoryCount = widget.categories.length;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(
//           17,
//           16,
//           17,
//           16,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(
//             alpha: 0.78,
//           ),
//           borderRadius: BorderRadius.circular(23),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.50,
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 46,
//               height: 46,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFCE4EC),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.calendar_month_outlined,
//                 size: 21,
//                 color: AppColors.primary,
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'YOUR LITTLE CALENDAR',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 8.5,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 1.35,
//                       color: AppColors.primary,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   Text(
//                     total == 0
//                         ? 'Nothing here yet.'
//                         : '$total little moments to remember.',
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
//                     categoryCount == 0
//                         ? 'Start adding the days that matter.'
//                         : '$categoryCount categories make up your story.',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 9,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(width: 8),
//
//             Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: AppColors.surface,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: AppColors.outlineVariant.withValues(
//                     alpha: 0.45,
//                   ),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.favorite_rounded,
//                 size: 14,
//                 color: AppColors.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // SEARCH
//   // ===========================================================================
//
//   Widget _buildSearch() {
//     if (!_showSearch) {
//       return const SizedBox.shrink();
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Container(
//         height: 50,
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.55,
//             ),
//           ),
//         ),
//         child: TextField(
//           autofocus: true,
//           onChanged: (value) {
//             setState(() {
//               _searchQuery = value;
//             });
//           },
//           style: AppTextTheme.bodyMedium.copyWith(
//             fontSize: 12,
//             color: AppColors.textPrimary,
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             hintText: 'Search categories...',
//             hintStyle: AppTextTheme.bodyMedium.copyWith(
//               fontSize: 12,
//               color: AppColors.textDisabled,
//             ),
//             prefixIcon: const Icon(
//               Icons.search_rounded,
//               size: 19,
//               color: AppColors.primary,
//             ),
//             suffixIcon: _searchQuery.isNotEmpty
//                 ? GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _searchQuery = '';
//                 });
//               },
//               child: const Icon(
//                 Icons.close_rounded,
//                 size: 17,
//                 color: AppColors.textSecondary,
//               ),
//             )
//                 : null,
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 14,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // CATEGORY LIST
//   // ===========================================================================
//
//   Widget _buildCategoryList() {
//     final categories = _filteredCategories;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'YOUR MOMENTS',
//                       style: AppTextTheme.labelSmall.copyWith(
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 1.7,
//                         color: AppColors.primary,
//                       ),
//                     ),
//
//                     const SizedBox(height: 3),
//
//                     Text(
//                       'Choose a chapter',
//                       style: GoogleFonts.playfairDisplay(
//                         fontSize: 21,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Text(
//                 '${categories.length} ${categories.length == 1 ? 'category' : 'categories'}',
//                 style: AppTextTheme.labelSmall.copyWith(
//                   fontSize: 9,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           ...List.generate(
//             categories.length,
//                 (index) {
//               final category = categories[index];
//
//               return _AnimatedEntry(
//                 controller: _animationController,
//                 index: index,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     bottom: 13,
//                   ),
//                   child: _CategoryCard(
//                     category: category,
//                     onTap: () {
//                       widget.onCategoryTap?.call(
//                         category,
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // EMPTY
//   // ===========================================================================
//
//   Widget _buildEmptyState() {
//     final searching = _searchQuery.trim().isNotEmpty;
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         30,
//         25,
//         30,
//         20,
//       ),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(
//           25,
//           30,
//           25,
//           30,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(
//             alpha: 0.75,
//           ),
//           borderRadius: BorderRadius.circular(26),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.5,
//             ),
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 68,
//               height: 68,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFCE4EC),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.calendar_today_outlined,
//                 size: 27,
//                 color: AppColors.primary,
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             Text(
//               searching
//                   ? 'Nothing found'
//                   : 'No special dates yet',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.playfairDisplay(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//
//             const SizedBox(height: 7),
//
//             Text(
//               searching
//                   ? 'Try searching for another category.'
//                   : 'The little moments are waiting to be remembered.',
//               textAlign: TextAlign.center,
//               style: AppTextTheme.bodyMedium.copyWith(
//                 fontSize: 11,
//                 height: 1.5,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//
//             if (!searching && widget.onAddDate != null) ...[
//               const SizedBox(height: 18),
//
//               GestureDetector(
//                 onTap: widget.onAddDate,
//                 child: Container(
//                   height: 44,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 18,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary,
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.add_rounded,
//                         size: 17,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(width: 7),
//                       Text(
//                         'Add a special date',
//                         style: AppTextTheme.labelLarge.copyWith(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // BOTTOM ACTION
//   // ===========================================================================
//
//   Widget _buildBottomAction() {
//     return Positioned(
//       left: 18,
//       right: 18,
//       bottom: 14,
//       child: SafeArea(
//         top: false,
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 540,
//             ),
//             child: GestureDetector(
//               onTap: widget.onAddDate,
//               child: Container(
//                 height: 58,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF765457),
//                       Color(0xFF966E72),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(29),
//                   border: Border.all(
//                     color: Colors.white.withValues(
//                       alpha: 0.15,
//                     ),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primary.withValues(
//                         alpha: 0.23,
//                       ),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                     BoxShadow(
//                       color: Colors.black.withValues(
//                         alpha: 0.08,
//                       ),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(width: 7),
//
//                     Container(
//                       width: 46,
//                       height: 46,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(
//                           alpha: 0.14,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.add_rounded,
//                         size: 23,
//                         color: Colors.white,
//                       ),
//                     ),
//
//                     const SizedBox(width: 13),
//
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment:
//                         MainAxisAlignment.center,
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Add a special date',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.playfairDisplay(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//
//                           const SizedBox(height: 3),
//
//                           Text(
//                             'Keep another little moment close',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: AppTextTheme.labelSmall.copyWith(
//                               fontSize: 10,
//                               color: Colors.white.withValues(
//                                 alpha: 0.72,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(width: 8),
//
//                     Container(
//                       width: 42,
//                       height: 42,
//                       margin: const EdgeInsets.only(
//                         right: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(
//                           alpha: 0.12,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.arrow_forward_rounded,
//                         size: 19,
//                         color: Colors.white,
//                       ),
//                     ),
//
//                     const SizedBox(width: 2),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // CATEGORY CARD
// // =============================================================================
//
// class _CategoryCard extends StatelessWidget {
//   const _CategoryCard({
//     required this.category,
//     required this.onTap,
//   });
//
//   final SpecialDateCategoryInfo category;
//
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final accent =
//         category.accent ?? const Color(0xFFFCE4EC);
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(
//             alpha: 0.82,
//           ),
//           borderRadius: BorderRadius.circular(23),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.52,
//             ),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(
//                 alpha: 0.035,
//               ),
//               blurRadius: 14,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 55,
//               height: 55,
//               decoration: BoxDecoration(
//                 color: accent,
//                 shape: BoxShape.circle,
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Icon(
//                     category.icon,
//                     size: 21,
//                     color: AppColors.primary,
//                   ),
//
//                   if (category.emoji != null)
//                     Positioned(
//                       right: 1,
//                       bottom: 0,
//                       child: Text(
//                         category.emoji!,
//                         style: const TextStyle(
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(width: 13),
//
//             Expanded(
//               child: Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   Text(
//                     category.subtitle,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 9.5,
//                       height: 1.4,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//
//                   const SizedBox(height: 7),
//
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF7F1F0),
//                           borderRadius:
//                           BorderRadius.circular(999),
//                         ),
//                         child: Text(
//                           '${category.count} ${category.count == 1 ? 'moment' : 'moments'}',
//                           style:
//                           AppTextTheme.labelSmall.copyWith(
//                             fontSize: 8,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(width: 7),
//
//                       const Icon(
//                         Icons.favorite_border_rounded,
//                         size: 11,
//                         color: AppColors.primary,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(width: 10),
//
//             Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8F3F1),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: AppColors.outlineVariant.withValues(
//                     alpha: 0.45,
//                   ),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.arrow_forward_rounded,
//                 size: 16,
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
// // =============================================================================
// // HERO LABEL
// // =============================================================================
//
// class _HeroLabel extends StatelessWidget {
//   const _HeroLabel({
//     required this.icon,
//     required this.text,
//   });
//
//   final IconData icon;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 9,
//         vertical: 6,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(
//           alpha: 0.10,
//         ),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(
//           color: Colors.white.withValues(
//             alpha: 0.12,
//           ),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 11,
//             color: const Color(0xFFF6D9DC),
//           ),
//
//           const SizedBox(width: 5),
//
//           Text(
//             text,
//             style: AppTextTheme.labelSmall.copyWith(
//               fontSize: 7.5,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 1.1,
//               color: Colors.white.withValues(
//                 alpha: 0.78,
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
// // CIRCLE BUTTON
// // =============================================================================
//
// class _CircleButton extends StatelessWidget {
//   const _CircleButton({
//     required this.icon,
//     required this.onTap,
//   });
//
//   final IconData icon;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 42,
//         height: 42,
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(
//             alpha: 0.78,
//           ),
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.55,
//             ),
//           ),
//         ),
//         child: Icon(
//           icon,
//           size: 19,
//           color: AppColors.textPrimary,
//         ),
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // ANIMATED ENTRY
// // =============================================================================
//
// class _AnimatedEntry extends StatelessWidget {
//   const _AnimatedEntry({
//     required this.controller,
//     required this.index,
//     required this.child,
//   });
//
//   final AnimationController controller;
//   final int index;
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     final start = (index * 0.08).clamp(
//       0.0,
//       0.55,
//     );
//
//     final animation = CurvedAnimation(
//       parent: controller,
//       curve: Interval(
//         start,
//         1.0,
//         curve: Curves.easeOutCubic,
//       ),
//     );
//
//     return AnimatedBuilder(
//       animation: animation,
//       child: child,
//       builder: (context, child) {
//         final value = animation.value;
//
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(
//               0,
//               16 * (1 - value),
//             ),
//             child: child,
//           ),
//         );
//       },
//     );
//   }
// }
//
// // =============================================================================
// // BACKGROUND
// // =============================================================================
//
// class _CategoryBackground extends StatelessWidget {
//   const _CategoryBackground();
//
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Stack(
//         children: [
//           Positioned(
//             top: 80,
//             right: -90,
//             child: _SoftCircle(
//               size: 210,
//               color: const Color(0xFFF3E6E4),
//             ),
//           ),
//
//           Positioned(
//             top: 390,
//             left: -100,
//             child: _SoftCircle(
//               size: 230,
//               color: const Color(0xFFECE8EF),
//             ),
//           ),
//
//           Positioned(
//             bottom: 130,
//             right: -80,
//             child: _SoftCircle(
//               size: 190,
//               color: const Color(0xFFF6E5E8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SoftCircle extends StatelessWidget {
//   const _SoftCircle({
//     required this.size,
//     required this.color,
//   });
//
//   final double size;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return ImageFiltered(
//       imageFilter: ImageFilter.blur(
//         sigmaX: 35,
//         sigmaY: 35,
//       ),
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateCategoryScreen extends StatefulWidget {
  const SpecialDateCategoryScreen({
    super.key,
    this.onBack,
    this.onCategorySelected,
  });

  final VoidCallback? onBack;

  /// Called when the user selects a category.
  final ValueChanged<SpecialDateCategory>? onCategorySelected;

  @override
  State<SpecialDateCategoryScreen> createState() =>
      _SpecialDateCategoryScreenState();
}

class _SpecialDateCategoryScreenState
    extends State<SpecialDateCategoryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  SpecialDateCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // CATEGORY DATA
  // ===========================================================================

  List<_CategoryOption> get _categories {
    return const [
      _CategoryOption(
        category: SpecialDateCategory.anniversary,
        title: 'Anniversary',
        subtitle: 'A day that belongs only to us.',
        emoji: '❤️',
        icon: Icons.favorite_rounded,
        accent: Color(0xFFF6D9DC),
      ),
      _CategoryOption(
        category: SpecialDateCategory.birthday,
        title: 'Birthday',
        subtitle: 'A day worth celebrating together.',
        emoji: '🎂',
        icon: Icons.cake_outlined,
        accent: Color(0xFFF3E4E6),
      ),
      _CategoryOption(
        category: SpecialDateCategory.firstMeeting,
        title: 'First Meeting',
        subtitle: 'Where our story first began.',
        emoji: '✨',
        icon: Icons.people_outline_rounded,
        accent: Color(0xFFEAE7F1),
      ),
      _CategoryOption(
        category: SpecialDateCategory.firstDate,
        title: 'First Date',
        subtitle: 'The beginning of something beautiful.',
        emoji: '💕',
        icon: Icons.favorite_border_rounded,
        accent: Color(0xFFF7E8EA),
      ),
      _CategoryOption(
        category: SpecialDateCategory.firstKiss,
        title: 'First Kiss',
        subtitle: 'One little moment we never forgot.',
        emoji: '💋',
        icon: Icons.face_retouching_natural_outlined,
        accent: Color(0xFFF3E3E8),
      ),
      _CategoryOption(
        category: SpecialDateCategory.firstTrip,
        title: 'First Trip',
        subtitle: 'The first place we explored together.',
        emoji: '✈️',
        icon: Icons.flight_takeoff_rounded,
        accent: Color(0xFFE8E9F2),
      ),
      _CategoryOption(
        category: SpecialDateCategory.customMoment,
        title: 'Custom Moment',
        subtitle: 'Something special that is just ours.',
        emoji: '🌷',
        icon: Icons.auto_awesome_rounded,
        accent: Color(0xFFF4EBDD),
      ),
    ];
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
          const Positioned.fill(
            child: _CategoryBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 125,
              ),
              children: [
                _buildTopBar(context),

                const SizedBox(height: 12),

                _buildProgress(),

                const SizedBox(height: 24),

                _buildIntro(),

                const SizedBox(height: 26),

                _buildCategorySection(),
              ],
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: widget.onBack ??
                    () {
                  context.pop();
                },
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPECIAL DATES',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Create a special date',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '1 OF 5',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PROGRESS
  // ===========================================================================

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: List.generate(
          5,
              (index) {
            final active = index == 0;

            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(
                  right: index == 4 ? 0 : 5,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary
                      : AppColors.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'A LITTLE BEGINNING',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.25,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),

          Text(
            'What kind of\nmoment is this?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 31,
              height: 1.08,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Every special date starts with a little story. '
                'Choose the one that feels most like yours.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CATEGORY SECTION
  // ===========================================================================

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHOOSE A CATEGORY',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Pick what makes this day special.',
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 15),

          ...List.generate(
            _categories.length,
                (index) {
              final option = _categories[index];

              return _AnimatedEntry(
                controller: _animationController,
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 11,
                  ),
                  child: _CategoryCard(
                    option: option,
                    selected:
                    _selectedCategory == option.category,
                    onTap: () {
                      setState(() {
                        _selectedCategory = option.category;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BOTTOM CTA
  // ===========================================================================

  Widget _buildBottomAction() {
    final enabled = _selectedCategory != null;

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
            child: GestureDetector(
              onTap: enabled
                  ? () {
                widget.onCategorySelected?.call(
                  _selectedCategory!,
                );
              }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 220,
                ),
                height: 58,
                decoration: BoxDecoration(
                  gradient: enabled
                      ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF765457),
                      Color(0xFF966E72),
                    ],
                  )
                      : null,
                  color: enabled
                      ? null
                      : const Color(0xFFE5DEDB),
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: enabled
                      ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.23,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.07,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 7),

                    AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 220,
                      ),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: enabled
                            ? Colors.white.withValues(
                          alpha: 0.14,
                        )
                            : Colors.white.withValues(
                          alpha: 0.55,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        enabled
                            ? Icons.arrow_forward_rounded
                            : Icons.favorite_border_rounded,
                        size: 21,
                        color: enabled
                            ? Colors.white
                            : AppColors.textDisabled,
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
                            enabled
                                ? 'Continue'
                                : 'Choose a category',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: enabled
                                  ? Colors.white
                                  : AppColors.textDisabled,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            enabled
                                ? 'Let’s give this moment a story'
                                : 'Your little story starts here',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            AppTextTheme.labelSmall.copyWith(
                              fontSize: 10,
                              color: enabled
                                  ? Colors.white.withValues(
                                alpha: 0.72,
                              )
                                  : AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (enabled)
                      Container(
                        width: 42,
                        height: 42,
                        margin:
                        const EdgeInsets.only(right: 4),
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
    );
  }
}

// =============================================================================
// CATEGORY MODEL — UI ONLY
// =============================================================================

class _CategoryOption {
  const _CategoryOption({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.icon,
    required this.accent,
  });

  final SpecialDateCategory category;
  final String title;
  final String subtitle;
  final String emoji;
  final IconData icon;
  final Color accent;
}

// =============================================================================
// CATEGORY CARD
// =============================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _CategoryOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF7F7)
              : Colors.white.withValues(
            alpha: 0.80,
          ),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(
              alpha: 0.52,
            ),
            width: selected ? 1.3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withValues(
                alpha: 0.10,
              )
                  : Colors.black.withValues(
                alpha: 0.025,
              ),
              blurRadius: selected ? 18 : 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFFCE4EC)
                    : option.accent,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    option.icon,
                    size: 21,
                    color: AppColors.primary,
                  ),

                  Positioned(
                    right: 1,
                    bottom: 0,
                    child: Text(
                      option.emoji,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 13),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    option.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Selection
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
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
                  width: 1.3,
                ),
              ),
              child: selected
                  ? const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              )
                  : null,
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
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.80,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.55,
            ),
          ),
        ),
        child: Icon(
          icon,
          size: 19,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.index,
    required this.child,
  });

  final AnimationController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(
      0.0,
      0.55,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        start,
        1,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 * (1 - value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _CategoryBackground extends StatelessWidget {
  const _CategoryBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 70,
            right: -85,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 35,
                sigmaY: 35,
              ),
              child: Container(
                width: 210,
                height: 210,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4E5E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          Positioned(
            top: 390,
            left: -105,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 40,
                sigmaY: 40,
              ),
              child: Container(
                width: 230,
                height: 230,
                decoration: const BoxDecoration(
                  color: Color(0xFFECE8F0),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 80,
            right: -90,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 35,
                sigmaY: 35,
              ),
              child: Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E4E7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}