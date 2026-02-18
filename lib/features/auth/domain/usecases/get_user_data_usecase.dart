import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@lazySingleton
class GetUserDataUsecase {
  final AuthRepo authRepo;

  GetUserDataUsecase({required this.authRepo});

  Future<AppUser?> call(String uid) {
    return authRepo.getUserData(uid);
  }
}
