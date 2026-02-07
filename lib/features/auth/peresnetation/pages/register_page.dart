import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_button.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/login_page.dart';

import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text_field.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/widgets/auth_page_banar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
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

      // auth cubit
      final authCubit = context.read<AuthCubit>();

      // check if not empty
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // sign up
        authCubit.register(name, email, password);
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
                  AuthPageBanar(authType: ''),
                  // email
                  MyText(text: "Name", fontSize: 20),
                  SizedBox(height: size.height * 0.01),

                  MyTextFormField(
                    controller: userNameController,
                    hintText: 'NAME',
                    emailOrPasswordOrUserOrBioOrName: 'user',
                  ),
                  SizedBox(height: size.height * 0.02),
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
                  SizedBox(height: size.height * 0.05),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },

                    child: MyText(
                      text: "Already have an account, login here",
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  MyButton(
                    text: "SIGN UP",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
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
