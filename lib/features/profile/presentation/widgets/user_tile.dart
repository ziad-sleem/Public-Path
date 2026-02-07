import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final String uid;
  const UserTile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: context.read<ProfileCubit>().getUserProfile(uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return ListTile(
            title: MyText(text: user.username, fontWeight: FontWeight.bold),
            subtitle: MyText(
              text: user.email,
              color: Theme.of(context).colorScheme.primary,
            ),
            leading: _buildProfileImage(context, user),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: user.uid),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: Text("Loading..."));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildProfileImage(BuildContext context, AppUser user) {
    if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      if (user.profileImage!.startsWith('http')) {
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.profileImage!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator.adaptive(),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        );
      } else {
        return CircleAvatar(
          backgroundImage: MemoryImage(base64Decode(user.profileImage!)),
        );
      }
    }
    return CircleAvatar(
      child: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
