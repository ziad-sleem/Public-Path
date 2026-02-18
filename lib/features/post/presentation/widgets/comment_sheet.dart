import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';

class CommentSheet extends StatefulWidget {
  final Post post;

  const CommentSheet({super.key, required this.post});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser;

    if (currentUser != null && _commentController.text.isNotEmpty) {
      final newComment = Comment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: _commentController.text,
        postId: widget.post.id,
        userId: currentUser.uid,
        userName: currentUser.username,
        timestamp: DateTime.now(),
      );

      context.read<PostCubit>().addComment(widget.post.id, newComment);
      _commentController.clear();
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      final seconds = difference.inSeconds;
      return seconds <= 1 ? '1 second ago' : '$seconds seconds ago';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1 ? '1 day ago' : '$days days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  void _showCommentOptions(String postId, Comment comment, bool isOwner) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Copy option
              ListTile(
                leading: Icon(
                  Icons.copy,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: const MyText(text: "Copy text"),
                onTap: () {
                  // Implement copy logic if needed, or just close
                  Navigator.pop(context);
                },
              ),

              // Delete option (only for owner)
              if (isOwner)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppColors.myRed,
                  ),
                  title: const MyText(text: "Delete", color: AppColors.myRed),
                  onTap: () {
                    Navigator.pop(context); // Close sheet
                    _showDeleteConfirmation(postId, comment);
                  },
                ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(String postId, Comment comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const MyText(text: "Delete Comment"),
          content: const MyText(
            text: "Are you sure you want to delete this comment?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const MyText(text: 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PostCubit>().deleteComment(postId, comment);
                Navigator.pop(context);
              },
              child: const MyText(text: 'Delete', color: AppColors.myRed),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: MyText(
              text: 'Comments',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Divider(color: Theme.of(context).colorScheme.tertiary, height: 1),

          // Comments list
          Expanded(
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoaded) {
                  // Find the updated post in the list
                  final updatedPost = state.posts.firstWhere(
                    (p) => p.id == widget.post.id,
                    orElse: () => widget.post,
                  );

                  if (updatedPost.comments.isEmpty) {
                    return Center(
                      child: MyText(
                        text: 'Be the first to add comment!',
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: updatedPost.comments.length,
                    itemBuilder: (context, index) {
                      final comment = updatedPost.comments[index];
                      final isOwner =
                          context.read<AuthCubit>().currentUser?.uid ==
                          comment.userId;

                      return GestureDetector(
                        onLongPress: () => _showCommentOptions(
                          updatedPost.id,
                          comment,
                          isOwner,
                        ),
                        child: Container(
                          color: Colors
                              .transparent, // Ensures the entire area is tappable
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // comment avatrar
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePage(uid: comment.userId),
                                    ),
                                  );
                                },
                                child: _CommentUserAvatar(
                                  userId: comment.userId,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // connent user name
                                    MyText(
                                      text: comment.userName,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    // comment
                                    MyText(text: comment.text, fontSize: 14),
                                    const SizedBox(height: 4),
                                    MyText(
                                      text: _formatTimeAgo(comment.timestamp),
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostError) {
                  return MyText(text: state.errorMessage);
                }

                return const Center(child: MyText(text: 'No comments yet...'));
              },
            ),
          ),

          Divider(color: Theme.of(context).colorScheme.tertiary, height: 1),

          // Text field at bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'InstagramSans',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontFamily: 'InstagramSans',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _addComment,
                  child: const MyText(
                    text: 'Post',
                    color: AppColors.igBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display comment user's profile image
class _CommentUserAvatar extends StatefulWidget {
  final String userId;

  const _CommentUserAvatar({required this.userId});

  @override
  State<_CommentUserAvatar> createState() => _CommentUserAvatarState();
}

class _CommentUserAvatarState extends State<_CommentUserAvatar> {
  String? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final profileCubit = context.read<ProfileCubit>();
      final user = await profileCubit.getUserProfile(widget.userId);
      if (mounted && user != null) {
        setState(() {
          _profileImage = user.profileImage;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_profileImage != null && _profileImage!.isNotEmpty) {
      // Check if it's a URL or base64
      if (_profileImage!.startsWith('http')) {
        return CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          backgroundImage: NetworkImage(_profileImage!),
          onBackgroundImageError: (_, __) {},
          child: null,
        );
      } else {
        // Base64 image
        try {
          return CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            backgroundImage: MemoryImage(base64Decode(_profileImage!)),
          );
        } catch (e) {
          // Fall through to default icon
        }
      }
    }

    // Default icon
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.onSecondary,
        size: 20,
      ),
    );
  }
}
