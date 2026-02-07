import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/widgets/user_tile.dart';

class FollowingPage extends StatelessWidget {
  final String uid;
  const FollowingPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(text: "Following"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<String>>(
        future: context.read<ProfileCubit>().getFollowing(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final following = snapshot.data!;
            return ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                return UserTile(uid: following[index]);
              },
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: MyText(
                text: "Not following anyone yet",
                color: Colors.grey,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: MyText(text: "Error: ${snapshot.error}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
