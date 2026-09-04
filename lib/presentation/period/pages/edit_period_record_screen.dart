import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class EditPeriodRecordScreen extends StatefulWidget {
  const EditPeriodRecordScreen({
    super.key,
    this.initialStartDate,
    this.initialPeriodLength = 5,
  });

  final DateTime? initialStartDate;
  final int initialPeriodLength;

  @override
  State<EditPeriodRecordScreen> createState() =>
      _EditPeriodRecordScreenState();
}

class _EditPeriodRecordScreenState
    extends State<EditPeriodRecordScreen> {
  late DateTime? _startDate;
  late int _periodLength;

  @override
  void initState() {
    super.initState();

    _startDate = widget.initialStartDate;
    _periodLength = widget.initialPeriodLength;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Stack(
                children: [
                  _buildBackground(),

                  SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),

                        const SizedBox(height: 26),

                        _buildPeriodCard(),

                        const SizedBox(height: 18),

                        _buildDurationCard(),

                        const SizedBox(height: 18),

                        _buildInfoCard(),

                        const SizedBox(height: 28),

                        _buildSaveButton(),
                      ],
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

  // ==========================================================
  // BACKGROUND
  // ==========================================================

  Widget _buildBackground() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -80,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.45),
              ),
            ),
          ),

          Positioned(
            top: 320,
            left: -130,
            child: Container(
              width: 220,
              height: 220,
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

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar() {
    return SizedBox(
      height: 60,
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
              'Edit period',
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
          'Update your record.',
          style:
          AppTextTheme.headlineMedium.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Make a correction to your most recent '
              'period record. Your predictions will '
              'be updated automatically.',
          style:
          AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PERIOD DATE
  // ==========================================================

  Widget _buildPeriodCard() {
    return _EditCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            icon: Icons.calendar_month_outlined,
            title: 'Period started',
            subtitle:
            'When did your period begin?',
          ),

          const SizedBox(height: 18),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _pickStartDate,
              borderRadius:
              BorderRadius.circular(16),
              child: Ink(
                width: double.infinity,
                padding:
                const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7F8),
                  borderRadius:
                  BorderRadius.circular(16),
                  border: Border.all(
                    color:
                    const Color(0xFFF0D9DC),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration:
                      const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.event_outlined,
                        size: 21,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start date',
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            _startDate == null
                                ? 'Select date'
                                : _formatDate(
                              _startDate!,
                            ),
                            style: AppTextTheme
                                .labelLarge
                                .copyWith(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w600,
                              color: AppColors
                                  .textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 34,
                      height: 34,
                      decoration:
                      const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color:
                        AppColors.primary,
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

  // ==========================================================
  // PERIOD DURATION
  // ==========================================================

  Widget _buildDurationCard() {
    return _EditCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            icon: Icons.water_drop_outlined,
            title: 'Period duration',
            subtitle:
            'How many days did this period last?',
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Bleeding duration',
                  style:
                  AppTextTheme.labelLarge
                      .copyWith(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ),

              _NumberSelector(
                value: _periodLength,
                min: 1,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    _periodLength = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Most periods last between 2 and 7 days.',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFO
  // ==========================================================

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3F1),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.65),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
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
              Icons.auto_awesome_outlined,
              size: 17,
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
                  'Your predictions will adjust',
                  style: AppTextTheme
                      .labelLarge
                      .copyWith(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Changing this record may change '
                      'your cycle day and upcoming '
                      'period predictions.',
                  style: AppTextTheme
                      .labelSmall
                      .copyWith(
                    fontSize: 9,
                    height: 1.45,
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
  // SAVE BUTTON
  // ==========================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: AppMainButton(
        text: 'Save Period',
        onPressed: _savePeriod,
        height: 52,
        borderRadius: 8,
      ),
    );
  }

  // ==========================================================
  // DATE PICKER
  // ==========================================================

  Future<void> _pickStartDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(
        now.year - 2,
        now.month,
        now.day,
      ),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  void _savePeriod() {
    if (_startDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select your period start date.',
          ),
        ),
      );

      return;
    }

    context.pop({
      'startDate': _startDate,
      'periodLength': _periodLength,
    });
  }

  // ==========================================================
  // FORMAT DATE
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

// ============================================================
// EDIT CARD
// ============================================================

class _EditCard extends StatelessWidget {
  const _EditCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.84,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============================================================
// SECTION HEADING
// ============================================================

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration:
          const BoxDecoration(
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
                title,
                style:
                AppTextTheme.labelLarge.copyWith(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  height: 1.3,
                  color:
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// NUMBER SELECTOR
// ============================================================

class _NumberSelector
    extends StatelessWidget {
  const _NumberSelector({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F1F1),
        borderRadius:
        BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          _SelectorButton(
            icon: Icons.remove_rounded,
            enabled: value > min,
            onTap: value > min
                ? () => onChanged(value - 1)
                : null,
          ),

          SizedBox(
            width: 42,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style:
              AppTextTheme.labelLarge.copyWith(
                fontSize: 14,
                fontWeight:
                FontWeight.w700,
                color:
                AppColors.textPrimary,
              ),
            ),
          ),

          _SelectorButton(
            icon: Icons.add_rounded,
            enabled: value < max,
            onTap: value < max
                ? () => onChanged(value + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SELECTOR BUTTON
// ============================================================

class _SelectorButton
    extends StatelessWidget {
  const _SelectorButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(
        icon,
        size: 16,
      ),
      color: enabled
          ? AppColors.primary
          : AppColors.textDisabled,
      visualDensity:
      VisualDensity.compact,
    );
  }
}