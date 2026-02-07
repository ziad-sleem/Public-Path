import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_button.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';

import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/widgets/caption_text_field.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/widgets/full_preview_image.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/widgets/image_beside_caption.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/widgets/location_tag_list_tile.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

// mobile image picker

class _UploadPostPageState extends State<UploadPostPage> {
  File? imagePickedFile;
  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController textController = TextEditingController();

  // current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();

    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Compress for Firestore size
      maxWidth: 1080, // Standard HD width
    );

    if (pickedImage != null && mounted) {
      setState(() {
        imagePickedFile = File(pickedImage.path);
      });
    }
  }

  // create post
  void uploadPost() {
    // check
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: MyText(text: "Both image and caption are required"),
        ),
      );
      return;
    }

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: MyText(text: "User not logged in. Please try again."),
        ),
      );
      return;
    }

    // create a new post object
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.username,
      text: textController.text,
      imageUrl: '',
      timeStamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // post cubit
    final postCubit = context.read<PostCubit>();

    postCubit.createPost(newPost, image: imagePickedFile!);
  }

  @override
  void dispose() {
    super.dispose();
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostLoaded) {
          Navigator.pop(context);
        } else if (state is PostError) {
          print("📍📍📍📍📍📍📍📍📍📍📍${state.errorMessage}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MyText(text: state.errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PostLoading || state is PostUpLoading;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: colorScheme.inversePrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: MyText(
              text: "New Post",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.inversePrimary,
            ),
            actions: [
              if (imagePickedFile != null && !isLoading)
                TextButton(
                  onPressed: uploadPost,
                  child: const MyText(
                    text: "Share",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0095F6),
                  ),
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (imagePickedFile == null)
                        _buildImagePlaceholder(context)
                      else
                        _buildPostEditor(context),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.2),
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 100,
            color: colorScheme.inversePrimary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: size.width * 0.5,

            child: MyButton(text: "Select from Gallery", onTap: pickImage),
          ),
        ],
      ),
    );
  }

  Widget _buildPostEditor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail
              ImageBesideCaption(imagePickedFile: imagePickedFile!),

              const SizedBox(width: 16),
              // Caption field
              Expanded(child: CaptionTextField(textController: textController)),
            ],
          ),
          const Divider(),
          const LocationTagListTile(),
          const Divider(),
          const SizedBox(height: 20),
          // Full preview image
          FullPreviewImage(onTap: pickImage, imagePickedFile: imagePickedFile!),
        ],
      ),
    );
  }
}
