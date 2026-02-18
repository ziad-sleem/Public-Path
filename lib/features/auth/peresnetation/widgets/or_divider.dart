import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: colorScheme.inversePrimary)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MyText(text: "OR", color: colorScheme.inversePrimary),
          ),
          Expanded(child: Divider(color: colorScheme.inversePrimary)),
        ],
      ),
    );
  }
}
