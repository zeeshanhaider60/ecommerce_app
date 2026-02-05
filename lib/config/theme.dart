import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontFamily: 'Roboto',
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      ),
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFF1C1B1F),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1C1B1F),
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
