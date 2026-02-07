import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app_using_firebase/features/post/data/firebase_post_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/data/firebase_profile_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseAuthRepo firebaseAuthRepo = FirebaseAuthRepo();
  final FirebasePostRepo firebasePostRepo = FirebasePostRepo();
  final FirebaseProfileRepo firebaseProfileRepo = FirebaseProfileRepo();

  // fetch user profile using repo , to loading single profile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await firebaseProfileRepo.fetchUserData(uid: uid);

      emit(ProfileLoaded(profileUser: user));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  // return user profile given uid , to load many profiles for posts
  Future<ProfileUser?> getUserProfile(String id) async {
    final user = await firebaseProfileRepo.fetchUserData(uid: id);
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
      await firebaseProfileRepo.updateUser(
        uid: uid,
        bio: bio,
        profileImage: profileImage,
        username: username,
      );

      // re-fetch updated user from Firestore
      final updatedUser = await firebaseProfileRepo.fetchUserData(uid: uid);

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
        await firebaseProfileRepo.removeFollow(
          uid: targetUserId,
          followHow: currentUserId,
        );
      } else {
        // Not following, so follow
        await firebaseProfileRepo.follow(
          uid: targetUserId,
          followHow: currentUserId,
        );
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
    final followers = await firebaseProfileRepo.fetchFollowers(uid: uid);
    final list = followers?.followers ?? [];
    return list;
  }

  // fetch following for a specific user
  Future<List<String>> getFollowing(String uid) async {
    final following = await firebaseProfileRepo.fetchFollowings(uid: uid);
    final list = following?.following ?? [];
    return list;
  }
}
