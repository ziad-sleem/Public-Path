import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'InstagramSans',
  scaffoldBackgroundColor: const Color(0xFF0B0F18),
  canvasColor: const Color(0xFF0B0F18),
  cardColor: AppColors.igGlassSurface,
  shadowColor: const Color(0x66000000),
  colorScheme: ColorScheme.dark(
    surface: AppColors.igGlassSurface,
    onSurface: AppColors.igWhite,
    primary: const Color(0xFF66B8FF),
    onPrimary: AppColors.igBlack,
    secondary: Colors.grey.shade300,
    tertiary: const Color(0xFF748BAE),
    inversePrimary: AppColors.igWhite,
  ),
);
