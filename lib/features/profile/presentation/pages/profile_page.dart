import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social_media_app_using_firebase/core/services/image_picker_service.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  final ImagePickerService _imagePickerService = ImagePickerService();

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: BlocProvider.of<ProfileCubit>(context),
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is ProfileLoaded) {
          // get loaded user
          final user = state.profileUser;
          final follower = user.followersCount;
          final following = user.followingCount;
          final userName = user.username;
          final bio = user.bio == '' ? 'no bio yet...' : user.bio;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.username),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    );
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.01),

                    // profile pic and followers and following
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // profile pic
                        picWidget(size, user.profileImage),

                        // followers
                        Column(children: [Text("follower"), Text("$follower")]),

                        // following
                        Column(
                          children: [Text("following"), Text("$following")],
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user name
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // bio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(bio?.toString() ?? "")),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(user: user),
                                  ),
                                );
                              },
                              child: Icon(Icons.settings),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            "POSTS",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),

                    // bio
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text("NO PROFILE FOUND..."));
        }
      },
    );
  }

  // pic widget
  Widget picWidget(Size size, String? profileImageBase64) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      height: size.height * 0.13,
      width: size.width * 0.3,
      child: ClipOval(
        child: profileImageBase64 != null && profileImageBase64.isNotEmpty
            ? Image.memory(
                _imagePickerService.base64ToImageBytes(profileImageBase64)!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: EdgeInsets.all(25),
                    child: Icon(
                      Icons.person,
                      size: size.height * 0.09,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              )
            : Container(
                padding: EdgeInsets.all(25),
                child: Icon(
                  Icons.person,
                  size: size.height * 0.09,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    );
  }
}
