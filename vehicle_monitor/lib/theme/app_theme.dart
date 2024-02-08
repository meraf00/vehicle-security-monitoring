import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract class AppTheme {
  /// Theme data for the app
  ///
  /// This theme data is used in [App] widget
  static final themeData = ThemeData(
    // Color Palette
    colorScheme: const ColorScheme(
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      secondary: AppColors.darkerBlue,
      onSecondary: AppColors.white,
      background: AppColors.gray100,
      onBackground: AppColors.darkBlue,
      surface: AppColors.gray200,
      onSurface: AppColors.darkBlue,
      error: AppColors.red,
      onError: AppColors.white,
      brightness: Brightness.light,
    ),

    // Text Theme
    textTheme: const TextTheme(
      // Headings
      titleMedium: TextStyle(
        color: AppColors.darkerBlue,
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.darkerBlue,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      // Body
      bodySmall: TextStyle(
        color: AppColors.darkBlue,
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.darkBlue,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      displayLarge: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 24,
        fontFamily: 'Poppins',
        color: AppColors.darkBlue,
      ),

      displayMedium: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        fontFamily: 'Poppins',
        color: AppColors.darkBlue,
      ),

      // Caption
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.darkGray,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    ),

    // Elevated Button theme
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
    ),

    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(AppColors.gray200),
        foregroundColor: const MaterialStatePropertyAll(AppColors.gray300),
        alignment: Alignment.center,
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(11),
            ),
          ),
        ),
      ),
    ),

    // Popup menu theme
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.gray100,
      textStyle: TextStyle(
        color: AppColors.darkBlue,
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) => Container(
        width: 36.h,
        height: 36.h,
        decoration: const BoxDecoration(
          color: AppColors.gray200,
          borderRadius: BorderRadius.all(
            Radius.circular(11),
          ),
        ),
        child: const Icon(Icons.chevron_left, color: AppColors.gray300),
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.darkBlue,
    ),
  );
}
