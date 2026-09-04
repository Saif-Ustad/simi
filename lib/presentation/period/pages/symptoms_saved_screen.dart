import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class SymptomsSavedScreen
    extends StatefulWidget {
  const SymptomsSavedScreen({
    super.key,
  });

  @override
  State<SymptomsSavedScreen> createState() =>
      _SymptomsSavedScreenState();
}

class _SymptomsSavedScreenState
    extends State<SymptomsSavedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 900),
    )..forward();
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
        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24,
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final value =
                      Curves.easeOutBack
                          .transform(
                        _controller.value,
                      );

                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: _buildSuccessContent(),
                  ),
                ),
              ),

              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBloom(),

        const SizedBox(height: 30),

        Text(
          'A little moment\nremembered.',
          textAlign: TextAlign.center,
          style:
          AppTextTheme.headlineMedium.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 27,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Your body’s signals have been safely '
              'saved in your journal.',
          textAlign: TextAlign.center,
          style:
          AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        _buildSummary(),
      ],
    );
  }

  Widget _buildBloom() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 116,
          height: 116,
          decoration:
          const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFCE4EC),
          ),
        ),

        Container(
          width: 82,
          height: 82,
          decoration:
          const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE8B4B8),
          ),
        ),

        const Icon(
          Icons.favorite_rounded,
          size: 34,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'SELECTED TODAY',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              letterSpacing: 1,
              fontWeight:
              FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _SavedChip(
                icon: Icons.psychology_outlined,
                text: 'Headache',
              ),
              _SavedChip(
                icon:
                Icons.battery_2_bar_outlined,
                text: 'Fatigue',
              ),
              _SavedChip(
                icon: Icons.sick_outlined,
                text: 'Nausea',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppMainButton(
            text: 'Done',
            onPressed: () {
              context.go(
                AppRoutes.period,
              );
            },
            height: 50,
            borderRadius: 8,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              context.push(
                AppRoutes.addSymptoms,
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize:
              const Size.fromHeight(48),
              side: BorderSide(
                color: AppColors.primary
                    .withValues(alpha: 0.45),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Edit Symptoms',
              style:
              AppTextTheme.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SavedChip extends StatelessWidget {
  const _SavedChip({
    required this.icon,
    required this.text,
  });

  final IconData icon;
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
        color: const Color(0xFFF3E9EA),
        borderRadius:
        BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}