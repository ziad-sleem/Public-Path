import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;

  Authenticated({required this.user});
}

class AuthRegistrationSuccess extends AuthState {
  final String phoneNumber;
  AuthRegistrationSuccess({required this.phoneNumber});
}

class Unauthenticated extends AuthState {}

class AuthPasswordResetEmailSent extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError({required this.errorMessage});
}
