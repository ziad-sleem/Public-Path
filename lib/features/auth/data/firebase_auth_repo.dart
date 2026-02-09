import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';


@LazySingleton(as: AuthRepo)
class FirebaseAuthRepo implements AuthRepo {
  // get the only instance or FirebaseAuth you can get and fill up the method by it
  final FirebaseAuth firebaseAuth;

  // get the only instance or FirebaseFirestore you can get and fill up the method by it
  final FirebaseFirestore firebaseFirestore ;

  FirebaseAuthRepo({required this.firebaseAuth, required this.firebaseFirestore});

  // implement loginWithEmailAndPassword
  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print("Starting login process for $email...");
      // attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      print("Firebase Auth success. Fetching user data for $uid...");

      final user = await getUserData(uid);
      if (user == null) {
        print("CRITICAL: User document missing in Firestore for $uid!");
      } else {
        print("Login successful for ${user.username}");
      }
      return user;
    }
    // catch any errors
    catch (e) {
      print("Login error: $e");
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
      print("Starting registration for $email...");
      // attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      final uid = userCredential.user!.uid;
      print("Firebase Auth account created: $uid");

      // auth user
      final user = AppUser(uid: uid, username: name, email: email);

      // profile user
      final profileUser = ProfileUser(
        bio: null,
        profileImageUrl: null,
        uid: uid,
        username: name,
        email: email,
      );

      print("Saving user data to Firestore...");
      // save auth user data in firestore
      await firebaseFirestore.collection("users").doc(uid).set(user.toMap());

      print("Saving profile data to Firestore...");
      // save profile user data in firestore
      await firebaseFirestore
          .collection("usersProfile")
          .doc(uid)
          .set(profileUser.toMap());

      print("Registration complete for $name");
      // return user
      return user;
    }
    // catch any errors
    catch (e) {
      print("Registration error: $e");
      throw Exception('create an account failed: ${e.toString()}');
    }
  }

  //  implement logout
  @override
  Future<void> logout() async {
    try {
      print("Logging out...");
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

  /// fetch user data for auth
  @override
  Future<AppUser?> getUserData(String uid) async {
    try {
      final snapshot = await firebaseFirestore
          .collection("users")
          .doc(uid)
          .get();

      if (!snapshot.exists) {
        print("No document found in 'users' collection for UID: $uid");
        return null;
      }

      return AppUser.fromMap(snapshot.data()!);
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
      return null;
    }
  }
}
