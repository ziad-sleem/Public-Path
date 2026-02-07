import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';

class AuthPageBanar extends StatelessWidget {
  final String authType;
  const AuthPageBanar({super.key, required this.authType});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.02),
        Center(
          child: MyText(
            text: "Public Path",
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: size.height * 0.07),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: authType == 'login' ? "Login Account" : "Create Account ",
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            MyText(
              text: authType == 'login'
                  ? "Welcome back!"
                  : "Let's get started!",
            ),
          ],
        ),
        SizedBox(height: size.height * 0.15),
      ],
    );
  }
}
