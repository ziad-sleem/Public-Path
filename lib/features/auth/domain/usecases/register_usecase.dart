import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';

@lazySingleton
class RegisterUsecase {
  final AuthRepo authRepo;

  RegisterUsecase({required this.authRepo});

  Future<AppUser?> call(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) {
    return authRepo.registerWithEmailAndPassword(
      name,
      email,
      password,
      phoneNumber,
    );
  }
}
