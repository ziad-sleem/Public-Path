/*

 Auth Repository - Outlines the possibel auth operations for this app.

 */

import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailAndPassword(String email, String password);
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> getUserData(String uid);
  
}
