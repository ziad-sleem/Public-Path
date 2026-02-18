import 'package:social_media_app_using_firebase/core/enums/field_type.dart';

class AppValidators {
  static String? validate({required String? value, required FieldType type}) {
    if (value == null || value.trim().isEmpty) {
      return _emptyMessage(type);
    }

    switch (type) {
      case FieldType.email:
        return _validateEmail(value);

      case FieldType.password:
        return _validatePassword(value);

      case FieldType.username:
        return _validateUsername(value);

      case FieldType.bio:
        return _validateBio(value);

      case FieldType.name:
        return _validateName(value);

      case FieldType.phoneNumber:
        return _validatePhone(value);

      case FieldType.none:
        return null;
    }
  }

  static String _emptyMessage(FieldType type) {
    switch (type) {
      case FieldType.email:
        return "Email is required";
      case FieldType.password:
        return "Password is required";
      case FieldType.username:
        return "Username is required";
      case FieldType.bio:
        return "Bio is required";
      case FieldType.name:
        return "Name is required";
      case FieldType.phoneNumber:
        return "Phone number is required";
      case FieldType.none:
        return "Field is required";
    }
  }

  static String? _validateEmail(String value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? _validatePassword(String value) {
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  static String? _validateUsername(String value) {
    final regex = RegExp(r'^[A-Za-z0-9_]{3,}$');
    if (!regex.hasMatch(value)) {
      return "Username must be at least 3 characters and contain only letters, numbers or _";
    }
    return null;
  }

  static String? _validateBio(String value) {
    if (value.length > 100) {
      return "Bio must be less than 100 characters";
    }
    return null;
  }

  static String? _validateName(String value) {
    if (value.length > 15) {
      return "Name must be less than 15 characters";
    }
    return null;
  }

  static String? _validatePhone(String value) {
    // Correct format: +[country code][number]
    final regex = RegExp(r'^\+\d{10,15}$');

    if (!regex.hasMatch(value)) {
      return "Format: +[country code][number] (e.g., +1234567890)";
    }
    return null;
  }
}
