import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';

class MyButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;

  const MyButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.textColor,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = widget.color ?? theme.colorScheme.primary;
    final textColor = widget.textColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      onTap: widget.onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: MyText(
            text: widget.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
