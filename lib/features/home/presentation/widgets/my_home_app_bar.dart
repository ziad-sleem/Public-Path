import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/pages/upload_post_page.dart';

class MyHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyHomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: MyText(
        text: 'Public Path',
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
      actions: [
        // upload new post button
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            );
          },
          child: MyText(text: "Create Post"),
        ),
      ],
    );
  }
}
