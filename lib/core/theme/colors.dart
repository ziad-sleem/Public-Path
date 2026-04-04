import 'package:flutter/material.dart';

class AppColors {
  static const Color igBlue = Color(0xFF0095F6);
  static const Color igWhite = Color(0xFFFFFFFF);
  static const Color igBlack = Color(0xFF000000);

  // Light Mode Specifics
  static const Color igLightGray = Color(0xFFFAFAFA);
  static const Color igLightBorder = Color(0xFFDBDBDB);

  // Dark Mode Specifics
  static const Color igDarkGray = Color(0xFF121212);
  static const Color igDarkBorder = Color(0xFF262626);

  // General shades
  static const Color igGrey = Color(0xFF8E8E8E);

  // Glass/Blur Tokens
  static const Color igGlass = Color(0x26FFFFFF); // 15% white
  static const Color igGlassSurface = Color(0x1AFFFFFF); // 10% white
  static const Color igFog = Color(0x33FFFFFF); // 20% white for borders

  // Legacy mapping to prevent breakages while refactoring
  static const Color mySecondTextColor = igGrey;
  static const Color myStrongGray = igGrey;
  static const Color myTransparent = Colors.transparent;

  static const Color myRed = Colors.red;
}
