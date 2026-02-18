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
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // sign up
    void signUp() {
      // prepare name and email and password
      final String name = userNameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      final String phoneNumber = phoneNumberController.text;

      final authCubit = context.read<AuthCubit>();

      // check if not empty
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // sign up
        authCubit.register(name, email, password, phoneNumber);
      }
      // fields are empty => display error
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: MyText(text: 'Please complete all fields')),
        );
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
                  AuthPageBanar(authType: ''),
                  SizedBox(height: size.height * 0.01),

                  // name
                  FieldWidget(
                    controller: userNameController,
                    fieldType: FieldType.name,
                  ),

                  // email
                  FieldWidget(
                    controller: emailController,
                    fieldType: FieldType.email,
                  ),

                  // phone Number
                  FieldWidget(
                    controller: phoneNumberController,
                    fieldType: FieldType.phoneNumber,
                  ),

                  // password
                  FieldWidget(
                    controller: passwordController,
                    fieldType: FieldType.password,
                  ),

                  SizedBox(height: size.height * 0.02),

                  // sign up
                  AppButton(
                    text: "SIGN UP",
                    isLoading: context.watch<AuthCubit>().state is AuthLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                  ),

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
                        text: "Already have an account, login here",
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
