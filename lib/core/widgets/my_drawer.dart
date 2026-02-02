import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              Icon(
                Icons.person,
                size: size.height * 0.1,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: size.height * 0.05),

              // home tile
              myDrawerTile("HOME", Icons.home_outlined, () {
                Navigator.pop(context);
              }),

              // profile tile
              myDrawerTile("PROFILE", Icons.person_2_outlined, () {
                // pop menu drawer
                Navigator.pop(context);

                // get current user id
                final user = context.read<AuthCubit>().currentUser;
                String? uid = user!.uid;

                // navigate
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)),
                );
              }),

              // search tile
              myDrawerTile("SEARCH", Icons.search_outlined, () {
                Navigator.pop(context);
              }),

              // setting tile
              myDrawerTile("SEARCH", Icons.settings_outlined, () {
                Navigator.pop(context);
              }),

              const Spacer(),

              // logout tile
              myDrawerTile('LOGOUT', Icons.logout_outlined, () {
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget myDrawerTile(
    String title,
    final IconData icon,
    final void Function()? onTap,
  ) {
    return ListTile(title: Text(title), leading: Icon(icon), onTap: onTap);
  }
}
