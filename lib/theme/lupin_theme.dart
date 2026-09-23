import 'package:flutter/material.dart';

class LupinTheme {
  // Exact palette from Lupin Electron theme.css
  static const Color bgMain = Color(0xFF090214);
  static const Color bgSidebar = Color(0xF20E041C);
  static const Color bgCard = Color(0xA61A0A30);
  static const Color bgCardHover = Color(0xD92B1050);
  static const Color bgPlayer = Color(0xF7100520);

  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentPinkHover = Color(0xFFF43F5E);
  static const Color accentPinkGlow = Color(0x73EC4899);

  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentPurpleGlow = Color(0x66A855F7);
  static const Color accentViolet = Color(0xFF8B5CF6);

  static const Color borderSubtle = Color(0x2EEC4899);
  static const Color borderGlow = Color(0x73EC4899);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD8B4FE);
  static const Color textMuted = Color(0xFF9333EA);
  static const Color textDim = Color(0xFF6B21A8);

  static const Color statusGreen = Color(0xFF10B981);

  // Background radial gradient from theme.css
  static const RadialGradient bgGradient = RadialGradient(
    center: Alignment(-0.8, -0.8),
    radius: 1.6,
    colors: [
      Color(0xFF290D4F),
      Color(0xFF100424),
      Color(0xFF07010E),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Neon pink-purple linear gradient
  static const LinearGradient neonGradient = LinearGradient(
    colors: [accentPink, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgMain,
      primaryColor: accentPink,
      colorScheme: const ColorScheme.dark(
        primary: accentPink,
        secondary: accentPurple,
        surface: bgCard,
        background: bgMain,
      ),
      fontFamily: 'Segoe UI',
      useMaterial3: true,
    );
  }
}
