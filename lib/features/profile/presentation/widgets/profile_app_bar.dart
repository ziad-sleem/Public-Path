import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      title: AppText(
        text: 'Profile',
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
      actions: [
        TextButton(
          onPressed: () {
            _showLogoutDialog(context, colorScheme);
          },
          child: AppText(text: "Logout"),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Logout'),
        content: const AppText(text: 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText(text: 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            child: AppText(text: 'Logout', color: colorScheme.error),
          ),
        ],
      ),
    );
  }
}
