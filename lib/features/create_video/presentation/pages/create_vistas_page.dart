import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/core/widgets/custom_snack_bar.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/create_post/presentation/widgets/caption_text_field.dart';
import 'package:social_media_app_using_firebase/features/create_video/domain/entities/video_entity.dart';
import 'package:social_media_app_using_firebase/features/create_video/presentation/cubit/create_video_cubit.dart';
import 'package:social_media_app_using_firebase/config/cloudinary/video_picker_service.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';

class CreateVistasPage extends StatefulWidget {
  final VoidCallback? onVideoSuccess;
  const CreateVistasPage({super.key, this.onVideoSuccess});

  @override
  State<CreateVistasPage> createState() => _CreateVistasPageState();
}

class _CreateVistasPageState extends State<CreateVistasPage> {
  File? videoFile;
  File? coverFile;
  final VideoPickerService _videoPickerService = VideoPickerService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AppUser? currentUser;
  ProfileUser? userProfile;
  bool _isUploadingVideo = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    if (currentUser != null) {
      final profileCubit = context.read<ProfileCubit>();
      userProfile = await profileCubit.getUserProfile(currentUser!.uid);
    }
  }

  Future<void> pickVideo() async {
    final file = await _videoPickerService.pickVideoFromGallery();
    if (file != null) {
      setState(() {
        videoFile = file;
      });
    }
  }

  Future<void> pickCover() async {
    final XFile? image = await _imagePicker.pickImage(
      maxHeight: 720,
      maxWidth: 1280,
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        coverFile = File(image.path);
      });
    }
  }

  void releaseVistas() {
    if (videoFile == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AppText(text: "Video and caption are required"),
        ),
      );
      return;
    }

    if (userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: AppText(text: "User profile not found")),
      );
      return;
    }

    final newVideo = VideoEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userProfile!.uid,
      caption: captionController.text,
      description: descriptionController.text,
      userName: userProfile!.username,
      userImage: userProfile!.profileImageUrl ?? '',
      videoUrl: '',
      thumbnailUrl: '',
      videoCover: '',
      timeStamp: DateTime.now(),
      likes: [],
      disLikes: [],
      comments: [],
    );

    context.read<CreateVideoCubit>().createVideo(
      newVideo,
      videoFile: videoFile,
      coverFile: coverFile,
    );
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<CreateVideoCubit, CreateVideoState>(
      listener: (context, state) {
        if (state is CreateVideoUpLoading) {
          setState(() => _isUploadingVideo = true);
        } else if (state is CreateVideoLoaded) {
          if (_isUploadingVideo) {
            setState(() => _isUploadingVideo = false);
            Navigator.pop(context);
            widget.onVideoSuccess?.call();
          }
        } else if (state is CreateVideoError) {
          setState(() => _isUploadingVideo = false);
          CustomSnackBar.error(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading =
            state is CreateVideoLoading || state is CreateVideoUpLoading;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: colorScheme.inversePrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: AppText(
              text: "New Vista",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.inversePrimary,
            ),
            actions: [
              if (videoFile != null && !isLoading)
                TextButton(
                  onPressed: releaseVistas,
                  child: AppText(
                    text: "Post",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditor(context, colorScheme),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildCoverPicker(context),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEditor(BuildContext context, ColorScheme colorScheme) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Preview/Placeholder
        GestureDetector(
          onTap: pickVideo,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
            ),
            child: videoFile == null
                ? Icon(Icons.video_call, color: colorScheme.inversePrimary)
                : Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      // You could show a generic thumbnail if you had a service for it,
                      // or just a placeholder showing that a video was selected.
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          color: colorScheme.surface.withOpacity(0.7),
                          child: AppText(
                            text: "VIDEO",
                            fontSize: 10,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              CaptionTextField(
                textController: captionController,
                hintText: "Write a Caption...",
              ),
              CaptionTextField(
                textController: descriptionController,
                hintText: "Write a Description...",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          text: "Cover Photo",
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: pickCover,
          child: Container(
            width: size.width * 0.4,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              image: coverFile != null
                  ? DecorationImage(
                      image: FileImage(coverFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: coverFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: colorScheme.inversePrimary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      const AppText(text: "Select Cover", fontSize: 12),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
