/// Design tokens for the "Precision in Motion" design language.
///
/// Aesthetic: Deep Space Elegance — observatory instruments, deep-water
/// bioluminescence, precision watchmaking. Dark, confident, alive.
///
/// Every visual constant in the app must come from this file. If a value
/// isn't here, it isn't part of the design system.
library;

import 'package:flutter/material.dart';

/// TYPOGRAPHY TOKENS
///
/// Display face: "Space Grotesk" (primary personality) — hero, section titles.
/// Body face: "Inter" — body copy, descriptions.
/// Utility face: "JetBrains Mono" — labels, code snippets, numbered markers.
class TypographyTokens {
  TypographyTokens._();

  // Display scale
  static const double heroDisplay = 96; // Hero statement text
  static const double displayXL = 72; // Section titles on desktop
  static const double displayL = 56; // Section titles on tablet
  static const double displayM = 40; // Section titles on mobile
  static const double titleL = 32; // Card titles, subsection heads
  static const double titleM = 24; // Project titles
  static const double titleS = 18; // Labels, overlines
  static const double bodyL = 17; // Primary body copy
  static const double bodyM = 15; // Secondary body copy
  static const double caption = 13; // Captions, meta info
  static const double mono = 12; // Utility mono — badges, numbers

  // Letter spacing (em fractions — multiply by font size for px)
  static const double trackedWide = 0.15; // Uppercase labels
  static const double trackedTight = -0.02; // Display text
  static const double trackedNormal = 0; // Body copy
}

/// COLOR PALETTE TOKENS
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color deepSpace = Color(0xFF080810); // Primary bg
  static const Color inkBlack = Color(0xFF0D0D1A); // Secondary bg
  static const Color surfaceCard = Color(0xFF111122); // Card surface
  static const Color surfaceMuted = Color(0xFF16162A); // Muted surface

  // Accent — Bioluminescent Teal
  static const Color accentPrimary = Color(0xFF00F5C4); // Primary accent
  static const Color accentGlow = Color(0x8000F5C4); // 50% accent (glow)
  static const Color accentSubtle = Color(0x2000F5C4); // 12.5% accent (subtle bg)

  // Secondary accent — Deep Violet (used sparingly)
  static const Color accentSecondary = Color(0xFF7B5CF0);
  static const Color accentVioletGlow = Color(0x407B5CF0); // 25% violet

  // Text
  static const Color textPrimary = Color(0xFFF0F0FF); // Primary text
  static const Color textSecondary = Color(0xFF9090B0); // Secondary / subdued
  static const Color textMuted = Color(0xFF505070); // Muted / placeholders
  static const Color textAccent = Color(0xFF00F5C4); // Accent text
  static const Color textOnAccent = Color(0xFF06120E); // Dark text on accent fills

  // Glass / Border
  static const Color borderSubtle = Color(0xFF252540); // Subtle borders
  static const Color borderActive = Color(0x4000F5C4); // Active borders (25% teal)
  static const Color glassWhite = Color(0x0FFFFFFF); // Glass surface base

  // Semantic
  static const Color successGreen = Color(0xFF00C896);
  static const Color warningAmber = Color(0xFFFFB347);
  static const Color errorRed = Color(0xFFFF5B5B);
}

/// SPACING TOKENS
class Spacing {
  Spacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
  static const double section = 120; // Between major sections (desktop)
  static const double sectionTablet = 80; // Between major sections (tablet)
  static const double sectionMobile = 60; // Between major sections (mobile)

  // Grid
  static const double pageMaxWidth = 1280;
  static const double pageGutter = 24;
  static const double gridGap = 20;
}

/// RADIUS TOKENS
class Radii {
  Radii._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 100;
  static const double circle = 9999;
}

/// DURATION TOKENS
///
/// Named `AppDurations` (not `Durations` as in the original spec) because
/// Flutter's Material library already exports a `Durations` class and the
/// collision would force import hiding at every call site.
class AppDurations {
  AppDurations._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration sluggish = Duration(milliseconds: 800);
  static const Duration dramatic = Duration(milliseconds: 1200);
  static const Duration crawl = Duration(milliseconds: 2000);
}

/// MOTION TOKENS — the only easing curves the app may use.
///
/// `Curves.linear` is intentionally absent: per the design brief it is never
/// used unless a continuous loop (marquee, orbit) genuinely calls for it.
class AppCurves {
  AppCurves._();

  /// Default enter — fast start, gentle settle.
  static const Curve enter = Curves.easeOutCubic;

  /// Default exit — gentle start, fast finish.
  static const Curve exit = Curves.easeInCubic;

  /// Emphasized hero/intro movement.
  static const Curve dramatic = Cubic(0.16, 1, 0.3, 1); // easeOutExpo-like

  /// Springy settle for cursor ring, tilt release.
  static const Curve spring = Curves.easeOutBack;

  /// Both-ways travel (curtains, morphs).
  static const Curve travel = Curves.easeInOutCubic;
}
