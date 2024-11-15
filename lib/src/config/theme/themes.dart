import 'package:flutter/material.dart';

import '../../core/utils/app_strings.dart';
import '../../core/utils/app_values.dart';
import 'color_palette.dart';

class AppTheme {
  static get lightTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        fontFamily: AppStrings.fontFamily,
        brightness: Brightness.light,
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: AppStrings.fontFamily,
            //fontSize: AppSize.s16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
          headlineMedium: TextStyle(
            fontFamily: AppStrings.fontFamily,
            //fontSize: AppSize.s16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
          headlineSmall: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
          bodySmall: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.strokeColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor50),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIconColor: AppColors.secondaryColor,
          suffixIconColor: AppColors.secondaryColor,
          hintStyle: TextStyle(fontSize: AppSize.s14),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontSize: AppSize.s16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.primaryColor),
            foregroundColor: MaterialStatePropertyAll(AppColors.whiteColor),
            minimumSize: MaterialStatePropertyAll(
              Size(double.maxFinite, 50),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Define o raio da borda aqui
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            minimumSize:
                MaterialStatePropertyAll(Size(double.infinity, AppSize.s50)),
            foregroundColor: MaterialStatePropertyAll(AppColors.primaryColor),
            side: MaterialStateProperty.all(
              BorderSide(
                color: AppColors.primaryColor, // Cor da borda
                width: AppSize.s1_5, // Largura da borda
              ),
            ),
          ),
        ),
      );
  // static get darkTheme => ThemeData(
  //       useMaterial3: true,
  //       scaffoldBackgroundColor: AppColors.blackColor,
  //       fontFamily: AppStrings.fontFamily,
  //       brightness: Brightness.dark,
  //       bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //         backgroundColor: AppColors.blackColor,
  //         elevation: AppSize.s2,
  //       ),
  //     );

  static get darkTheme => ThemeData(
        useMaterial3: true,
        // scaffoldBackgroundColor: Colors.black, // Fundo preto
        fontFamily: AppStrings.fontFamily,
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor, // Botão mantém a cor primária
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor, // Texto em branco
          ),
          headlineMedium: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
          ),
          headlineSmall: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
          ),
          bodySmall: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontWeight: FontWeight.w400,
            color: AppColors.grey1, // Texto secundário em cinza claro
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.strokeColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor50),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIconColor: AppColors.secondaryColor,
          suffixIconColor: AppColors.secondaryColor,
          hintStyle: TextStyle(
            fontSize: AppSize.s14,
            color: AppColors.grey, // Texto de dica em cinza
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.blackColor, // Fundo do AppBar preto
          titleTextStyle: TextStyle(
            fontFamily: AppStrings.fontFamily,
            fontSize: AppSize.s16,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor, // Texto em branco
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.primaryColor),
            foregroundColor: MaterialStatePropertyAll(AppColors.whiteColor),
            minimumSize: MaterialStatePropertyAll(
              Size(double.maxFinite, 50),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Define o raio da borda aqui
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            minimumSize:
                MaterialStatePropertyAll(Size(double.infinity, AppSize.s50)),
            foregroundColor: MaterialStatePropertyAll(AppColors.primaryColor),
            side: MaterialStateProperty.all(
              BorderSide(
                color: AppColors.primaryColor, // Cor da borda
                width: AppSize.s1_5, // Largura da borda
              ),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              AppColors.blackColor, // Fundo do BottomNavigationBar preto
          selectedItemColor: AppColors.primaryColor, // Cor do ícone selecionado
          unselectedItemColor: AppColors.grey, // Cor do ícone não selecionado
          elevation: AppSize.s2,
        ),
      );
}
