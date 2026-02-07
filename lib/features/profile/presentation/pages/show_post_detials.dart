import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/widgets/post_widget.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

class ShowPostDetials extends StatelessWidget {
  final Post post;
  const ShowPostDetials({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: PostWidget(post: post),
        ),
      ),
    );
  }
}
