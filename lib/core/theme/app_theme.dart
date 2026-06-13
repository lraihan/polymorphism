import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';

/// Application theme — dark only, by design.
///
/// The portfolio has a single visual identity ("Deep Space Elegance");
/// there is deliberately no light mode.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.accentPrimary,
      onPrimary: AppColors.textOnAccent,
      secondary: AppColors.accentSecondary,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.deepSpace,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceCard,
      outline: AppColors.borderSubtle,
      error: AppColors.errorRed,
    );

    final textTheme = TextTheme(
      displayLarge: AppTypography.heroDisplay,
      displayMedium: AppTypography.displayXL,
      displaySmall: AppTypography.displayL,
      headlineLarge: AppTypography.displayM,
      headlineMedium: AppTypography.titleL,
      headlineSmall: AppTypography.titleM,
      titleLarge: AppTypography.titleL,
      titleMedium: AppTypography.titleM,
      titleSmall: AppTypography.titleS,
      bodyLarge: AppTypography.bodyL,
      bodyMedium: AppTypography.bodyM,
      bodySmall: AppTypography.caption,
      labelLarge: AppTypography.mono,
      labelMedium: AppTypography.mono,
      labelSmall: AppTypography.badge,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.deepSpace,
      textTheme: textTheme,

      // Interactions are hand-crafted; suppress Material's defaults.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,

      // Visible, on-brand keyboard focus ring.
      focusColor: AppColors.accentSubtle,

      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),

      dividerTheme: const DividerThemeData(color: AppColors.borderSubtle, thickness: 1, space: 1),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        textStyle: AppTypography.caption.copyWith(color: AppColors.textPrimary),
        waitDuration: AppDurations.normal,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceCard,
        hoverColor: AppColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
        labelStyle: AppTypography.bodyM,
        floatingLabelStyle: AppTypography.caption.copyWith(color: AppColors.textAccent),
        hintStyle: AppTypography.bodyM.copyWith(color: AppColors.textMuted),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.errorRed),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: const BorderSide(color: AppColors.accentPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceMuted,
        contentTextStyle: AppTypography.bodyM.copyWith(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accentPrimary,
        selectionColor: AppColors.accentPrimary.withValues(alpha: 0.25),
        selectionHandleColor: AppColors.accentPrimary,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.borderSubtle),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(Radii.xs),
      ),

      // Cheap insurance: any un-styled text still lands on-palette.
      fontFamily: GoogleFonts.inter().fontFamily,
    );
  }
}
