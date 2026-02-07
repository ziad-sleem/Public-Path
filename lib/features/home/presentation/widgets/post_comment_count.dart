import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

class PostCommentCount extends StatelessWidget {
  final Post post;
  final Function()? showCommentSheet;
  const PostCommentCount({super.key, required this.post,required this.showCommentSheet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
      child: GestureDetector(
        onTap: showCommentSheet,
        child: MyText(
          text: 'View all ${post.comments.length} comments',
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
