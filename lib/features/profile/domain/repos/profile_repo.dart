import 'package:social_media_app_using_firebase/features/profile/domain/models/followers.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/following.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser> fetchUserData({required String uid});
  Future<void> updateUser({
    required String uid,
    String? username,
    String? bio,
    String? profileImage,
    String? phoneNumber,
  });

  // following proccess
  Future<Followers?> fetchFollowers({required String uid});
  Future<Followings?> fetchFollowings({required String uid});
  Future<void> follow({required String uid, required String followHow});
  Future<void> removeFollow({required String uid, required String followHow});
}
