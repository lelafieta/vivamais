import 'package:flutter/material.dart';
import 'package:maxalert/utils/app_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey[900]!,
    primary: Colors.white,
    secondary: Colors.black,
    onPrimaryContainer: Colors.grey[900],
    primaryContainer: Colors.grey[900],
    onPrimary: Colors.grey[400]!,
    onTertiary: AppColors.WHITE_COLOR,
    outline: AppColors.WHITE_COLOR,
    surfaceTint: AppColors.BLACK_COLOR,
    onSecondary: AppColors.WHITE_COLOR,
    error: AppColors.RED_COLOR,
    secondaryContainer: Colors.grey[900],
  ),
);

ThemeData ligthTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.MAIN_COLOR,
    onPrimaryContainer: AppColors.MAIN_COLOR,
    secondary: AppColors.SECOND_COLOR,
    onSurface: AppColors.CONTENT_COLOR,
    surface: AppColors.WHITE_COLOR,
    onBackground: AppColors.BLACK_COLOR,
    background: AppColors.WHITE_COLOR,
    onError: AppColors.RED_OPACITY_COLOR,
    error: AppColors.RED_COLOR,
    outlineVariant: AppColors.ORANGE_COLOR,
    onPrimary: AppColors.CONTENT_UNSELECT_COLOR,
    onSecondary: AppColors.PURPLE_COLOR,
    outline: AppColors.ITEM_BACKGROUND_COLOR,
    primaryContainer: AppColors.GRAY_COLOR,
    surfaceVariant: AppColors.GREEN_COLOR,
    onTertiary: Colors.white,
    shadow: Colors.black,
    surfaceTint: Colors.white,
    secondaryContainer: Color.fromARGB(255, 234, 234, 234),
  ),
);

ThemeData systemTheme = ThemeData();

// class AppColors {
//   static const Color MAIN_COLOR = Color(0XFF002D74);
//   static const Color SECOND_COLOR = Color(0XFF00A1E0);
//   static const Color CONTENT_COLOR = Color(0XFF777777);
//   static const Color GRAY_COLOR = Color(0XFFDDDDDD);
//   static const Color BLACK_COLOR = Color(0XFF000000);
//   static const Color WHITE_COLOR = Colors.white;
//   static const Color RED_OPACITY_COLOR = Color(0XFFFBE8E8);
//   static const Color RED_COLOR = Colors.red;
//   static const Color WHITE_OPACITY_COLOR = Color.fromARGB(255, 255, 255, 255);
//   static const Color ORANGE_COLOR = Colors.orange;
//   static const Color GREEN_COLOR = Colors.green;
//   static const Color CONTENT_UNSELECT_COLOR = Color(0XFF9F9999);
//   static const Color ITEM_BACKGROUND_COLOR = Color(0XFFF0F0F0);
//   static const Color PURPLE_COLOR = Color(0XFF8E54BB);
// }
