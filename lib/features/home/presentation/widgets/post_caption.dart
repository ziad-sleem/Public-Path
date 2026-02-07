import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

class PostCaption extends StatelessWidget {
  final Post post;
  const PostCaption({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontFamily: 'InstagramSans',
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: '${post.userName} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: post.text),
          ],
        ),
      ),
    );
  }
}
