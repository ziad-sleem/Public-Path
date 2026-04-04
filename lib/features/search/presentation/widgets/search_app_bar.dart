import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppText(text: 'Search', fontWeight: FontWeight.bold, fontSize: 30),
    );
  }
}
