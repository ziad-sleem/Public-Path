import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';

class PostImage extends StatelessWidget {
  final Post post;
  const PostImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                color: colorScheme.surface,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorContainer(colorScheme),
          )
        : Image.memory(
            base64Decode(post.imageUrl),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorContainer(colorScheme),
          );
  }

  Widget _buildErrorContainer(dynamic colorScheme) {
    return Container(
      color: colorScheme.surfaceVariant,
      height: 200,
      width: double.infinity,
      child: const Icon(Icons.error),
    );
  }
}
