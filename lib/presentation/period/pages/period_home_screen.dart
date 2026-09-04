import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:simi/presentation/period/pages/period_setup_screen.dart';

import '../../../common/widgets/app_profile_avatar.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodHomeScreen extends StatelessWidget {
  const PeriodHomeScreen({
    super.key,

    this.myName = 'Saif',
    this.partnerName = 'Simran',
    this.userPhoto,

    // ----------------------------------------------------------
    // PERIOD STATE
    // ----------------------------------------------------------

    // Set this to true after the user completes cycle setup.
    this.cycleSetupComplete = true,

    // Null means the user has not logged a period yet.
    this.lastPeriodDate,

    // ----------------------------------------------------------
    // SETUP CALLBACKS
    // ----------------------------------------------------------

    this.onSetUpCycle,
    this.onMaybeLater,

    // ----------------------------------------------------------
    // PERIOD CALLBACKS
    // ----------------------------------------------------------

    this.onAddPeriod,
    this.onAddSymptoms,
    this.onEditPeriod,
    this.onOpenHistory,
    this.onOpenSettings,
  });


  // ============================================================
  // STATE
  // ============================================================

  final String myName;
  final String partnerName;
  final ImageProvider? userPhoto;

  /// True when the user has completed the initial cycle setup.
  final bool cycleSetupComplete;

  /// Most recent period start date.
  ///
  /// null = user has not added any period yet.
  final DateTime? lastPeriodDate;

  // ============================================================
  // CALLBACKS
  // ============================================================

  final VoidCallback? onSetUpCycle;
  final VoidCallback? onMaybeLater;

  final VoidCallback? onAddPeriod;
  final VoidCallback? onAddSymptoms;
  final VoidCallback? onEditPeriod;
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenSettings;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // STATE 1:
    // Cycle setup is NOT completed.
    // ----------------------------------------------------------

    if (!cycleSetupComplete) {
      return PeriodSetupScreen(
        onSetUpCycle: onSetUpCycle,
        onMaybeLater: onMaybeLater,
      );
    }

    // ----------------------------------------------------------
    // STATE 2:
    // Cycle setup IS completed,
    // but user has not added their first period.
    // ----------------------------------------------------------

    if (lastPeriodDate == null) {
      return _EmptyPeriodHome(
        myName: myName,
        partnerName: partnerName,
        userPhoto: userPhoto,
        onAddPeriod: onAddPeriod,
      );
    }

    // ----------------------------------------------------------
    // STATE 3:
    // Setup completed + period data exists.
    // Show normal dashboard.
    // ----------------------------------------------------------

    return _PeriodDashboard(
      lastPeriodDate: lastPeriodDate!,
      onAddPeriod: onAddPeriod,
      onAddSymptoms: onAddSymptoms,
      onEditPeriod: onEditPeriod,
      onOpenHistory: onOpenHistory,
      onOpenSettings: onOpenSettings,
    );
  }
}

// ============================================================
// EMPTY PERIOD HOME
// ============================================================
//
// This screen is shown when:
//
// cycleSetupComplete == true
// AND
// lastPeriodDate == null
//
// ============================================================
// ============================================================
// EMPTY PERIOD HOME
// ============================================================

class _EmptyPeriodHome extends StatefulWidget {
  const _EmptyPeriodHome({
    required this.myName,
    required this.partnerName,
    required this.userPhoto,
    required this.onAddPeriod,
  });

  final String myName;
  final String partnerName;
  final ImageProvider? userPhoto;
  final VoidCallback? onAddPeriod;

  @override
  State<_EmptyPeriodHome> createState() => _EmptyPeriodHomeState();
}

