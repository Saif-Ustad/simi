// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../core/config/routes/router.dart';
// import '../../../core/config/theme/app_colors.dart';
// import '../../../core/config/theme/app_text_theme.dart';
//
// class PeriodSavedSuccessScreen extends StatefulWidget {
//   const PeriodSavedSuccessScreen({
//     super.key,
//     required this.startDate,
//     this.cycleLength = 28,
//     this.onViewCycle,
//   });
//
//   final DateTime startDate;
//   final int cycleLength;
//   final VoidCallback? onViewCycle;
//
//   @override
//   State<PeriodSavedSuccessScreen> createState() =>
//       _PeriodSavedSuccessScreenState();
// }
//
// class _PeriodSavedSuccessScreenState
//     extends State<PeriodSavedSuccessScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController;
//
//   late final Animation<double> _iconScale;
//   late final Animation<double> _contentFade;
//   late final Animation<double> _contentSlide;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//
//     _iconScale = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     );
//
//     _contentFade = CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(
//         0.25,
//         1.0,
//         curve: Curves.easeOut,
//       ),
//     );
//
//     _contentSlide = Tween<double>(
//       begin: 20,
//       end: 0,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(
//           0.20,
//           1.0,
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   // ============================================================
//   // DATE HELPERS
//   // ============================================================
//
//   String _formatDate(DateTime date) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//
//     return '${months[date.month - 1]} '
//         '${date.day}, '
//         '${date.year}';
//   }
//
//   DateTime get _nextPeriodDate {
//     return DateTime(
//       widget.startDate.year,
//       widget.startDate.month,
//       widget.startDate.day,
//     ).add(
//       Duration(days: widget.cycleLength),
//     );
//   }
//
//   String _formatShortDate(DateTime date) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//
//     return '${months[date.month - 1]} ${date.day}';
//   }
//
//   // ============================================================
//   // BUILD
//   // ============================================================
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // ======================================================
//             // BACKGROUND DECORATIONS
//             // ======================================================
//
//             const Positioned(
//               top: -110,
//               left: -70,
//               child: _SuccessGlow(
//                 size: 230,
//                 color: Color(0xFFE8B4B8),
//               ),
//             ),
//
//             const Positioned(
//               bottom: -130,
//               right: -80,
//               child: _SuccessGlow(
//                 size: 260,
//                 color: Color(0xFFCDCAFE),
//               ),
//             ),
//
//             // Small decorative circles.
//             Positioned(
//               top: 190,
//               right: 38,
//               child: _DecorativeDot(
//                 size: 8,
//                 color: AppColors.primaryContainer,
//               ),
//             ),
//
//             Positioned(
//               top: 255,
//               left: 30,
//               child: _DecorativeDot(
//                 size: 6,
//                 color: const Color(0xFFCDCAFE),
//               ),
//             ),
//
//             // ======================================================
//             // CONTENT
//             // ======================================================
//
//             SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(
//                 20,
//                 20,
//                 20,
//                 32,
//               ),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxWidth: 448,
//                   ),
//                   child: Column(
//                     children: [
//                       // =================================================
//                       // SUCCESS ICON
//                       // =================================================
//
//                       ScaleTransition(
//                         scale: _iconScale,
//                         child: _buildSuccessIcon(),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // =================================================
//                       // HEADING + DESCRIPTION
//                       // =================================================
//
//                       AnimatedBuilder(
//                         animation: _animationController,
//                         builder: (context, child) {
//                           return Opacity(
//                             opacity: _contentFade.value,
//                             child: Transform.translate(
//                               offset: Offset(
//                                 0,
//                                 _contentSlide.value,
//                               ),
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: _buildIntro(),
//                       ),
//
//                       const SizedBox(height: 28),
//
//                       // =================================================
//                       // SUMMARY CARD
//                       // =================================================
//
//                       AnimatedBuilder(
//                         animation: _animationController,
//                         builder: (context, child) {
//                           return Opacity(
//                             opacity: _contentFade.value,
//                             child: Transform.translate(
//                               offset: Offset(
//                                 0,
//                                 _contentSlide.value,
//                               ),
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: _buildSummaryCard(),
//                       ),
//
//                       const SizedBox(height: 28),
//
//                       // =================================================
//                       // VIEW CYCLE
//                       // =================================================
//
//                       _buildViewCycleButton(),
//
//                       const SizedBox(height: 14),
//
//                       // =================================================
//                       // PRIVACY
//                       // =================================================
//
//                       _buildPrivacyMessage(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // SUCCESS ICON
//   // ============================================================
//
//   Widget _buildSuccessIcon() {
//     return Container(
//       width: 88,
//       height: 88,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8B4B8),
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6B4448).withValues(
//               alpha: 0.16,
//             ),
//             blurRadius: 28,
//             offset: const Offset(0, 9),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Container(
//           width: 44,
//           height: 44,
//           decoration: BoxDecoration(
//             color: const Color(0xFF7C5357),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.check_rounded,
//             color: Colors.white,
//             size: 27,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // INTRO
//   // ============================================================
//
//   Widget _buildIntro() {
//     return Column(
//       children: [
//         Text(
//           'Period Recorded',
//           textAlign: TextAlign.center,
//           style: AppTextTheme.displayLarge.copyWith(
//             fontFamily: 'Playfair Display',
//             fontSize: 30,
//             height: 1.15,
//             letterSpacing: -0.6,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF7C5357),
//           ),
//         ),
//
//         const SizedBox(height: 10),
//
//         Text(
//           'Your cycle has been successfully\n'
//               'updated. Take it easy and be gentle\n'
//               'with yourself today.',
//           textAlign: TextAlign.center,
//           style: AppTextTheme.bodyMediumSecondary.copyWith(
//             fontSize: 13,
//             height: 1.55,
//             color: const Color(0xFF504444),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // SUMMARY CARD
//   // ============================================================
//
//   Widget _buildSummaryCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.94),
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(
//           color: const Color(0xFFE9E1DC),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.045),
//             blurRadius: 22,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ========================================================
//           // HEADER
//           // ========================================================
//
//           Text(
//             'CYCLE SUMMARY',
//             style: AppTextTheme.labelSmall.copyWith(
//               color: const Color(0xFF827474),
//               fontSize: 9,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1.1,
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // ========================================================
//           // START DATE + CYCLE DAY
//           // ========================================================
//
//           Row(
//             children: [
//               Expanded(
//                 child: _buildSummaryValue(
//                   label: 'Start Date',
//                   value: _formatDate(widget.startDate),
//                 ),
//               ),
//
//               Container(
//                 width: 1,
//                 height: 42,
//                 color: const Color(0xFFE9E1DC),
//               ),
//
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: _buildSummaryValue(
//                     label: 'Cycle Day',
//                     value: 'Day 1',
//                     alignRight: true,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           Container(
//             height: 1,
//             color: const Color(0xFFE9E1DC),
//           ),
//
//           const SizedBox(height: 14),
//
//           // ========================================================
//           // NEXT PERIOD
//           // ========================================================
//
//           Row(
//             children: [
//               const Icon(
//                 Icons.calendar_today_outlined,
//                 size: 14,
//                 color: Color(0xFF6B6D91),
//               ),
//
//               const SizedBox(width: 7),
//
//               Expanded(
//                 child: Text(
//                   'Next predicted period: '
//                       '${_formatShortDate(_nextPeriodDate)}',
//                   style: AppTextTheme.bodyMedium.copyWith(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF1E1B18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//           // ========================================================
//           // CYCLE PROGRESS
//           // ========================================================
//
//           ClipRRect(
//             borderRadius: BorderRadius.circular(999),
//             child: Container(
//               width: double.infinity,
//               height: 7,
//               color: const Color(0xFFE9E1DC),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: FractionallySizedBox(
//                   widthFactor: 0.05,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF7C5357),
//                       borderRadius:
//                       BorderRadius.circular(999),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // SUMMARY VALUE
//   // ============================================================
//
//   Widget _buildSummaryValue({
//     required String label,
//     required String value,
//     bool alignRight = false,
//   }) {
//     return Column(
//       crossAxisAlignment: alignRight
//           ? CrossAxisAlignment.end
//           : CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           textAlign:
//           alignRight ? TextAlign.right : TextAlign.left,
//           style: AppTextTheme.labelSmall.copyWith(
//             fontSize: 10,
//             color: const Color(0xFF504444),
//           ),
//         ),
//
//         const SizedBox(height: 4),
//
//         Text(
//           value,
//           textAlign:
//           alignRight ? TextAlign.right : TextAlign.left,
//           style: AppTextTheme.bodyLarge.copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF1E1B18),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // VIEW CYCLE BUTTON
//   // ============================================================
//
//   Widget _buildViewCycleButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               Color(0xFF795458),
//               Color(0xFF956C70),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(999),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF7C5357).withValues(
//                 alpha: 0.18,
//               ),
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               if (widget.onViewCycle != null) {
//                 widget.onViewCycle!();
//               } else {
//                 context.go(AppRoutes.period);
//               }
//             },
//             borderRadius: BorderRadius.circular(999),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'View Cycle',
//                   style: AppTextTheme.labelLarge.copyWith(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//
//                 const SizedBox(width: 7),
//
//                 const Icon(
//                   Icons.arrow_forward_rounded,
//                   size: 16,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // PRIVACY
//   // ============================================================
//
//   Widget _buildPrivacyMessage() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.lock_outline_rounded,
//           size: 13,
//           color: AppColors.textSecondary.withValues(
//             alpha: 0.65,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           'Private • Just between you two',
//           style: AppTextTheme.labelSmall.copyWith(
//             fontSize: 9,
//             color: AppColors.textSecondary.withValues(
//               alpha: 0.7,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // BACKGROUND GLOW
// // ============================================================
//
// class _SuccessGlow extends StatelessWidget {
//   const _SuccessGlow({
//     required this.size,
//     required this.color,
//   });
//
//   final double size;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: RadialGradient(
//             colors: [
//               color.withValues(alpha: 0.18),
//               color.withValues(alpha: 0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================
// // DECORATIVE DOT
// // ============================================================
//
// class _DecorativeDot extends StatelessWidget {
//   const _DecorativeDot({
//     required this.size,
//     required this.color,
//   });
//
//   final double size;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }


import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodSavedSuccessScreen extends StatefulWidget {
  const PeriodSavedSuccessScreen({
    super.key,
    required this.startDate,
    this.cycleLength = 28,
    this.onViewCycle,
  });

  final DateTime startDate;
  final int cycleLength;
  final VoidCallback? onViewCycle;

  @override
  State<PeriodSavedSuccessScreen> createState() =>
      _PeriodSavedSuccessScreenState();
}

class _PeriodSavedSuccessScreenState
    extends State<PeriodSavedSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _floatingController;

  late final Animation<double> _iconScale;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    // Main entrance animation.
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _iconScale = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.elasticOut,
      ),
    );

    _fade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.25,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.2,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Very subtle floating background animation.
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  // ============================================================
  // DATE HELPERS
  // ============================================================

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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatShortDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}';
  }

  DateTime get _nextPeriodDate {
    return DateTime(
      widget.startDate.year,
      widget.startDate.month,
      widget.startDate.day,
    ).add(
      Duration(days: widget.cycleLength),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // ------------------------------------------------------
            // BACKGROUND
            // ------------------------------------------------------

            const Positioned(
              top: -120,
              right: -100,
              child: _Glow(
                size: 280,
                opacity: 0.18,
              ),
            ),

            const Positioned(
              bottom: -140,
              left: -110,
              child: _Glow(
                size: 300,
                opacity: 0.12,
              ),
            ),

            AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final y = math.sin(
                  _floatingController.value *
                      math.pi,
                ) *
                    8;

                return Positioned(
                  top: 145 + y,
                  left: 34,
                  child: child!,
                );
              },
              child: const _SmallDot(
                size: 7,
              ),
            ),

            AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final y = math.sin(
                  (_floatingController.value *
                      math.pi) +
                      1.5,
                ) *
                    7;

                return Positioned(
                  top: 245 + y,
                  right: 38,
                  child: child!,
                );
              },
              child: const _SmallDot(
                size: 9,
              ),
            ),

            // ------------------------------------------------------
            // CONTENT
            // ------------------------------------------------------

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                22,
                24,
                22,
                36,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 448,
                  ),
                  child: Column(
                    children: [
                      // ------------------------------------------------
                      // SUCCESS ICON
                      // ------------------------------------------------

                      ScaleTransition(
                        scale: _iconScale,
                        child: _buildSuccessIcon(),
                      ),

                      const SizedBox(height: 25),

                      // ------------------------------------------------
                      // HEADING
                      // ------------------------------------------------

                      FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: _buildHeading(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ------------------------------------------------
                      // MEMORY CARD
                      // ------------------------------------------------

                      FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: _buildCycleCard(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ------------------------------------------------
                      // LITTLE MESSAGE
                      // ------------------------------------------------

                      FadeTransition(
                        opacity: _fade,
                        child: _buildGentleMessage(),
                      ),

                      const SizedBox(height: 26),

                      // ------------------------------------------------
                      // BUTTON
                      // ------------------------------------------------

                      FadeTransition(
                        opacity: _fade,
                        child: _buildViewButton(),
                      ),

                      const SizedBox(height: 16),

                      // ------------------------------------------------
                      // PRIVACY
                      // ------------------------------------------------

                      FadeTransition(
                        opacity: _fade,
                        child: _buildPrivacy(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUCCESS ICON
  // ============================================================

  Widget _buildSuccessIcon() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft glow.
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFCE4EC).withValues(
                alpha: 0.65,
              ),
            ),
          ),

          // Inner soft circle.
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF7DADD),
                  Color(0xFFE8B4B8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E6E6E).withValues(
                    alpha: 0.12,
                  ),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),

          // Flower / new beginning symbol.
          const Icon(
            Icons.local_florist_rounded,
            size: 42,
            color: Color(0xFF7C5357),
          ),

          // Small floating sparkles.
          const Positioned(
            top: 8,
            right: 18,
            child: Icon(
              Icons.auto_awesome,
              size: 13,
              color: Color(0xFFB9858A),
            ),
          ),

          const Positioned(
            bottom: 17,
            left: 12,
            child: Icon(
              Icons.auto_awesome,
              size: 9,
              color: Color(0xFFB9858A),
            ),
          ),

          const Positioned(
            top: 27,
            left: 13,
            child: _TinyDot(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADING
  // ============================================================

  Widget _buildHeading() {
    return Column(
      children: [
        Text(
          'A little moment\nremembered.',
          textAlign: TextAlign.center,
          style: AppTextTheme.displayLarge.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 30,
            height: 1.13,
            letterSpacing: -0.7,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF7C5357),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Your cycle has been added to your story.\n'
              'Be gentle with yourself today.',
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMediumSecondary.copyWith(
            fontSize: 13,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CYCLE CARD
  // ============================================================

  Widget _buildCycleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE9DEDA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 25,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card heading.
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  size: 16,
                  color: Color(0xFF8E6E6E),
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR NEW CYCLE',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Day one begins here',
                    style:
                    AppTextTheme.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Main date.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC)
                  .withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'START DATE',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatDate(widget.startDate),
                      style:
                      AppTextTheme.bodyLarge.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF322F2E),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.75,
                    ),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                  child: Text(
                    'DAY 1',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7C5357),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Divider.
          Container(
            height: 1,
            color: const Color(0xFFE9E1DC),
          ),

          const SizedBox(height: 17),

          // Prediction.
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF6B6D91),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next predicted period',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatShortDate(_nextPeriodDate),
                      style:
                      AppTextTheme.bodyMedium.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Color(0xFFB4ACAA),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Progress.
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 6,
              width: double.infinity,
              color: const Color(0xFFE9E1DC),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1 / 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C5357),
                    borderRadius:
                    BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 7),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cycle started',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${widget.cycleLength} day cycle',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
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
  // GENTLE MESSAGE
  // ============================================================

  Widget _buildGentleMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.favorite_outline_rounded,
          size: 14,
          color: Color(0xFFB9858A),
        ),

        const SizedBox(width: 7),

        Flexible(
          child: Text(
            'One small step toward understanding yourself.',
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VIEW CYCLE BUTTON
  // ============================================================

  Widget _buildViewButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
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
              color: const Color(0xFF7C5357)
                  .withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (widget.onViewCycle != null) {
                widget.onViewCycle!();
              } else {
                context.go(AppRoutes.period);
              }
            },
            borderRadius: BorderRadius.circular(999),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  'View My Cycle',
                  style:
                  AppTextTheme.labelLarge.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 9),

                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  Widget _buildPrivacy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 12,
          color: AppColors.textSecondary.withValues(
            alpha: 0.65,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Private • Just between you two',
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary.withValues(
              alpha: 0.7,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// BACKGROUND GLOW
// ============================================================

class _Glow extends StatelessWidget {
  const _Glow({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFE8B4B8)
                  .withValues(alpha: opacity),
              const Color(0xFFE8B4B8)
                  .withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SMALL DECORATIVE DOT
// ============================================================

class _SmallDot extends StatelessWidget {
  const _SmallDot({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE8B4B8),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFFE8B4B8),
        shape: BoxShape.circle,
      ),
    );
  }
}