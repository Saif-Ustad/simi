import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_colors.dart';

class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({
    super.key,
    required this.image,
    required this.fallbackIcon,
  });

  final ImageProvider? image;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceBright,
        border: Border.all(
          color: AppColors.primaryContainer,
          width: 1.5,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.35),
        backgroundImage: image,
        child: image == null
            ? Icon(
          fallbackIcon,
          size: 21,
          color: AppColors.primary,
        )
            : null,
      ),
    );
  }
}