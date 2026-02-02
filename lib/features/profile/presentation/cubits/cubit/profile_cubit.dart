import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/post/data/firebase_post_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/entities/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  AppUser? currentUser;

  ProfileCubit(FirebaseAuthRepo profileRepo) : super(ProfileInitial());

  final FirebaseAuthRepo firebaseAuthRepo = FirebaseAuthRepo();
  final FirebasePostRepo firebasePostRepo = FirebasePostRepo();

  // fetch user profile using repo , to loading single profile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await firebaseAuthRepo.getUserData(uid);

      if (user != null) {
        currentUser = user;
        emit(ProfileLoaded(profileUser: user));
      } else {
        emit(ProfileError(errorMessage: 'User not found'));
      }
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  // return user profile given uid , to load many profiles for posts
  Future<AppUser?> getUserProfile(String id) async {
    final user = await firebaseAuthRepo.getUserData(id);
    return user;
  }

  Future<void> updateUser({
    required String uid,
    String? username,
    String? bio,
    String? profileImage,
    String? coverImage,
  }) async {
    try {
      emit(ProfileLoading());

      // send ONLY changed fields to Firestore
      await firebaseAuthRepo.updateUser(
        uid: uid,
        username: username,
        bio: bio,
        profileImage: profileImage,
        coverImage: coverImage,
      );

      // re-fetch updated user from Firestore
      final updatedUser = await firebaseAuthRepo.getUserData(uid);

      if (updatedUser == null) {
        emit(ProfileError(errorMessage: 'Failed to load updated user'));
        return;
      }

      currentUser = updatedUser;
      emit(ProfileLoaded(profileUser: updatedUser));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }
}
