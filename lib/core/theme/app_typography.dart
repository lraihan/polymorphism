import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';

/// Named text style factory.
///
/// Three faces, three jobs:
/// - Space Grotesk — display: hero statements, section titles, card titles.
/// - Inter — body: descriptions, paragraphs, form fields.
/// - JetBrains Mono — utility: eyebrow labels, section numbers, badges.
///
/// Letter spacing tokens are em fractions, so they are multiplied by the
/// font size here to produce the logical-pixel values Flutter expects.
class AppTypography {
  AppTypography._();

  // ── Display (Space Grotesk) ────────────────────────────────────────────

  static TextStyle get heroDisplay => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.heroDisplay,
    fontWeight: FontWeight.w700,
    letterSpacing: TypographyTokens.heroDisplay * TypographyTokens.trackedTight,
    height: 0.98,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayXL => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.displayXL,
    fontWeight: FontWeight.w700,
    letterSpacing: TypographyTokens.displayXL * TypographyTokens.trackedTight,
    height: 1.02,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayL => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.displayL,
    fontWeight: FontWeight.w700,
    letterSpacing: TypographyTokens.displayL * TypographyTokens.trackedTight,
    height: 1.05,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayM => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.displayM,
    fontWeight: FontWeight.w700,
    letterSpacing: TypographyTokens.displayM * TypographyTokens.trackedTight,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleL => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.titleL,
    fontWeight: FontWeight.w600,
    letterSpacing: TypographyTokens.titleL * TypographyTokens.trackedTight,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleM => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.titleM,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleS => GoogleFonts.spaceGrotesk(
    fontSize: TypographyTokens.titleS,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ── Body (Inter) ───────────────────────────────────────────────────────

  static TextStyle get bodyL => GoogleFonts.inter(
    fontSize: TypographyTokens.bodyL,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyM => GoogleFonts.inter(
    fontSize: TypographyTokens.bodyM,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: TypographyTokens.caption,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );

  // ── Utility (JetBrains Mono) ───────────────────────────────────────────

  /// Eyebrow labels and section numbers — `02 / WORKS`.
  static TextStyle get mono => GoogleFonts.jetBrainsMono(
    fontSize: TypographyTokens.mono,
    fontWeight: FontWeight.w500,
    letterSpacing: TypographyTokens.mono * TypographyTokens.trackedWide,
    height: 1.4,
    color: AppColors.textMuted,
  );

  /// Accent variant of [mono] for active markers.
  static TextStyle get monoAccent => mono.copyWith(color: AppColors.textAccent);

  /// Small mono for tech badges and meta chips.
  static TextStyle get badge => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 11 * 0.08,
    height: 1.3,
    color: AppColors.textSecondary,
  );
}
