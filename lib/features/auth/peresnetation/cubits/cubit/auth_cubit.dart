import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/logout_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final SigninWithGoogleUsecase signinWithGoogleUsecase;

  AuthCubit({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.resetPasswordUsecase,
    required this.signinWithGoogleUsecase,
  }) : super(AuthInitial());

  // check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await getCurrentUserUsecase();

    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user
  AppUser? get currentUser {
    if (state is Authenticated) {
      return (state as Authenticated).user;
    }
    return null;
  }

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await loginUsecase(email, password);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
      emit(Unauthenticated());
    }
  }

  // resgister with email and password
  Future<void> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      emit(AuthLoading());
      final user = await registerUsecase(name, email, password, phoneNumber);
      if (user != null) {
        emit(AuthRegistrationSuccess(phoneNumber: phoneNumber.toString()));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout
  Future<void> logout() async {
    await logoutUsecase();
    emit(Unauthenticated());
  }

  // sign in with google
  Future<void> signinWithGoogle() async {
    try {
      emit(AuthLoading());
      final user = await signinWithGoogleUsecase();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
      emit(Unauthenticated());
    }
  }

  /// reset password by email
  Future<void> resetPassword(String email) async {
    try {
      emit(AuthLoading());
      await resetPasswordUsecase(email);
      emit(AuthPasswordResetEmailSent());
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
      emit(Unauthenticated());
    }
  }
}
