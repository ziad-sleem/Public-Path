import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';

abstract class AuthRemoteDatasource {
  Future<AppUser?> loginWithEmailAndPassword(String email, String password);
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
    String phoneNumber,
  );
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> getUserData(String uid);
  Future<AppUser?> signinWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> sendOtp({
    required String phone,
    required Function(String verificationId) codeSent,
  });
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  });
}

@LazySingleton(as: AuthRemoteDatasource)
class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final user = await getUserData(uid);

      return user;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No account found for this email.');
        case 'wrong-password':
          throw Exception('Incorrect password. Please try again.');
        case 'invalid-email':
          throw Exception('The email address is badly formatted.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        default:
          throw Exception('Login failed: ${e.message ?? e.code}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      // attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      final uid = userCredential.user!.uid;

      // auth user
      final user = AppUser(
        uid: uid,
        username: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      // profile user
      final profileUser = ProfileUser(
        bio: null,
        profileImageUrl: null,
        uid: uid,
        username: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      // save auth user data in firestore
      await firebaseFirestore.collection("users").doc(uid).set(user.toMap());

      // save profile user data in firestore
      await firebaseFirestore
          .collection("usersProfile")
          .doc(uid)
          .set(profileUser.toMap());

      // return user
      return user;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('An account already exists for this email.');
        case 'invalid-email':
          throw Exception('The email address is badly formatted.');
        case 'weak-password':
          throw Exception(
            'The password is too weak. Please use a stronger password.',
          );
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled.');
        default:
          throw Exception('Registration failed: ${e.message ?? e.code}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

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
    try {
      final snapshot = await firebaseFirestore
          .collection("users")
          .doc(uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return AppUser.fromMap(snapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('get user data failed: ${e.toString()}');
    }
  }

  @override
  Future<AppUser?> signinWithGoogle() async {
    try {
      // Use the singleton instance (v7+ API)
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      // Authenticate using the v7 API (throws on failure)
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Get the idToken from authentication
      final idToken = googleUser.authentication.idToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final AppUser user = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          username: firebaseUser.displayName ?? '',
          phoneNumber: firebaseUser.phoneNumber ?? '',
        );

        // Check if user exists in Firestore
        final userDoc = await firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Save to users collection
          await firebaseFirestore
              .collection("users")
              .doc(user.uid)
              .set(user.toMap());
          // Save to userProfile collection
          final profileUser = ProfileUser(
            uid: user.uid,
            email: user.email,
            username: user.username,
            bio: '',
            profileImageUrl: firebaseUser.photoURL ?? '',
            phoneNumber: firebaseUser.phoneNumber ?? '',
          );

          await firebaseFirestore
              .collection("usersProfile")
              .doc(user.uid)
              .set(profileUser.toMap());
        }

        return user;
      }
      return null;
    } catch (e) {
      throw Exception('failed to signIn with Google: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('failed to reset password: ${e.toString()}');
    }
  }

  @override
  Future<void> sendOtp({
    required String phone,
    required Function(String verificationId) codeSent,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (verificationId, _) {
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      throw Exception('failed to send Otp: ${e.toString()}');
    }
  }

  @override
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // If a user is already signed in (like after registration), link the phone number
      if (firebaseAuth.currentUser != null) {
        return await firebaseAuth.currentUser!.linkWithCredential(credential);
      }

      // Otherwise, just sign in (for phone-only login)
      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('failed to verify Otp: ${e.toString()}');
    }
  }
}
