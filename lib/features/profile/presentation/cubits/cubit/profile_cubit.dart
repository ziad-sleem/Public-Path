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

  // cache for profiles to avoid redundant network requests
  final Map<String, ProfileUser> _profileCache = {};
  final Map<String, List<String>> _followersCache = {};
  final Map<String, List<String>> _followingCache = {};

  // fetch user profile using repo , to loading single profile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      // check cache first
      if (_profileCache.containsKey(uid)) {
        emit(ProfileLoaded(profileUser: _profileCache[uid]!));
      } else {
        // only show loading if we have nothing in cache
        emit(ProfileLoading());
      }

      final user = await firebaseProfileRepo.fetchUserData(uid: uid);

      // update cache
      _profileCache[uid] = user;

      emit(ProfileLoaded(profileUser: user));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  // return user profile given uid , to load many profiles for posts
  Future<ProfileUser?> getUserProfile(String id) async {
    // check cache first
    if (_profileCache.containsKey(id)) {
      return _profileCache[id];
    }

    final user = await firebaseProfileRepo.fetchUserData(uid: id);

    // update cache
    _profileCache[id] = user;

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

      // update cache with fresh data
      _profileCache[uid] = updatedUser;

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
        await firebaseProfileRepo.removeFollow(
          uid: targetUserId,
          followHow: currentUserId,
        );
        _updateLocalFollowState(currentUserId, targetUserId, false);
      } else {
        await firebaseProfileRepo.follow(
          uid: targetUserId,
          followHow: currentUserId,
        );
        _updateLocalFollowState(currentUserId, targetUserId, true);
      }
    } catch (e) {
      // If error occurs, we might want to refresh to ensure UI is in sync
      await fetchUserProfile(targetUserId);
      emit(ProfileError(errorMessage: (e.toString())));
    }
  }

  // Helper to update local cache and state without full re-fetch
  void _updateLocalFollowState(
    String currentUid,
    String targetUid,
    bool isFollow,
  ) {
    // 1. Update target user's follower count in cache
    final targetUser = _profileCache[targetUid];
    if (targetUser != null) {
      final updatedUser = targetUser.copyWith(
        followersCount: (targetUser.followersCount ?? 0) + (isFollow ? 1 : -1),
      );
      _profileCache[targetUid] = updatedUser;

      // Emit new state if we are currently looking at this profile
      if (state is ProfileLoaded &&
          (state as ProfileLoaded).profileUser.uid == targetUid) {
        emit(ProfileLoaded(profileUser: updatedUser));
      }
    }

    // 2. Update current user's following count in cache
    final currentUser = _profileCache[currentUid];
    if (currentUser != null) {
      _profileCache[currentUid] = currentUser.copyWith(
        followingCount: (currentUser.followingCount ?? 0) + (isFollow ? 1 : -1),
      );
    }

    // 3. Update relationship caches
    if (_followersCache.containsKey(targetUid)) {
      if (isFollow) {
        _followersCache[targetUid]!.add(currentUid);
      } else {
        _followersCache[targetUid]!.remove(currentUid);
      }
    }

    if (_followingCache.containsKey(currentUid)) {
      if (isFollow) {
        _followingCache[currentUid]!.add(targetUid);
      } else {
        _followingCache[currentUid]!.remove(targetUid);
      }
    }
  }

  // fetch followers for a specific user
  Future<List<String>> getFollowers(String uid) async {
    if (_followersCache.containsKey(uid)) return _followersCache[uid]!;

    final followers = await firebaseProfileRepo.fetchFollowers(uid: uid);
    final list = followers?.followers ?? [];
    _followersCache[uid] = list;
    return list;
  }

  // fetch following for a specific user
  Future<List<String>> getFollowing(String uid) async {
    if (_followingCache.containsKey(uid)) return _followingCache[uid]!;

    final following = await firebaseProfileRepo.fetchFollowings(uid: uid);
    final list = following?.following ?? [];
    _followingCache[uid] = list;
    return list;
  }
}
