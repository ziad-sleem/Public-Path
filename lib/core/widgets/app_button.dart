import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    final textCol = textColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isLoading ? buttonColor.withOpacity(0.7) : buttonColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textCol,
                  ),
                )
              : MyText(
                  text: text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textCol,
                ),
        ),
      ),
    );
  }
}
