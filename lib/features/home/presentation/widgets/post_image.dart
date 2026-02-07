import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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
        ? CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => Container(
              height: 300,
              color: Colors.grey[900],
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
            errorWidget: (context, url, error) => _buildErrorContainer(),
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
