import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';

class MyTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String emailOrPasswordOrUserOrBioOrName;
  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.emailOrPasswordOrUserOrBioOrName,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.emailOrPasswordOrUserOrBioOrName == 'password';
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${widget.emailOrPasswordOrUserOrBioOrName}';
        }
        if (widget.emailOrPasswordOrUserOrBioOrName == 'email') {
          // Robust email regex
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          );
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        } else if (widget.emailOrPasswordOrUserOrBioOrName == 'password') {
          // Password: min 8 chars, can be only numbers or any characters
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
        } else if (widget.emailOrPasswordOrUserOrBioOrName == 'user') {
          // // Username: min 3 chars, only letters, numbers, underscores
          // final usernameRegex = RegExp(r'^[A-Za-z0-9_]{3,} 0$');
          // if (!usernameRegex.hasMatch(value)) {
          //   return 'Username must be at least 3 characters and contain only letters, numbers, or underscores';
          // }
        } else if (widget.emailOrPasswordOrUserOrBioOrName == 'editBio') {
          if (value.length > 100) {
            return "Bio must be less than 50 characters";
          }
        } else if (widget.emailOrPasswordOrUserOrBioOrName == 'editName') {
          if (value.length > 15) {
            return "Name must be less than 15 characters";
          }
        }
        return null;
      },
      controller: widget.controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.emailOrPasswordOrUserOrBioOrName == 'email'
            ? Icon(Icons.email)
            : widget.emailOrPasswordOrUserOrBioOrName == 'password'
            ? Icon(Icons.password_outlined)
            : widget.emailOrPasswordOrUserOrBioOrName == 'user'
            ? Icon(Icons.person)
            : widget.emailOrPasswordOrUserOrBioOrName == "editBio"
            ? Icon(Icons.edit_attributes)
            : Icon(Icons.abc),
        prefixIconColor: AppColors.igGrey,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        // Add show/hide password icon for password fields
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.igGrey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
