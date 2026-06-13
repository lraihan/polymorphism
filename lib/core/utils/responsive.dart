import 'package:flutter/material.dart';

/// Layout breakpoints.
///
/// mobile  < 768  ·  tablet 768–1023  ·  desktop 1024–1439  ·  wide ≥ 1440
enum Breakpoint { mobile, tablet, desktop, wide }

/// Breakpoint helpers, available on any [BuildContext].
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < 768;
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024 && screenWidth < 1440;
  bool get isWide => screenWidth >= 1440;

  /// True for tablet and up — handy for "not mobile" layouts.
  bool get isDesktopOrWider => screenWidth >= 1024;

  Breakpoint get breakpoint {
    if (isMobile) {
      return Breakpoint.mobile;
    }
    if (isTablet) {
      return Breakpoint.tablet;
    }
    if (isDesktop) {
      return Breakpoint.desktop;
    }
    return Breakpoint.wide;
  }

  /// Picks the value for the current breakpoint, falling back toward mobile.
  ///
  /// `context.responsive(mobile: 40, desktop: 96)` → tablet gets 40,
  /// wide gets 96.
  T responsive<T>({required T mobile, T? tablet, T? desktop, T? wide}) {
    switch (breakpoint) {
      case Breakpoint.wide:
        return wide ?? desktop ?? tablet ?? mobile;
      case Breakpoint.desktop:
        return desktop ?? tablet ?? mobile;
      case Breakpoint.tablet:
        return tablet ?? mobile;
      case Breakpoint.mobile:
        return mobile;
    }
  }
}
