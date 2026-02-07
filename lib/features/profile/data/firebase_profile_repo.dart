import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/followers.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/following.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// fetch user data for profile
  @override
  Future<ProfileUser> fetchUserData({required String uid}) async {
    try {
      final snapshot = await firebaseFirestore
          .collection("usersProfile")
          .doc(uid)
          .get();
      final user = ProfileUser.fromMap(snapshot.data()!);
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// required uid, not required username, bio, profileImage, coverImage
  @override
  Future<void> updateUser({
    required String uid,
    String? username,
    String? bio,
    String? profileImage,
    String? coverImage,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (username != null) data['username'] = username;
      if (bio != null) data['bio'] = bio;
      if (profileImage != null) data['profileImage'] = profileImage;
      if (coverImage != null) data['coverImage'] = coverImage;

      // nothing to update
      if (data.isEmpty) return;

      await firebaseFirestore.collection('usersProfile').doc(uid).update(data);
    } catch (e) {
      throw Exception('update user failed: ${e.toString()}');
    }
  }

  // following process

  @override
  Future<Followers?> fetchFollowers({required String uid}) async {
    try {
      final snapshot = await firebaseFirestore
          .collection('followers')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        return Followers.fromMap(snapshot.data()!);
      }
      return Followers(userId: uid, followers: []);
    } catch (e) {
      throw Exception('fetch followers failed: ${e.toString()}');
    }
  }

  @override
  Future<Followings?> fetchFollowings({required String uid}) async {
    try {
      final snapshot = await firebaseFirestore
          .collection('following')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        return Followings.fromMap(snapshot.data()!);
      }
      return Followings(userId: uid, following: []);
    } catch (e) {
      throw Exception('fetch following failed: ${e.toString()}');
    }
  }

  @override
  Future<void> follow({required String uid, required String followHow}) async {
    try {
      final batch = firebaseFirestore.batch();

      // target user followers doc
      final followersDoc = firebaseFirestore.collection('followers').doc(uid);
      batch.set(followersDoc, {
        'userId': uid,
        'followers': FieldValue.arrayUnion([followHow]),
      }, SetOptions(merge: true));

      // current user following doc
      final followingDoc = firebaseFirestore
          .collection('following')
          .doc(followHow);
      batch.set(followingDoc, {
        'userId': followHow,
        'following': FieldValue.arrayUnion([uid]),
      }, SetOptions(merge: true));

      // update counts in usersProfile
      final targetProfile = firebaseFirestore
          .collection('usersProfile')
          .doc(uid);
      batch.update(targetProfile, {'followersCount': FieldValue.increment(1)});

      final sourceProfile = firebaseFirestore
          .collection('usersProfile')
          .doc(followHow);
      batch.update(sourceProfile, {'followingCount': FieldValue.increment(1)});

      await batch.commit();
    } catch (e) {
      throw Exception('follow failed: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFollow({
    required String uid,
    required String followHow,
  }) async {
    try {
      final batch = firebaseFirestore.batch();

      // target user followers doc
      final followersDoc = firebaseFirestore.collection('followers').doc(uid);
      batch.set(followersDoc, {
        'userId': uid,
        'followers': FieldValue.arrayRemove([followHow]),
      }, SetOptions(merge: true));

      // current user following doc
      final followingDoc = firebaseFirestore
          .collection('following')
          .doc(followHow);
      batch.set(followingDoc, {
        'userId': followHow,
        'following': FieldValue.arrayRemove([uid]),
      }, SetOptions(merge: true));

      // update counts in usersProfile
      final targetProfile = firebaseFirestore
          .collection('usersProfile')
          .doc(uid);
      batch.update(targetProfile, {'followersCount': FieldValue.increment(-1)});

      final sourceProfile = firebaseFirestore
          .collection('usersProfile')
          .doc(followHow);
      batch.update(sourceProfile, {'followingCount': FieldValue.increment(-1)});

      await batch.commit();
    } catch (e) {
      throw Exception('remove follow failed: ${e.toString()}');
    }
  }
}