class _EmptyPeriodHomeState extends State<_EmptyPeriodHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ==================================================
            // TOP BAR
            // ==================================================

            _buildTopBar(
              widget.myName,
              widget.partnerName,
              widget.userPhoto,
            ),

            // ==================================================
            // MAIN AREA
            // ==================================================

            Expanded(
              child: Stack(
                children: [
                  // ==================================================
                  // BACKGROUND DECORATIONS
                  // ==================================================

                  const Positioned(
                    top: -90,
                    right: -70,
                    child: _BackgroundGlow(
                      size: 230,
                      opacity: 0.16,
                    ),
                  ),

                  const Positioned(
                    bottom: -100,
                    left: -90,
                    child: _BackgroundGlow(
                      size: 250,
                      opacity: 0.12,
                    ),
                  ),

                  // ==================================================
                  // MAIN CONTENT
                  // ==================================================

                  Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        32,
                        24,
                        40,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 448,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // YOUR EXISTING CONTENT STARTS HERE

                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                final value =
                                Curves.easeInOut.transform(
                                  _controller.value,
                                );

                                return Transform.translate(
                                  offset: Offset(
                                    0,
                                    -3 * value,
                                  ),
                                  child: child,
                                );
                              },
                              child: const _EmptyPeriodIllustration(),
                            ),

                            const SizedBox(height: 30),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 22,
                                  height: 1,
                                  color: AppColors.primaryContainer,
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  'A LITTLE BEGINNING',
                                  style: AppTextTheme.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 9,
                                    letterSpacing: 1.6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Container(
                                  width: 22,
                                  height: 1,
                                  color: AppColors.primaryContainer,
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Your story starts here',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.headlineMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                'Log your first period and we’ll start\n'
                                    'building your personal cycle story.',
                                textAlign: TextAlign.center,
                                style: AppTextTheme.bodyMediumSecondary.copyWith(
                                  height: 1.55,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            _AddPeriodButton(
                              onPressed: () {
                                context.push(AppRoutes.periodAddRecord);
                              },
                            ),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 13,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.75,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Private, personal & just for you',
                                  style: AppTextTheme.labelSmall.copyWith(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
}

Widget _buildTopBar(String myName, String partnerName, ImageProvider? userPhoto) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Row(
      children: [
        AppProfileAvatar(
          image: userPhoto,
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
                '$myName & $partnerName',
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
          icon: Icons.settings_outlined,
          onTap: () {},
        ),
      ],
    ),
  );
}



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
// ADD PERIOD BUTTON
// ============================================================
class _AddPeriodButton extends StatelessWidget {
  const _AddPeriodButton({
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 190,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF795458),
              Color(0xFF956C70),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              'Add First Period',
              style: AppTextTheme.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// EMPTY PERIOD ILLUSTRATION
// ============================================================

class _EmptyPeriodIllustration extends StatelessWidget {
  const _EmptyPeriodIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ======================================================
          // OUTER SOFT GLOW
          // ======================================================

          Container(
            width: 178,
            height: 178,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer.withValues(
                alpha: 0.08,
              ),
            ),
          ),

          // ======================================================
          // MAIN PINK CIRCLE
          // ======================================================

          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryContainer.withValues(
                    alpha: 0.62,
                  ),
                  AppColors.primaryContainer.withValues(
                    alpha: 0.18,
                  ),
                ],
              ),
              border: Border.all(
                color: AppColors.primaryContainer.withValues(
                  alpha: 0.28,
                ),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // ======================================================
          // INNER CALENDAR CARD
          // ======================================================

          Container(
            width: 94,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // ------------------------------------------------
                // CALENDAR HEADER
                // ------------------------------------------------

                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(7),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'YOUR CYCLE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                // ------------------------------------------------
                // CALENDAR BODY
                // ------------------------------------------------

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      9,
                      10,
                      8,
                    ),
                    child: Column(
                      children: [
                        // Calendar dots
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            5,
                                (index) => Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 2
                                    ? AppColors.primaryContainer
                                    : AppColors.outlineVariant
                                    .withValues(alpha: 0.55),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 9),

                        // Heart
                        Expanded(
                          child: Center(
                            child: Icon(
                              Icons.favorite_rounded,
                              size: 27,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // FLOATING HEART - TOP RIGHT
          // ======================================================

          Positioned(
            top: 17,
            right: 17,
            child: _FloatingIcon(
              icon: Icons.favorite_rounded,
              size: 27,
              iconSize: 12,
              backgroundColor: AppColors.surfaceBright,
              iconColor: AppColors.primary,
            ),
          ),

          // ======================================================
          // FLOATING DOT - LEFT
          // ======================================================

          Positioned(
            left: 17,
            top: 65,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
          ),

          // ======================================================
          // FLOATING HEART - BOTTOM LEFT
          // ======================================================

          Positioned(
            bottom: 18,
            left: 28,
            child: _FloatingIcon(
              icon: Icons.favorite_border_rounded,
              size: 25,
              iconSize: 12,
              backgroundColor: AppColors.surfaceBright,
              iconColor: AppColors.primary,
            ),
          ),

          // ======================================================
          // FLOATING DOT - BOTTOM RIGHT
          // ======================================================

          Positioned(
            bottom: 35,
            right: 16,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// FLOATING ICON
// ============================================================

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}


// ============================================================
// BACKGROUND GLOW
// ============================================================

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primaryContainer.withValues(
              alpha: opacity,
            ),
            AppColors.primaryContainer.withValues(
              alpha: 0,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PERIOD DASHBOARD
// ============================================================
//
// class _PeriodDashboard extends StatelessWidget {
//   const _PeriodDashboard({
//     required this.lastPeriodDate,
//     required this.onAddPeriod,
//     required this.onAddSymptoms,
//     required this.onEditPeriod,
//     required this.onOpenHistory,
//     required this.onOpenSettings,
//   });
//
//   final DateTime lastPeriodDate;
//
//   final VoidCallback? onAddPeriod;
//   final VoidCallback? onAddSymptoms;
//   final VoidCallback? onEditPeriod;
//   final VoidCallback? onOpenHistory;
//   final VoidCallback? onOpenSettings;
//
//   // ============================================================
//   // CALCULATED CYCLE DAY
//   // ============================================================
//
//   int get cycleDay {
//     final today = DateTime.now();
//
//     final todayOnly = DateTime(
//       today.year,
//       today.month,
//       today.day,
//     );
//
//     final periodOnly = DateTime(
//       lastPeriodDate.year,
//       lastPeriodDate.month,
//       lastPeriodDate.day,
//     );
//
//     final difference = todayOnly.difference(periodOnly).inDays;
//
//     return difference < 0 ? 1 : difference + 1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: SafeArea(
//         bottom: false,
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // ----------------------------------------------------
//             // TOP BAR
//             // ----------------------------------------------------
//
//             SliverToBoxAdapter(
//               child: _buildTopBar(),
//             ),
//
//             // ----------------------------------------------------
//             // CONTENT
//             // ----------------------------------------------------
//
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(
//                 16,
//                 12,
//                 16,
//                 32,
//               ),
//               sliver: SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     // Current cycle
//                     _CurrentCycleCard(
//                       cycleDay: cycleDay,
//                       onEditPeriod: onEditPeriod,
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Calendar
//                     const _CycleCalendar(),
//
//                     const SizedBox(height: 20),
//
//                     // Quick actions
//                     _QuickActions(
//                       onAddPeriod: onAddPeriod,
//                       onAddSymptoms: onAddSymptoms,
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Insights
//                     _CycleInsightsCard(
//                       cycleDay: cycleDay,
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Today
//                     _TodayCard(
//                       onAddSymptoms: onAddSymptoms,
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // History
//                     _HistoryCard(
//                       onOpenHistory: onOpenHistory,
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // Privacy
//                     const _PrivacyCard(),
//                   ],
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
//   // TOP BAR
//   // ============================================================
//
//   Widget _buildTopBar() {
//     return SizedBox(
//       height: 64,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'MY LOVE',
//                     style: AppTextTheme.labelSmall.copyWith(
//                       letterSpacing: 1.2,
//                       color: AppColors.primary,
//                     ),
//                   ),
//
//                   const SizedBox(height: 2),
//
//                   Text(
//                     'Cycle Tracking',
//                     style: AppTextTheme.headlineSmall,
//                   ),
//                 ],
//               ),
//             ),
//
//             // ----------------------------------------------------
//             // SETTINGS
//             // ----------------------------------------------------
//
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppColors.surfaceBright,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: AppColors.outlineVariant,
//                 ),
//               ),
//               child: IconButton(
//                 onPressed: onOpenSettings,
//                 padding: EdgeInsets.zero,
//                 icon: const Icon(
//                   Icons.settings_outlined,
//                   size: 19,
//                   color: AppColors.textSecondary,
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
// // ============================================================
// // CURRENT CYCLE
// // ============================================================
//
// class _CurrentCycleCard extends StatelessWidget {
//   const _CurrentCycleCard({
//     required this.cycleDay,
//     required this.onEditPeriod,
//   });
//
//   final int cycleDay;
//   final VoidCallback? onEditPeriod;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceBright,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(
//             alpha: 0.55,
//           ),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(
//               alpha: 0.04,
//             ),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // ------------------------------------------------------
//           // CURRENT PHASE
//           // ------------------------------------------------------
//
//           Text(
//             'CURRENT PHASE',
//             style: AppTextTheme.labelSmall.copyWith(
//               color: AppColors.primary,
//               letterSpacing: 1,
//               fontSize: 10,
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           Text(
//             'Day $cycleDay',
//             style: AppTextTheme.displayLarge.copyWith(
//               color: AppColors.primary,
//               fontSize: 34,
//             ),
//           ),
//
//           const SizedBox(height: 2),
//
//           Text(
//             'Fertile Window',
//             style: AppTextTheme.bodyMediumSecondary,
//           ),
//
//           const SizedBox(height: 20),
//
//           // ------------------------------------------------------
//           // PROGRESS
//           // ------------------------------------------------------
//
//           const _CycleProgress(),
//
//           const SizedBox(height: 20),
//
//           // ------------------------------------------------------
//           // STATS
//           // ------------------------------------------------------
//
//           Row(
//             children: [
//               Expanded(
//                 child: _CycleStat(
//                   label: 'Cycle Day',
//                   value: '$cycleDay',
//                 ),
//               ),
//
//               Container(
//                 width: 1,
//                 height: 34,
//                 color: AppColors.outlineVariant.withValues(
//                   alpha: 0.5,
//                 ),
//               ),
//
//               Expanded(
//                 child: _CycleStat(
//                   label: 'Next Period',
//                   value: '14 days',
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // ------------------------------------------------------
//           // EDIT PERIOD
//           // ------------------------------------------------------
//
//           SizedBox(
//             width: double.infinity,
//             height: 42,
//             child: OutlinedButton.icon(
//               onPressed: onEditPeriod,
//               icon: const Icon(
//                 Icons.edit_outlined,
//                 size: 16,
//               ),
//               label: Text(
//                 'Edit Period',
//                 style: AppTextTheme.labelLarge.copyWith(
//                   color: AppColors.primary,
//                 ),
//               ),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: AppColors.primary,
//                 side: BorderSide(
//                   color: AppColors.primary.withValues(
//                     alpha: 0.35,
//                   ),
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(999),
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
// // ============================================================
// // CYCLE PROGRESS
// // ============================================================
//
// class _CycleProgress extends StatelessWidget {
//   const _CycleProgress();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(999),
//           child: SizedBox(
//             height: 7,
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 14,
//                   child: Container(
//                     color: AppColors.primaryContainer,
//                   ),
//                 ),
//
//                 Expanded(
//                   flex: 6,
//                   child: Container(
//                     color: AppColors.secondary.withValues(
//                       alpha: 0.35,
//                     ),
//                   ),
//                 ),
//
//                 Expanded(
//                   flex: 8,
//                   child: Container(
//                     color: AppColors.outlineVariant.withValues(
//                       alpha: 0.35,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 7),
//
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Period',
//                 style: AppTextTheme.labelSmall,
//               ),
//             ),
//
//             Expanded(
//               child: Text(
//                 'Fertile',
//                 textAlign: TextAlign.center,
//                 style: AppTextTheme.labelSmall,
//               ),
//             ),
//
//             Expanded(
//               child: Text(
//                 'Next cycle',
//                 textAlign: TextAlign.end,
//                 style: AppTextTheme.labelSmall,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // CYCLE STAT
// // ============================================================
//
// class _CycleStat extends StatelessWidget {
//   const _CycleStat({
//     required this.label,
//     required this.value,
//   });
//
//   final String label;
//   final String value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: AppTextTheme.labelSmall,
//         ),
//
//         const SizedBox(height: 4),
//
//         Text(
//           value,
//           style: AppTextTheme.labelLarge,
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // CALENDAR
// // ============================================================
//
// class _CycleCalendar extends StatelessWidget {
//   const _CycleCalendar();
//
//   @override
//   Widget build(BuildContext context) {
//     const days = [
//       'S',
//       'M',
//       'T',
//       'W',
//       'T',
//       'F',
//       'S',
//     ];
//
//     const dates = [
//       '',
//       '',
//       '1',
//       '2',
//       '3',
//       '4',
//       '5',
//       '6',
//       '7',
//       '8',
//       '9',
//       '10',
//       '11',
//       '12',
//       '13',
//       '14',
//       '15',
//       '16',
//       '17',
//       '18',
//       '19',
//       '20',
//       '21',
//       '22',
//       '23',
//       '24',
//       '25',
//       '26',
//       '27',
//       '28',
//       '29',
//       '30',
//       '31',
//     ];
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceBright,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(
//             alpha: 0.55,
//           ),
//         ),
//       ),
//       child: Column(
//         children: [
//           // ------------------------------------------------------
//           // MONTH HEADER
//           // ------------------------------------------------------
//
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 padding: EdgeInsets.zero,
//                 icon: const Icon(
//                   Icons.chevron_left_rounded,
//                   size: 22,
//                 ),
//               ),
//
//               Expanded(
//                 child: Text(
//                   'October',
//                   textAlign: TextAlign.center,
//                   style: AppTextTheme.labelLarge,
//                 ),
//               ),
//
//               IconButton(
//                 onPressed: () {},
//                 padding: EdgeInsets.zero,
//                 icon: const Icon(
//                   Icons.chevron_right_rounded,
//                   size: 22,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 8),
//
//           // ------------------------------------------------------
//           // WEEK DAYS
//           // ------------------------------------------------------
//
//           Row(
//             children: days.map((day) {
//               return Expanded(
//                 child: Center(
//                   child: Text(
//                     day,
//                     style: AppTextTheme.labelSmall.copyWith(
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//
//           const SizedBox(height: 8),
//
//           // ------------------------------------------------------
//           // DATES
//           // ------------------------------------------------------
//
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: dates.length,
//             gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 7,
//               childAspectRatio: 1,
//             ),
//             itemBuilder: (context, index) {
//               final date = dates[index];
//
//               if (date.isEmpty) {
//                 return const SizedBox();
//               }
//
//               final isPeriod = date == '1' ||
//                   date == '2' ||
//                   date == '3' ||
//                   date == '4' ||
//                   date == '5';
//
//               final isToday = date == '14';
//
//               return Center(
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: isToday
//                         ? AppColors.primary
//                         : isPeriod
//                         ? AppColors.surface
//                         : Colors.transparent,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       date,
//                       style: AppTextTheme.bodyMedium.copyWith(
//                         fontSize: 12,
//                         color: isToday
//                             ? AppColors.onPrimary
//                             : AppColors.textPrimary,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           const SizedBox(height: 12),
//
//           // ------------------------------------------------------
//           // LEGEND
//           // ------------------------------------------------------
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const _CalendarLegend(
//                 color: AppColors.surface,
//                 text: 'Period',
//               ),
//
//               const SizedBox(width: 18),
//
//               const _CalendarLegend(
//                 color: AppColors.primary,
//                 text: 'Today',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // CALENDAR LEGEND
// // ============================================================
//
// class _CalendarLegend extends StatelessWidget {
//   const _CalendarLegend({
//     required this.color,
//     required this.text,
//   });
//
//   final Color color;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//
//         const SizedBox(width: 5),
//
//         Text(
//           text,
//           style: AppTextTheme.labelSmall,
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // QUICK ACTIONS
// // ============================================================
//
// class _QuickActions extends StatelessWidget {
//   const _QuickActions({
//     required this.onAddPeriod,
//     required this.onAddSymptoms,
//   });
//
//   final VoidCallback? onAddPeriod;
//   final VoidCallback? onAddSymptoms;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: _ActionCard(
//             icon: Icons.add_circle_outline_rounded,
//             title: 'Add Period',
//             backgroundColor: AppColors.surface,
//             onTap: onAddPeriod,
//           ),
//         ),
//
//         const SizedBox(width: 12),
//
//         Expanded(
//           child: _ActionCard(
//             icon: Icons.favorite_border_rounded,
//             title: 'Add Symptoms',
//             backgroundColor: AppColors.surfaceBright,
//             onTap: onAddSymptoms,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // ACTION CARD
// // ============================================================
//
// class _ActionCard extends StatelessWidget {
//   const _ActionCard({
//     required this.icon,
//     required this.title,
//     required this.backgroundColor,
//     required this.onTap,
//   });
//
//   final IconData icon;
//   final String title;
//   final Color backgroundColor;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: backgroundColor,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 16,
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 20,
//                 color: AppColors.primary,
//               ),
//
//               const SizedBox(width: 8),
//
//               Expanded(
//                 child: Text(
//                   title,
//                   style: AppTextTheme.labelLarge.copyWith(
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================
// // CYCLE INSIGHTS
// // ============================================================
//
// class _CycleInsightsCard extends StatelessWidget {
//   const _CycleInsightsCard({
//     required this.cycleDay,
//   });
//
//   final int cycleDay;
//
//   @override
//   Widget build(BuildContext context) {
//     return _SectionCard(
//       title: 'CYCLE INSIGHTS',
//       child: Row(
//         children: [
//           Expanded(
//             child: _InsightItem(
//               icon: Icons.loop_rounded,
//               label: 'Average Cycle',
//               value: '28 days',
//             ),
//           ),
//
//           Expanded(
//             child: _InsightItem(
//               icon: Icons.water_drop_outlined,
//               label: 'Period Length',
//               value: '5 days',
//             ),
//           ),
//
//           Expanded(
//             child: _InsightItem(
//               icon: Icons.calendar_today_outlined,
//               label: 'Cycle Day',
//               value: '$cycleDay',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // INSIGHT ITEM
// // ============================================================
//
// class _InsightItem extends StatelessWidget {
//   const _InsightItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//
//   final IconData icon;
//   final String label;
//   final String value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           size: 19,
//           color: AppColors.primary,
//         ),
//
//         const SizedBox(height: 7),
//
//         Text(
//           value,
//           style: AppTextTheme.labelLarge,
//         ),
//
//         const SizedBox(height: 3),
//
//         Text(
//           label,
//           textAlign: TextAlign.center,
//           style: AppTextTheme.labelSmall,
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================
// // TODAY
// // ============================================================
//
// class _TodayCard extends StatelessWidget {
//   const _TodayCard({
//     required this.onAddSymptoms,
//   });
//
//   final VoidCallback? onAddSymptoms;
//
//   @override
//   Widget build(BuildContext context) {
//     return _SectionCard(
//       title: 'TODAY',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'How are you feeling?',
//             style: AppTextTheme.bodyLarge,
//           ),
//
//           const SizedBox(height: 14),
//
//           Row(
//             children: [
//               const Expanded(
//                 child: _MoodChip(
//                   emoji: '😊',
//                   label: 'Good',
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               const Expanded(
//                 child: _MoodChip(
//                   emoji: '😐',
//                   label: 'Okay',
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               const Expanded(
//                 child: _MoodChip(
//                   emoji: '😔',
//                   label: 'Low',
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           SizedBox(
//             width: double.infinity,
//             height: 42,
//             child: OutlinedButton(
//               onPressed: onAddSymptoms,
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: AppColors.primary,
//                 side: BorderSide(
//                   color: AppColors.primary.withValues(
//                     alpha: 0.35,
//                   ),
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),
//               child: Text(
//                 'Add Symptoms',
//                 style: AppTextTheme.labelLarge.copyWith(
//                   color: AppColors.primary,
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
// // ============================================================
// // MOOD CHIP
// // ============================================================
//
// class _MoodChip extends StatelessWidget {
//   const _MoodChip({
//     required this.emoji,
//     required this.label,
//   });
//
//   final String emoji;
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(
//             alpha: 0.5,
//           ),
//         ),
//       ),
//       child: Column(
//         children: [
//           Text(
//             emoji,
//             style: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//
//           const SizedBox(height: 3),
//
//           Text(
//             label,
//             style: AppTextTheme.labelSmall,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // HISTORY
// // ============================================================
//
// class _HistoryCard extends StatelessWidget {
//   const _HistoryCard({
//     required this.onOpenHistory,
//   });
//
//   final VoidCallback? onOpenHistory;
//
//   @override
//   Widget build(BuildContext context) {
//     return _SectionCard(
//       title: 'RECENT CYCLES',
//       trailing: TextButton(
//         onPressed: onOpenHistory,
//         child: Text(
//           'View All',
//           style: AppTextTheme.labelSmall.copyWith(
//             color: AppColors.primary,
//           ),
//         ),
//       ),
//       child: Column(
//         children: [
//           const _HistoryRow(
//             month: 'October',
//             dates: 'Oct 1 – Oct 5',
//             duration: '5 days',
//           ),
//
//           Divider(
//             color: AppColors.outlineVariant.withValues(
//               alpha: 0.4,
//             ),
//           ),
//
//           const _HistoryRow(
//             month: 'September',
//             dates: 'Sep 3 – Sep 7',
//             duration: '5 days',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // HISTORY ROW
// // ============================================================
//
// class _HistoryRow extends StatelessWidget {
//   const _HistoryRow({
//     required this.month,
//     required this.dates,
//     required this.duration,
//   });
//
//   final String month;
//   final String dates;
//   final String duration;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: AppColors.surface,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.calendar_month_outlined,
//               size: 19,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   month,
//                   style: AppTextTheme.labelLarge,
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 Text(
//                   dates,
//                   style: AppTextTheme.labelSmall,
//                 ),
//               ],
//             ),
//           ),
//
//           Text(
//             duration,
//             style: AppTextTheme.labelSmall.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // SHARED SECTION CARD
// // ============================================================
//
// class _SectionCard extends StatelessWidget {
//   const _SectionCard({
//     required this.title,
//     required this.child,
//     this.trailing,
//   });
//
//   final String title;
//   final Widget child;
//   final Widget? trailing;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceBright,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.outlineVariant.withValues(
//             alpha: 0.55,
//           ),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: AppTextTheme.labelSmall.copyWith(
//                     color: AppColors.primary,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//
//               if (trailing != null) trailing!,
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           child,
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================
// // PRIVACY
// // ============================================================
//
// class _PrivacyCard extends StatelessWidget {
//   const _PrivacyCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: AppColors.surfaceBright,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.lock_outline_rounded,
//               size: 18,
//               color: AppColors.primary,
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Private & just for two',
//                   style: AppTextTheme.labelLarge,
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 Text(
//                   'Your cycle information stays private.',
//                   style: AppTextTheme.labelSmall,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// ============================================================
// PREMIUM PERIOD DASHBOARD
// ============================================================

class _PeriodDashboard extends StatefulWidget {
  const _PeriodDashboard({
    required this.lastPeriodDate,
    required this.onAddPeriod,
    required this.onAddSymptoms,
    required this.onEditPeriod,
    required this.onOpenHistory,
    required this.onOpenSettings,
  });

  final DateTime lastPeriodDate;

  final VoidCallback? onAddPeriod;
  final VoidCallback? onAddSymptoms;
  final VoidCallback? onEditPeriod;
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenSettings;

  @override
  State<_PeriodDashboard> createState() =>
      _PeriodDashboardState();
}

class _PeriodDashboardState extends State<_PeriodDashboard>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  // ------------------------------------------------------------
  // CYCLE SETTINGS
  // ------------------------------------------------------------

  static const int cycleLength = 28;
  static const int periodLength = 5;

  // ------------------------------------------------------------
  // CYCLE DAY
  // ------------------------------------------------------------

  int get cycleDay {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final start = DateTime(
      widget.lastPeriodDate.year,
      widget.lastPeriodDate.month,
      widget.lastPeriodDate.day,
    );

    final difference = today.difference(start).inDays;

    if (difference < 0) return 1;

    // Keep the day inside the current 28-day cycle.
    return (difference % cycleLength) + 1;
  }

  // ------------------------------------------------------------
  // NEXT PERIOD
  // ------------------------------------------------------------

  DateTime get nextPeriodDate {
    final start = DateTime(
      widget.lastPeriodDate.year,
      widget.lastPeriodDate.month,
      widget.lastPeriodDate.day,
    );

    final daysSinceStart = DateTime.now()
        .difference(start)
        .inDays;

    final cyclesPassed =
        daysSinceStart ~/ cycleLength;

    return start.add(
      Duration(
        days: (cyclesPassed + 1) * cycleLength,
      ),
    );
  }

  int get daysUntilNextPeriod {
    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return nextPeriodDate
        .difference(todayOnly)
        .inDays;
  }

  // ------------------------------------------------------------
  // PHASE
  // ------------------------------------------------------------

  String get cyclePhase {
    if (cycleDay <= periodLength) {
      return 'Menstrual Phase';
    }

    if (cycleDay <= 13) {
      return 'Follicular Phase';
    }

    if (cycleDay <= 16) {
      return 'Ovulation Window';
    }

    return 'Luteal Phase';
  }

  String get phaseMessage {
    if (cycleDay <= periodLength) {
      return 'A time to slow down and care for yourself.';
    }

    if (cycleDay <= 13) {
      return 'Energy is gradually beginning to rise.';
    }

    if (cycleDay <= 16) {
      return 'You may feel more energetic and social.';
    }

    return 'A gentle time to recharge and listen to yourself.';
  }

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ======================================================
            // BACKGROUND
            // ======================================================

            const Positioned(
              top: -120,
              right: -100,
              child: _DashboardGlow(
                size: 300,
                opacity: 0.18,
              ),
            ),

            const Positioned(
              bottom: -150,
              left: -120,
              child: _DashboardGlow(
                size: 320,
                opacity: 0.11,
              ),
            ),

            // ======================================================
            // CONTENT
            // ======================================================

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // --------------------------------------------------
                // TOP BAR
                // --------------------------------------------------

                SliverToBoxAdapter(
                  child: _buildTopBar(),
                ),

                // --------------------------------------------------
                // MAIN CONTENT
                // --------------------------------------------------

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    10,
                    18,
                    36,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // HERO
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.0,
                          end: 0.45,
                          child: _buildCycleHero(),
                        ),

                        const SizedBox(height: 18),

                        // QUICK ACTIONS
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.18,
                          end: 0.60,
                          child: _buildQuickActions(),
                        ),

                        const SizedBox(height: 18),


                        // CALENDAR
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.30,
                          end: 0.72,
                          child: _buildCalendar(),
                        ),

                        const SizedBox(height: 18),

                        // Symptoms
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.62,
                          end: 1.0,
                          child: _SymptomHistoryRow(
                            title: 'Today’s symptoms',
                            subtitle: 'Headache • Fatigue • Nausea',
                            onTap: () {
                              context.push(
                                AppRoutes.symptomDetail,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 18),


                        // TODAY
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.42,
                          end: 0.82,
                          child: _buildToday(),
                        ),

                        const SizedBox(height: 18),

                        // INSIGHTS
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.52,
                          end: 0.90,
                          child: _buildInsights(),
                        ),

                        const SizedBox(height: 18),

                        // HISTORY
                        _DashboardEntrance(
                          controller: _entranceController,
                          begin: 0.62,
                          end: 1.0,
                          child: _buildHistory(),
                        ),

                        const SizedBox(height: 18),

                        _buildPrivacy(),
                      ],
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

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          8,
          18,
          4,
        ),
        child: Row(
          children: [
            // Avatar

            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryContainer,
                  width: 1.4,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: const Color(0xFFFCE4EC),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 21,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'MY LOVE',
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Your cycle story',
                    style:
                    AppTextTheme.headlineSmall.copyWith(
                      fontFamily: 'Playfair Display',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Lock

            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.78,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outlineVariant,
                  width: 0.8,
                ),
              ),
              child: IconButton(
                onPressed: () => (context.push(AppRoutes.periodSettings)),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 17,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CYCLE HERO
  // ============================================================

  Widget _buildCycleHero() {
    final progress =
        cycleDay / cycleLength;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF9F7),
            Color(0xFFFCECEF),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFEEDBDD),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: 0.08,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // --------------------------------------------------------
          // TOP LABEL
          // --------------------------------------------------------

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CURRENT CYCLE',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              GestureDetector(
                onTap: widget.onEditPeriod,
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --------------------------------------------------------
          // CYCLE ORBIT
          // --------------------------------------------------------

          SizedBox(
            width: 205,
            height: 205,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow

                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: 0.50,
                    ),
                  ),
                ),

                // Orbit

                CustomPaint(
                  size: const Size(
                    178,
                    178,
                  ),
                  painter: _CycleOrbitPainter(
                    progress: progress,
                  ),
                ),

                // Center

                Container(
                  width: 126,
                  height: 126,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: 0.82,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(
                          alpha: 0.10,
                        ),
                        blurRadius: 25,
                        offset: const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        'DAY',
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 1),

                      Text(
                        '$cycleDay',
                        style:
                        AppTextTheme.displayLarge.copyWith(
                          fontFamily:
                          'Playfair Display',
                          fontSize: 43,
                          height: 1,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'of $cycleLength',
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Small heart

                // AnimatedBuilder(
                //   animation: _pulseController,
                //   builder: (context, child) {
                //     final scale =
                //         1 +
                //             (_pulseController.value *
                //                 0.08);
                //
                //     return Transform.scale(
                //       scale: scale,
                //       child: child,
                //     );
                //   },
                //   child: const Positioned(
                //     top: 12,
                //     right: 36,
                //     child: Icon(
                //       Icons.favorite_rounded,
                //       size: 15,
                //       color: Color(0xFFE8B4B8),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          // --------------------------------------------------------
          // PHASE
          // --------------------------------------------------------

          Text(
            cyclePhase,
            style:
            AppTextTheme.headlineSmall.copyWith(
              fontFamily: 'Playfair Display',
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            phaseMessage,
            textAlign: TextAlign.center,
            style:
            AppTextTheme.bodyMediumSecondary.copyWith(
              fontSize: 11,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 17),

          // --------------------------------------------------------
          // BOTTOM STATS
          // --------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.62,
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HeroStat(
                    icon: Icons.calendar_today_outlined,
                    label: 'Started',
                    value:
                    _formatShortDate(
                      widget.lastPeriodDate,
                    ),
                  ),
                ),

                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.outlineVariant,
                ),

                Expanded(
                  child: _HeroStat(
                    icon: Icons.hourglass_empty_rounded,
                    label: 'Next period',
                    value:
                    '$daysUntilNextPeriod days',
                  ),
                ),

                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.outlineVariant,
                ),

                Expanded(
                  child: _HeroStat(
                    icon: Icons.loop_rounded,
                    label: 'Cycle',
                    value:
                    '$cycleLength days',
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
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _PremiumActionCard(
            icon: Icons.add_rounded,
            title: 'Add Period',
            subtitle: 'Log a new day',
            filled: true,
            onTap: widget.onAddPeriod,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _PremiumActionCard(
            icon: Icons.favorite_border_rounded,
            title: 'Symptoms',
            subtitle: 'How are you?',
            filled: false,
            onTap: widget.onAddSymptoms,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _buildCalendar() {
    final now = DateTime.now();

    final monthStart = DateTime(
      now.year,
      now.month,
      1,
    );

    final daysInMonth = DateTime(
      now.year,
      now.month + 1,
      0,
    ).day;

    final firstWeekday =
        monthStart.weekday % 7;

    final monthName =
    _monthName(now.month);

    return _PremiumSectionCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
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
                      monthName,
                      style:
                      AppTextTheme.headlineSmall.copyWith(
                        fontFamily:
                        'Playfair Display',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      'Your cycle at a glance',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${daysInMonth} days',
                style:
                AppTextTheme.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Weekdays

          Row(
            children: const [
              _WeekDay('S'),
              _WeekDay('M'),
              _WeekDay('T'),
              _WeekDay('W'),
              _WeekDay('T'),
              _WeekDay('F'),
              _WeekDay('S'),
            ],
          ),

          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount:
            firstWeekday + daysInMonth,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox();
              }

              final day =
                  index - firstWeekday + 1;

              final date = DateTime(
                now.year,
                now.month,
                day,
              );

              final isToday =
              _isSameDay(
                date,
                DateTime.now(),
              );

              final cycleDate =
              _cycleDayForDate(date);

              final isPeriod =
                  cycleDate >= 1 &&
                      cycleDate <= periodLength;

              final isFuture =
              date.isAfter(
                DateTime.now(),
              );

              return Center(
                child: AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 180,
                  ),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? AppColors.primary
                        : isPeriod
                        ? const Color(
                      0xFFFCE4EC,
                    )
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style:
                      AppTextTheme.bodyMedium.copyWith(
                        fontSize: 11,
                        fontWeight: isToday ||
                            isPeriod
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isToday
                            ? Colors.white
                            : isFuture
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 13),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              _LegendDot(
                color:
                const Color(0xFFFCE4EC),
                label: 'Period',
              ),

              const SizedBox(width: 18),

              _LegendDot(
                color: AppColors.primary,
                label: 'Today',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY
  // ============================================================

  Widget _buildToday() {
    return _PremiumSectionCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SectionIcon(
                icon: Icons.favorite_border_rounded,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TODAY',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'How are you feeling?',
                      style:
                      AppTextTheme.bodyLarge.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              const Expanded(
                child: _PremiumMood(
                  emoji: '😊',
                  title: 'Good',
                  background:
                  Color(0xFFF6EEE8),
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: _PremiumMood(
                  emoji: '😌',
                  title: 'Calm',
                  background:
                  Color(0xFFF0EFF6),
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: _PremiumMood(
                  emoji: '🥺',
                  title: 'Low',
                  background:
                  Color(0xFFFCE4EC),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed:
              widget.onAddSymptoms,
              icon: const Icon(
                Icons.edit_outlined,
                size: 15,
              ),
              label: const Text(
                'Add how you feel today',
              ),
              style:
              OutlinedButton.styleFrom(
                foregroundColor:
                AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary
                      .withValues(alpha: 0.28),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INSIGHTS
  // ============================================================

  Widget _buildInsights() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFF322F2E),
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.10,
            ),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: Color(0xFFE8B4B8),
              ),

              const SizedBox(width: 9),

              Text(
                'A LITTLE INSIGHT',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'You are on day $cycleDay of your cycle.',
            style:
            AppTextTheme.headlineSmall.copyWith(
              fontFamily: 'Playfair Display',
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            phaseMessage,
            textAlign: TextAlign.center,
            style:
            AppTextTheme.bodyMediumSecondary.copyWith(
              color: Colors.white70,
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _DarkInsight(
                  value: '$cycleDay',
                  label: 'Cycle day',
                ),
              ),

              Expanded(
                child: _DarkInsight(
                  value: '$cycleLength',
                  label: 'Avg. cycle',
                ),
              ),

              Expanded(
                child: _DarkInsight(
                  value: '$periodLength',
                  label: 'Period days',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

  // ============================================================
// HISTORY
// ============================================================

  Widget _buildHistory() {
    return _PremiumSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // HEADER
          // ------------------------------------------------------
          Row(
            children: [
              const _SectionIcon(
                icon: Icons.auto_stories_outlined,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Your cycle story',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontFamily: 'Playfair Display',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              TextButton(
                onPressed: widget.onOpenHistory,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: AppTextTheme.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------
          // TIMELINE
          // ------------------------------------------------------
          _CycleTimelineEvent(
            date: widget.lastPeriodDate,
            title: 'Period started',
            subtitle:
            'Your current cycle began here',
            duration: '$periodLength days',
            icon: Icons.favorite_rounded,
            active: true,
            isLast: false,
          ),

          _CycleTimelineEvent(
            date: nextPeriodDate,
            title: 'Next expected period',
            subtitle:
            'Your body may be preparing for a new cycle',
            duration:
            daysUntilNextPeriod == 0
                ? 'Expected today'
                : '$daysUntilNextPeriod days away',
            icon: Icons.auto_awesome_rounded,
            active: false,
            isLast: true,
          ),
        ],
      ),
    );
  }



  // ============================================================
  // PRIVACY
  // ============================================================

  Widget _buildPrivacy() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_outline_rounded,
          size: 12,
          color: AppColors.textSecondary,
        ),

        const SizedBox(width: 6),

        Text(
          'Your cycle data stays private',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 4),

        const Text(
          '•',
          style: TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 4),

        Text(
          'Just for you',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  int _cycleDayForDate(DateTime date) {
    final start = DateTime(
      widget.lastPeriodDate.year,
      widget.lastPeriodDate.month,
      widget.lastPeriodDate.day,
    );

    final target = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        target.difference(start).inDays;

    if (difference < 0) {
      return 0;
    }

    return (difference % cycleLength) + 1;
  }

  bool _isSameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
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

  String _monthName(int month) {
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

    return months[month - 1];
  }
}

// ============================================================
// DASHBOARD GLOW
// ============================================================

class _DashboardGlow extends StatelessWidget {
  const _DashboardGlow({
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
              const Color(0xFFE8B4B8).withValues(
                alpha: opacity,
              ),
              const Color(0xFFE8B4B8).withValues(
                alpha: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ENTRANCE ANIMATION
// ============================================================

class _DashboardEntrance extends StatelessWidget {
  const _DashboardEntrance({
    required this.controller,
    required this.begin,
    required this.end,
    required this.child,
  });

  final AnimationController controller;
  final double begin;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
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
      child: child,
    );
  }
}


// ============================================================
// CYCLE ORBIT PAINTER
// ============================================================

class _CycleOrbitPainter extends CustomPainter {
  const _CycleOrbitPainter({
    required this.progress,
  });

  final double progress;

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.width / 2 - 9;

    // ----------------------------------------------------------
    // BACKGROUND ORBIT
    // ----------------------------------------------------------

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = const Color(
        0xFFE8D9D6,
      );

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    // ----------------------------------------------------------
    // ACTIVE ORBIT
    // ----------------------------------------------------------

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = const Color(
        0xFFE8B4B8,
      );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      activePaint,
    );

    // ----------------------------------------------------------
    // CURRENT POSITION
    // ----------------------------------------------------------

    final angle =
        (-math.pi / 2) +
            (math.pi * 2 * progress);

    final dotPosition = Offset(
      center.dx +
          radius * math.cos(angle),
      center.dy +
          radius * math.sin(angle),
    );

    final dotPaint = Paint()
      ..color = const Color(
        0xFF7C5357,
      );

    canvas.drawCircle(
      dotPosition,
      5,
      dotPaint,
    );

    // Small outer dot.

    final outerDotPaint = Paint()
      ..color = Colors.white;

    canvas.drawCircle(
      dotPosition,
      2,
      outerDotPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _CycleOrbitPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}


class _HeroStat extends StatelessWidget {
  const _HeroStat({
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
          size: 14,
          color: AppColors.primary,
        ),

        const SizedBox(height: 5),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
          AppTextTheme.labelLarge.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 8,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}


class _PremiumActionCard extends StatelessWidget {
  const _PremiumActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            gradient: filled
                ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF795458),
                Color(0xFF956C70),
              ],
            )
                : null,
            color: filled
                ? null
                : Colors.white.withValues(alpha: 0.80),
            borderRadius: BorderRadius.circular(20),
            border: filled
                ? null
                : Border.all(
              color: AppColors.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Smaller icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withValues(alpha: 0.14)
                      : const Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: filled
                      ? Colors.white
                      : AppColors.primary,
                ),
              ),

              const SizedBox(width: 10),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: filled
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color: filled
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Space between text and arrow
              const SizedBox(width: 12),

              // Smaller arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: filled
                    ? Colors.white70
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumSectionCard extends StatelessWidget {
  const _PremiumSectionCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.82,
        ),
        borderRadius:
        BorderRadius.circular(23),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}


class _WeekDay extends StatelessWidget {
  const _WeekDay(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 5),

        Text(
          label,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}


class _SectionIcon extends StatelessWidget {
  const _SectionIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius:
        BorderRadius.circular(11),
      ),
      child: Icon(
        icon,
        size: 18,
        color: AppColors.primary,
      ),
    );
  }
}


class _PremiumMood extends StatelessWidget {
  const _PremiumMood({
    required this.emoji,
    required this.title,
    required this.background,
  });

  final String emoji;
  final String title;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}


class _DarkInsight extends StatelessWidget {
  const _DarkInsight({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style:
          AppTextTheme.headlineSmall.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 8,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}


class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.month,
    required this.date,
    required this.title,
    required this.duration,
    required this.active,
    this.last = false,
  });

  final String month;
  final String date;
  final String title;
  final String duration;
  final bool active;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? AppColors.primary
                        : AppColors.primaryContainer,
                  ),
                ),

                if (!last)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppColors.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      month,
                      style:
                      AppTextTheme.labelLarge.copyWith(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      date,
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style:
                        AppTextTheme.bodyMedium.copyWith(
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        duration,
                        style:
                        AppTextTheme.labelSmall.copyWith(
                          fontSize: 8,
                          color:
                          AppColors.textSecondary,
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
    );
  }
}


class _CycleTimelineEvent extends StatelessWidget {
  const _CycleTimelineEvent({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.icon,
    required this.active,
    required this.isLast,
  });

  final DateTime date;
  final String title;
  final String subtitle;
  final String duration;
  final IconData icon;
  final bool active;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
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

    final month = months[date.month - 1];
    final day = date.day.toString();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // DATE COLUMN
          // ----------------------------------------------------
          SizedBox(
            width: 58,
            child: Column(
              children: [
                Text(
                  month.substring(0, 3).toUpperCase(),
                  style: AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: active
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  day,
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontFamily: 'Playfair Display',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // TIMELINE
          // ----------------------------------------------------
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Timeline dot
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? AppColors.primary
                        : const Color(0xFFF5EEF0),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                      width: 1,
                    ),
                    boxShadow: active
                        ? [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: active
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),

                // Vertical connecting line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      color: AppColors.outlineVariant
                          .withValues(alpha: 0.75),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------
          // EVENT CONTENT
          // ----------------------------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 22,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  13,
                  14,
                  13,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFFFF7F8)
                      : Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: active
                        ? const Color(0xFFF1DADD)
                        : AppColors.outlineVariant
                        .withValues(alpha: 0.65),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // Status + duration
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            active
                                ? 'CURRENT CYCLE'
                                : 'UPCOMING',
                            style: AppTextTheme.labelSmall.copyWith(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFFCE4EC)
                                : const Color(0xFFF4F1F0),
                            borderRadius:
                            BorderRadius.circular(999),
                          ),
                          child: Text(
                            duration,
                            style:
                            AppTextTheme.labelSmall.copyWith(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      title,
                      style:
                      AppTextTheme.labelLarge.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Subtitle
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
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

class _SymptomHistoryRow extends StatelessWidget {
  const _SymptomHistoryRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            children: [
              const _SectionIcon(
                icon: Icons.favorite_border_rounded,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Today’s symptoms',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontFamily: 'Playfair Display',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  context.push(
                    AppRoutes.symptomHistory,
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: AppTextTheme.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}