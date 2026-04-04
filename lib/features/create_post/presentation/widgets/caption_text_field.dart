import 'package:flutter/material.dart';

class CaptionTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const CaptionTextField({
    super.key,
    required this.textController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: textController,
      maxLines: 4,
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: hintText,
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
