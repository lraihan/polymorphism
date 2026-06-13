import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/responsive.dart';

/// Cross-cutting convenience extensions.
extension PortfolioContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// True when the OS asks for reduced motion — every non-essential
  /// animation must check this.
  bool get reducedMotion => MediaQuery.disableAnimationsOf(this);

  /// True when a fine pointer (mouse) drives the experience: web desktop.
  /// Gates the custom cursor, hover tilt, and magnetic effects.
  bool get supportsHover => kIsWeb && !isMobile;

  /// Horizontal padding for page content at the current breakpoint.
  double get pageGutter => responsive(mobile: Spacing.md, tablet: Spacing.xl, desktop: Spacing.xxl);

  /// Vertical padding between major sections at the current breakpoint.
  double get sectionSpacing =>
      responsive(mobile: Spacing.sectionMobile, tablet: Spacing.sectionTablet, desktop: Spacing.section);
}

/// Small numeric helpers used by scroll-driven animation math.
extension UnitInterval on double {
  /// Re-maps this 0–1 value to the 0–1 progress within [start]–[end].
  double subProgress(double start, double end) => ((this - start) / (end - start)).clamp(0.0, 1.0);
}
