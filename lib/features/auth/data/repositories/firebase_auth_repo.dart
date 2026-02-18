import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@LazySingleton(as: AuthRepo)
class FirebaseAuthRepo implements AuthRepo {
  final AuthRemoteDatasource authRemoteDataSource;

  FirebaseAuthRepo({required this.authRemoteDataSource});

  // implement loginWithEmailAndPassword
  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await authRemoteDataSource.loginWithEmailAndPassword(
      email,
      password,
    );
  }

  // implement registerWithEmailAndPassword
  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    return await authRemoteDataSource.registerWithEmailAndPassword(
      name,
      email,
      password,
      phoneNumber,
    );
  }

  @override
  Future<void> logout() async {
    await authRemoteDataSource.logout();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    return await authRemoteDataSource.getCurrentUser();
  }

  @override
  Future<AppUser?> getUserData(String uid) async {
    return await authRemoteDataSource.getUserData(uid);
  }

  @override
  Future<AppUser?> signinWithGoogle() async {
    return await authRemoteDataSource.signinWithGoogle();
  }

  @override
  Future<void> resetPassword(String email) async {
    return await authRemoteDataSource.resetPassword(email);
  }

  @override
  Future<void> sendOtp({
    required String phone,
    required Function(String verificationId) codeSent,
  }) async {
    await authRemoteDataSource.sendOtp(phone: phone, codeSent: codeSent);
  }

  @override
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    return await authRemoteDataSource.verifyOtp(
      verificationId: verificationId,
      otp: otp,
    );
  }
}
