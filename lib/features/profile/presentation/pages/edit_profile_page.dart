import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text_field.dart';
import 'package:social_media_app_using_firebase/core/services/image_picker_service.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
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
  }

  // Show image source selection dialog
  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
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
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
        // Convert to base64
        final base64String = await _imagePickerService.imageToBase64(imageFile);
        setState(() {
          _selectedImageBase64 = base64String;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final imageFile = await _imagePickerService.pickImageFromCamera();
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
        // Convert to base64
        final base64String = await _imagePickerService.imageToBase64(imageFile);
        setState(() {
          _selectedImageBase64 = base64String;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
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
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    profileCubit.updateUser(
      uid: widget.user.uid,
      bio: bio.isNotEmpty ? bio : null,
      username: userName,
      // Only update profile image if a new image was selected
      profileImage: _selectedImageBase64 != null ? _selectedImageBase64 : null,
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
                Text("Loading..."),
              ],
            ),
          );
        } else if (state is ProfileError) {
          return Text("NO USER FOUND");
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
      backgroundColor: Theme.of(context).colorScheme.background,

      appBar: AppBar(
        title: Text("Edit Profile"),

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
                    ElevatedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: Icon(Icons.image),
                      label: Text("Select Image"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // edit user name
              Text(
                'Edit Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),

              MyTextFormField(
                controller: nameController,
                hintText: "EDIT Name",
                emailOrPasswordOrUserOrBioOrName: 'editBio',
              ),
              SizedBox(height: size.height * 0.05),

              // edit bio
              Text(
                'Edit Bio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),

              MyTextFormField(
                controller: bioController,
                hintText: "EDIT BIO",
                emailOrPasswordOrUserOrBioOrName: 'editBio',
              ),
              SizedBox(height: size.height * 0.05),
              // Save button
              Center(
                child: ElevatedButton.icon(
                  onPressed: updateProfile,
                  icon: Icon(Icons.save_alt_rounded),
                  label: Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
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
