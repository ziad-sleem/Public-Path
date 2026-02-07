import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/show_post_detials.dart';

class ProfilePostWidget extends StatelessWidget {
  final Post post;
  const ProfilePostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: post.imageUrl.isNotEmpty
          ? GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowPostDetials(post: post),
                ),
              ),
              child: post.imageUrl.startsWith('http')
                  ? Image.network(
                      post.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Theme.of(context).colorScheme.tertiary,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error)),
                    )
                  : Image.memory(
                      base64Decode(post.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.error));
                      },
                    ),
            )
          : const Center(child: Icon(Icons.image)),
    );
  }
}
