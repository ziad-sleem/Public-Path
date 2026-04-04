import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';

class PostCommentCount extends StatelessWidget {
  final Post post;
  final Function()? showCommentSheet;
  const PostCommentCount({
    super.key,
    required this.post,
    required this.showCommentSheet,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
      child: GestureDetector(
        onTap: showCommentSheet,
        child: AppText(
          text: 'View all ${post.comments.length} comments',
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),
    );
  }
}
