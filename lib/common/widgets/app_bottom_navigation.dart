import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/config/routes/router.dart';
import '../../core/config/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
  });

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRoutes.memories)) {
      return 1;
    }

    if (location.startsWith(AppRoutes.period)) {
      return 2;
    }

    if (location.startsWith(AppRoutes.chat)) {
      return 3;
    }

    if (location.startsWith(AppRoutes.more)) {
      return 4;
    }

    return 0;
  }

  void _onItemTapped(
      BuildContext context,
      int index,
      ) {
    final routes = [
      AppRoutes.home,
      AppRoutes.memories,
      AppRoutes.period,
      AppRoutes.chat,
      AppRoutes.more,
    ];

    final currentIndex = _getSelectedIndex(context);

    if (currentIndex == index) {
      return;
    }

    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          height: 78,
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.92),
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(
                  alpha: 0.45,
                ),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                selected: selectedIndex == 0,
                onTap: () => _onItemTapped(context, 0),
              ),

              _NavItem(
                icon: Icons.favorite_border_rounded,
                activeIcon: Icons.favorite_rounded,
                label: 'Memories',
                selected: selectedIndex == 1,
                onTap: () => _onItemTapped(context, 1),
              ),

              _NavItem(
                icon: Icons.water_drop_outlined,
                activeIcon: Icons.water_drop_rounded,
                label: 'Period',
                selected: selectedIndex == 2,
                onTap: () => _onItemTapped(context, 2),
              ),

              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Chat',
                selected: selectedIndex == 3,
                onTap: () => _onItemTapped(context, 3),
              ),

              _NavItem(
                icon: Icons.more_horiz_rounded,
                activeIcon: Icons.more_horiz_rounded,
                label: 'More',
                selected: selectedIndex == 4,
                onTap: () => _onItemTapped(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 30,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                selected ? activeIcon : icon,
                size: 19,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}