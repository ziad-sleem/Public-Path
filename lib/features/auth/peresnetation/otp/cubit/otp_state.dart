part of 'otp_cubit.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}


class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpCodeSent extends OtpState {
  final String verificationId;

  const OtpCodeSent(this.verificationId);

}

class OtpVerified extends OtpState {}

class OtpError extends OtpState {
  final String message;

  const OtpError(this.message);

}
