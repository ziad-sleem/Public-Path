import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';

class ForgetPasswordWidget extends StatelessWidget {
  final TextEditingController emailController;
  const ForgetPasswordWidget({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          if (emailController.text.isNotEmpty) {
            context.read<AuthCubit>().resetPassword(emailController.text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: MyText(text: "Please enter your email first"),
              ),
            );
          }
        },
        child: MyText(text: 'Forget password'),
      ),
    );
  }
}
