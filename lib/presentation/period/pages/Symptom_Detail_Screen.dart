import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class SymptomDetailScreen
    extends StatelessWidget {
  const SymptomDetailScreen({
    super.key,
    this.date,
    this.time,
    this.intensity = 'Moderate',
    this.notes =
    'Woke up feeling a little drained today. '
        'Took some time to rest and feel better.',
  });

  final DateTime? date;
  final String? time;
  final String intensity;
  final String notes;

  @override
  Widget build(BuildContext context) {
    final recordedDate =
        date ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context),

            Expanded(
              child: SingleChildScrollView(
                physics:
                const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  40,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildDateCard(
                      recordedDate,
                    ),

                    const SizedBox(height: 18),

                    _buildSymptoms(),

                    const SizedBox(height: 18),

                    _buildNotes(),

                    const SizedBox(height: 28),

                    _buildEditButton(context),

                    const SizedBox(height: 10),

                    _buildDeleteButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar(
      BuildContext context) {
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
          ),

          Expanded(
            child: Text(
              'Entry details',
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
  // DATE
  // ==========================================================

  Widget _buildDateCard(
      DateTime date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.85,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
            const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'RECORDED ON',
                  style: AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 8,
                    letterSpacing: 1,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _formatDate(date),
                  style:
                  AppTextTheme.headlineSmall
                      .copyWith(
                    fontFamily:
                    'Playfair Display',
                    fontSize: 19,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  time ?? '2:30 PM',
                  style:
                  AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 9,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          _IntensityBadge(
            text: intensity,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SYMPTOMS
  // ==========================================================

  Widget _buildSymptoms() {
    return _DetailSection(
      title: 'SYMPTOMS LOGGED',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          _DetailSymptom(
            icon: Icons.psychology_outlined,
            title: 'Headache',
          ),
          _DetailSymptom(
            icon:
            Icons.battery_2_bar_outlined,
            title: 'Fatigue',
          ),
          _DetailSymptom(
            icon: Icons.sick_outlined,
            title: 'Nausea',
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // NOTES
  // ==========================================================

  Widget _buildNotes() {
    return _DetailSection(
      title: 'PERSONAL NOTES',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.025,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          notes,
          style:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 11,
            height: 1.55,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  Widget _buildEditButton(
      BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppMainButton(
        text: 'Edit Entry',
        onPressed: () {
          context.push(
            '/period/symptoms/add',
          );
        },
        height: 50,
        borderRadius: 999,
      ),
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Widget _buildDeleteButton(
      BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () =>
            _confirmDelete(context),
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: 16,
        ),
        label: const Text(
          'Delete Entry',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor:
          const Color(0xFFB05C5C),
          side: const BorderSide(
            color: Color(0xFFE9CFCF),
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          AppColors.surface,
          title: Text(
            'Delete this entry?',
            style: AppTextTheme
                .headlineSmall
                .copyWith(
              fontFamily:
              'Playfair Display',
              fontWeight:
              FontWeight.w600,
            ),
          ),
          content: Text(
            'This symptom entry will be '
                'permanently removed.',
            style:
            AppTextTheme.bodyMedium.copyWith(
              color:
              AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child:
              const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color:
                  Color(0xFFB05C5C),
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}


class _DetailSection
    extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.only(
            left: 2,
            bottom: 9,
          ),
          child: Text(
            title,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              letterSpacing: 1.1,
              fontWeight:
              FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),

        child,
      ],
    );
  }
}


class _DetailSymptom
    extends StatelessWidget {
  const _DetailSymptom({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),

          const SizedBox(height: 7),

          Text(
            title,
            textAlign: TextAlign.center,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight:
              FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntensityBadge
    extends StatelessWidget {
  const _IntensityBadge({
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
        color: const Color(0xFFFFF0F2),
        borderRadius:
        BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 10,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              fontWeight:
              FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}