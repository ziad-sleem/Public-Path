import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/pages/login_page.dart';

import 'package:social_media_app_using_firebase/core/widgets/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please complete all fields')));
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
                  SizedBox(height: size.height * 0.1),
                  Text(
                    "Create Account",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text("Create Account", style: TextStyle()),
                  SizedBox(height: size.height * 0.2),
                  // email
                  Text("Name", style: TextStyle(fontSize: 20)),
                  SizedBox(height: size.height * 0.01),

                  MyTextFormField(
                    controller: userNameController,
                    hintText: 'NAME',
                    emailOrPasswordOrUserOrBioOrName: 'user',
                  ),
                  SizedBox(height: size.height * 0.02),
                  // email
                  Text("EMAIL", style: TextStyle(fontSize: 20)),
                  SizedBox(height: size.height * 0.01),

                  MyTextFormField(
                    controller: emailController,
                    hintText: 'EMAIL',
                    emailOrPasswordOrUserOrBioOrName: 'email',
                  ),
                  SizedBox(height: size.height * 0.02),

                  // password
                  Text("PASSWORD", style: TextStyle(fontSize: 20)),
                  SizedBox(height: size.height * 0.01),

                  MyTextFormField(
                    controller: passwordController,
                    hintText: "PASSWORD",
                    emailOrPasswordOrUserOrBioOrName: 'password',
                  ),
                  SizedBox(height: size.height * 0.1),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Already have an account, loing here",
                      style: TextStyle(color: colorScheme.inversePrimary),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(color: colorScheme.inversePrimary),
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
