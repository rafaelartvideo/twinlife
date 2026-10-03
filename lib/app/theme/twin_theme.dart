import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class TwinColors {
  static const ivory = Color(0xFFFAF7F1);
  static const sand = Color(0xFFE7D8C4);
  static const mocha = Color(0xFFA78B7F);
  static const terracotta = Color(0xFFC96F56);
  static const burgundy = Color(0xFF7A1E2D);
  static const softGold = Color(0xFFD4B483);
  static const ink = Color(0xFF2E2423);
  static const muted = Color(0xFF776967);
  static const white = Color(0xFFFFFFFF);
}

abstract final class TwinTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: TwinColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TwinColors.burgundy,
        brightness: Brightness.light,
        surface: TwinColors.ivory,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 48,
          height: .92,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 38,
          height: 1,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 27,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: TwinColors.ink,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          height: 1.5,
          color: TwinColors.ink,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          height: 1.45,
          color: TwinColors.muted,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: TwinColors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TwinColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: TwinColors.sand.withValues(alpha: .7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: TwinColors.burgundy, width: 1.4),
        ),
      ),
    );
  }
}
