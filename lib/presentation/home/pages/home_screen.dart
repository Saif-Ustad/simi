// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../common/widgets/app_main_button.dart';
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_text_theme.dart';
//
// enum HomeMode { firstTime, populated }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({
//     super.key,
//     this.mode = HomeMode.firstTime,
//     this.myName = 'Saif',
//     this.partnerName = 'Simran',
//     this.storyStartDate,
//     this.myMood,
//     this.partnerMood,
//     this.nextSpecialDate,
//     this.specialDateLabel,
//     this.memoryTitle,
//     this.memoryDescription,
//     this.futureMessageAvailable = false,
//     this.journalPrompt,
//     this.cycleText,
//     this.userPhoto,
//     this.partnerPhoto,
//     this.onAddMemory,
//     this.onJournal,
//     this.onSpecialDate,
//     this.onFutureMessage,
//     this.onMood,
//     this.onCycle,
//     this.onGallery,
//     this.onMore,
//   });
//
//   final HomeMode mode;
//
//   final String myName;
//   final String partnerName;
//
//   final DateTime? storyStartDate;
//
//   final String? myMood;
//   final String? partnerMood;
//
//   final DateTime? nextSpecialDate;
//   final String? specialDateLabel;
//
//   final String? memoryTitle;
//   final String? memoryDescription;
//
//   final bool futureMessageAvailable;
//
//   final String? journalPrompt;
//
//   final String? cycleText;
//
//   final ImageProvider? userPhoto;
//   final ImageProvider? partnerPhoto;
//
//   final VoidCallback? onAddMemory;
//   final VoidCallback? onJournal;
//   final VoidCallback? onSpecialDate;
//   final VoidCallback? onFutureMessage;
//   final VoidCallback? onMood;
//   final VoidCallback? onCycle;
//   final VoidCallback? onGallery;
//   final VoidCallback? onMore;
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int get _daysTogether {
//     if (widget.storyStartDate == null) {
//       return 0;
//     }
//
//     final start = DateTime(
//       widget.storyStartDate!.year,
//       widget.storyStartDate!.month,
//       widget.storyStartDate!.day,
//     );
//
//     final today = DateTime.now();
//
//     final current = DateTime(today.year, today.month, today.day);
//
//     return current.difference(start).inDays;
//   }
//
//   String get _greeting {
//     final hour = DateTime.now().hour;
//
//     if (hour < 12) {
//       return 'Good morning,';
//     }
//
//     if (hour < 17) {
//       return 'Good afternoon,';
//     }
//
//     if (hour < 21) {
//       return 'Good evening,';
//     }
//
//     return 'Good night,';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: SafeArea(bottom: false, child: _buildHome()),
//     );
//   }
//
//   // ============================================================
//   // HOME
//   // ============================================================
//
//   Widget _buildHome() {
//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         SliverToBoxAdapter(child: _buildTopBar()),
//
//         SliverPadding(
//           padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
//           sliver: SliverList(
//             delegate: SliverChildListDelegate(
//               widget.mode == HomeMode.firstTime
//                   ? _firstTimeContent()
//                   : _populatedContent(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
//       child: Row(
//         children: [
//           _CoupleAvatar(
//             image: widget.userPhoto,
//             fallbackIcon: Icons.person_outline_rounded,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'MY LOVE',
//                   style: GoogleFonts.inter(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1.4,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${widget.myName} & ${widget.partnerName}',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 19,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _CircleIconButton(icon: Icons.lock_outline_rounded, onTap: () {}),
//         ],
//       ),
//     );
//   }
//   // ============================================================
//   // FIRST TIME HOME
//   // ============================================================
//
//   List<Widget> _firstTimeContent() {
//     return [
//       _buildFirstGreeting(),
//
//       const SizedBox(height: 20),
//
//       _buildStoryCard(),
//
//       const SizedBox(height: 24),
//
//       _buildSectionTitle(eyebrow: 'YOUR LITTLE WORLD', title: 'Make it yours.'),
//
//       const SizedBox(height: 12),
//
//       _buildFirstTimeActions(),
//
//       const SizedBox(height: 24),
//
//       _buildPrivacyCard(),
//
//       const SizedBox(height: 24),
//
//       _buildFirstMemoryCard(),
//     ];
//   }
//
//   Widget _buildFirstGreeting() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Welcome to SIMI ❤️',
//           style: AppTextTheme.headlineMedium.copyWith(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.w600,
//             height: 1.2,
//           ),
//         ),
//
//         const SizedBox(height: 6),
//
//         Text(
//           'A private little space made just for the two of you.',
//           style: GoogleFonts.inter(
//             fontSize: 14,
//             height: 1.5,
//             color: AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStoryCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.primaryContainer, AppColors.surfaceBright],
//         ),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withValues(alpha: 0.10),
//             blurRadius: 22,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             right: -20,
//             top: -28,
//             child: Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withValues(alpha: 0.28),
//               ),
//             ),
//           ),
//
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   _SmallIconCircle(
//                     icon: Icons.favorite_rounded,
//                     background: Colors.white.withValues(alpha: 0.65),
//                     foreground: AppColors.primary,
//                   ),
//
//                   const Spacer(),
//
//                   Text(
//                     'YOUR STORY',
//                     style: GoogleFonts.inter(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 1.2,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               Text(
//                 widget.storyStartDate != null
//                     ? 'Together for'
//                     : 'Your story begins here',
//                 style: GoogleFonts.inter(
//                   fontSize: 13,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//
//               const SizedBox(height: 2),
//
//               if (widget.storyStartDate != null)
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       '$_daysTogether',
//                       style: GoogleFonts.playfairDisplay(
//                         fontSize: 42,
//                         height: 1,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//
//                     const SizedBox(width: 8),
//
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Text(
//                         _daysTogether == 1 ? 'day' : 'days',
//                         style: GoogleFonts.inter(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               else
//                 Text(
//                   'A beautiful story starts\nwith little moments.',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 22,
//                     height: 1.25,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//
//               const SizedBox(height: 10),
//
//               if (widget.storyStartDate != null)
//                 Text(
//                   'And there are many more memories to come. ❤️',
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     height: 1.5,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // FIRST TIME ACTIONS
//   // ============================================================
//
//   Widget _buildFirstTimeActions() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: _HomeActionCard(
//                 icon: Icons.photo_camera_outlined,
//                 title: 'Memory',
//                 subtitle: 'Save a moment',
//                 color: AppColors.primaryContainer,
//                 onTap: widget.onAddMemory,
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             Expanded(
//               child: _HomeActionCard(
//                 icon: Icons.edit_note_rounded,
//                 title: 'Journal',
//                 subtitle: 'Write something',
//                 color: const Color(0xFFEDE7E8),
//                 onTap: widget.onJournal,
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 12),
//
//         Row(
//           children: [
//             Expanded(
//               child: _HomeActionCard(
//                 icon: Icons.event_outlined,
//                 title: 'Special Date',
//                 subtitle: 'Never forget',
//                 color: const Color(0xFFE8E5F4),
//                 onTap: widget.onSpecialDate,
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             Expanded(
//               child: _HomeActionCard(
//                 icon: Icons.mail_outline_rounded,
//                 title: 'Future Message',
//                 subtitle: 'Write for later',
//                 color: const Color(0xFFE5E2F2),
//                 onTap: widget.onFutureMessage,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // PRIVACY
//   // ============================================================
//
//   Widget _buildPrivacyCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.textPrimary,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withValues(alpha: 0.10),
//             ),
//             child: const Icon(
//               Icons.lock_outline_rounded,
//               size: 20,
//               color: Colors.white,
//             ),
//           ),
//
//           const SizedBox(width: 14),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Just for the two of you.',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//
//                 const SizedBox(height: 3),
//
//                 Text(
//                   'Your memories, messages and moments stay in your little world.',
//                   style: GoogleFonts.inter(
//                     fontSize: 11,
//                     height: 1.45,
//                     color: Colors.white.withValues(alpha: 0.70),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // FIRST MEMORY
//   // ============================================================
//
//   Widget _buildFirstMemoryCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(alpha: 0.55),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'FIRST MEMORY',
//                 style: GoogleFonts.inter(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 1.1,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//
//               const Spacer(),
//
//               Icon(
//                 Icons.auto_awesome_rounded,
//                 size: 16,
//                 color: AppColors.primary,
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           Text(
//             'What should you remember forever?',
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 21,
//               height: 1.25,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 7),
//
//           Text(
//             'Add your first photo, date or little story together.',
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               height: 1.5,
//               color: AppColors.textSecondary,
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           SizedBox(
//             width: double.infinity,
//             child: AppMainButton(
//               text: 'Add First Memory',
//               onPressed: widget.onAddMemory,
//               height: 48,
//               borderRadius: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // POPULATED HOME
//   // ============================================================
//
//   List<Widget> _populatedContent() {
//     return [
//       _buildPopulatedGreeting(),
//
//       const SizedBox(height: 18),
//
//       _buildRelationshipSummary(),
//
//       const SizedBox(height: 22),
//
//       _buildSectionTitle(eyebrow: 'TODAY', title: 'How are we feeling?'),
//
//       const SizedBox(height: 12),
//
//       _buildTodayCards(),
//
//       const SizedBox(height: 22),
//
//       if (widget.nextSpecialDate != null) ...[
//         _buildNextSpecialDate(),
//         const SizedBox(height: 22),
//       ],
//
//       if (widget.memoryTitle != null) ...[
//         _buildMemoryOfDay(),
//         const SizedBox(height: 22),
//       ],
//
//       if (widget.futureMessageAvailable) ...[
//         _buildFutureMessage(),
//         const SizedBox(height: 22),
//       ],
//
//       _buildJournalPrompt(),
//
//       const SizedBox(height: 22),
//
//       _buildQuickActions(),
//     ];
//   }
//
//   Widget _buildPopulatedGreeting() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _greeting,
//           style: GoogleFonts.inter(
//             fontSize: 13,
//             color: AppColors.textSecondary,
//           ),
//         ),
//
//         const SizedBox(height: 2),
//
//         Text(
//           '${widget.partnerName} ❤️',
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 30,
//             height: 1.15,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//
//         const SizedBox(height: 5),
//
//         Text(
//           'Your little world is waiting for you.',
//           style: GoogleFonts.inter(
//             fontSize: 13,
//             color: AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // RELATIONSHIP SUMMARY
//   // ============================================================
//
//   Widget _buildRelationshipSummary() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(alpha: 0.55),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 18,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _CoupleAvatar(
//             image: widget.userPhoto,
//             fallbackIcon: Icons.person_outline_rounded,
//           ),
//
//           const SizedBox(width: 8),
//
//           Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.primaryContainer,
//             ),
//             child: Icon(
//               Icons.favorite_rounded,
//               size: 14,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(width: 8),
//
//           _CoupleAvatar(
//             image: widget.partnerPhoto,
//             fallbackIcon: Icons.person_outline_rounded,
//           ),
//
//           const SizedBox(width: 16),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'TOGETHER',
//                   style: GoogleFonts.inter(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.1,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 3),
//
//                 Text(
//                   '$_daysTogether days',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Icon(
//             Icons.favorite_border_rounded,
//             size: 22,
//             color: AppColors.primary,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // TODAY
//   // ============================================================
//
//   Widget _buildTodayCards() {
//     return Row(
//       children: [
//         Expanded(
//           child: _InfoCard(
//             icon: Icons.sentiment_satisfied_alt_rounded,
//             title: 'My Mood',
//             value: widget.myMood ?? 'Not added',
//             iconBackground: AppColors.primaryContainer,
//             onTap: widget.onMood,
//           ),
//         ),
//
//         const SizedBox(width: 12),
//
//         Expanded(
//           child: _InfoCard(
//             icon: Icons.water_drop_outlined,
//             title: 'Period',
//             value: widget.cycleText ?? 'Not added',
//             iconBackground: const Color(0xFFE7E4F1),
//             onTap: widget.onCycle,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // SPECIAL DATE
//   // ============================================================
//
//   Widget _buildNextSpecialDate() {
//     final days = widget.nextSpecialDate
//         ?.difference(DateTime.now())
//         .inDays
//         .clamp(0, 9999);
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF6ECEB),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.75),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Icon(
//               Icons.event_rounded,
//               color: AppColors.primary,
//               size: 24,
//             ),
//           ),
//
//           const SizedBox(width: 14),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'UPCOMING',
//                   style: GoogleFonts.inter(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.1,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 Text(
//                   widget.specialDateLabel ?? 'Special day',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 19,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//
//                 if (days != null) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     days == 0 ? 'Today ❤️' : '$days days to go',
//                     style: GoogleFonts.inter(
//                       fontSize: 11,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//
//           Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // MEMORY
//   // ============================================================
//
//   Widget _buildMemoryOfDay() {
//     return Container(
//       width: double.infinity,
//       height: 230,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         color: AppColors.primaryContainer,
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Stack(
//         children: [
//           Positioned.fill(child: _MemoryBackground()),
//
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withValues(alpha: 0.62),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           Positioned(
//             left: 18,
//             right: 18,
//             bottom: 18,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'MEMORY OF THE DAY',
//                   style: GoogleFonts.inter(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.2,
//                     color: Colors.white.withValues(alpha: 0.85),
//                   ),
//                 ),
//
//                 const SizedBox(height: 5),
//
//                 Text(
//                   widget.memoryTitle ?? 'A beautiful moment',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 23,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//
//                 if (widget.memoryDescription != null) ...[
//                   const SizedBox(height: 3),
//                   Text(
//                     widget.memoryDescription!,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.inter(
//                       fontSize: 11,
//                       color: Colors.white.withValues(alpha: 0.80),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//
//           Positioned(
//             right: 16,
//             top: 16,
//             child: Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withValues(alpha: 0.85),
//               ),
//               child: Icon(
//                 Icons.favorite_rounded,
//                 size: 17,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // FUTURE MESSAGE
//   // ============================================================
//
//   Widget _buildFutureMessage() {
//     return InkWell(
//       onTap: widget.onFutureMessage,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(19),
//         decoration: BoxDecoration(
//           color: AppColors.secondary,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 46,
//               height: 46,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withValues(alpha: 0.12),
//               ),
//               child: const Icon(
//                 Icons.mail_outline_rounded,
//                 color: Colors.white,
//                 size: 21,
//               ),
//             ),
//
//             const SizedBox(width: 14),
//
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'FUTURE MESSAGE',
//                     style: GoogleFonts.inter(
//                       fontSize: 9,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 1.1,
//                       color: Colors.white.withValues(alpha: 0.70),
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   Text(
//                     'Something is waiting for you...',
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Icon(Icons.chevron_right_rounded, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // JOURNAL
//   // ============================================================
//
//   Widget _buildJournalPrompt() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF1ECEC),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'DAILY REFLECTION',
//                 style: GoogleFonts.inter(
//                   fontSize: 9,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 1.1,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//
//               const Spacer(),
//
//               Icon(
//                 Icons.edit_note_rounded,
//                 size: 18,
//                 color: AppColors.textSecondary,
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 12),
//
//           Text(
//             widget.journalPrompt ??
//                 'What was the best part of your day together?',
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 21,
//               height: 1.3,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           GestureDetector(
//             onTap: widget.onJournal,
//             child: Text(
//               'Write in Journal →',
//               style: GoogleFonts.inter(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // QUICK ACTIONS
//   // ============================================================
//
//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle(
//           eyebrow: 'QUICK ACTIONS',
//           title: 'Add to your world.',
//         ),
//
//         const SizedBox(height: 12),
//
//         Row(
//           children: [
//             Expanded(
//               child: _QuickAction(
//                 icon: Icons.add_photo_alternate_outlined,
//                 title: 'Memory',
//                 onTap: widget.onAddMemory,
//               ),
//             ),
//
//             const SizedBox(width: 10),
//
//             Expanded(
//               child: _QuickAction(
//                 icon: Icons.edit_outlined,
//                 title: 'Journal',
//                 onTap: widget.onJournal,
//               ),
//             ),
//
//             const SizedBox(width: 10),
//
//             Expanded(
//               child: _QuickAction(
//                 icon: Icons.event_outlined,
//                 title: 'Date',
//                 onTap: widget.onSpecialDate,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // SECTION TITLE
//   // ============================================================
//
//   Widget _buildSectionTitle({required String eyebrow, required String title}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           eyebrow,
//           style: GoogleFonts.inter(
//             fontSize: 9,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 1.2,
//             color: AppColors.textSecondary,
//           ),
//         ),
//
//         const SizedBox(height: 3),
//
//         Text(
//           title,
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 21,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // HOME ACTION CARD
// // ============================================================
//
// class _HomeActionCard extends StatelessWidget {
//   const _HomeActionCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//     this.onTap,
//   });
//
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         height: 116,
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(alpha: 0.45),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: color.withValues(alpha: 0.75),
//               ),
//               child: Icon(icon, size: 18, color: AppColors.primary),
//             ),
//
//             const Spacer(),
//
//             Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//
//             const SizedBox(height: 2),
//
//             Text(
//               subtitle,
//               style: GoogleFonts.inter(
//                 fontSize: 10,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================
// // INFO CARD
// // ============================================================
//
// class _InfoCard extends StatelessWidget {
//   const _InfoCard({
//     required this.icon,
//     required this.title,
//     required this.value,
//     required this.iconBackground,
//     this.onTap,
//   });
//
//   final IconData icon;
//   final String title;
//   final String value;
//   final Color iconBackground;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         height: 120,
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(alpha: 0.45),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: iconBackground,
//               ),
//               child: Icon(icon, size: 18, color: AppColors.primary),
//             ),
//
//             const Spacer(),
//
//             Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontSize: 10,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//
//             const SizedBox(height: 3),
//
//             Text(
//               value,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.inter(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================
// // QUICK ACTION
// // ============================================================
//
// class _QuickAction extends StatelessWidget {
//   const _QuickAction({required this.icon, required this.title, this.onTap});
//
//   final IconData icon;
//   final String title;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         height: 76,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: AppColors.outlineVariant.withValues(alpha: 0.45),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 20, color: AppColors.primary),
//
//             const SizedBox(height: 7),
//
//             Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================
// // COUPLE AVATAR
// // ============================================================
// class _CoupleAvatar extends StatelessWidget {
//   const _CoupleAvatar({required this.image, required this.fallbackIcon});
//
//   final ImageProvider? image;
//   final IconData fallbackIcon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 44,
//       height: 44,
//       padding: const EdgeInsets.all(2),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.surfaceBright,
//         border: Border.all(color: AppColors.primaryContainer, width: 1.5),
//       ),
//       child: CircleAvatar(
//         backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.35),
//         backgroundImage: image,
//         child:
//             image == null
//                 ? Icon(fallbackIcon, size: 21, color: AppColors.primary)
//                 : null,
//       ),
//     );
//   }
// }
//
// // ============================================================
// // SMALL ICON CIRCLE
// // ============================================================
//
// class _SmallIconCircle extends StatelessWidget {
//   const _SmallIconCircle({
//     required this.icon,
//     required this.background,
//     required this.foreground,
//   });
//
//   final IconData icon;
//   final Color background;
//   final Color foreground;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 38,
//       height: 38,
//       decoration: BoxDecoration(shape: BoxShape.circle, color: background),
//       child: Icon(icon, size: 18, color: foreground),
//     );
//   }
// }
//
// // ============================================================
// // CIRCLE ICON BUTTON
// // ============================================================
//
// class _CircleIconButton extends StatelessWidget {
//   const _CircleIconButton({required this.icon, this.onTap});
//
//   final IconData icon;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white.withValues(alpha: 0.75),
//       shape: const CircleBorder(),
//       child: InkWell(
//         onTap: onTap,
//         customBorder: const CircleBorder(),
//         child: SizedBox(
//           width: 40,
//           height: 40,
//           child: Icon(icon, size: 18, color: AppColors.textPrimary),
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================
// // MEMORY BACKGROUND
// // ============================================================
//
// class _MemoryBackground extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(painter: _MemoryPainter());
//   }
// }
//
// class _MemoryPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();
//
//     paint.shader = const LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [Color(0xFFEBCDCF), Color(0xFFC8B5B1), Color(0xFF8E7773)],
//     ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     canvas.drawRect(Offset.zero & size, paint);
//
//     final circlePaint = Paint()..color = Colors.white.withValues(alpha: 0.13);
//
//     canvas.drawCircle(
//       Offset(size.width * 0.18, size.height * 0.28),
//       size.width * 0.25,
//       circlePaint,
//     );
//
//     canvas.drawCircle(
//       Offset(size.width * 0.82, size.height * 0.22),
//       size.width * 0.18,
//       circlePaint,
//     );
//
//     final heartPaint = Paint()..color = Colors.white.withValues(alpha: 0.12);
//
//     final path = Path();
//
//     final centerX = size.width * 0.50;
//     final centerY = size.height * 0.40;
//
//     path.moveTo(centerX, centerY + 35);
//
//     path.cubicTo(
//       centerX - 65,
//       centerY - 8,
//       centerX - 48,
//       centerY - 55,
//       centerX - 18,
//       centerY - 55,
//     );
//
//     path.cubicTo(
//       centerX,
//       centerY - 55,
//       centerX,
//       centerY - 34,
//       centerX,
//       centerY - 34,
//     );
//
//     path.cubicTo(
//       centerX,
//       centerY - 34,
//       centerX,
//       centerY - 55,
//       centerX + 18,
//       centerY - 55,
//     );
//
//     path.cubicTo(
//       centerX + 48,
//       centerY - 55,
//       centerX + 65,
//       centerY - 8,
//       centerX,
//       centerY + 35,
//     );
//
//     canvas.drawPath(path, heartPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }


import 'package:flutter/material.dart';
import 'package:simi/common/widgets/app_profile_avatar.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

enum HomeMode { firstTime, populated }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.mode = HomeMode.firstTime,
    this.myName = 'Saif',
    this.partnerName = 'Simran',
    this.storyStartDate,
    this.myMood,
    this.partnerMood,
    this.nextSpecialDate,
    this.specialDateLabel,
    this.memoryTitle,
    this.memoryDescription,
    this.futureMessageAvailable = false,
    this.cycleText,
    this.userPhoto,
    this.partnerPhoto,
    this.onAddMemory,
    this.onPeriod,
    this.onSpecialDate,
    this.onFutureMessage,
    this.onMood,
    this.onCycle,
    this.onGallery,
    this.onMore,
  });

  final HomeMode mode;

  final String myName;
  final String partnerName;

  final DateTime? storyStartDate;

  final String? myMood;
  final String? partnerMood;

  final DateTime? nextSpecialDate;
  final String? specialDateLabel;

  final String? memoryTitle;
  final String? memoryDescription;

  final bool futureMessageAvailable;

  final String? cycleText;

  final ImageProvider? userPhoto;
  final ImageProvider? partnerPhoto;

  final VoidCallback? onAddMemory;
  final VoidCallback? onPeriod;
  final VoidCallback? onSpecialDate;
  final VoidCallback? onFutureMessage;
  final VoidCallback? onMood;
  final VoidCallback? onCycle;
  final VoidCallback? onGallery;
  final VoidCallback? onMore;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get _daysTogether {
    if (widget.storyStartDate == null) {
      return 0;
    }

    final start = DateTime(
      widget.storyStartDate!.year,
      widget.storyStartDate!.month,
      widget.storyStartDate!.day,
    );

    final today = DateTime.now();

    final current = DateTime(today.year, today.month, today.day);

    return current.difference(start).inDays;
  }

  String get _greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning,';
    }

    if (hour < 17) {
      return 'Good afternoon,';
    }

    if (hour < 21) {
      return 'Good evening,';
    }

    return 'Good night,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: _buildHome(),
      ),
    );
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHome() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildTopBar(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              widget.mode == HomeMode.firstTime
                  ? _firstTimeContent()
                  : _populatedContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          AppProfileAvatar(
            image: widget.userPhoto,
            fallbackIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY LOVE',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.myName} & ${widget.partnerName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          _CircleIconButton(
            icon: Icons.lock_outline_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FIRST TIME HOME
  // ============================================================

  List<Widget> _firstTimeContent() {
    return [
      _buildFirstGreeting(),

      const SizedBox(height: 20),

      _buildStoryCard(),

      const SizedBox(height: 24),

      _buildSectionTitle(
        eyebrow: 'YOUR LITTLE WORLD',
        title: 'Make it yours.',
      ),

      const SizedBox(height: 12),

      _buildFirstTimeActions(),

      const SizedBox(height: 24),

      _buildPrivacyCard(),

      const SizedBox(height: 24),

      _buildFirstMemoryCard(),
    ];
  }

  Widget _buildFirstGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to SIMI ❤️',
          style: AppTextTheme.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A private little space made just for the two of you.',
          style: AppTextTheme.bodyMediumSecondary,
        ),
      ],
    );
  }

  Widget _buildStoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryContainer,
            AppColors.surfaceBright,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -28,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.28),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SmallIconCircle(
                    icon: Icons.favorite_rounded,
                    background: Colors.white.withValues(alpha: 0.65),
                    foreground: AppColors.primary,
                  ),
                  const Spacer(),
                  Text(
                    'YOUR STORY',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                widget.storyStartDate != null
                    ? 'Together for'
                    : 'Your story begins here',
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 2),

              if (widget.storyStartDate != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_daysTogether',
                      style: AppTextTheme.displayLarge.copyWith(
                        fontSize: 42,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _daysTogether == 1 ? 'day' : 'days',
                        style: AppTextTheme.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'A beautiful story starts\nwith little moments.',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontSize: 22,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

              const SizedBox(height: 10),

              if (widget.storyStartDate != null)
                Text(
                  'And there are many more memories to come. ❤️',
                  style: AppTextTheme.labelSmall.copyWith(
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FIRST TIME ACTIONS
  // ============================================================

  Widget _buildFirstTimeActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HomeActionCard(
                icon: Icons.photo_camera_outlined,
                title: 'Memory',
                subtitle: 'Save a moment',
                color: AppColors.primaryContainer,
                onTap: widget.onAddMemory,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HomeActionCard(
                icon: Icons.calendar_month_rounded,
                title: 'Period',
                subtitle: 'Track your cycle',
                color: const Color(0xFFFCE4EC),
                onTap: widget.onPeriod,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _HomeActionCard(
                icon: Icons.event_outlined,
                title: 'Special Date',
                subtitle: 'Never forget',
                color: const Color(0xFFE8E5F4),
                onTap: widget.onSpecialDate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HomeActionCard(
                icon: Icons.mail_outline_rounded,
                title: 'Future Message',
                subtitle: 'Write for later',
                color: const Color(0xFFE5E2F2),
                onTap: widget.onFutureMessage,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  Widget _buildPrivacyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.10),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Just for the two of you.',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Your memories, messages and moments stay in your little world.',
                  style: AppTextTheme.caption.copyWith(
                    fontSize: 11,
                    height: 1.45,
                    color: Colors.white.withValues(alpha: 0.70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FIRST MEMORY
  // ============================================================

  Widget _buildFirstMemoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'FIRST MEMORY',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'What should you remember forever?',
            style: AppTextTheme.headlineSmall.copyWith(
              fontSize: 21,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Add your first photo, date or little story together.',
            style: AppTextTheme.labelSmall.copyWith(
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: AppMainButton(
              text: 'Add First Memory',
              onPressed: widget.onAddMemory,
              height: 48,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // POPULATED HOME
  // ============================================================

  List<Widget> _populatedContent() {
    return [
      _buildPopulatedGreeting(),

      const SizedBox(height: 18),

      _buildRelationshipSummary(),

      const SizedBox(height: 22),

      _buildSectionTitle(
        eyebrow: 'TODAY',
        title: 'How are we feeling?',
      ),

      const SizedBox(height: 12),

      _buildTodayCards(),

      const SizedBox(height: 22),

      if (widget.nextSpecialDate != null) ...[
        _buildNextSpecialDate(),
        const SizedBox(height: 22),
      ],

      if (widget.memoryTitle != null) ...[
        _buildMemoryOfDay(),
        const SizedBox(height: 22),
      ],

      if (widget.futureMessageAvailable) ...[
        _buildFutureMessage(),
        const SizedBox(height: 22),
      ],

      _buildQuickActions(),
    ];
  }

  Widget _buildPopulatedGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          '${widget.partnerName} ❤️',
          style: AppTextTheme.displayLarge.copyWith(
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Your little world is waiting for you.',
          style: AppTextTheme.bodyMedium.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RELATIONSHIP SUMMARY
  // ============================================================

  Widget _buildRelationshipSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          AppProfileAvatar(
            image: widget.userPhoto,
            fallbackIcon: Icons.person_outline_rounded,
          ),

          const SizedBox(width: 8),

          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
            ),
            child: Icon(
              Icons.favorite_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 8),

          AppProfileAvatar(
            image: widget.userPhoto,
            fallbackIcon: Icons.person_outline_rounded,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOGETHER',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$_daysTogether days',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.favorite_border_rounded,
            size: 22,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY
  // ============================================================

  Widget _buildTodayCards() {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.sentiment_satisfied_alt_rounded,
            title: 'My Mood',
            value: widget.myMood ?? 'Not added',
            iconBackground: AppColors.primaryContainer,
            onTap: widget.onMood,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _InfoCard(
            icon: Icons.water_drop_outlined,
            title: 'Period',
            value: widget.cycleText ?? 'Not added',
            iconBackground: const Color(0xFFE7E4F1),
            onTap: widget.onCycle,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SPECIAL DATE
  // ============================================================

  Widget _buildNextSpecialDate() {
    final days = widget.nextSpecialDate
        ?.difference(DateTime.now())
        .inDays
        .clamp(0, 9999);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.event_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UPCOMING',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.specialDateLabel ?? 'Special day',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                if (days != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    days == 0 ? 'Today ❤️' : '$days days to go',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEMORY
  // ============================================================

  Widget _buildMemoryOfDay() {
    return Container(
      width: double.infinity,
      height: 230,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: _MemoryBackground(),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.62),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MEMORY OF THE DAY',
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.memoryTitle ?? 'A beautiful moment',
                  style: AppTextTheme.headlineMedium.copyWith(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                if (widget.memoryDescription != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    widget.memoryDescription!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.caption.copyWith(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.80),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Positioned(
            right: 16,
            top: 16,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              child: Icon(
                Icons.favorite_rounded,
                size: 17,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FUTURE MESSAGE
  // ============================================================

  Widget _buildFutureMessage() {
    return InkWell(
      onTap: widget.onFutureMessage,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FUTURE MESSAGE',
                    style: AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Something is waiting for you...',
                    style: AppTextTheme.headlineSmall.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          eyebrow: 'QUICK ACTIONS',
          title: 'Add to your world.',
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_photo_alternate_outlined,
                title: 'Memory',
                onTap: widget.onAddMemory,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _HomeActionCard(
                icon: Icons.calendar_month_rounded,
                title: 'Period',
                subtitle: 'Track your cycle',
                color: const Color(0xFFFCE4EC),
                onTap: widget.onPeriod,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _QuickAction(
                icon: Icons.event_outlined,
                title: 'Date',
                onTap: widget.onSpecialDate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required String eyebrow,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          title,
          style: AppTextTheme.headlineSmall.copyWith(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// HOME ACTION CARD
// ============================================================

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 116,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.75),
              ),
              child: Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
            ),

            const Spacer(),

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
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO CARD
// ============================================================

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconBackground,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color iconBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackground,
              ),
              child: Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.labelLarge.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// QUICK ACTION
// ============================================================

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),

            const SizedBox(height: 7),

            Text(
              title,
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// SMALL ICON CIRCLE
// ============================================================

class _SmallIconCircle extends StatelessWidget {
  const _SmallIconCircle({
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
      ),
      child: Icon(
        icon,
        size: 18,
        color: foreground,
      ),
    );
  }
}

// ============================================================
// CIRCLE ICON BUTTON
// ============================================================

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.75),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
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

// ============================================================
// MEMORY BACKGROUND
// ============================================================

class _MemoryBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MemoryPainter(),
    );
  }
}

class _MemoryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFEBCDCF),
        Color(0xFFC8B5B1),
        Color(0xFF8E7773),
      ],
    ).createShader(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.13);

    canvas.drawCircle(
      Offset(
        size.width * 0.18,
        size.height * 0.28,
      ),
      size.width * 0.25,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.82,
        size.height * 0.22,
      ),
      size.width * 0.18,
      circlePaint,
    );

    final heartPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12);

    final path = Path();

    final centerX = size.width * 0.50;
    final centerY = size.height * 0.40;

    path.moveTo(
      centerX,
      centerY + 35,
    );

    path.cubicTo(
      centerX - 65,
      centerY - 8,
      centerX - 48,
      centerY - 55,
      centerX - 18,
      centerY - 55,
    );

    path.cubicTo(
      centerX,
      centerY - 55,
      centerX,
      centerY - 34,
      centerX,
      centerY - 34,
    );

    path.cubicTo(
      centerX,
      centerY - 34,
      centerX,
      centerY - 55,
      centerX + 18,
      centerY - 55,
    );

    path.cubicTo(
      centerX + 48,
      centerY - 55,
      centerX + 65,
      centerY - 8,
      centerX,
      centerY + 35,
    );

    canvas.drawPath(
      path,
      heartPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}