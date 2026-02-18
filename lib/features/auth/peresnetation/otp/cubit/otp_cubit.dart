import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'otp_state.dart';

@injectable
class OtpCubit extends Cubit<OtpState> {
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;

  OtpCubit(this.sendOtpUsecase, this.verifyOtpUsecase) : super(OtpInitial());

  String? _verificationId;

  Future<void> sendOtp(String phone) async {
    emit(OtpLoading());

    try {
      await sendOtpUsecase(
        phone: phone,
        codeSent: (verificationId) {
          _verificationId = verificationId;
          emit(OtpCodeSent(verificationId));
        },
      );
    } catch (e) {
      emit(OtpError(e.toString()));
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (_verificationId == null) {
      emit(const OtpError("Verification ID is null"));
      return;
    }

    emit(OtpLoading());

    try {
      await verifyOtpUsecase(verificationId: _verificationId!, otp: otp);

      emit(OtpVerified());
    } catch (e) {
      emit(OtpError("Invalid OTP: ${e.toString()}"));
    }
  }
}
