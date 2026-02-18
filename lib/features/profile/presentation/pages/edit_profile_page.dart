import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/cloudinary/image_picker_service.dart';
import 'package:social_media_app_using_firebase/core/enums/field_type.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_button.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _selectedImage;
  String? _selectedImageBase64;

  @override
  void initState() {
    super.initState();
    // pre-fill bio with current user's bio
    bioController.text = widget.user.bio ?? '';
    nameController.text = widget.user.username;
    phoneController.text = widget.user.phoneNumber;
  }

  // Show image source selection dialog
  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: MyText(text: 'Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: MyText(text: 'Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: MyText(text: 'Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final imageFile = await _imagePickerService.pickImageFromGallery();
      if (imageFile != null && mounted) {
        setState(() {
          _selectedImage = imageFile;
        });
        // Convert to base64
        final base64String = await _imagePickerService.imageToBase64(imageFile);
        if (mounted) {
          setState(() {
            _selectedImageBase64 = base64String;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: MyText(text: 'Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final imageFile = await _imagePickerService.pickImageFromCamera();
      if (imageFile != null && mounted) {
        setState(() {
          _selectedImage = imageFile;
        });
        // Convert to base64
        final base64String = await _imagePickerService.imageToBase64(imageFile);
        if (mounted) {
          setState(() {
            _selectedImageBase64 = base64String;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: MyText(text: 'Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // update profile
  void updateProfile() async {
    if (!_formkey.currentState!.validate()) return;

    final String bio = bioController.text.trim();
    final String userName = nameController.text.trim();
    final String phoneNumber = phoneController.text.trim();
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    profileCubit.updateUser(
      uid: widget.user.uid,
      bio: bio.isNotEmpty ? bio : null,
      username: userName,
      phoneNumber: phoneNumber,
      // Only update profile image if a new image was selected
      profileImage: _selectedImageBase64,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            body: Column(
              children: [
                CircularProgressIndicator.adaptive(),
                MyText(text: "Loading..."),
              ],
            ),
          );
        } else if (state is ProfileError) {
          return MyText(text: "NO USER FOUND");
        } else {
          return buildEditPage(size: size);
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0, required Size size}) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: "Edit Profile"),

        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),

              // Profile image preview and selection
              Center(
                child: Column(
                  children: [
                    // Profile image preview
                    Stack(
                      children: [
                        Container(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: _selectedImage != null
                                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                : widget.user.profileImage != null
                                ? Image.memory(
                                    _imagePickerService.base64ToImageBytes(
                                      widget.user.profileImage,
                                    )!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: size.width * 0.15,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.person,
                                    size: size.width * 0.15,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            radius: 18,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: _showImageSourceDialog,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                      width: size.width * 0.5,

                      child: AppButton(
                        text: "Select Image",
                        onTap: _showImageSourceDialog,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // edit user name
              MyText(
                text: 'Edit Name',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: size.height * 0.02),

              AppTextField(
                controller: nameController,
                fieldType: FieldType.name,
              ),
              SizedBox(height: size.height * 0.05),

              // edit Phone
              MyText(
                text: 'Edit Phone Number',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: size.height * 0.02),

              AppTextField(
                controller: phoneController,
                fieldType: FieldType.phoneNumber,
              ),
              SizedBox(height: size.height * 0.05),

              // edit bio
              MyText(
                text: 'Edit Bio',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: size.height * 0.02),

              AppTextField(controller: bioController, fieldType: FieldType.bio),
              SizedBox(height: size.height * 0.05),
              // Save button
              Center(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: AppButton(text: "Save Changes", onTap: updateProfile),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
