import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/enums/field_type.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_button.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/auth_page_banar.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/field_widget.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/google_signin_button.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/or_divider.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/forget_password_widget.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, this.togglePages});

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
      backgroundColor: colorScheme.surface,
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
                  SizedBox(height: size.height * 0.14),

                  // email
                  FieldWidget(
                    controller: emailController,
                    fieldType: FieldType.email,
                  ),

                  SizedBox(height: size.height * 0.02),

                  // password
                  FieldWidget(
                    controller: passwordController,
                    fieldType: FieldType.password,
                  ),

                  SizedBox(height: size.height * 0.01),

                  // forget password
                  ForgetPasswordWidget(emailController: emailController),
                  SizedBox(height: size.height * 0.02),

                  AppButton(
                    text: "LOGIN",
                    isLoading: context.watch<AuthCubit>().state is AuthLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed to login
                        login();
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  // OR divider
                  OrDivider(),

                  // Google Sign-In button
                  GoogleSigninButton(),
                  SizedBox(height: size.height * 0.02),

                  // toggle page
                  Center(
                    child: TextButton(
                      onPressed: widget.togglePages,
                      child: MyText(
                        text: 'Don\'t have an account? Register.',
                        color: colorScheme.inversePrimary,
                      ),
                    ),
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
