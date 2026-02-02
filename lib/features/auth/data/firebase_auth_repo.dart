import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  // get the only instance or FirebaseAuth you can get and fill up the method by it
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // get the only instance or FirebaseFirestore you can get and fill up the method by it
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // implement loginWithEmailAndPassword
  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // create user
      return getUserData(userCredential.user!.uid);
    }
    // catch any errors
    catch (e) {
      throw Exception('login failed: ${e.toString()}');
    }
  }

  // implement registerWithEmailAndPassword
  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      final uid = userCredential.user!.uid;

      final user = AppUser(
        uid: uid,
        username: name,
        email: email,
        createdAt: DateTime.now(),
        bio: "",
        followersCount: 0,
        followingCount: 0,
        isVerified: false,
        profileImage: null,
      );

      // save user data in firestore
      await firebaseFirestore.collection("users").doc(uid).set(user.toMap());

      // return user
      return user;
    }
    // catch any errors
    catch (e) {
      throw Exception('creae an account failed: ${e.toString()}');
    }
  }

  //  implement logout
  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('logout failed: ${e.toString()}');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // get current logged in user from firebase
    final firebaseUSer = firebaseAuth.currentUser;
    // no user loggend in
    if (firebaseUSer == null) {
      return null;
    }
    //  user exists
    return getUserData(firebaseAuth.currentUser!.uid);
  }

  @override
  Future<AppUser?> getUserData(String uid) async {
    final snapshot = await firebaseFirestore.collection("users").doc(uid).get();

    if (!snapshot.exists) return null;

    return AppUser.fromMap(snapshot.data()!);
  }

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

      await firebaseFirestore.collection("users").doc(uid).update(data);
    } catch (e) {
      throw Exception('update user failed: ${e.toString()}');
    }
  }
}
