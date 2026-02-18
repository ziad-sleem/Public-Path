import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@lazySingleton
class ResetPasswordUsecase {
  final AuthRepo authRepo;

  ResetPasswordUsecase({required this.authRepo});

  Future<void> call(String email) async {
    await authRepo.resetPassword(email);
  }
}
