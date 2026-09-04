import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class PeriodSetupScreen extends StatelessWidget {
  const PeriodSetupScreen({
    super.key,
    this.onSetUpCycle,
    this.onMaybeLater,
  });

  final VoidCallback? onSetUpCycle;
  final VoidCallback? onMaybeLater;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                const _BackgroundDecoration(),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: _IntroCard(
                        onSetUpCycle: onSetUpCycle,
                        onMaybeLater: onMaybeLater,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: -80,
              top: -80,
              child: _SoftCircle(
                size: 384,
                color: AppColors.primaryContainer,
                opacity: 0.20,
              ),
            ),
            Positioned(
              right: -80,
              top: 389,
              child: _SoftCircle(
                size: 320,
                color: AppColors.secondary,
                opacity: 0.20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.onSetUpCycle,
    required this.onMaybeLater,
  });

  final VoidCallback? onSetUpCycle;
  final VoidCallback? onMaybeLater;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.60),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _HeroImage(),
          const SizedBox(height: 28),
          Text(
            'Understand your\nnatural rhythm',
            textAlign: TextAlign.center,
            style: AppTextTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              'Track your periods, symptoms,\nand cycle patterns to stay in\ntune with your body.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyLargeSecondary,
            ),
          ),
          const SizedBox(height: 40),
          _SetUpCycleButton(onPressed: onSetUpCycle),
          const SizedBox(height: 16),
          _MaybeLaterButton(onPressed: onMaybeLater),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 292 / 256,
        child: Image.asset(
          'assets/images/period_tracking_intro.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const _HeroImageFallback();
          },
        ),
      ),
    );
  }
}

class _HeroImageFallback extends StatelessWidget {
  const _HeroImageFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8E9E7),
            Color(0xFFE8B4B8),
            Color(0xFFD7C0BA),
            Color(0xFFF6EEE8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -24,
            top: 24,
            child: _Blob(
              width: 130,
              height: 82,
              color: Color(0xFFE7B5B7),
            ),
          ),
          Positioned(
            left: 82,
            top: 18,
            child: _Blob(
              width: 68,
              height: 68,
              color: Color(0xFFD9B8BC),
            ),
          ),
          Positioned(
            right: -12,
            top: 76,
            child: _Blob(
              width: 116,
              height: 74,
              color: Color(0xFFEFD1C0),
            ),
          ),
          Positioned(
            left: 34,
            bottom: 20,
            child: _Blob(
              width: 150,
              height: 70,
              color: Color(0xFFD8C2BA),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 18,
            child: _Blob(
              width: 88,
              height: 88,
              color: Color(0xFFBBA3A5),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );
  }
}

class _SetUpCycleButton extends StatelessWidget {
  const _SetUpCycleButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF7C5357),
              Color(0xFF8E6569),
            ],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child:
        AppMainButton(
          text: 'Set Up Cycle',
          onPressed: () => context.push(AppRoutes.periodCycleStartDate),
          height: 48,
          borderRadius: 6,
        ),
      ),
    );
  }
}

class _MaybeLaterButton extends StatelessWidget {
  const _MaybeLaterButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          'Maybe Later',
          style: AppTextTheme.labelLarge,
        ),
      ),
    );
  }
}