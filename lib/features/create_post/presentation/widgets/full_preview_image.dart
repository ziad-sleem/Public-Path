import 'dart:io';

import 'package:flutter/material.dart';

class FullPreviewImage extends StatelessWidget {
  final Function()? onTap;
  final File imagePickedFile;

  const FullPreviewImage({super.key, this.onTap, required this.imagePickedFile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap, // Allow changing the image
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(
              imagePickedFile,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: colorScheme.surface.withOpacity(0.7),
                child: IconButton(
                  icon: Icon(Icons.edit, color: colorScheme.onSurface, size: 20),
                  onPressed: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
