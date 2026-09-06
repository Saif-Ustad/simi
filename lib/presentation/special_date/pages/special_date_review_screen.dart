// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_text_theme.dart';
// import 'special_dates_home_screen.dart';
//
// class SpecialDateReviewScreen extends StatefulWidget {
//   const SpecialDateReviewScreen({
//     super.key,
//     required this.category,
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.repeatsYearly,
//     required this.reminderDays,
//     required this.note,
//     this.onBack,
//     this.onSave,
//     this.onEditCategory,
//     this.onEditOccasion,
//     this.onEditDate,
//     this.onEditDetails,
//   });
//
//   final SpecialDateCategory category;
//   final String title;
//   final String description;
//   final DateTime date;
//   final bool repeatsYearly;
//   final int reminderDays;
//   final String note;
//
//   final VoidCallback? onBack;
//
//   final VoidCallback? onSave;
//
//   final VoidCallback? onEditCategory;
//   final VoidCallback? onEditOccasion;
//   final VoidCallback? onEditDate;
//   final VoidCallback? onEditDetails;
//
//   @override
//   State<SpecialDateReviewScreen> createState() =>
//       _SpecialDateReviewScreenState();
// }
//
// class _SpecialDateReviewScreenState
//     extends State<SpecialDateReviewScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController;
//
//   bool _isSaving = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 850),
//     )..forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   // ===========================================================================
//   // CATEGORY
//   // ===========================================================================
//
//   _CategoryInfo get _categoryInfo {
//     switch (widget.category) {
//       case SpecialDateCategory.anniversary:
//         return const _CategoryInfo(
//           emoji: '❤️',
//           icon: Icons.favorite_rounded,
//           label: 'ANNIVERSARY',
//         );
//
//       case SpecialDateCategory.birthday:
//         return const _CategoryInfo(
//           emoji: '🎂',
//           icon: Icons.cake_outlined,
//           label: 'BIRTHDAY',
//         );
//
//       case SpecialDateCategory.firstMeeting:
//         return const _CategoryInfo(
//           emoji: '✨',
//           icon: Icons.people_outline_rounded,
//           label: 'FIRST MEETING',
//         );
//
//       case SpecialDateCategory.firstDate:
//         return const _CategoryInfo(
//           emoji: '💕',
//           icon: Icons.favorite_border_rounded,
//           label: 'FIRST DATE',
//         );
//
//       case SpecialDateCategory.firstKiss:
//         return const _CategoryInfo(
//           emoji: '💋',
//           icon: Icons.face_retouching_natural_outlined,
//           label: 'FIRST KISS',
//         );
//
//       case SpecialDateCategory.firstTrip:
//         return const _CategoryInfo(
//           emoji: '✈️',
//           icon: Icons.flight_takeoff_rounded,
//           label: 'FIRST TRIP',
//         );
//
//       case SpecialDateCategory.customMoment:
//         return const _CategoryInfo(
//           emoji: '🌷',
//           icon: Icons.auto_awesome_rounded,
//           label: 'CUSTOM MOMENT',
//         );
//     }
//   }
//
//   // ===========================================================================
//   // DATE
//   // ===========================================================================
//
//   String get _monthName {
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
//     return months[widget.date.month - 1];
//   }
//
//   String get _weekdayName {
//     const weekdays = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday',
//     ];
//
//     return weekdays[widget.date.weekday - 1];
//   }
//
//   String get _formattedDate {
//     return '${widget.date.day} $_monthName ${widget.date.year}';
//   }
//
//   String get _reminderText {
//     switch (widget.reminderDays) {
//       case 1:
//         return '1 day before';
//       case 3:
//         return '3 days before';
//       case 7:
//         return '1 week before';
//       case 14:
//         return '2 weeks before';
//       case 30:
//         return '1 month before';
//       default:
//         return '${widget.reminderDays} days before';
//     }
//   }
//
//   // ===========================================================================
//   // SAVE
//   // ===========================================================================
//
//   Future<void> _save() async {
//     if (_isSaving) return;
//
//     setState(() {
//       _isSaving = true;
//     });
//
//     widget.onSave?.call();
//
//     if (!mounted) return;
//
//     /*
//      * The parent/router can navigate to the success page.
//      *
//      * If no callback is provided, we simply prevent the button
//      * from appearing stuck.
//      */
//     await Future<void>.delayed(
//       const Duration(milliseconds: 250),
//     );
//
//     if (!mounted) return;
//
//     setState(() {
//       _isSaving = false;
//     });
//   }
//
//   // ===========================================================================
//   // BUILD
//   // ===========================================================================
//
//   @override
//   Widget build(BuildContext context) {
//     final info = _categoryInfo;
//
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: Stack(
//         children: [
//           const Positioned.fill(
//             child: _ReviewBackground(),
//           ),
//
//           SafeArea(
//             bottom: false,
//             child: ListView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.only(
//                 bottom: 135,
//               ),
//               children: [
//                 _buildTopBar(),
//
//                 const SizedBox(height: 12),
//
//                 _buildProgress(),
//
//                 const SizedBox(height: 28),
//
//                 _buildIntro(info),
//
//                 const SizedBox(height: 25),
//
//                 _buildMomentPreview(info),
//
//                 const SizedBox(height: 25),
//
//                 _buildDetailsSection(),
//
//                 const SizedBox(height: 25),
//
//                 _buildReminderSection(),
//
//                 if (widget.note.trim().isNotEmpty) ...[
//                   const SizedBox(height: 25),
//                   _buildNoteSection(),
//                 ],
//
//                 const SizedBox(height: 24),
//
//                 _buildFinalMessage(),
//               ],
//             ),
//           ),
//
//           _buildBottomAction(),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // TOP BAR
//   // ===========================================================================
//
//   Widget _buildTopBar() {
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
//             onTap: widget.onBack ?? () => context.pop(),
//           ),
//
//           const SizedBox(width: 13),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
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
//                 const SizedBox(height: 2),
//                 Text(
//                   'One last look',
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
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 9,
//               vertical: 6,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFCE4EC),
//               borderRadius:
//               BorderRadius.circular(999),
//             ),
//             child: Text(
//               '5 OF 5',
//               style: AppTextTheme.labelSmall.copyWith(
//                 fontSize: 8,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 1,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // PROGRESS
//   // ===========================================================================
//
//   Widget _buildProgress() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Row(
//         children: List.generate(
//           5,
//               (index) {
//             return Expanded(
//               child: Container(
//                 height: 3,
//                 margin: EdgeInsets.only(
//                   right: index == 4 ? 0 : 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   borderRadius:
//                   BorderRadius.circular(99),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // INTRO
//   // ===========================================================================
//
//   Widget _buildIntro(_CategoryInfo info) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 24,
//       ),
//       child: Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 6,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFCE4EC),
//               borderRadius:
//               BorderRadius.circular(999),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   info.emoji,
//                   style: const TextStyle(
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   'READY TO KEEP',
//                   style:
//                   AppTextTheme.labelSmall.copyWith(
//                     fontSize: 8,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.3,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 17),
//
//           Text(
//             'This little moment\nis almost yours.',
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 31,
//               height: 1.06,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           Text(
//             'Take one last look. Everything feels right? '
//                 'Save it and we’ll keep this moment close.',
//             style: AppTextTheme.bodyMedium.copyWith(
//               fontSize: 12,
//               height: 1.55,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // BIG MOMENT PREVIEW
//   // ===========================================================================
//
//   Widget _buildMomentPreview(
//       _CategoryInfo info,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.fromLTRB(
//           20,
//           20,
//           20,
//           22,
//         ),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF292324),
//               Color(0xFF604447),
//             ],
//           ),
//           borderRadius:
//           BorderRadius.circular(29),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(
//                 alpha: 0.14,
//               ),
//               blurRadius: 24,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -50,
//               right: -45,
//               child: Container(
//                 width: 150,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(
//                     alpha: 0.045,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//
//             Positioned(
//               bottom: -65,
//               left: -55,
//               child: Container(
//                 width: 170,
//                 height: 170,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8B4B8)
//                       .withValues(alpha: 0.06),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 53,
//                       height: 53,
//                       decoration: BoxDecoration(
//                         color: Colors.white
//                             .withValues(
//                           alpha: 0.10,
//                         ),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white
//                               .withValues(
//                             alpha: 0.10,
//                           ),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           info.emoji,
//                           style: const TextStyle(
//                             fontSize: 23,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(width: 12),
//
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             info.label,
//                             style: AppTextTheme
//                                 .labelSmall
//                                 .copyWith(
//                               fontSize: 8,
//                               fontWeight:
//                               FontWeight.w700,
//                               letterSpacing: 1.6,
//                               color: Colors.white
//                                   .withValues(
//                                 alpha: 0.55,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'A moment worth remembering',
//                             style: AppTextTheme
//                                 .labelSmall
//                                 .copyWith(
//                               fontSize: 9.5,
//                               color: Colors.white
//                                   .withValues(
//                                 alpha: 0.72,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 28),
//
//                 Text(
//                   _weekdayName.toUpperCase(),
//                   style: AppTextTheme.labelSmall.copyWith(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 2.2,
//                     color: const Color(0xFFF3DADC),
//                   ),
//                 ),
//
//                 const SizedBox(height: 5),
//
//                 Text(
//                   '${widget.date.day}',
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 58,
//                     height: 0.95,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 Text(
//                   _monthName,
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 23,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white
//                         .withValues(alpha: 0.92),
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 Text(
//                   '${widget.date.year}',
//                   style: AppTextTheme.bodyMedium.copyWith(
//                     fontSize: 11,
//                     color: Colors.white
//                         .withValues(alpha: 0.55),
//                   ),
//                 ),
//
//                 const SizedBox(height: 22),
//
//                 Container(
//                   width: double.infinity,
//                   padding:
//                   const EdgeInsets.symmetric(
//                     horizontal: 15,
//                     vertical: 13,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white
//                         .withValues(alpha: 0.07),
//                     borderRadius:
//                     BorderRadius.circular(16),
//                   ),
//                   child: Text(
//                     widget.title,
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow:
//                     TextOverflow.ellipsis,
//                     style:
//                     GoogleFonts.playfairDisplay(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
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
//   // DETAILS
//   // ===========================================================================
//
//   Widget _buildDetailsSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           const _SectionLabel(
//             title: 'THE DETAILS',
//             subtitle:
//             'Everything you chose for this moment.',
//           ),
//
//           const SizedBox(height: 13),
//
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(
//                 alpha: 0.84,
//               ),
//               borderRadius:
//               BorderRadius.circular(21),
//               border: Border.all(
//                 color: AppColors.outlineVariant
//                     .withValues(alpha: 0.55),
//               ),
//             ),
//             child: Column(
//               children: [
//                 _ReviewRow(
//                   icon: Icons.auto_awesome_rounded,
//                   label: 'Category',
//                   value: _categoryInfo.label,
//                   onEdit: widget.onEditCategory,
//                 ),
//
//                 const _Divider(),
//
//                 _ReviewRow(
//                   icon: Icons.favorite_border_rounded,
//                   label: 'Moment',
//                   value: widget.title,
//                   onEdit: widget.onEditOccasion,
//                 ),
//
//                 const _Divider(),
//
//                 _ReviewRow(
//                   icon: Icons.calendar_today_outlined,
//                   label: 'Date',
//                   value: _formattedDate,
//                   onEdit: widget.onEditDate,
//                 ),
//
//                 if (widget.description
//                     .trim()
//                     .isNotEmpty) ...[
//                   const _Divider(),
//
//                   _ReviewRow(
//                     icon: Icons.notes_rounded,
//                     label: 'Description',
//                     value: widget.description,
//                     onEdit: widget.onEditOccasion,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===========================================================================
//   // REMINDER
//   // ===========================================================================
//
//   Widget _buildReminderSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           const _SectionLabel(
//             title: 'REMINDER',
//             subtitle:
//             'So the moment doesn’t sneak up on you.',
//           ),
//
//           const SizedBox(height: 13),
//
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(
//                 alpha: 0.84,
//               ),
//               borderRadius:
//               BorderRadius.circular(21),
//               border: Border.all(
//                 color: AppColors.outlineVariant
//                     .withValues(alpha: 0.55),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 45,
//                   height: 45,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFFCE4EC),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.notifications_none_rounded,
//                     size: 20,
//                     color: AppColors.primary,
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _reminderText,
//                         style:
//                         GoogleFonts.playfairDisplay(
//                           fontSize: 16,
//                           fontWeight:
//                           FontWeight.w600,
//                           color:
//                           AppColors.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         widget.repeatsYearly
//                             ? 'Every year, a little reminder for both of you.'
//                             : 'A one-time reminder for this special day.',
//                         maxLines: 2,
//                         overflow:
//                         TextOverflow.ellipsis,
//                         style: AppTextTheme.labelSmall
//                             .copyWith(
//                           fontSize: 9.5,
//                           height: 1.4,
//                           color:
//                           AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(width: 8),
//
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8F1F0),
//                     borderRadius:
//                     BorderRadius.circular(999),
//                   ),
//                   child: Row(
//                     mainAxisSize:
//                     MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.replay_rounded,
//                         size: 11,
//                         color: AppColors.primary,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         widget.repeatsYearly
//                             ? 'Yearly'
//                             : 'Once',
//                         style: AppTextTheme.labelSmall
//                             .copyWith(
//                           fontSize: 8,
//                           fontWeight:
//                           FontWeight.w600,
//                           color:
//                           AppColors.primary,
//                         ),
//                       ),
//                     ],
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
//   // ===========================================================================
//   // NOTE
//   // ===========================================================================
//
//   Widget _buildNoteSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           const _SectionLabel(
//             title: 'YOUR LITTLE NOTE',
//             subtitle:
//             'Something future-you might want to read.',
//           ),
//
//           const SizedBox(height: 13),
//
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8F1F0),
//               borderRadius:
//               BorderRadius.circular(21),
//               border: Border.all(
//                 color: AppColors.outlineVariant
//                     .withValues(alpha: 0.45),
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '“',
//                   style: TextStyle(
//                     fontSize: 30,
//                     height: 0.8,
//                     color: AppColors.primary,
//                   ),
//                 ),
//
//                 const SizedBox(width: 5),
//
//                 Expanded(
//                   child: Text(
//                     widget.note,
//                     style:
//                     GoogleFonts.playfairDisplay(
//                       fontSize: 14,
//                       height: 1.5,
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.italic,
//                       color:
//                       AppColors.textPrimary,
//                     ),
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
//   // ===========================================================================
//   // FINAL MESSAGE
//   // ===========================================================================
//
//   Widget _buildFinalMessage() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 35,
//       ),
//       child: Column(
//         children: [
//           const Icon(
//             Icons.favorite_rounded,
//             size: 19,
//             color: AppColors.primary,
//           ),
//
//           const SizedBox(height: 9),
//
//           Text(
//             'Some dates are more than dates.',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 5),
//
//           Text(
//             'They become little pieces of your story.',
//             textAlign: TextAlign.center,
//             style: AppTextTheme.labelSmall.copyWith(
//               fontSize: 9.5,
//               height: 1.4,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
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
//               onTap: _isSaving ? null : _save,
//               child: AnimatedContainer(
//                 duration:
//                 const Duration(milliseconds: 180),
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
//                   borderRadius:
//                   BorderRadius.circular(29),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primary
//                           .withValues(alpha: 0.23),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                     BoxShadow(
//                       color: Colors.black
//                           .withValues(alpha: 0.07),
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
//                         color: Colors.white
//                             .withValues(
//                           alpha: 0.14,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                       child: _isSaving
//                           ? const SizedBox(
//                         width: 19,
//                         height: 19,
//                         child:
//                         CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor:
//                           AlwaysStoppedAnimation<
//                               Color>(
//                             Colors.white,
//                           ),
//                         ),
//                       )
//                           : const Icon(
//                         Icons.favorite_rounded,
//                         size: 21,
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
//                             _isSaving
//                                 ? 'Keeping your moment…'
//                                 : 'Save this moment',
//                             maxLines: 1,
//                             overflow:
//                             TextOverflow.ellipsis,
//                             style:
//                             GoogleFonts.playfairDisplay(
//                               fontSize: 17,
//                               fontWeight:
//                               FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 3),
//                           Text(
//                             _isSaving
//                                 ? 'Just a second'
//                                 : 'Make it part of your story',
//                             maxLines: 1,
//                             overflow:
//                             TextOverflow.ellipsis,
//                             style:
//                             AppTextTheme.labelSmall
//                                 .copyWith(
//                               fontSize: 10,
//                               color: Colors.white
//                                   .withValues(
//                                 alpha: 0.72,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     Container(
//                       width: 42,
//                       height: 42,
//                       margin:
//                       const EdgeInsets.only(
//                         right: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white
//                             .withValues(
//                           alpha: 0.12,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         _isSaving
//                             ? Icons.more_horiz_rounded
//                             : Icons.arrow_forward_rounded,
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
// // REVIEW ROW
// // =============================================================================
//
// class _ReviewRow extends StatelessWidget {
//   const _ReviewRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//     this.onEdit,
//   });
//
//   final IconData icon;
//   final String label;
//   final String value;
//   final VoidCallback? onEdit;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         15,
//         14,
//         10,
//         14,
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: const BoxDecoration(
//               color: Color(0xFFFCE4EC),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               size: 16,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(width: 11),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: AppTextTheme.labelSmall
//                       .copyWith(
//                     fontSize: 8,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.8,
//                     color:
//                     AppColors.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   value,
//                   maxLines: 2,
//                   overflow:
//                   TextOverflow.ellipsis,
//                   style:
//                   AppTextTheme.bodyMedium.copyWith(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           if (onEdit != null) ...[
//             const SizedBox(width: 7),
//             GestureDetector(
//               onTap: onEdit,
//               child: Container(
//                 width: 31,
//                 height: 31,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF7F1F0),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.edit_outlined,
//                   size: 14,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // DIVIDER
// // =============================================================================
//
// class _Divider extends StatelessWidget {
//   const _Divider();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 62,
//       ),
//       child: Divider(
//         height: 1,
//         thickness: 0.7,
//         color: AppColors.outlineVariant
//             .withValues(alpha: 0.35),
//       ),
//     );
//   }
// }
//
// // =============================================================================
// // SECTION LABEL
// // =============================================================================
//
// class _SectionLabel extends StatelessWidget {
//   const _SectionLabel({
//     required this.title,
//     required this.subtitle,
//   });
//
//   final String title;
//   final String subtitle;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//       CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: AppTextTheme.labelSmall.copyWith(
//             fontSize: 9,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 1.7,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           subtitle,
//           style: AppTextTheme.bodyMedium.copyWith(
//             fontSize: 11,
//             color: AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // =============================================================================
// // CATEGORY INFO
// // =============================================================================
//
// class _CategoryInfo {
//   const _CategoryInfo({
//     required this.emoji,
//     required this.icon,
//     required this.label,
//   });
//
//   final String emoji;
//   final IconData icon;
//   final String label;
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
//             alpha: 0.80,
//           ),
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: AppColors.outlineVariant
//                 .withValues(alpha: 0.55),
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
// // BACKGROUND
// // =============================================================================
//
// class _ReviewBackground extends StatelessWidget {
//   const _ReviewBackground();
//
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Stack(
//         children: [
//           Positioned(
//             top: 45,
//             right: -90,
//             child: ImageFiltered(
//               imageFilter: ImageFilter.blur(
//                 sigmaX: 40,
//                 sigmaY: 40,
//               ),
//               child: Container(
//                 width: 230,
//                 height: 230,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF3E3E5),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 430,
//             left: -110,
//             child: ImageFiltered(
//               imageFilter: ImageFilter.blur(
//                 sigmaX: 42,
//                 sigmaY: 42,
//               ),
//               child: Container(
//                 width: 245,
//                 height: 245,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFECE9F1),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 80,
//             right: -80,
//             child: ImageFiltered(
//               imageFilter: ImageFilter.blur(
//                 sigmaX: 38,
//                 sigmaY: 38,
//               ),
//               child: Container(
//                 width: 195,
//                 height: 195,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF5E5E8),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'special_dates_home_screen.dart';

class SpecialDateReviewScreen extends StatefulWidget {
  const SpecialDateReviewScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.repeatsYearly,
    required this.reminderDays,
    required this.note,
    this.onBack,
    this.onSave,
  });

  final SpecialDateCategory category;
  final String title;
  final String description;
  final DateTime date;
  final bool repeatsYearly;
  final int reminderDays;
  final String note;

  final VoidCallback? onBack;
  final VoidCallback? onSave;

  @override
  State<SpecialDateReviewScreen> createState() =>
      _SpecialDateReviewScreenState();
}

class _SpecialDateReviewScreenState
    extends State<SpecialDateReviewScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late SpecialDateCategory _category;
  late String _title;
  late String _description;
  late DateTime _date;
  late bool _repeatsYearly;
  late int _reminderDays;
  late String _note;

  @override
  void initState() {
    super.initState();

    _category = widget.category;
    _title = widget.title;
    _description = widget.description;
    _date = widget.date;
    _repeatsYearly = widget.repeatsYearly;
    _reminderDays = widget.reminderDays;
    _note = widget.note;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // CATEGORY
  // ---------------------------------------------------------------------------

  Future<void> _showCategoryEditor() async {
    final result =
    await showModalBottomSheet<SpecialDateCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _CategoryEditorSheet(
          selectedCategory: _category,
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _category = result;
    });
  }

  // ---------------------------------------------------------------------------
  // MOMENT
  // ---------------------------------------------------------------------------

  Future<void> _showMomentEditor() async {
    final result =
    await showModalBottomSheet<_MomentEditResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _MomentEditorSheet(
          title: _title,
          description: _description,
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _title = result.title;
      _description = result.description;
    });
  }

  // ---------------------------------------------------------------------------
  // DATE
  // ---------------------------------------------------------------------------

  Future<void> _showDateEditor() async {
    DateTime selectedDate = _date;
    bool repeatsYearly = _repeatsYearly;

    final result =
    await showModalBottomSheet<_DateEditResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _EditorSheetContainer(
              title: 'Change the date',
              subtitle:
              'Choose the day you want to remember.',
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme:
                              Theme.of(context)
                                  .colorScheme
                                  .copyWith(
                                primary:
                                AppColors.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked == null) return;

                      setSheetState(() {
                        selectedDate = picked;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.primary,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Special date',
                                  style: AppTextTheme
                                      .labelSmall
                                      .copyWith(
                                    fontSize: 9,
                                    color: AppColors
                                        .textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _formatDate(selectedDate),
                                  style: GoogleFonts
                                      .playfairDisplay(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: AppColors
                                        .textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.edit_calendar_outlined,
                            size: 19,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {
                      setSheetState(() {
                        repeatsYearly = !repeatsYearly;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(17),
                        border: Border.all(
                          color: AppColors.outlineVariant
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFCE4EC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.replay_rounded,
                              color: AppColors.primary,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repeat every year',
                                  style: AppTextTheme
                                      .labelLarge
                                      .copyWith(
                                    color: AppColors
                                        .textPrimary,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Remember this date every year.',
                                  style: AppTextTheme
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
                          Switch(
                            value: repeatsYearly,
                            onChanged: (value) {
                              setSheetState(() {
                                repeatsYearly = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor:
                            AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _EditorSaveButton(
                    label: 'Save date',
                    onTap: () {
                      Navigator.pop(
                        sheetContext,
                        _DateEditResult(
                          date: selectedDate,
                          repeatsYearly: repeatsYearly,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _date = result.date;
      _repeatsYearly = result.repeatsYearly;
    });
  }

  // ---------------------------------------------------------------------------
  // DETAILS
  // ---------------------------------------------------------------------------

  Future<void> _showDetailsEditor() async {
    final result =
    await showModalBottomSheet<_DetailsEditResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _DetailsEditorSheet(
          reminderDays: _reminderDays,
          note: _note,
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _reminderDays = result.reminderDays;
      _note = result.note;
    });
  }

  // ---------------------------------------------------------------------------
  // CATEGORY INFORMATION
  // ---------------------------------------------------------------------------

  _CategoryInfo get _categoryInfo {
    switch (_category) {
      case SpecialDateCategory.anniversary:
        return const _CategoryInfo(
          label: 'Anniversary',
          emoji: '❤️',
          icon: Icons.favorite_rounded,
        );

      case SpecialDateCategory.birthday:
        return const _CategoryInfo(
          label: 'Birthday',
          emoji: '🎂',
          icon: Icons.cake_outlined,
        );

      case SpecialDateCategory.firstMeeting:
        return const _CategoryInfo(
          label: 'First Meeting',
          emoji: '✨',
          icon: Icons.people_outline_rounded,
        );

      case SpecialDateCategory.firstDate:
        return const _CategoryInfo(
          label: 'First Date',
          emoji: '💕',
          icon: Icons.favorite_border_rounded,
        );

      case SpecialDateCategory.firstKiss:
        return const _CategoryInfo(
          label: 'First Kiss',
          emoji: '💋',
          icon: Icons.face_retouching_natural_rounded,
        );

      case SpecialDateCategory.firstTrip:
        return const _CategoryInfo(
          label: 'First Trip',
          emoji: '✈️',
          icon: Icons.flight_takeoff_rounded,
        );

      case SpecialDateCategory.customMoment:
        return const _CategoryInfo(
          label: 'Custom Moment',
          emoji: '🌷',
          icon: Icons.auto_awesome_rounded,
        );
    }
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
          const Positioned.fill(
            child: _ReviewBackground(),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 145,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  _buildProgress(),
                  _buildIntro(),
                  _buildMomentPreview(),
                  _buildDetailsSection(),
                  _buildReminderCard(),

                  if (_note.trim().isNotEmpty)
                    _buildNoteCard(),

                  _buildFinalMessage(),
                ],
              ),
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        0,
      ),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onBack ??
                      () => Navigator.of(context).pop(),
              child: const _CircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
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
                    'SPECIAL DATES',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'One last look',
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.6),
                ),
              ),
              child: Text(
                '5 OF 5',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROGRESS
  // ---------------------------------------------------------------------------

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        4,
        20,
        0,
      ),
      child: Row(
        children: List.generate(
          5,
              (index) {
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(
                  right: index == 4 ? 0 : 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                  BorderRadius.circular(99),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INTRO
  // ---------------------------------------------------------------------------

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        22,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'ONE LAST LOOK',
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.1,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This little moment\nis almost yours.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 29,
              height: 1.12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Take one last look before we keep it '
                'somewhere special.',
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

  // ---------------------------------------------------------------------------
  // MOMENT PREVIEW
  // ---------------------------------------------------------------------------

  Widget _buildMomentPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 235,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF211A1B),
              Color(0xFF49383A),
              Color(0xFF72575A),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.13),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                right: -35,
                top: -35,
                child: Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B4B8)
                        .withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Decorative circle
              Positioned(
                left: -45,
                bottom: -55,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row
                    Row(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.11),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _categoryInfo.emoji,
                            style: const TextStyle(
                              fontSize: 20,
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
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'SPECIAL MOMENT',
                            style: AppTextTheme.labelSmall.copyWith(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.white.withValues(alpha: 0.76),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 45),

                    // Title
                    Text(
                      _title.trim().isEmpty
                          ? 'A beautiful moment'
                          : _title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 27,
                        height: 1.12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Date
                    Text(
                      _formatDate(_date),
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.68),
                      ),
                    ),

                    // Description
                    if (_description.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        _description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontSize: 11,
                          height: 1.45,
                          color: Colors.white.withValues(alpha: 0.74),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DETAILS SECTION
  // ---------------------------------------------------------------------------

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionLabel(
            'YOUR MOMENT',
            'Everything looks right?',
          ),
          const SizedBox(height: 13),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.84),
              borderRadius:
              BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.55),
              ),
            ),
            child: Column(
              children: [
                _ReviewRow(
                  icon: _categoryInfo.icon,
                  label: 'Category',
                  value:
                  _categoryInfo.label,
                  onEdit: _showCategoryEditor,
                ),

                const _ReviewDivider(),

                _ReviewRow(
                  icon:
                  Icons.favorite_border_rounded,
                  label: 'Moment',
                  value: _title.isEmpty
                      ? 'Untitled moment'
                      : _title,
                  onEdit: _showMomentEditor,
                ),

                const _ReviewDivider(),

                _ReviewRow(
                  icon:
                  Icons.calendar_today_outlined,
                  label: 'Date',
                  value: _formatDate(_date),
                  onEdit: _showDateEditor,
                ),

                if (_description
                    .trim()
                    .isNotEmpty) ...[
                  const _ReviewDivider(),

                  _ReviewRow(
                    icon: Icons.notes_rounded,
                    label: 'Description',
                    value: _description,
                    onEdit: _showMomentEditor,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REMINDER
  // ---------------------------------------------------------------------------

  Widget _buildReminderCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE4EC)
              .withValues(alpha: 0.72),
          borderRadius:
          BorderRadius.circular(21),
          border: Border.all(
            color: const Color(0xFFE8B4B8)
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'REMINDER',
                    style: AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _reminderText,
                    style:
                    GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _repeatsYearly
                        ? 'Repeats every year.'
                        : 'One special reminder.',
                    style: AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _showDetailsEditor,
              child: Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(999),
                ),
                child: Text(
                  'EDIT',
                  style: AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _reminderText {
    switch (_reminderDays) {
      case 1:
        return '1 day before';
      case 3:
        return '3 days before';
      case 7:
        return '1 week before';
      case 14:
        return '2 weeks before';
      case 30:
        return '1 month before';
      default:
        return '$_reminderDays days before';
    }
  }

  // ---------------------------------------------------------------------------
  // NOTE
  // ---------------------------------------------------------------------------

  Widget _buildNoteCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.80),
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F1F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'PRIVATE NOTE',
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 8,
                            fontWeight:
                            FontWeight.w700,
                            letterSpacing: 1.4,
                            color:
                            AppColors.primary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showDetailsEditor,
                        child: Text(
                          'EDIT',
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 8,
                            fontWeight:
                            FontWeight.w700,
                            letterSpacing: 1.0,
                            color:
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _note,
                    style:
                    AppTextTheme.bodyMedium.copyWith(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors.textSecondary,
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

  // ---------------------------------------------------------------------------
  // FINAL MESSAGE
  // ---------------------------------------------------------------------------

  Widget _buildFinalMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        35,
        30,
        20,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(height: 11),
          Text(
            'Some dates are more than dates.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This one will stay here as a little '
                'piece of your story.',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyMedium.copyWith(
              fontSize: 10,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM CTA
  // ---------------------------------------------------------------------------

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: widget.onSave,
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 540,
              ),
              child: Container(
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
                  borderRadius:
                  BorderRadius.circular(29),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.14),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withValues(alpha: 0.23),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.08),
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
                        color: Colors.white
                            .withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 21,
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
                            'Save this moment',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Keep it somewhere special',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: Colors.white
                                  .withValues(
                                alpha: 0.70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 42,
                      height: 42,
                      margin:
                      const EdgeInsets.only(
                        right: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.12),
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

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  Widget _sectionLabel(
      String title,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            color: AppColors.textSecondary,
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

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

// =============================================================================
// CATEGORY EDITOR
// =============================================================================

class _CategoryEditorSheet extends StatelessWidget {
  const _CategoryEditorSheet({
    required this.selectedCategory,
  });

  final SpecialDateCategory selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = [
      const _CategoryChoice(
        category: SpecialDateCategory.anniversary,
        emoji: '❤️',
        title: 'Anniversary',
        subtitle:
        'A day that belongs only to us.',
      ),
      const _CategoryChoice(
        category: SpecialDateCategory.birthday,
        emoji: '🎂',
        title: 'Birthday',
        subtitle:
        'A day worth celebrating together.',
      ),
      const _CategoryChoice(
        category: SpecialDateCategory.firstMeeting,
        emoji: '✨',
        title: 'First Meeting',
        subtitle:
        'Where our story first began.',
      ),
      const _CategoryChoice(
        category: SpecialDateCategory.firstDate,
        emoji: '💕',
        title: 'First Date',
        subtitle:
        'The beginning of something beautiful.',
      ),
      const _CategoryChoice(
        category: SpecialDateCategory.firstKiss,
        emoji: '💋',
        title: 'First Kiss',
        subtitle:
        'One little moment we never forgot.',
      ),
      const _CategoryChoice(
        category: SpecialDateCategory.firstTrip,
        emoji: '✈️',
        title: 'First Trip',
        subtitle:
        'The first place we explored together.',
      ),
      const _CategoryChoice(
        category: SpecialDateCategory.customMoment,
        emoji: '🌷',
        title: 'Custom Moment',
        subtitle:
        'Something special that is just ours.',
      ),
    ];

    return _EditorSheetContainer(
      title: 'Change category',
      subtitle: 'What kind of moment is this?',
      child: Column(
        children: [
          for (final item in categories)
            Padding(
              padding:
              const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                    item.category,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color:
                    selectedCategory ==
                        item.category
                        ? const Color(0xFFFCE4EC)
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(17),
                    border: Border.all(
                      color: selectedCategory ==
                          item.category
                          ? AppColors.primary
                          : AppColors.outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        item.emoji,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w600,
                                color: AppColors
                                    .textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: AppTextTheme
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
                      Icon(
                        selectedCategory ==
                            item.category
                            ? Icons
                            .check_circle_rounded
                            : Icons
                            .radio_button_unchecked,
                        size: 20,
                        color:
                        selectedCategory ==
                            item.category
                            ? AppColors.primary
                            : AppColors
                            .textDisabled,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChoice {
  const _CategoryChoice({
    required this.category,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final SpecialDateCategory category;
  final String emoji;
  final String title;
  final String subtitle;
}

// =============================================================================
// MOMENT EDITOR
// =============================================================================

class _MomentEditResult {
  const _MomentEditResult({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class _MomentEditorSheet extends StatefulWidget {
  const _MomentEditorSheet({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  State<_MomentEditorSheet> createState() =>
      _MomentEditorSheetState();
}

class _MomentEditorSheetState
    extends State<_MomentEditorSheet> {
  late final TextEditingController
  _titleController;

  late final TextEditingController
  _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(
          text: widget.title,
        );

    _descriptionController =
        TextEditingController(
          text: widget.description,
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final title =
    _titleController.text.trim();

    if (title.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      _MomentEditResult(
        title: title,
        description:
        _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EditorSheetContainer(
      title: 'Edit your moment',
      subtitle:
      'Make the story feel just right.',
      child: Column(
        children: [
          _EditorTextField(
            controller: _titleController,
            label: 'Moment title',
            hint: 'Our anniversary',
            icon:
            Icons.favorite_border_rounded,
          ),

          const SizedBox(height: 12),

          _EditorTextField(
            controller:
            _descriptionController,
            label: 'A little description',
            hint: 'Why is this day special?',
            icon: Icons.notes_rounded,
            maxLines: 4,
          ),

          const SizedBox(height: 16),

          _EditorSaveButton(
            label: 'Save changes',
            onTap: _save,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DATE RESULT
// =============================================================================

class _DateEditResult {
  const _DateEditResult({
    required this.date,
    required this.repeatsYearly,
  });

  final DateTime date;
  final bool repeatsYearly;
}

// =============================================================================
// DETAILS EDITOR
// =============================================================================

class _DetailsEditResult {
  const _DetailsEditResult({
    required this.reminderDays,
    required this.note,
  });

  final int reminderDays;
  final String note;
}

class _DetailsEditorSheet extends StatefulWidget {
  const _DetailsEditorSheet({
    required this.reminderDays,
    required this.note,
  });

  final int reminderDays;
  final String note;

  @override
  State<_DetailsEditorSheet> createState() =>
      _DetailsEditorSheetState();
}

class _DetailsEditorSheetState
    extends State<_DetailsEditorSheet> {
  late int _reminderDays;

  late final TextEditingController
  _noteController;

  final List<int> _options = const [
    1,
    3,
    7,
    14,
    30,
  ];

  @override
  void initState() {
    super.initState();

    _reminderDays =
        widget.reminderDays;

    _noteController =
        TextEditingController(
          text: widget.note,
        );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _label(int days) {
    switch (days) {
      case 1:
        return '1 day';
      case 3:
        return '3 days';
      case 7:
        return '1 week';
      case 14:
        return '2 weeks';
      case 30:
        return '1 month';
      default:
        return '$days days';
    }
  }

  void _save() {
    Navigator.pop(
      context,
      _DetailsEditResult(
        reminderDays: _reminderDays,
        note: _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EditorSheetContainer(
      title: 'Edit the little details',
      subtitle:
      'Reminders and notes for this moment.',
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'REMIND US',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 9),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: _options.map((days) {
              final selected =
                  days == _reminderDays;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _reminderDays = days;
                  });
                },
                child: AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 180,
                  ),
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFF7F1F0),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                  child: Text(
                    _label(days),
                    style: AppTextTheme
                        .labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight:
                      FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : AppColors
                          .textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          _EditorTextField(
            controller: _noteController,
            label: 'Private note',
            hint:
            'Something future-you might want to remember…',
            icon: Icons.edit_note_rounded,
            maxLines: 4,
          ),

          const SizedBox(height: 16),

          _EditorSaveButton(
            label: 'Save details',
            onTap: _save,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SHARED EDITOR SHEET
// =============================================================================

class _EditorSheetContainer
    extends StatelessWidget {
  const _EditorSheetContainer({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.viewInsetsOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          20 + bottomInset,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color:
                  AppColors.outlineVariant,
                  borderRadius:
                  BorderRadius.circular(99),
                ),
              ),

              const SizedBox(height: 22),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle,
                  style: AppTextTheme
                      .labelSmall.copyWith(
                    fontSize: 10,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              child,

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// EDITOR TEXT FIELD
// =============================================================================

class _EditorTextField
    extends StatelessWidget {
  const _EditorTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization:
        TextCapitalization.sentences,
        style:
        AppTextTheme.bodyMedium.copyWith(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTextTheme.labelSmall
              .copyWith(
            fontSize: 10,
            color: AppColors.primary,
          ),
          hintStyle:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 11,
            color: AppColors.textDisabled,
          ),
          prefixIcon: Padding(
            padding:
            const EdgeInsets.only(
              left: 12,
              right: 4,
              top: 13,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              widthFactor: 1,
              child: Icon(
                icon,
                size: 19,
                color: AppColors.primary,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.fromLTRB(
            8,
            14,
            14,
            14,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SAVE BUTTON
// =============================================================================

class _EditorSaveButton
    extends StatelessWidget {
  const _EditorSaveButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius:
          BorderRadius.circular(26),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style:
          AppTextTheme.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// REVIEW ROW
// =============================================================================

class _ReviewRow
    extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onEdit;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow:
                  TextOverflow.ellipsis,
                  style: GoogleFonts
                      .playfairDisplay(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F1F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 15,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewDivider
    extends StatelessWidget {
  const _ReviewDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 64,
      endIndent: 14,
      color: AppColors.outlineVariant
          .withValues(alpha: 0.45),
    );
  }
}

// =============================================================================
// CATEGORY INFO
// =============================================================================

class _CategoryInfo {
  const _CategoryInfo({
    required this.label,
    required this.emoji,
    required this.icon,
  });

  final String label;
  final String emoji;
  final IconData icon;
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton
    extends StatelessWidget {
  const _CircleButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.82),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 16,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _ReviewBackground
    extends StatelessWidget {
  const _ReviewBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 430,
            left: -130,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.10),
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