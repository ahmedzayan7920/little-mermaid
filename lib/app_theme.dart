import 'package:flutter/material.dart';
import 'package:puzzle/core/app_colors.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData(
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary),
    ),
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.lightPrimary,
    primaryColorDark: AppColors.primary,
    disabledColor: AppColors.grey1,
    splashColor: AppColors.lightPrimary,
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.error,
      buttonColor: AppColors.primary,
      splashColor: AppColors.lightPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        disabledBackgroundColor: AppColors.darkGrey,
        disabledForegroundColor: AppColors.white,
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.primary,
        textStyle: TextStyle(color: AppColors.primary, fontSize: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.white, fontSize: 20),
      floatingLabelStyle: TextStyle(color: AppColors.white, fontSize: 20),
      hintStyle: TextStyle(color: AppColors.grey, fontSize: 15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.white, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey1, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    ),
  );
}
