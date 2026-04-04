import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';
import 'package:social_media_app_using_firebase/core/widgets/liquid_glass.dart';
import 'package:social_media_app_using_firebase/features/main_page/presentation/cubit/main_cubit.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.myTransparent,
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GlassContainer(
        padding: EdgeInsets.zero,
        borderRadius: 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                0,
                Icons.home_outlined,
                Icons.home,
                "Home",
                colorScheme,
              ),
              _buildNavItem(
                context,
                1,
                Icons.slow_motion_video_rounded,
                Icons.slow_motion_video_rounded,
                "Vistas",
                colorScheme,
              ),
              _buildNavItem(
                context,
                2,
                Icons.search,
                Icons.search,
                "Search",
                colorScheme,
              ),
              _buildNavItem(
                context,
                3,
                Icons.person_outline,
                Icons.person,
                "Profile",
                colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
    ColorScheme colorScheme,
  ) {
    final bool isSelected = selectedIndex == index;
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => context.read<MainCubit>().changeTab(index),
      behavior: HitTestBehavior.deferToChild,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? primaryColor : colorScheme.onSurfaceVariant,
              size: 26,
            ),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
