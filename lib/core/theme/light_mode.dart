import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'InstagramSans',
  scaffoldBackgroundColor: AppColors.igGlass,
  canvasColor: const Color(0xFFF5F8FF),
  cardColor: const Color(0xB3FFFFFF),
  shadowColor: const Color(0x14000000),
  colorScheme: ColorScheme.light(
    surface: AppColors.igWhite,
    onSurface: AppColors.igBlack,
    primary: AppColors.igBlue,
    onPrimary: AppColors.igWhite,
    secondary: AppColors.igBlack,
    tertiary: AppColors.igLightBorder,
    inversePrimary: AppColors.igBlack,
  ),
);
