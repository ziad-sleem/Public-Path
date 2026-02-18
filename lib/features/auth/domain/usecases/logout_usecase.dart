import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@lazySingleton
class LogoutUsecase {
  final AuthRepo authRepo;

  LogoutUsecase({required this.authRepo});

  Future<void> call() {
    return authRepo.logout();
  }
}
