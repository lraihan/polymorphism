import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bgDark = Color(0xFF1A1F2B);
  static const Color glassSurface = Color(0x1AFFFFFF); // 10% white
  static const Color moonGlow = Color(0xFFE6B980);
  static const Color textPrimary = Color(0xFFF1F1F1);
  static const Color accent = Color(0xFF4E9AF1);
}

class AppSpacing {
  static const double base = 8;
  static const double xs = base * 0.5; // 4
  static const double sm = base * 1.0; // 8
  static const double md = base * 2.0; // 16
  static const double lg = base * 3.0; // 24
  static const double xl = base * 4.0; // 32
  static const double xxl = base * 6.0; // 48
  static const double xxxl = base * 8.0; // 64
}

class AppMotion {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
}

class AppTheme {
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.moonGlow,
      surface: AppColors.bgDark,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.bgDark,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgDark,

      textTheme: TextTheme(
        displayLarge: GoogleFonts.bebasNeue(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.bebasNeue(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
          color: AppColors.textPrimary,
        ),
        displaySmall: GoogleFonts.bebasNeue(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
          color: AppColors.textPrimary,
        ),

        headlineLarge: GoogleFonts.bebasNeue(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.bebasNeue(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.bebasNeue(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 2,
          color: AppColors.textPrimary,
        ),

        titleLarge: GoogleFonts.inconsolata(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.inconsolata(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.inconsolata(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),

        bodyLarge: GoogleFonts.inconsolata(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inconsolata(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.inconsolata(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: AppColors.textPrimary,
        ),

        labelLarge: GoogleFonts.inconsolata(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.inconsolata(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textPrimary,
        ),
        labelSmall: GoogleFonts.inconsolata(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textPrimary,
        ),
      ),

      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.bebasNeue(fontSize: 24, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.glassSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md)),
      ),
    );
  }
}
