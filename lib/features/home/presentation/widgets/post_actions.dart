import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

class PostActions extends StatefulWidget {
  final Post post;
  final Function()? onLikeTap;
  final Function()? onCommentTap;
  final String userId;
  const PostActions({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.userId,
  });

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              // Like icon and count
              GestureDetector(
                onTap: widget.onLikeTap,
                child: Row(
                  children: [
                    Icon(
                      widget.post.likes.contains(widget.userId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.post.likes.contains(widget.userId)
                          ? AppColors.myRed
                          : Theme.of(context).colorScheme.inversePrimary,
                      size: 28,
                    ),
                    const SizedBox(width: 6),
                    MyText(
                      text: widget.post.likes.length.toString(),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),

              // Comment icon and count
              GestureDetector(
                onTap: widget.onCommentTap,
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      size: 26,
                    ),
                    const SizedBox(width: 6),
                    MyText(
                      text: widget.post.comments.length.toString(),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),

              // Share icon (placeholder for now)
              Icon(
                Icons.send_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 26,
              ),
              const Spacer(),

              // Save icon (placeholder)
              Icon(
                Icons.bookmark_border,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 28,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
