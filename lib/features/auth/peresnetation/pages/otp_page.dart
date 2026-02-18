import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_button.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/otp/cubit/otp_cubit.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  int _resendSeconds = 30;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    // Use the OtpCubit specifically for OTP operations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtpCubit>().sendOtp(widget.phoneNumber);
    });
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: colorScheme.inversePrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.tertiary),
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Verify Phone'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.read<AuthCubit>().logout(), // Go back to login
        ),
      ),
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: MyText(text: 'Verification Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            // After OTP successfully verified, checking auth will find the user logged in
            context.read<AuthCubit>().checkAuth();
          }
          if (state is OtpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: MyText(text: state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is OtpCodeSent) {
            _startResendTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: MyText(text: 'OTP Sent!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                text: "Verification Code",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 10),
              MyText(
                text: "We sent a code to ${widget.phoneNumber}",
                color: colorScheme.inversePrimary.withOpacity(0.7),
              ),
              const SizedBox(height: 30),

              // OTP Input
              Form(
                key: formKey,
                child: Pinput(
                  length: 6,
                  controller: pinController,
                  focusNode: focusNode,
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: colorScheme.primary),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    return value?.length == 6 ? null : 'Pin is incorrect';
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    context.read<OtpCubit>().verifyOtp(pin);
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Verify Button
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  return AppButton(
                    text: "VERIFY",
                    // isLoading: state is OtpLoading, // User removed isLoading from AppButton, but I could add it back or just handle disablement
                    onTap: state is OtpLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              context.read<OtpCubit>().verifyOtp(
                                pinController.text,
                              );
                            }
                          },
                  );
                },
              ),

              const SizedBox(height: 20),

              // Resend Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(text: "Didn't receive code? "),
                  TextButton(
                    onPressed: _canResend
                        ? () {
                            context.read<OtpCubit>().sendOtp(
                              widget.phoneNumber,
                            );
                          }
                        : null,
                    child: MyText(
                      text: _canResend
                          ? "Resend"
                          : "Resend in ${_resendSeconds}s",
                      color: _canResend ? colorScheme.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpScreenProvider extends StatelessWidget {
  final String phoneNumber;
  const OtpScreenProvider({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OtpCubit>(),
      child: OtpPage(phoneNumber: phoneNumber),
    );
  }
}
