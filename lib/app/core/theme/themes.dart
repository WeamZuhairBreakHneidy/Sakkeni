import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';



class AppTheme {
  static const String primaryFont = 'Inter';
  static const String secondaryFont = 'Poppins';

  // Define light theme
  static ThemeData get lightTheme {

    return ThemeData(

      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: secondaryFont,
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 24.r,  color: AppColors.white),
        headlineMedium: TextStyle(fontSize: 28.r, fontWeight: FontWeight.w600, color: AppColors.primary),
        bodyLarge: TextStyle(fontSize: 18.r, color: AppColors.primary),
        bodyMedium: TextStyle(fontSize: 16.r, color: AppColors.primary),
        bodySmall: TextStyle(fontSize: 14.r, color: AppColors.secondary.withOpacity(0.7)),
        labelLarge: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        elevation: 2,
        iconTheme: IconThemeData(color: AppColors.surface),
        titleTextStyle: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, color: AppColors.surface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          textStyle: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        shadowColor: AppColors.primary.withOpacity(0.2),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary, width: 2.w)),
        labelStyle: TextStyle(color: AppColors.primary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: TextStyle(color: AppColors.surface),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        titleTextStyle: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, color: AppColors.primary),
        contentTextStyle: TextStyle(fontSize: 16.r, color: AppColors.primary),
      ),
    );
  }

  // Define dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: primaryFont,
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 32.r, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 28.r, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 18.r, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 16.r, color: AppColors.secondary),
        bodySmall: TextStyle(fontSize: 14.r, color: AppColors.secondary.withOpacity(0.7)),
        labelLarge: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          textStyle: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface.withOpacity(0.1),
        shadowColor: AppColors.primary.withOpacity(0.4),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary, width: 2.w)),
        labelStyle: TextStyle(color: AppColors.primary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        titleTextStyle: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: TextStyle(fontSize: 16.r, color: Colors.white),
      ),
    );
  }
}
