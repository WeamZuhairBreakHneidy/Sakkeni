import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class AppTheme {
  static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Inter';

  // Define light theme
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.orange, // Text color on background
        onSurface: AppColors.primary, // Text color on surface/card
      ),
      dividerColor: AppColors.surface,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: primaryFont,
      textTheme: TextTheme(
        // Text on a dark background (like AppBar)
        headlineLarge: TextStyle(fontSize: 24.r, color: AppColors.white),
        headlineMedium: TextStyle(fontSize: 22.r, fontWeight: FontWeight.w600, color: AppColors.white),
        // Text on a light background
        bodyLarge: TextStyle(fontSize: 18.r, color: AppColors.primary),
        bodyMedium: TextStyle(fontSize: 16.r, color: AppColors.primary),
        titleMedium: TextStyle(fontSize: 14.r, color: AppColors.background, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 12.r, color: AppColors.background, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12.r, color: AppColors.background, fontWeight: FontWeight.w400), // Note: This is for a dark background
        labelLarge: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, color: AppColors.primary),
        labelSmall: TextStyle(fontSize: 10.r, color: AppColors.primary),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        elevation: 2,
        iconTheme: IconThemeData(color: AppColors.surface),
        titleTextStyle: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, color: AppColors.surface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.responsiveButtonColor,
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
        surface: Colors.black54, // Darker surface for contrast
        onSurface: Colors.white, // Text color on dark background
      ),
      dividerColor: Colors.white.withOpacity(0.2),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: primaryFont,
      textTheme: TextTheme(
        // Text on a dark background
        headlineLarge: TextStyle(fontSize: 24.r, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 22.r, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 18.r, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 16.r, color: Colors.white70), // Softer white for less emphasis
        titleMedium: TextStyle(fontSize: 14.r, color: Colors.white, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 12.r, color: Colors.white70, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12.r, color: Colors.white70, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, color: AppColors.primary), // Use primary for a specific color
        labelSmall: TextStyle(fontSize: 10.r, color: AppColors.white),
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
          foregroundColor: Colors.white,
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
        color: Colors.black54,
        shadowColor: AppColors.primary.withOpacity(0.4),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black54,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary, width: 2.w)),
        labelStyle: TextStyle(color: Colors.white),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        titleTextStyle: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: TextStyle(fontSize: 16.r, color: Colors.white),
      ),
    );
  }
}