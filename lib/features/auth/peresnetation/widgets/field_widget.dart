import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/enums/field_type.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text_field.dart';

class FieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FieldType fieldType;

  const FieldWidget({
    super.key,
    required this.controller,
    required this.fieldType,
  });

  @override
  State<FieldWidget> createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  String _getText() {
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
        return "Phone Number";
      case FieldType.none:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: _getText(),
            fontSize: 18,
            color: colorScheme.inversePrimary,
          ),
          SizedBox(height: size.height * 0.01),
          AppTextField(
            controller: widget.controller,
            fieldType: widget.fieldType,
          ),
        ],
      ),
    );
  }
}
