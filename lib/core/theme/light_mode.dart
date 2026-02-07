import 'package:flutter/material.dart';
import 'package:social_media_app_using_firebase/core/theme/colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'InstagramSans',
  colorScheme: ColorScheme.light(
    background: AppColors.igWhite,
    onBackground: AppColors.igBlack,
    surface: AppColors.igWhite,
    onSurface: AppColors.igBlack,
    primary: AppColors.igBlue,
    onPrimary: AppColors.igWhite,
    secondary: AppColors.igLightGray,
    tertiary: AppColors.igLightBorder,
    inversePrimary: AppColors.igBlack,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'InstagramSans',
    bodyColor: AppColors.igBlack,
    displayColor: AppColors.igBlack,
  ),
);
