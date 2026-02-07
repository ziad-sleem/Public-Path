import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

class PostImage extends StatelessWidget {
  final Post post;
  const PostImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return post.imageUrl.startsWith('http')
        ? Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 300,
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorContainer(),
          )
        : Image.memory(
            base64Decode(post.imageUrl),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorContainer(),
          );
  }

  Widget _buildErrorContainer() {
    return Container(
      color: Colors.grey[300],
      height: 200,
      width: double.infinity,
      child: const Icon(Icons.error),
    );
  }
}
