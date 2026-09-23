import 'package:flutter/material.dart';

class LupinTheme {
  static const Color background = Color(0FF090214);
  static const Color surface = Color(0FF130B24);
  static const Color surfaceLight = Color(0FF1E1238);
  static const Color neonPink = Color(0FFEC4899);
  static const Color neonPurple = Color(0FFA855F7);
  static const Color neonCyan = Color(0FF06B6D4);
  static const Color textPrimary = Color(0FFF8FAFC);
  static const Color textSecondary = Color(0FF94A3B8);
  static const Color glassBorder = Color(0x33A855F7);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: neonPink,
      colorScheme: const ColorScheme.dark(
        primary: neonPink,
        secondary: neonPurple,
        surface: surface,
        background: background,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: const TextStyle(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static BoxDecoration glassDecoration({double radius = 16.0}) {
    return BoxDecoration(
      color: surface.withOpacity(0.7),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: glassBorder, width: 1.0),
      boxShadow: [
        BoxShadow(
          color: neonPurple.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: -5,
        )
      ],
    );
  }
}
