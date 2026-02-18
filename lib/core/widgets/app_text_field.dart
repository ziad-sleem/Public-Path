import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';
import '../enums/field_type.dart';
import '../validation/app_validators.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final FieldType fieldType;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    this.fieldType = FieldType.none,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscurePassword = true;

  bool get _isPassword => widget.fieldType == FieldType.password;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isPassword ? _obscurePassword : false,
      keyboardType: widget.keyboardType ?? _defaultKeyboardType(),
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      validator: (value) =>
          AppValidators.validate(value: value, type: widget.fieldType),
      decoration: InputDecoration(
        hintText: _getHintText(),
        prefixIcon: Icon(_getPrefixIcon()),
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
        suffixIcon: _isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
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

  IconData _getPrefixIcon() {
    switch (widget.fieldType) {
      case FieldType.email:
        return Icons.email;
      case FieldType.password:
        return Icons.lock;
      case FieldType.username:
        return Icons.person;
      case FieldType.bio:
        return Icons.edit;
      case FieldType.name:
        return Icons.badge;
      case FieldType.phoneNumber:
        return Icons.phone;
      case FieldType.none:
        return Icons.text_fields;
    }
  }

  String _getHintText() {
    switch (widget.fieldType) {
      case FieldType.email:
        return "Email";
      case FieldType.password:
        return "Password";
      case FieldType.username:
        return "User name";
      case FieldType.bio:
        return "Bio";
      case FieldType.name:
        return "Name";
      case FieldType.phoneNumber:
        return "Phone Number (+1234567890)";
      case FieldType.none:
        return "";
    }
  }

  TextInputType _defaultKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phoneNumber:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
