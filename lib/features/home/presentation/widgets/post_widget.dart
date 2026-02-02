import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void fetchAllPosts() {
    context.read<PostCubit>().fetchAllPosts();
  }

  void deletePost(String postId) {
    context.read<PostCubit>().deletePost(postId: postId);
    fetchAllPosts();
  }

  void showDeleteActions(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Post"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancle'),
            ),
            TextButton(
              onPressed: () {
                deletePost(postId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool? isOwnPost = false;

  AppUser? currentUser;
  AppUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                postUser?.profileImage != null &&
                        postUser!.profileImage!.isNotEmpty
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.memory(
                            base64Decode(postUser!.profileImage!),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                const SizedBox(width: 12),
                Text(
                  widget.post.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isOwnPost == true)
                  IconButton(
                    onPressed: () => showDeleteActions(widget.post.userId),
                    icon: Icon(Icons.delete_outline),
                  ),
              ],
            ),
          ),
          if (widget.post.imageUrl.isNotEmpty)
            Image.memory(
              base64Decode(widget.post.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
            ),
          SizedBox(height: 8.0),
          Text(widget.post.text),
        ],
      ),
    );
  }
}
