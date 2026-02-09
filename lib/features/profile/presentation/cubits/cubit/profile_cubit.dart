import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app_using_firebase/features/post/domain/repo/post_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/repos/profile_repo.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepo authRepo;
  final PostRepo postRepo;
  final ProfileRepo profileRepo;

  ProfileCubit({
    required this.authRepo,
    required this.postRepo,
    required this.profileRepo,
  }) : super(ProfileInitial());

  // fetch user profile using repo , to loading single profile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await profileRepo.fetchUserData(uid: uid);

      emit(ProfileLoaded(profileUser: user));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  // return user profile given uid , to load many profiles for posts
  Future<ProfileUser?> getUserProfile(String id) async {
    final user = await profileRepo.fetchUserData(uid: id);
    return user;
  }

  Future<void> updateUser({
    required String uid,
    String? username,
    String? bio,
    String? profileImage,
  }) async {
    try {
      emit(ProfileLoading());

      // send ONLY changed fields to Firestore
      await profileRepo.updateUser(
        uid: uid,
        bio: bio,
        profileImage: profileImage,
        username: username,
      );

      // re-fetch updated user from Firestore
      final updatedUser = await profileRepo.fetchUserData(uid: uid);

      emit(ProfileLoaded(profileUser: updatedUser));
    } catch (e) {
      emit(ProfileError(errorMessage: (e.toString())));
    }
  }

  // toggle follow/unfollow
  Future<void> toggleFollow(
    String currentUserId,
    String targetUserId,
    bool isCurrentlyFollowing,
  ) async {
    try {
      if (isCurrentlyFollowing) {
        // Currently following, so unfollow
        await profileRepo.removeFollow(
          uid: targetUserId,
          followHow: currentUserId,
        );
      } else {
        // Not following, so follow
        await profileRepo.follow(uid: targetUserId, followHow: currentUserId);
      }
      // Refresh the target user's profile after toggle
      await fetchUserProfile(targetUserId);
    } catch (e) {
      // If error occurs, refresh to ensure UI is in sync
      await fetchUserProfile(targetUserId);
      emit(ProfileError(errorMessage: (e.toString())));
    }
  }

  // fetch followers for a specific user
  Future<List<String>> getFollowers(String uid) async {
    final followers = await profileRepo.fetchFollowers(uid: uid);
    final list = followers?.followers ?? [];
    return list;
  }

  // fetch following for a specific user
  Future<List<String>> getFollowing(String uid) async {
    final following = await profileRepo.fetchFollowings(uid: uid);
    final list = following?.following ?? [];
    return list;
  }
}
