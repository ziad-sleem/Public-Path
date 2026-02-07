import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_actions.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_caption.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_comment_count.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_image.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_time_stamp.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_user_info.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/widgets/comment_sheet.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  // fetch all posts
  void fetchAllPosts() {
    context.read<PostCubit>().fetchAllPosts();
  }

  // delete your post
  Future<void> deletePost(String postId) async {
    await context.read<PostCubit>().deletePost(postId: postId);
    fetchAllPosts();
  }

  // like
  Future<void> toggleLikePost(String postId) async {
    // current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // optimistically like and update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    // update like
    await context
        .read<PostCubit>()
        .toggleLikePost(postId: postId, userId: currentUser!.uid)
        .catchError((error) {
          // if there's an error, revert back to original values
          setState(() {
            if (isLiked) {
              widget.post.likes.add(currentUser!.uid);
            } else {
              widget.post.likes.remove(currentUser!.uid);
            }
          });
        });
  }

  // comment process
  void showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: postCubit,
        child: CommentSheet(post: widget.post),
      ),
    );
  }

  final TextEditingController commentController = TextEditingController();

  // delete post options
  void showDeleteActions(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: MyText(text: "Delete Post"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: MyText(text: 'Cancle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deletePost(postId);
              },
              child: MyText(text: 'Delete'),
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
    if (currentUser != null) {
      isOwnPost = (widget.post.userId == currentUser!.uid);
    }
  }

  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null && mounted) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // container above the image
          PostUserInfo(
            post: widget.post,
            postUser: postUser,
            showDeleteActions: () => showDeleteActions(widget.post.id),
          ),

          // post image
          PostImage(post: widget.post),

          // Like , comment , shares
          PostActions(
            post: widget.post,
            onLikeTap: () => toggleLikePost(widget.post.id),
            onCommentTap: showCommentSheet,
            userId: currentUser?.uid ?? '',
          ),

          // Caption: Username + Text
          PostCaption(post: widget.post),

          // Comment count
          if (widget.post.comments.isNotEmpty)
            PostCommentCount(post: widget.post, showCommentSheet: showCommentSheet),

          // Timestamp
          PostTimeStamp(post: widget.post)
        
        ],
      ),
    );
  }

 

}
