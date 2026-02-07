import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_button.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social_media_app_using_firebase/core/services/image_picker_service.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/follower_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/following_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/widgets/profile_post_widget.dart';

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

  bool isFollowing = false;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
    context.read<PostCubit>().fetchAllPostsByUserId(userId: widget.uid);
    checkFollowStatus();
  }

  Future<void> checkFollowStatus() async {
    final followers = await profileCubit.getFollowers(widget.uid);
    if (mounted) {
      setState(() {
        isFollowing = followers.contains(authCubit.currentUser!.uid);
      });
    }
  }

  Future<void> toggleFollow() async {
    final currentUserId = authCubit.currentUser!.uid;
    final targetUserId = widget.uid;

    // optimistically update UI
    setState(() {
      isFollowing = !isFollowing;
    });

    try {
      final bool wasFollowing =
          !isFollowing; // Since we already flipped it in setState
      await profileCubit.toggleFollow(
        currentUserId,
        targetUserId,
        wasFollowing,
      );
    } catch (e) {
      // revert if failed
      setState(() {
        isFollowing = !isFollowing;
      });
    }
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
              title: MyText(text: user.username),
              foregroundColor: Theme.of(context).colorScheme.primary,              
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

                              MyText(text: userName, fontSize: 20),
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
                                    const MyText(text: "follower"),
                                    MyText(text: "$follower"),
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
                                    const MyText(text: "following"),
                                    MyText(text: "$following"),
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
                      MyText(text: bio?.toString() ?? "No Bio Yet..."),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          context.read<AuthCubit>().currentUser!.uid ==
                                  widget.uid
                              ? SizedBox(
                                  width: size.width * 0.45,
                                  child: MyButton(
                                    text: 'Edit Profile',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilePage(user: user),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  width: size.width * 0.45,
                                  child: MyButton(
                                    onTap: toggleFollow,
                                    text: isFollowing ? "Unfollow" : "Follow",
                                  ),
                                ),
                          SizedBox(width: size.width * 0.01),

                          SizedBox(
                            width: size.width * 0.45,

                            child: MyButton(
                              text: 'Share Profile',
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.05),
                      BlocBuilder<PostCubit, PostState>(
                        builder: (context, state) {
                          if (state is PostLoading) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else if (state is PostLoaded) {
                            final posts = state.posts;
                            return GridView.builder(
                              itemCount: posts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                  ),
                              itemBuilder: (context, index) {
                                return ProfilePostWidget(post: posts[index]);
                              },
                            );
                          } else if (state is PostError) {
                            return Center(
                              child: MyText(text: state.errorMessage),
                            );
                          } else {
                            return const SizedBox.shrink();
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
            body: Center(child: MyText(text: state.errorMessage)),
          );
        } else {
          return const Scaffold(
            body: Center(child: MyText(text: "NO PROFILE FOUND...")),
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
                  ? CachedNetworkImage(
                      imageUrl: profileImageBase64,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      errorWidget: (context, url, error) =>
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
