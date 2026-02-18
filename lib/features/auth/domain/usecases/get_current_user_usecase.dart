import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@lazySingleton
class GetCurrentUserUsecase {
  final AuthRepo authRepo;

  GetCurrentUserUsecase({required this.authRepo});

  Future<AppUser?> call() {
    return authRepo.getCurrentUser();
  }
}
