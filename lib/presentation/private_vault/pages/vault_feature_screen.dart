// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_text_theme.dart';
//
// enum VaultFeatureType {
//   memories,
//   privateChat,
//   specialDates,
//   giftWishes,
//   futureMessages,
//   loveNotifications,
//   photos,
//   videos,
// }
//
// class VaultFeatureItem {
//   const VaultFeatureItem({
//     required this.title,
//     required this.subtitle,
//     required this.dateLabel,
//     this.description,
//     this.icon,
//     this.image,
//     this.isUnread = false,
//     this.isLocked = false,
//   });
//
//   final String title;
//   final String subtitle;
//   final String dateLabel;
//   final String? description;
//   final IconData? icon;
//   final ImageProvider? image;
//   final bool isUnread;
//   final bool isLocked;
// }
//
// class VaultFeatureScreen extends StatelessWidget {
//   const VaultFeatureScreen({
//     super.key,
//     required this.type,
//     this.items = const [],
//     this.onBack,
//     this.onAdd,
//     this.onItemTap,
//     this.onMore,
//   });
//
//   final VaultFeatureType type;
//   final List<VaultFeatureItem> items;
//
//   final VoidCallback? onBack;
//   final VoidCallback? onAdd;
//   final ValueChanged<VaultFeatureItem>? onItemTap;
//   final VoidCallback? onMore;
//
//   String get _title {
//     switch (type) {
//       case VaultFeatureType.memories:
//         return 'Hidden Memories';
//
//       case VaultFeatureType.privateChat:
//         return 'Private Chat';
//
//       case VaultFeatureType.specialDates:
//         return 'Special Dates';
//
//       case VaultFeatureType.giftWishes:
//         return 'Gift Wishes';
//
//       case VaultFeatureType.futureMessages:
//         return 'Future Messages';
//
//       case VaultFeatureType.loveNotifications:
//         return 'Love Notifications';
//
//       case VaultFeatureType.photos:
//         return 'Private Photos';
//
//       case VaultFeatureType.videos:
//         return 'Private Videos';
//     }
//   }
//
//   String get _eyebrow {
//     switch (type) {
//       case VaultFeatureType.memories:
//         return 'MOMENTS WE KEEP';
//
//       case VaultFeatureType.privateChat:
//         return 'JUST BETWEEN US';
//
//       case VaultFeatureType.specialDates:
//         return 'DATES THAT MATTER';
//
//       case VaultFeatureType.giftWishes:
//         return 'LITTLE WISHES';
//
//       case VaultFeatureType.futureMessages:
//         return 'FOR LATER';
//
//       case VaultFeatureType.loveNotifications:
//         return 'LITTLE REMINDERS';
//
//       case VaultFeatureType.photos:
//         return 'PRIVATE MOMENTS';
//
//       case VaultFeatureType.videos:
//         return 'MOMENTS IN MOTION';
//     }
//   }
//
//   String get _description {
//     switch (type) {
//       case VaultFeatureType.memories:
//         return 'The moments you chose to keep just between you.';
//
//       case VaultFeatureType.privateChat:
//         return 'Conversations that belong only to the two of you.';
//
//       case VaultFeatureType.specialDates:
//         return 'The dates you never want to forget.';
//
//       case VaultFeatureType.giftWishes:
//         return 'Things you secretly hope to give or receive.';
//
//       case VaultFeatureType.futureMessages:
//         return 'Words waiting for the right moment.';
//
//       case VaultFeatureType.loveNotifications:
//         return 'Little reminders that make your day softer.';
//
//       case VaultFeatureType.photos:
//         return 'Photos that are meant for your eyes only.';
//
//       case VaultFeatureType.videos:
//         return 'Moving memories kept safely between you.';
//     }
//   }
//
//   IconData get _icon {
//     switch (type) {
//       case VaultFeatureType.memories:
//         return Icons.auto_awesome_outlined;
//
//       case VaultFeatureType.privateChat:
//         return Icons.chat_bubble_outline_rounded;
//
//       case VaultFeatureType.specialDates:
//         return Icons.event_outlined;
//
//       case VaultFeatureType.giftWishes:
//         return Icons.card_giftcard_outlined;
//
//       case VaultFeatureType.futureMessages:
//         return Icons.mail_outline_rounded;
//
//       case VaultFeatureType.loveNotifications:
//         return Icons.favorite_border_rounded;
//
//       case VaultFeatureType.photos:
//         return Icons.photo_library_outlined;
//
//       case VaultFeatureType.videos:
//         return Icons.videocam_outlined;
//     }
//   }
//
//   String get _addLabel {
//     switch (type) {
//       case VaultFeatureType.memories:
//         return 'Hide a memory';
//
//       case VaultFeatureType.privateChat:
//         return 'Start private chat';
//
//       case VaultFeatureType.specialDates:
//         return 'Add special date';
//
//       case VaultFeatureType.giftWishes:
//         return 'Add a wish';
//
//       case VaultFeatureType.futureMessages:
//         return 'Write for later';
//
//       case VaultFeatureType.loveNotifications:
//         return 'Create a reminder';
//
//       case VaultFeatureType.photos:
//         return 'Hide photos';
//
//       case VaultFeatureType.videos:
//         return 'Hide videos';
//     }
//   }
//
//   bool get _isMedia {
//     return type == VaultFeatureType.photos ||
//         type == VaultFeatureType.videos;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: Stack(
//         children: [
//           const _Background(),
//
//           CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               SliverToBoxAdapter(
//                 child: _buildTopBar(context),
//               ),
//
//               SliverToBoxAdapter(
//                 child: _buildHeader(),
//               ),
//
//               if (items.isEmpty)
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: _buildEmptyState(),
//                 )
//               else if (_isMedia)
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(
//                     20,
//                     10,
//                     20,
//                     130,
//                   ),
//                   sliver: SliverToBoxAdapter(
//                     child: _buildMediaGrid(),
//                   ),
//                 )
//               else
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(
//                     20,
//                     10,
//                     20,
//                     130,
//                   ),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                         final item = items[index];
//
//                         return Padding(
//                           padding: const EdgeInsets.only(
//                             bottom: 12,
//                           ),
//                           child: _FeatureCard(
//                             item: item,
//                             type: type,
//                             onTap: () {
//                               onItemTap?.call(item);
//                             },
//                           ),
//                         );
//                       },
//                       childCount: items.length,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//
//           if (onAdd != null) _buildBottomAction(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTopBar(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: SizedBox(
//         height: 68,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//           ),
//           child: Row(
//             children: [
//               _CircleButton(
//                 icon: Icons.arrow_back_ios_new_rounded,
//                 onTap: onBack ?? () => Navigator.pop(context),
//               ),
//
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     'Private Vault',
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//
//               _CircleButton(
//                 icon: Icons.more_horiz_rounded,
//                 onTap: onMore,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         20,
//         14,
//         20,
//         18,
//       ),
//       child: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(
//             maxWidth: 560,
//           ),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(
//               20,
//               20,
//               20,
//               22,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.76),
//               borderRadius: BorderRadius.circular(26),
//               border: Border.all(
//                 color: AppColors.outlineVariant
//                     .withValues(alpha: 0.55),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.04),
//                   blurRadius: 18,
//                   offset: const Offset(0, 7),
//                 ),
//               ],
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 54,
//                   height: 54,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFFCE4EC),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     _icon,
//                     color: AppColors.primary,
//                     size: 23,
//                   ),
//                 ),
//
//                 const SizedBox(width: 14),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _eyebrow,
//                         style: AppTextTheme.labelSmall.copyWith(
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 1.4,
//                           color: AppColors.primary,
//                         ),
//                       ),
//
//                       const SizedBox(height: 5),
//
//                       Text(
//                         _title,
//                         style: GoogleFonts.playfairDisplay(
//                           fontSize: 25,
//                           height: 1.1,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//
//                       const SizedBox(height: 7),
//
//                       Text(
//                         _description,
//                         style: AppTextTheme.bodyMedium.copyWith(
//                           fontSize: 11.5,
//                           height: 1.45,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(width: 8),
//
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 9,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.textPrimary
//                         .withValues(alpha: 0.06),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${items.length}',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(
//           30,
//           10,
//           30,
//           130,
//         ),
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(
//             maxWidth: 390,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 92,
//                 height: 92,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFCE4EC),
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: AppColors.primary
//                         .withValues(alpha: 0.10),
//                   ),
//                 ),
//                 child: Icon(
//                   _icon,
//                   size: 34,
//                   color: AppColors.primary,
//                 ),
//               ),
//
//               const SizedBox(height: 22),
//
//               Text(
//                 'Nothing hidden here yet.',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.playfairDisplay(
//                   fontSize: 23,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               Text(
//                 'Some things are worth keeping a little closer. '
//                     'This space is yours to fill.',
//                 textAlign: TextAlign.center,
//                 style: AppTextTheme.bodyMedium.copyWith(
//                   fontSize: 12,
//                   height: 1.55,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//
//               const SizedBox(height: 22),
//
//               if (onAdd != null)
//                 OutlinedButton.icon(
//                   onPressed: onAdd,
//                   icon: const Icon(
//                     Icons.add_rounded,
//                     size: 18,
//                   ),
//                   label: Text(
//                     _addLabel,
//                     style: AppTextTheme.labelLarge.copyWith(
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.textPrimary,
//                     side: const BorderSide(
//                       color: AppColors.outlineVariant,
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 13,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMediaGrid() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: items.length,
//       gridDelegate:
//       const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.86,
//       ),
//       itemBuilder: (context, index) {
//         final item = items[index];
//
//         return _MediaCard(
//           item: item,
//           type: type,
//           onTap: () {
//             onItemTap?.call(item);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildBottomAction() {
//     return Positioned(
//       left: 20,
//       right: 20,
//       bottom: 16,
//       child: SafeArea(
//         top: false,
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 420,
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: onAdd,
//                 borderRadius: BorderRadius.circular(27),
//                 child: Ink(
//                   height: 62,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF171515),
//                         Color(0xFF302727),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(27),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black
//                             .withValues(alpha: 0.18),
//                         blurRadius: 22,
//                         offset: const Offset(0, 9),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 12),
//
//                       Container(
//                         width: 42,
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: Colors.white
//                               .withValues(alpha: 0.08),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           _icon,
//                           color: Colors.white,
//                           size: 19,
//                         ),
//                       ),
//
//                       const SizedBox(width: 12),
//
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment:
//                           MainAxisAlignment.center,
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               _addLabel.toUpperCase(),
//                               style: GoogleFonts.inter(
//                                 fontSize: 10.5,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 1.2,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 3),
//                             Text(
//                               'Keep it just between us',
//                               style: GoogleFonts.inter(
//                                 fontSize: 10,
//                                 color: Colors.white
//                                     .withValues(alpha: 0.55),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       Container(
//                         width: 34,
//                         height: 34,
//                         margin: const EdgeInsets.only(
//                           right: 13,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white
//                               .withValues(alpha: 0.09),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.add_rounded,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                       ),
//                     ],
//                   ),
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
// class _Background extends StatelessWidget {
//   const _Background();
//
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Stack(
//         children: [
//           Positioned(
//             top: -90,
//             right: -70,
//             child: Container(
//               width: 220,
//               height: 220,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFCE4EC)
//                     .withValues(alpha: 0.45),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 120,
//             left: -100,
//             child: Container(
//               width: 220,
//               height: 220,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE8B4B8)
//                     .withValues(alpha: 0.10),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CircleButton extends StatelessWidget {
//   const _CircleButton({
//     required this.icon,
//     this.onTap,
//   });
//
//   final IconData icon;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(21),
//         child: Ink(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.70),
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: AppColors.outlineVariant
//                   .withValues(alpha: 0.55),
//             ),
//           ),
//           child: Icon(
//             icon,
//             size: 18,
//             color: AppColors.textPrimary,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _FeatureCard extends StatelessWidget {
//   const _FeatureCard({
//     required this.item,
//     required this.type,
//     required this.onTap,
//   });
//
//   final VaultFeatureItem item;
//   final VaultFeatureType type;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(22),
//         child: Ink(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.82),
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(
//               color: AppColors.outlineVariant
//                   .withValues(alpha: 0.55),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.035),
//                 blurRadius: 14,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               _FeatureIcon(
//                 icon: item.icon ?? _iconFor(type),
//                 unread: item.isUnread,
//               ),
//
//               const SizedBox(width: 13),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             item.title,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.playfairDisplay(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                         ),
//
//                         if (item.isLocked)
//                           const Icon(
//                             Icons.lock_outline_rounded,
//                             size: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 4),
//
//                     Text(
//                       item.subtitle,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTextTheme.bodyMedium.copyWith(
//                         fontSize: 11.5,
//                         height: 1.4,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     Text(
//                       item.dateLabel,
//                       style: AppTextTheme.labelSmall.copyWith(
//                         fontSize: 9.5,
//                         color: AppColors.textDisabled,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               const Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 12,
//                 color: AppColors.primary,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   static IconData _iconFor(VaultFeatureType type) {
//     switch (type) {
//       case VaultFeatureType.memories:
//         return Icons.auto_awesome_outlined;
//       case VaultFeatureType.privateChat:
//         return Icons.chat_bubble_outline_rounded;
//       case VaultFeatureType.specialDates:
//         return Icons.event_outlined;
//       case VaultFeatureType.giftWishes:
//         return Icons.card_giftcard_outlined;
//       case VaultFeatureType.futureMessages:
//         return Icons.mail_outline_rounded;
//       case VaultFeatureType.loveNotifications:
//         return Icons.favorite_border_rounded;
//       case VaultFeatureType.photos:
//         return Icons.photo_library_outlined;
//       case VaultFeatureType.videos:
//         return Icons.videocam_outlined;
//     }
//   }
// }
//
// class _FeatureIcon extends StatelessWidget {
//   const _FeatureIcon({
//     required this.icon,
//     this.unread = false,
//   });
//
//   final IconData icon;
//   final bool unread;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: 48,
//           height: 48,
//           decoration: const BoxDecoration(
//             color: Color(0xFFFCE4EC),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             size: 20,
//             color: AppColors.primary,
//           ),
//         ),
//
//         if (unread)
//           Positioned(
//             top: 1,
//             right: 1,
//             child: Container(
//               width: 9,
//               height: 9,
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Colors.white,
//                   width: 2,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
//
// class _MediaCard extends StatelessWidget {
//   const _MediaCard({
//     required this.item,
//     required this.type,
//     required this.onTap,
//   });
//
//   final VaultFeatureItem item;
//   final VaultFeatureType type;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final isVideo = type == VaultFeatureType.videos;
//
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(22),
//         child: Ink(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(
//               color: AppColors.outlineVariant
//                   .withValues(alpha: 0.5),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.04),
//                 blurRadius: 15,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(21),
//                   ),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       if (item.image != null)
//                         Image(
//                           image: item.image!,
//                           fit: BoxFit.cover,
//                         )
//                       else
//                         Container(
//                           color: const Color(0xFFF3E9E8),
//                           child: Icon(
//                             isVideo
//                                 ? Icons.videocam_outlined
//                                 : Icons.photo_outlined,
//                             size: 32,
//                             color: AppColors.primary,
//                           ),
//                         ),
//
//                       if (isVideo)
//                         Center(
//                           child: Container(
//                             width: 44,
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: Colors.black
//                                   .withValues(alpha: 0.55),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.play_arrow_rounded,
//                               color: Colors.white,
//                               size: 23,
//                             ),
//                           ),
//                         ),
//
//                       Positioned(
//                         top: 10,
//                         right: 10,
//                         child: Container(
//                           width: 30,
//                           height: 30,
//                           decoration: BoxDecoration(
//                             color: Colors.black
//                                 .withValues(alpha: 0.42),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.lock_outline_rounded,
//                             size: 14,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(
//                   13,
//                   11,
//                   13,
//                   13,
//                 ),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.playfairDisplay(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//
//                     const SizedBox(height: 3),
//
//                     Text(
//                       item.dateLabel,
//                       style: AppTextTheme.labelSmall.copyWith(
//                         fontSize: 9,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

enum VaultFeatureType {
  memories,
  privateChat,
  specialDates,
  giftWishes,
  futureMessages,
  loveNotifications,
  photos,
  videos,
}

class VaultFeatureItem {
  const VaultFeatureItem({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    this.description,
    this.icon,
    this.image,
    this.isUnread = false,
    this.isLocked = false,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String? description;
  final IconData? icon;
  final ImageProvider? image;
  final bool isUnread;
  final bool isLocked;
}

class VaultFeatureScreen extends StatefulWidget {
  const VaultFeatureScreen({
    super.key,
    required this.type,
    this.items = const [],
    this.onBack,
    this.onAdd,
    this.onItemTap,
    this.onMore,
  });

  final VaultFeatureType type;
  final List<VaultFeatureItem> items;

  final VoidCallback? onBack;
  final VoidCallback? onAdd;
  final ValueChanged<VaultFeatureItem>? onItemTap;
  final VoidCallback? onMore;

  @override
  State<VaultFeatureScreen> createState() =>
      _VaultFeatureScreenState();
}

class _VaultFeatureScreenState
    extends State<VaultFeatureScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'Hidden Memories';

      case VaultFeatureType.privateChat:
        return 'Private Chat';

      case VaultFeatureType.specialDates:
        return 'Special Dates';

      case VaultFeatureType.giftWishes:
        return 'Gift Wishes';

      case VaultFeatureType.futureMessages:
        return 'Future Messages';

      case VaultFeatureType.loveNotifications:
        return 'Love Notifications';

      case VaultFeatureType.photos:
        return 'Private Photos';

      case VaultFeatureType.videos:
        return 'Private Videos';
    }
  }

  String get _eyebrow {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'MOMENTS WE KEEP';

      case VaultFeatureType.privateChat:
        return 'JUST BETWEEN US';

      case VaultFeatureType.specialDates:
        return 'DATES THAT MATTER';

      case VaultFeatureType.giftWishes:
        return 'LITTLE WISHES';

      case VaultFeatureType.futureMessages:
        return 'FOR LATER';

      case VaultFeatureType.loveNotifications:
        return 'LITTLE REMINDERS';

      case VaultFeatureType.photos:
        return 'PRIVATE MOMENTS';

      case VaultFeatureType.videos:
        return 'MOMENTS IN MOTION';
    }
  }

  String get _description {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'The moments you chose to keep just between you.';

      case VaultFeatureType.privateChat:
        return 'Conversations that belong only to the two of you.';

      case VaultFeatureType.specialDates:
        return 'The dates you never want to forget.';

      case VaultFeatureType.giftWishes:
        return 'Things you secretly hope to give or receive.';

      case VaultFeatureType.futureMessages:
        return 'Words waiting for the right moment.';

      case VaultFeatureType.loveNotifications:
        return 'Little reminders that make your day softer.';

      case VaultFeatureType.photos:
        return 'Photos that are meant for your eyes only.';

      case VaultFeatureType.videos:
        return 'Moving memories kept safely between you.';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return Icons.auto_awesome_outlined;

      case VaultFeatureType.privateChat:
        return Icons.chat_bubble_outline_rounded;

      case VaultFeatureType.specialDates:
        return Icons.event_outlined;

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

  String get _addLabel {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'Keep a memory close';

      case VaultFeatureType.privateChat:
        return 'Start private chat';

      case VaultFeatureType.specialDates:
        return 'Add special date';

      case VaultFeatureType.giftWishes:
        return 'Add a wish';

      case VaultFeatureType.futureMessages:
        return 'Write for later';

      case VaultFeatureType.loveNotifications:
        return 'Create a reminder';

      case VaultFeatureType.photos:
        return 'Hide photos';

      case VaultFeatureType.videos:
        return 'Hide videos';
    }
  }

  bool get _isMedia =>
      widget.type == VaultFeatureType.photos ||
          widget.type == VaultFeatureType.videos;

  List<VaultFeatureItem> get _filteredItems {
    if (_searchQuery.trim().isEmpty) {
      return widget.items;
    }

    final query = _searchQuery.toLowerCase();

    return widget.items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query) ||
          item.dateLabel.toLowerCase().contains(query) ||
          (item.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const _VaultBackground(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(context),
              ),

              SliverToBoxAdapter(
                child: _buildHero(),
              ),

              SliverToBoxAdapter(
                child: _buildInsightStrip(),
              ),

              if (widget.items.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildSearchAndSort(),
                ),

              if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              else if (_isMedia)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    130,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildMediaGrid(items),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    130,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = items[index];

                        return _AnimatedEntry(
                          index: index,
                          controller: _animationController,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: _VaultItemCard(
                              item: item,
                              type: widget.type,
                              onTap: () {
                                widget.onItemTap?.call(item);
                              },
                            ),
                          ),
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
            ],
          ),

          if (widget.onAdd != null)
            _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
        child: Row(
          children: [
            _RoundButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: widget.onBack ??
                      () => Navigator.of(context).pop(),
            ),

            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _showSearch
                      ? Container(
                    key: const ValueKey('search'),
                    height: 42,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.82,
                      ),
                      borderRadius:
                      BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.outlineVariant
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    child: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search your private space',
                        hintStyle:
                        AppTextTheme.bodyMedium.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 11,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 11,
                        ),
                      ),
                    ),
                  )
                      : Text(
                    'Private Vault',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            _RoundButton(
              icon: _showSearch
                  ? Icons.close_rounded
                  : Icons.search_rounded,
              onTap: () {
                setState(() {
                  _showSearch = !_showSearch;

                  if (!_showSearch) {
                    _searchQuery = '';
                  }
                });
              },
            ),

            const SizedBox(width: 8),

            _RoundButton(
              icon: Icons.more_horiz_rounded,
              onTap: widget.onMore,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final opacity =
          Curves.easeOut.transform(_animationController.value);

          final offset =
              18 * (1 - _animationController.value);

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, offset),
              child: child,
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 560,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF171515),
                Color(0xFF302727),
                Color(0xFF49373A),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -25,
                top: -30,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.10),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.10,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.10,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 11),

                      Text(
                        'PRIVATE & LOCKED',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.white.withValues(
                            alpha: 0.55,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              size: 11,
                              color: Color(0xFFE8B4B8),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.items.length}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    _eyebrow,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.7,
                      color: const Color(0xFFE8B4B8),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      height: 1.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    _description,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      height: 1.5,
                      color: Colors.white.withValues(
                        alpha: 0.62,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      _HeroStat(
                        value: '${widget.items.length}',
                        label: _statLabel,
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.white.withValues(
                          alpha: 0.10,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const _HeroStat(
                        value: '100%',
                        label: 'PRIVATE',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _statLabel {
    switch (widget.type) {
      case VaultFeatureType.memories:
        return 'MEMORIES';
      case VaultFeatureType.privateChat:
        return 'MESSAGES';
      case VaultFeatureType.specialDates:
        return 'DATES';
      case VaultFeatureType.giftWishes:
        return 'WISHES';
      case VaultFeatureType.futureMessages:
        return 'LETTERS';
      case VaultFeatureType.loveNotifications:
        return 'REMINDERS';
      case VaultFeatureType.photos:
        return 'PHOTOS';
      case VaultFeatureType.videos:
        return 'VIDEOS';
    }
  }

  Widget _buildInsightStrip() {
    if (widget.items.isEmpty) {
      return const SizedBox(height: 4);
    }

    final latest = widget.items.first.dateLabel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.74),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(
              alpha: 0.48,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 15,
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
                    'YOUR LITTLE CORNER',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.items.length == 1
                        ? 'One thing you chose to keep close.'
                        : '${widget.items.length} things you chose to keep close.',
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              latest,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
      child: Row(
        children: [
          Text(
            _isMedia ? 'PRIVATE MOMENTS' : 'RECENTLY KEPT',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          if (_searchQuery.isNotEmpty)
            Text(
              '${_filteredItems.length} found',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<VaultFeatureItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.84,
      ),
      itemBuilder: (context, index) {
        return _AnimatedEntry(
          index: index,
          controller: _animationController,
          child: _VaultMediaCard(
            item: items[index],
            isVideo: widget.type == VaultFeatureType.videos,
            onTap: () {
              widget.onItemTap?.call(items[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          28,
          20,
          28,
          130,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: 0.08,
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    _icon,
                    size: 34,
                    color: AppColors.primary,
                  ),
                  Positioned(
                    right: 25,
                    bottom: 22,
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration: const BoxDecoration(
                        color: AppColors.textPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              _searchQuery.isNotEmpty
                  ? 'Nothing found.'
                  : 'Nothing hidden here yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              _searchQuery.isNotEmpty
                  ? 'Try another little memory or word.'
                  : 'Some things are worth keeping a little closer. '
                  'This space is yours to fill.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),

            if (_searchQuery.isEmpty &&
                widget.onAdd != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: widget.onAdd,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 18,
                ),
                label: Text(
                  _addLabel,
                  style: AppTextTheme.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(
                    color: AppColors.outlineVariant,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 14,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 14,
                  sigmaY: 14,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onAdd,
                    borderRadius: BorderRadius.circular(28),
                    child: Ink(
                      height: 62,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF171515),
                            Color(0xFF3B2C2E),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.08,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.20,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 11),

                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.09,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _icon,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _addLabel,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Keep it just between us',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    color: Colors.white
                                        .withValues(alpha: 0.52),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8B4B8)
                                  .withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFFE8B4B8),
                              size: 18,
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
      ),
    );
  }
}


class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.76),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Icon(
            icon,
            size: 17,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}



class _VaultItemCard extends StatelessWidget {
  const _VaultItemCard({
    required this.item,
    required this.type,
    required this.onTap,
  });

  final VaultFeatureItem item;
  final VaultFeatureType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = item.image != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(
                alpha: 0.48,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: SizedBox(
                      width: 74,
                      height: 74,
                      child: Image(
                        image: item.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  _VaultIcon(
                    icon: item.icon ?? _iconFor(type),
                    unread: item.isUnread,
                  ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          if (item.isLocked)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                size: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontSize: 11.5,
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 9),

                      Row(
                        children: [
                          Icon(
                            _iconFor(type),
                            size: 11,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.dateLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              AppTextTheme.labelSmall.copyWith(
                                fontSize: 9,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ),
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
        ),
      ),
    );
  }

  static IconData _iconFor(VaultFeatureType type) {
    switch (type) {
      case VaultFeatureType.memories:
        return Icons.auto_awesome_outlined;
      case VaultFeatureType.privateChat:
        return Icons.chat_bubble_outline_rounded;
      case VaultFeatureType.specialDates:
        return Icons.event_outlined;
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
}


class _VaultIcon extends StatelessWidget {
  const _VaultIcon({
    required this.icon,
    this.unread = false,
  });

  final IconData icon;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCE4EC),
                Color(0xFFF7EDEE),
              ],
            ),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Icon(
            icon,
            size: 25,
            color: AppColors.primary,
          ),
        ),

        if (unread)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}




class _VaultMediaCard extends StatelessWidget {
  const _VaultMediaCard({
    required this.item,
    required this.isVideo,
    required this.onTap,
  });

  final VaultFeatureItem item;
  final bool isVideo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          height: 230,
          decoration: BoxDecoration(
            color: const Color(0xFFF1E8E7),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (item.image != null)
                  Image(
                    image: item.image!,
                    fit: BoxFit.cover,
                  )
                else
                  Center(
                    child: Icon(
                      isVideo
                          ? Icons.videocam_outlined
                          : Icons.photo_outlined,
                      size: 35,
                      color: AppColors.primary,
                    ),
                  ),

                // cinematic gradient
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.68),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 11,
                  right: 11,
                  child: Container(
                    width: 31,
                    height: 31,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.38),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),

                if (isVideo)
                  Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.48),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),

                Positioned(
                  left: 13,
                  right: 13,
                  bottom: 13,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.dateLabel,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.white.withValues(
                            alpha: 0.70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        start,
        end,
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
              18 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}



class _VaultBackground extends StatelessWidget {
  const _VaultBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.48),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 360,
            left: -120,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 120,
            right: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF6B6D91)
                    .withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}