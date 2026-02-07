import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'InstagramSans',
  colorScheme: ColorScheme.dark(
    background: AppColors.igBlack,
    onBackground: AppColors.igWhite,
    surface: AppColors.igBlack,
    onSurface: AppColors.igWhite,
    primary: AppColors.igBlue,
    onPrimary: AppColors.igWhite,
    secondary: AppColors.igDarkGray,
    tertiary: AppColors.igDarkBorder,
    inversePrimary: AppColors.igWhite,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'InstagramSans',
    bodyColor: AppColors.igWhite,
    displayColor: AppColors.igWhite,
  ),
);
