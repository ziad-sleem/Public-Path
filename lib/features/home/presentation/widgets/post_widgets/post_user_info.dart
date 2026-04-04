import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/core/widgets/liquid_glass.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/other_user_profile_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';

class PostUserInfo extends StatelessWidget {
  final Post post;
  final ProfileUser? postUser;
  final Function()? showDeleteActions;
  const PostUserInfo({
    super.key,
    required this.post,
    required this.postUser,
    required this.showDeleteActions,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().currentUser;
    final bool isOwnPost =
        (currentUser != null && currentUser.uid == post.userId);
    return GlassContainer(
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (currentUser != null) {
            currentUser.uid == post.userId
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: currentUser.uid),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => getIt<ProfileCubit>()..fetchUserProfile(post.userId),
                          ),
                          BlocProvider(
                            create: (context) => getIt<HomeCubit>()
                              ..doEvent(FetchAllPostByUserIdEvent(userId: post.userId)),
                          ),
                        ],
                        child: OtherUserProfilePage(uid: post.userId),
                      ),
                    ),
                  );
          }
        },
        child: Row(
          children: [
            // user image
            postUser?.profileImage != null && postUser!.profileImage!.isNotEmpty
                ? Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: postUser!.profileImage!.startsWith('http')
                          ? Image.network(
                              postUser!.profileImage!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildErrorIcon(context),
                            )
                          : Image.memory(
                              base64Decode(postUser!.profileImage!),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildErrorIcon(context),
                            ),
                    ),
                  )
                : _buildErrorIcon(context),
            const SizedBox(width: 12),

            AppText(
              text: postUser?.username ?? 'Loading...',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            if (isOwnPost == true)
              IconButton(
                onPressed: showDeleteActions,
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.onSurface,
        size: 30,
      ),
    );
  }
}
