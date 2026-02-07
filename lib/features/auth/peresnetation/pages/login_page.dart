import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_button.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/register_page.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text_field.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/auth_page_banar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // login method
    void login() {
      // prepare email and password
      final String email = emailController.text;
      final String password = passwordController.text;

      // auth cubit
      final authCubit = context.read<AuthCubit>();

      // check if not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        // login
        authCubit.login(email, password);
      }
    }

    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                AuthPageBanar(authType: 'login'),
                  // email
                  MyText(text: "EMAIL", fontSize: 20),
                  SizedBox(height: size.height * 0.01),

                  MyTextFormField(
                    controller: emailController,
                    hintText: 'EMAIL',
                    emailOrPasswordOrUserOrBioOrName: 'email',
                  ),
                  SizedBox(height: size.height * 0.02),

                  // password
                  MyText(text: "PASSWORD", fontSize: 20),
                  SizedBox(height: size.height * 0.01),

                  MyTextFormField(
                    controller: passwordController,
                    hintText: "PASSWORD",
                    emailOrPasswordOrUserOrBioOrName: 'password',
                  ),
                  SizedBox(height: size.height * 0.01),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: null,
                      child: MyText(text: 'Forget password'),
                    ),
                  ),
                  SizedBox(height: size.height * 0.07),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: MyText(
                      text: 'Don\'t have an account? Register.',
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  MyButton(
                    text: "LOGIN",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed to login
                        login();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
