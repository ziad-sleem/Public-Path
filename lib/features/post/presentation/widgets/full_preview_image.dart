import 'dart:io';

import 'package:flutter/material.dart';

class FullPreviewImage extends StatelessWidget {
  final Function()? onTap;
  final File imagePickedFile;

  const FullPreviewImage({super.key, this.onTap, required this.imagePickedFile});

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
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
