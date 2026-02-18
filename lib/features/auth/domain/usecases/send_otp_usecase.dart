import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@lazySingleton
class SendOtpUsecase {
  final AuthRepo authRepo;

  SendOtpUsecase({required this.authRepo});

  Future<void> call({
    required String phone,
    required Function(String verificationId) codeSent,
  }) async {
    await authRepo.sendOtp(phone: phone, codeSent: codeSent);
  }
}
