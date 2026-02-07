import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CaptionTextField extends StatelessWidget {
  final TextEditingController textController;
  const CaptionTextField({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: textController,
      maxLines: 4,
      cursorColor: const Color(0xFF0095F6),
      decoration: InputDecoration(
        hintText: "Write a caption...",
        hintStyle: TextStyle(
          color: colorScheme.inversePrimary.withOpacity(0.5),
          fontFamily: 'InstagramSans',
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      style: TextStyle(
        color: colorScheme.inversePrimary,
        fontFamily: 'InstagramSans',
        fontSize: 16,
      ),
    );
  }
}
