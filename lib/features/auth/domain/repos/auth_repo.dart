/*

 Auth Repository - Outlines the possibel auth operations for this app.

 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
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
