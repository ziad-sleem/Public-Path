import 'dart:io';

import 'package:flutter/widgets.dart';

class ImageBesideCaption extends StatelessWidget {
  final File imagePickedFile;
  const ImageBesideCaption( {super.key, required this.imagePickedFile});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        imagePickedFile,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}
