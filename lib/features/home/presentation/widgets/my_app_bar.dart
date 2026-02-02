import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/pages/upload_post_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Home'),
      actions: [
        // upload new post button
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => PostCubit(),
                  child: UploadPostPage(),
                ),
              ),
            );
          },
          icon: Icon(Icons.add, size: 30),
        ),
      ],
    );
  }
}
