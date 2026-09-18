import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF080F0E);
  static const surface = Color(0xFF131B19);
  static const elevated = Color(0xFF202926);
  static const border = Color(0xFF27312D);
  static const green = Color(0xFF00DB75);
  static const lime = Color(0xFF46F67C);
  static const text = Color(0xFFF6F8F7);
  static const muted = Color(0xFF858C89);
  static const red = Color(0xFFFF4C52);
}

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.green,
      secondary: AppColors.lime,
      surface: AppColors.surface,
      onSurface: AppColors.text,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.text, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.muted, fontSize: 12),
      titleLarge: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w900,
        letterSpacing: -.6,
      ),
    ),
    dividerColor: AppColors.border,
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: .5,
    ),
    splashFactory: InkRipple.splashFactory,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      modalBackgroundColor: AppColors.surface,
      showDragHandle: true,
      dragHandleColor: AppColors.muted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.green),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
    ),
  );
}
