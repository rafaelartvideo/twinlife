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

  static const fightRed = Color(0xFFD64B4B);
  static const disagreementYellow = Color(0xFFE1B23F);
  static const intimacyPink = Color(0xFFE46A92);
  static const cycleGray = Color(0xFF8A8A90);
  static const specialBlue = Color(0xFF4F78C9);
}

abstract final class TwinType {
  static const double title = 14;
  static const double body = 12;
  static const double caption = 10;
  static const double input = 13;
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

    final text = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: text.copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 42,
          height: .95,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          height: 1,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 28,
          height: 1,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          height: 1,
          fontWeight: FontWeight.w600,
          color: TwinColors.ink,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.title,
          fontWeight: FontWeight.w800,
          color: TwinColors.ink,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.body,
          fontWeight: FontWeight.w700,
          color: TwinColors.ink,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.title,
          height: 1.45,
          color: TwinColors.ink,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.body,
          height: 1.4,
          color: TwinColors.muted,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.caption,
          height: 1.35,
          color: TwinColors.muted,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.body,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: TwinColors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TwinColors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.body,
          fontWeight: FontWeight.w700,
          color: TwinColors.mocha,
        ),
        floatingLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.body,
          fontWeight: FontWeight.w800,
          color: TwinColors.burgundy,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: TwinType.body,
          color: TwinColors.muted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: TwinColors.sand.withValues(alpha: .8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: TwinColors.burgundy,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
