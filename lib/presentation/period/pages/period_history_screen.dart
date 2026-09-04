import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodHistoryScreen extends StatefulWidget {
  const PeriodHistoryScreen({
    super.key,
    this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
  });

  final DateTime? lastPeriodDate;
  final int cycleLength;
  final int periodLength;

  @override
  State<PeriodHistoryScreen> createState() =>
      _PeriodHistoryScreenState();
}

class _PeriodHistoryScreenState
    extends State<PeriodHistoryScreen> {
  late final DateTime _lastPeriodDate;

  @override
  void initState() {
    super.initState();

    _lastPeriodDate =
        widget.lastPeriodDate ?? DateTime.now();
  }

  // ==========================================================
  // CALCULATED DATA
  // ==========================================================

  List<_CycleHistoryItem> get _history {
    final current = _lastPeriodDate;

    return [
      _CycleHistoryItem(
        date: current,
        title: 'Current cycle',
        subtitle: 'Your latest period',
        duration: widget.periodLength,
        status: _CycleStatus.current,
      ),

      _CycleHistoryItem(
        date: _subtractDays(
          current,
          widget.cycleLength,
        ),
        title: 'Previous cycle',
        subtitle: 'Period recorded',
        duration: widget.periodLength,
        status: _CycleStatus.completed,
      ),

      _CycleHistoryItem(
        date: _subtractDays(
          current,
          widget.cycleLength * 2,
        ),
        title: 'Previous cycle',
        subtitle: 'Period recorded',
        duration: widget.periodLength,
        status: _CycleStatus.completed,
      ),

      _CycleHistoryItem(
        date: _subtractDays(
          current,
          widget.cycleLength * 3,
        ),
        title: 'Previous cycle',
        subtitle: 'Period recorded',
        duration: widget.periodLength,
        status: _CycleStatus.completed,
      ),
    ];
  }

  DateTime get _nextPeriodDate {
    return _lastPeriodDate.add(
      Duration(days: widget.cycleLength),
    );
  }

  DateTime _subtractDays(
      DateTime date,
      int days,
      ) {
    return date.subtract(
      Duration(days: days),
    );
  }

  int get _daysIntoCurrentCycle {
    final today = DateTime.now();

    final difference = DateTime(
      today.year,
      today.month,
      today.day,
    ).difference(
      DateTime(
        _lastPeriodDate.year,
        _lastPeriodDate.month,
        _lastPeriodDate.day,
      ),
    );

    final day = difference.inDays + 1;

    if (day < 1) return 1;

    if (day > widget.cycleLength) {
      return widget.cycleLength;
    }

    return day;
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _HistoryBackground(),

            Column(
              children: [
                _buildTopBar(context),

                Expanded(
                  child: SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),
                    padding:
                    const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),

                        const SizedBox(height: 22),

                        _buildCycleOverview(),

                        const SizedBox(height: 26),

                        _buildTimelineHeader(),

                        const SizedBox(height: 12),

                        _buildTimeline(),

                        const SizedBox(height: 26),

                        _buildPredictionCard(),

                        const SizedBox(height: 22),

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

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          const SizedBox(width: 8),

          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
            color: AppColors.textPrimary,
          ),

          Expanded(
            child: Text(
              'Cycle history',
              textAlign: TextAlign.center,
              style:
              AppTextTheme.headlineSmall.copyWith(
                fontFamily: 'Playfair Display',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Your rhythm, remembered.',
          style:
          AppTextTheme.headlineMedium.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'A gentle look back at your cycles, '
              'patterns and what your body has been telling you.',
          style:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // OVERVIEW
  // ==========================================================

  Widget _buildCycleOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF795458),
            Color(0xFF956C70),
          ],
        ),
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'YOUR CURRENT RHYTHM',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight:
                    FontWeight.w700,
                    color: Colors.white
                        .withValues(alpha: 0.75),
                  ),
                ),
              ),

              Text(
                'Day $_daysIntoCurrentCycle',
                style:
                AppTextTheme.labelLarge.copyWith(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _OverviewStat(
                  value:
                  '${widget.cycleLength}',
                  label: 'Average cycle',
                ),
              ),

              _overviewDivider(),

              Expanded(
                child: _OverviewStat(
                  value:
                  '${widget.periodLength}',
                  label: 'Period length',
                ),
              ),

              _overviewDivider(),

              Expanded(
                child: _OverviewStat(
                  value:
                  '${_history.length}',
                  label: 'Cycles saved',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewDivider() {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white
          .withValues(alpha: 0.16),
    );
  }

  // ==========================================================
  // TIMELINE HEADER
  // ==========================================================

  Widget _buildTimelineHeader() {
    return Row(
      children: [
        const _HistorySectionIcon(
          icon: Icons.auto_stories_outlined,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            'Your cycle story',
            style:
            AppTextTheme.headlineSmall.copyWith(
              fontFamily: 'Playfair Display',
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Text(
          '${_history.length} records',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TIMELINE
  // ==========================================================

  Widget _buildTimeline() {
    return Column(
      children: [
        for (int index = 0;
        index < _history.length;
        index++)
          _HistoryTimelineTile(
            item: _history[index],
            isLast:
            index == _history.length - 1,
            onTap: () {
              _openHistoryItem(
                _history[index],
              );
            },
          ),
      ],
    );
  }

  // ==========================================================
  // PREDICTION
  // ==========================================================

  Widget _buildPredictionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.82,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.65),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration:
            const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
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
                  'Looking ahead',
                  style:
                  AppTextTheme.labelLarge
                      .copyWith(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Your next period is expected around '
                      '${_formatDate(_nextPeriodDate)}.',
                  style:
                  AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 9,
                    height: 1.4,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRIVACY
  // ==========================================================

  Widget _buildPrivacy() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: AppColors.textSecondary
              .withValues(alpha: 0.75),
        ),

        const SizedBox(width: 6),

        Text(
          'Your cycle history stays private.',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // OPEN ITEM
  // ==========================================================

  void _openHistoryItem(
      _CycleHistoryItem item) {
    // For now we don't have a dedicated
    // cycle-detail screen.
    //
    // Later you can do:
    //
    // context.push(
    //   AppRoutes.periodDetail,
    //   extra: item,
    // );

    _showCycleDetails(item);
  }

  void _showCycleDetails(
      _CycleHistoryItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          decoration:
          const BoxDecoration(
            color: AppColors.surface,
            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                  AppColors.outlineVariant,
                  borderRadius:
                  BorderRadius.circular(
                    999,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                item.title,
                style: AppTextTheme
                    .headlineSmall
                    .copyWith(
                  fontFamily:
                  'Playfair Display',
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _formatDate(item.date),
                style:
                AppTextTheme.bodyMedium
                    .copyWith(
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _BottomStat(
                      value:
                      '${item.duration} days',
                      label: 'Period length',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BottomStat(
                      value:
                      '${widget.cycleLength} days',
                      label: 'Cycle length',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  style:
                  OutlinedButton.styleFrom(
                    minimumSize:
                    const Size.fromHeight(
                      48,
                    ),
                    side: BorderSide(
                      color: AppColors.primary
                          .withValues(
                        alpha: 0.45,
                      ),
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        999,
                      ),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextTheme
                        .labelLarge
                        .copyWith(
                      color:
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // FORMATTERS
  // ==========================================================

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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}


class _HistoryBackground
    extends StatelessWidget {
  const _HistoryBackground();

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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.45),
              ),
            ),
          ),

          Positioned(
            top: 420,
            left: -130,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _OverviewStat
    extends StatelessWidget {
  const _OverviewStat({
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
            fontSize: 20,
            fontWeight:
            FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 8,
            color: Colors.white
                .withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}


class _HistoryTimelineTile
    extends StatelessWidget {
  const _HistoryTimelineTile({
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  final _CycleHistoryItem item;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active =
        item.status == _CycleStatus.current;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? AppColors.primary
                        : const Color(
                      0xFFFCE4EC,
                    ),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.primary
                          .withValues(
                        alpha: 0.20,
                      ),
                    ),
                  ),
                  child: Icon(
                    active
                        ? Icons.favorite_rounded
                        : Icons.calendar_month_outlined,
                    size: 15,
                    color: active
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin:
                      const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      color: AppColors
                          .outlineVariant
                          .withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.only(
                bottom: 14,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius:
                  BorderRadius.circular(18),
                  child: Container(
                    padding:
                    const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(
                        0xFFFFF7F8,
                      )
                          : Colors.white
                          .withValues(
                        alpha: 0.78,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                      border: Border.all(
                        color: active
                            ? AppColors
                            .primaryContainer
                            .withValues(
                          alpha: 0.65,
                        )
                            : AppColors
                            .outlineVariant
                            .withValues(
                          alpha: 0.55,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.025,
                          ),
                          blurRadius: 12,
                          offset:
                          const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _formatShortDate(
                                item.date,
                              ),
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w600,
                                color: active
                                    ? AppColors
                                    .primary
                                    : AppColors
                                    .textSecondary,
                              ),
                            ),

                            const Spacer(),

                            if (active)
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  AppColors
                                      .primary,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    999,
                                  ),
                                ),
                                child: Text(
                                  'CURRENT',
                                  style:
                                  AppTextTheme
                                      .labelSmall
                                      .copyWith(
                                    fontSize: 7,
                                    letterSpacing:
                                    0.8,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    color:
                                    Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item.title,
                          style: AppTextTheme
                              .labelLarge
                              .copyWith(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                            color: AppColors
                                .textPrimary,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item.subtitle,
                          style: AppTextTheme
                              .labelSmall
                              .copyWith(
                            fontSize: 9,
                            height: 1.35,
                            color: AppColors
                                .textSecondary,
                          ),
                        ),

                        const SizedBox(height: 11),

                        Row(
                          children: [
                            const Icon(
                              Icons.water_drop_outlined,
                              size: 12,
                              color:
                              AppColors.primary,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              '${item.duration} days',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                AppColors.primary,
                              ),
                            ),

                            const Spacer(),

                            const Icon(
                              Icons
                                  .arrow_forward_ios_rounded,
                              size: 10,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatShortDate(
      DateTime date) {
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}


enum _CycleStatus {
  current,
  completed,
}

class _CycleHistoryItem {
  const _CycleHistoryItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.status,
  });

  final DateTime date;
  final String title;
  final String subtitle;
  final int duration;
  final _CycleStatus status;
}


class _HistorySectionIcon
    extends StatelessWidget {
  const _HistorySectionIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFFFCE4EC),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 17,
        color: AppColors.primary,
      ),
    );
  }
}


class _BottomStat
    extends StatelessWidget {
  const _BottomStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style:
            AppTextTheme.labelLarge.copyWith(
              fontSize: 12,
              fontWeight:
              FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
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

  return '${months[date.month - 1]} '
      '${date.day}, ${date.year}';
}