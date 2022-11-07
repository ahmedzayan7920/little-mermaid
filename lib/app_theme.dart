import 'package:flutter/material.dart';
import 'package:puzzle/core/app_colors.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData(
    // main colors
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.lightPrimary,
    primaryColorDark: AppColors.primary,
    disabledColor: AppColors.grey1,
    splashColor: AppColors.lightPrimary,
    // ripple effect color

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.white, fontSize: 20),
      floatingLabelStyle: TextStyle(color: AppColors.white, fontSize: 20),
      hintStyle: TextStyle(color: AppColors.grey, fontSize: 15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // content padding
      contentPadding: const EdgeInsets.all(16),
      // enabled border style
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),

      // focused border style
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),

      // error border style
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      // focused border style
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    ),
    // label style
  );
}
