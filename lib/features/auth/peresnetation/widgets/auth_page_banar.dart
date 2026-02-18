import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';

class AuthPageBanar extends StatelessWidget {
  final String authType;
  const AuthPageBanar({super.key, required this.authType});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: MyText(
              text: "Public Path",
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

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
      ],
    );
  }
}
