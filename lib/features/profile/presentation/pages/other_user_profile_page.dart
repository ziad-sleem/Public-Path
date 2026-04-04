import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/cloudinary/image_picker_service.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_button.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/follower_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/following_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/widgets/profile_post_widget.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String uid;
  const OtherUserProfilePage({super.key, required this.uid});

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  void initState() {
    super.initState();

    // Fetch user-specific data whenever this page is initialized
    _fetchProfileData();
  }

  void _fetchProfileData() {
    context.read<ProfileCubit>().fetchUserProfile(widget.uid);
    context.read<HomeCubit>().doEvent(
      FetchAllPostByUserIdEvent(userId: widget.uid),
    );
  }

  @override
  void didUpdateWidget(OtherUserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      _fetchProfileData();
    }
  }

  Future<void> toggleFollow(bool isFollowing) async {
    final currentUserId = context.read<AuthCubit>().currentUser!.uid;
    final targetUserId = widget.uid;

    try {
      await context.read<ProfileCubit>().toggleFollow(
        currentUserId,
        targetUserId,
        isFollowing,
      );
    } catch (e) {
      // Error is handled in cubit and emitted as ProfileError
    }
  }

  @override
  Widget build(BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
                  backgroundColor: colorScheme.surface,

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
                  backgroundColor: colorScheme.surface,

            appBar: AppBar(
              title: AppText(
                text: 'Profile',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.01),

                  // profile pic and followers and following
                  Row(
                    children: [
                      // profile pic
                      picWidget(size, user.profileImage),
                      // followers
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // user name
                          Row(
                            children: [
                              SizedBox(width: size.width * 0.08),

                              AppText(text: userName, fontSize: 20),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: size.width * 0.08),

                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FollowerPage(uid: widget.uid),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const AppText(text: "follower"),
                                    AppText(text: "$follower"),
                                  ],
                                ),
                              ),
                              SizedBox(width: size.width * 0.2),

                              // following
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FollowingPage(uid: widget.uid),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const AppText(text: "following"),
                                    AppText(text: "$following"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // bio
                      AppText(text: bio?.toString() ?? "No Bio Yet..."),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.45,
                            child: AppButton(
                              onTap: () => toggleFollow(state.isFollowing),
                              text: state.isFollowing ? "Unfollow" : "Follow",
                            ),
                          ),
                          SizedBox(width: size.width * 0.01),

                          SizedBox(
                            width: size.width * 0.45,

                            child: AppButton(
                              text: 'Share Profile',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.05),

                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoading) {
                            return const Center();
                          } else if (state is HomeLoaded) {
                            final userPosts = state.posts;
                            return GridView.builder(
                              itemCount: userPosts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                  ),
                              itemBuilder: (context, index) {
                                return ProfilePostWidget(
                                  post: userPosts[index],
                                );
                              },
                            );
                          } else if (state is HomeError) {
                            return Center(
                              child: AppText(text: state.errorMessage),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileError) {
          return Scaffold(
            body: Center(child: AppText(text: state.errorMessage)),
          );
        } else {
          return const Scaffold(
            body: Center(child: AppText(text: "NO PROFILE FOUND...")),
          );
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
      height: size.height * 0.10,
      width: size.width * 0.2,
      child: ClipOval(
        child: profileImageBase64 != null && profileImageBase64.isNotEmpty
            ? (profileImageBase64.startsWith('http')
                  ? Image.network(
                      profileImageBase64,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          _buildProfileErrorIcon(size),
                    )
                  : Image.memory(
                      _imagePickerService.base64ToImageBytes(
                        profileImageBase64,
                      )!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildProfileErrorIcon(size),
                    ))
            : _buildProfileErrorIcon(size),
      ),
    );
  }

  Widget _buildProfileErrorIcon(Size size) {
    return Center(
      child: Icon(
        Icons.person,
        size: size.height * 0.09,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
