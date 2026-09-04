import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class SymptomHistoryScreen extends StatefulWidget {
  const SymptomHistoryScreen({
    super.key,
  });

  @override
  State<SymptomHistoryScreen> createState() =>
      _SymptomHistoryScreenState();
}

class _SymptomHistoryScreenState
    extends State<SymptomHistoryScreen> {
  // ==========================================================
  // TEMPORARY DATA
  // ==========================================================

  final List<_SymptomRecord> _records = [
    _SymptomRecord(
      date: DateTime(2023, 10, 14),
      time: '2:30 PM',
      symptoms: [
        'Headache',
        'Fatigue',
        'Nausea',
      ],
      intensity: 5,
      note:
      'Woke up feeling incredibly drained today. '
          'The headache started around noon.',
    ),

    _SymptomRecord(
      date: DateTime(2023, 10, 12),
      time: '10:15 AM',
      symptoms: [
        'Cramps',
        'Bloating',
      ],
      intensity: 3,
      note:
      'A little uncomfortable in the morning '
          'but felt better later.',
    ),

    _SymptomRecord(
      date: DateTime(2023, 10, 8),
      time: '8:45 PM',
      symptoms: [
        'Mood Swings',
        'Fatigue',
      ],
      intensity: 2,
      note:
      'Feeling more emotional than usual today.',
    ),

    _SymptomRecord(
      date: DateTime(2023, 9, 28),
      time: '6:20 PM',
      symptoms: [
        'Headache',
      ],
      intensity: 2,
      note:
      'Mild headache after a long day.',
    ),

    _SymptomRecord(
      date: DateTime(2023, 9, 24),
      time: '11:00 AM',
      symptoms: [
        'Backache',
        'Bloating',
      ],
      intensity: 4,
      note:
      'Lower back felt uncomfortable throughout '
          'the afternoon.',
    ),
  ];

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
            const _SymptomsHistoryBackground(),

            Column(
              children: [
                _buildTopBar(context),

                Expanded(
                  child: _buildContent(),
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
              'Symptom history',
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
  // CONTENT
  // ==========================================================

  Widget _buildContent() {
    if (_records.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
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

          _buildSummary(),

          const SizedBox(height: 28),

          _buildTimeline(),

          const SizedBox(height: 28),

          _buildPrivacy(),
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
          'How have you been feeling?',
          style:
          AppTextTheme.headlineMedium.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Every little signal matters. '
              'Here is everything you have recorded.',
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
  // SUMMARY
  // ==========================================================

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
        BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  '${_records.length} symptom entries',
                  style: AppTextTheme.labelLarge
                      .copyWith(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Your body has been speaking. '
                      'You have been listening.',
                  style: AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 9,
                    height: 1.4,
                    color: Colors.white
                        .withValues(alpha: 0.72),
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
  // TIMELINE
  // ==========================================================

  Widget _buildTimeline() {
    final groups =
    _groupRecordsByMonth();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        for (final entry in groups.entries) ...[
          _buildMonthLabel(entry.key),

          const SizedBox(height: 12),

          for (int i = 0;
          i < entry.value.length;
          i++)
            _SymptomTimelineTile(
              record: entry.value[i],
              isLast:
              i == entry.value.length - 1,
              onTap: () {
                _openSymptomDetail(
                  entry.value[i],
                );
              },
            ),

          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildMonthLabel(String month) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 2),
      child: Row(
        children: [
          Text(
            month.toUpperCase(),
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              height: 1,
              color: AppColors
                  .outlineVariant
                  .withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // GROUP BY MONTH
  // ==========================================================

  Map<String, List<_SymptomRecord>>
  _groupRecordsByMonth() {
    final Map<String, List<_SymptomRecord>>
    grouped = {};

    for (final record in _records) {
      final month = _monthName(record.date);

      grouped.putIfAbsent(
        month,
            () => [],
      );

      grouped[month]!.add(record);
    }

    return grouped;
  }

  // ==========================================================
  // DETAIL
  // ==========================================================

  void _openSymptomDetail(
      _SymptomRecord record) {
    context.push(
      AppRoutes.symptomDetail,
    );
  }

  // ==========================================================
  // EMPTY
  // ==========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration:
              const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 30,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'Nothing recorded yet',
              style: AppTextTheme
                  .headlineSmall
                  .copyWith(
                fontFamily:
                'Playfair Display',
                fontSize: 22,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'When you log symptoms, '
                  'they will appear here as your personal story.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMedium
                  .copyWith(
                fontSize: 12,
                height: 1.5,
                color:
                AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    AppRoutes.addSymptoms,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  foregroundColor:
                  Colors.white,
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      999,
                    ),
                  ),
                ),
                child: Text(
                  'Add Symptoms',
                  style: AppTextTheme
                      .labelLarge
                      .copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          'Your symptoms stay private to you.',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color:
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  String _monthName(DateTime date) {
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

    return months[date.month - 1];
  }
}

class _SymptomTimelineTile
    extends StatelessWidget {
  const _SymptomTimelineTile({
    required this.record,
    required this.isLast,
    required this.onTap,
  });

  final _SymptomRecord record;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          // ----------------------------------------------------
          // TIMELINE
          // ----------------------------------------------------

          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration:
                  const BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 16,
                    color:
                    AppColors.primary,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin:
                      const EdgeInsets
                          .symmetric(
                        vertical: 5,
                      ),
                      color: AppColors
                          .outlineVariant
                          .withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ----------------------------------------------------
          // CARD
          // ----------------------------------------------------

          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.only(
                bottom: 16,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                  child: Container(
                    padding:
                    const EdgeInsets.all(
                      15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.82,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                      border: Border.all(
                        color: AppColors
                            .outlineVariant
                            .withValues(
                          alpha: 0.6,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.025,
                          ),
                          blurRadius: 13,
                          offset:
                          const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // DATE + TIME
                        Row(
                          children: [
                            Text(
                              _formatDate(
                                record.date,
                              ),
                              style:
                              AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                AppColors
                                    .primary,
                              ),
                            ),

                            const SizedBox(
                              width: 7,
                            ),

                            Container(
                              width: 3,
                              height: 3,
                              decoration:
                              const BoxDecoration(
                                color: AppColors
                                    .outlineVariant,
                                shape: BoxShape
                                    .circle,
                              ),
                            ),

                            const SizedBox(
                              width: 7,
                            ),

                            Text(
                              record.time,
                              style:
                              AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: AppColors
                                    .textSecondary,
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

                        const SizedBox(height: 11),

                        // SYMPTOMS
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final symptom
                            in record.symptoms)
                              _SymptomChip(
                                text: symptom,
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // INTENSITY
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .water_drop_outlined,
                              size: 12,
                              color:
                              AppColors.primary,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              'Intensity',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 8,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child:
                              _IntensityBar(
                                value:
                                record.intensity,
                              ),
                            ),

                            const SizedBox(
                                width: 7),

                            Text(
                              _intensityLabel(
                                record.intensity,
                              ),
                              style:
                              AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 8,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                AppColors
                                    .primary,
                              ),
                            ),
                          ],
                        ),

                        if (record.note
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(
                            height: 11,
                          ),

                          Text(
                            record.note,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              height: 1.4,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }

  String _intensityLabel(int value) {
    if (value <= 1) return 'Mild';
    if (value <= 3) return 'Moderate';
    return 'High';
  }
}


class _SymptomChip
    extends StatelessWidget {
  const _SymptomChip({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC)
            .withValues(alpha: 0.65),
        borderRadius:
        BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style:
        AppTextTheme.labelSmall.copyWith(
          fontSize: 8,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _IntensityBar
    extends StatelessWidget {
  const _IntensityBar({
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
            (index) {
          final active =
              index < value;

          return Expanded(
            child: Container(
              height: 4,
              margin:
              const EdgeInsets.only(
                right: 3,
              ),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : AppColors
                    .outlineVariant
                    .withValues(
                  alpha: 0.45,
                ),
                borderRadius:
                BorderRadius.circular(
                  999,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SymptomRecord {
  const _SymptomRecord({
    required this.date,
    required this.time,
    required this.symptoms,
    required this.intensity,
    required this.note,
  });

  final DateTime date;
  final String time;
  final List<String> symptoms;
  final int intensity;
  final String note;
}

class _SymptomsHistoryBackground
    extends StatelessWidget {
  const _SymptomsHistoryBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.45),
              ),
            ),
          ),

          Positioned(
            top: 460,
            left: -130,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.07),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

