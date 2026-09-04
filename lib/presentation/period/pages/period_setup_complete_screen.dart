import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodSetupCompleteScreen extends StatelessWidget {
  const PeriodSetupCompleteScreen({
    super.key,
    this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.onGetStarted,
  });

  final DateTime? lastPeriodDate;
  final int cycleLength;
  final int periodLength;
  final VoidCallback? onGetStarted;

  // ---------------------------------------------------------------------------
  // DATE
  // ---------------------------------------------------------------------------

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not set';
    }

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

  String _formatShortDate(DateTime? date) {
    if (date == null) {
      return '--';
    }

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return months[date.month - 1];
  }

  // ---------------------------------------------------------------------------
  // ACTION
  // ---------------------------------------------------------------------------

  void _handleGetStarted(BuildContext context) {
    HapticFeedback.mediumImpact();

    onGetStarted?.call();

    if (onGetStarted == null) {
      context.go(AppRoutes.period);
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(lastPeriodDate);
    final shortMonth = _formatShortDate(lastPeriodDate);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxHeight < 620;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      20,
                      isSmall ? 8 : 18,
                      20,
                      24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 460,
                        ),
                        child: Column(
                          children: [
                            _buildSuccessOrb(
                              compact: isSmall,
                            ),

                            SizedBox(
                              height: isSmall ? 18 : 26,
                            ),

                            _buildIntro(),

                            SizedBox(
                              height: isSmall ? 22 : 30,
                            ),

                            _buildRhythmSummary(
                              dateText: dateText,
                              shortMonth: shortMonth,
                            ),

                            SizedBox(
                              height: isSmall ? 18 : 24,
                            ),

                            _buildPrivacyNote(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: AppMainButton(
                text: 'Start Tracking',
                onPressed: () => {},
                height: 48,
                borderRadius: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          children: [
            Text(
              'Cycle Setup',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E7E6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    'COMPLETE',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: AppColors.primary,
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
  // SUCCESS ORB
  // ---------------------------------------------------------------------------

  Widget _buildSuccessOrb({
    required bool compact,
  }) {
    final size = compact ? 92.0 : 112.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x12E8B4B8),
            ),
          ),

          // Middle ring
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x22E8B4B8),
              border: Border.all(
                color: const Color(0x55E8B4B8),
                width: 1,
              ),
            ),
          ),

          // Main circle
          Container(
            width: size * 0.55,
            height: size * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9B7073),
                  Color(0xFF7C5357),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INTRO
  // ---------------------------------------------------------------------------

  Widget _buildIntro() {
    return Column(
      children: [
        Text(
          'Your rhythm is\nmapped.',
          textAlign: TextAlign.center,
          style: AppTextTheme.displayLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'A few details are all we needed.\n'
              'Your cycle insights are now ready.',
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // RHYTHM SUMMARY
  // ---------------------------------------------------------------------------

  Widget _buildRhythmSummary({
    required String dateText,
    required String shortMonth,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEEDDDD),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.045,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDateRow(
            dateText: dateText,
            shortMonth: shortMonth,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Divider(
              height: 1,
              color: const Color(0xFFF0E5E2),
            ),
          ),

          _buildMetricsRow(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE ROW
  // ---------------------------------------------------------------------------

  Widget _buildDateRow({
    required String dateText,
    required String shortMonth,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        18,
      ),
      child: Row(
        children: [
          // Date block
          Container(
            width: 50,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF8EFEC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lastPeriodDate == null
                      ? '--'
                      : '${lastPeriodDate!.day}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  shortMonth,
                  style: GoogleFonts.inter(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LAST PERIOD',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  dateText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Your starting point',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: Color(0xFF9B7073),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // METRICS
  // ---------------------------------------------------------------------------

  Widget _buildMetricsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        18,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetric(
              icon: Icons.sync_rounded,
              eyebrow: 'CYCLE',
              value: '$cycleLength',
              unit: 'days',
            ),
          ),

          Container(
            width: 1,
            height: 50,
            color: const Color(0xFFF0E5E2),
          ),

          Expanded(
            child: _buildMetric(
              icon: Icons.water_drop_outlined,
              eyebrow: 'PERIOD',
              value: '$periodLength',
              unit: 'days',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String eyebrow,
    required String value,
    required String unit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFF8EFEC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: GoogleFonts.inter(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.9,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(width: 3),

                    Text(
                      unit,
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIVACY NOTE
  // ---------------------------------------------------------------------------

  Widget _buildPrivacyNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: AppColors.textSecondary,
        ),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            'Your cycle information stays private.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}