import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyOtpUsecase {
  final AuthRepo authRepo;

  VerifyOtpUsecase({required this.authRepo});

  Future<UserCredential> call({
    required String verificationId,
    required String otp,
  }) async {
    return await authRepo.verifyOtp(verificationId: verificationId, otp: otp);
  }
}
