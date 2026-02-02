import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text_field.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';

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
    );

    if (pickedImage != null) {
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
        SnackBar(content: Text("Both image and caption are required")),
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
    final size = MediaQuery.of(context).size;
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostLoaded) {
          Navigator.pop(context);
        } else if (state is PostError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is PostLoading || state is PostUpLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Create Post"),
              actions: [
                IconButton(
                  onPressed: uploadPost,
                  icon: const Icon(Icons.upload),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pick Image'),
                      SizedBox(height: size.height * 0.01),

                      // image preview
                      if (imagePickedFile != null) Image.file(imagePickedFile!),
                      SizedBox(height: size.height * 0.01),

                      // pick image button
                      if (imagePickedFile == null)
                        Center(
                          child: MaterialButton(
                            onPressed: pickImage,
                            child: const Text("Pick Image"),
                          ),
                        ),
                      SizedBox(height: size.height * 0.05),
                      const Divider(),
                      SizedBox(height: size.height * 0.05),

                      Text("Caption"),
                      SizedBox(height: size.height * 0.01),

                      // caption text field
                      MyTextFormField(
                        controller: textController,
                        hintText: "                        Caption",
                        emailOrPasswordOrUserOrBioOrName: 'bio',
                      ),
                      SizedBox(height: size.height * 0.05),
                      const Divider(),
                      SizedBox(height: size.height * 0.05),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            uploadPost();
                          },
                          child: Text("Upload Post"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
