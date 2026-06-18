library lucide_icons;

import 'package:flutter/widgets.dart';

// Vendored + trimmed copy of lucide_icons_flutter 3.1.10.
//
// Why this exists:
//   * 3.1.10 is the last release that still ships the github/figma/linkedin
//     brand glyphs (removed upstream in 3.1.12).
//   * Upstream declared icons as `LucideIconData extends IconData`, which no
//     longer compiles now that Flutter's IconData is a `final` class. Each icon
//     below is therefore a plain `const IconData(...)` instead.
//
// Only the icons actually referenced by the app are kept, so Flutter's font
// subsetter ships ~25KB instead of the full 704KB Lucide font. (The icon
// tree-shaker keeps every *defined* IconData, so trimming the definitions is
// what trims the font.)
//
// To add another Lucide icon:
//   1. Find its code point in the full glyph list at
//      https://pub.dev/packages/lucide_icons_flutter (or the 3.1.10 source).
//   2. Add a line below following the same pattern, e.g.
//      `static const IconData name = IconData(<codePoint>, fontFamily: 'Lucide',`
//      `fontPackage: 'lucide_icons_flutter');`
//   3. Reference it as `LucideIcons.name`. The subsetter picks it up on rebuild.

/// Lucide icons used by this project. See the header note above to add more.
class LucideIcons {
  const LucideIcons._();

  /// arrow-down-right
  static const IconData arrowDownRight = IconData(57413, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// arrow-right
  static const IconData arrowRight = IconData(57417, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// arrow-up-right
  static const IconData arrowUpRight = IconData(57421, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// check-check
  static const IconData checkCheck = IconData(58254, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// chevron-left
  static const IconData chevronLeft = IconData(57454, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// chevron-right
  static const IconData chevronRight = IconData(57455, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// circle-alert
  static const IconData circleAlert = IconData(57463, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// code
  static const IconData code = IconData(57491, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// figma
  static const IconData figma = IconData(57535, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// frame
  static const IconData frame = IconData(58001, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// gauge
  static const IconData gauge = IconData(57791, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// github
  static const IconData github = IconData(57574, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// heart
  static const IconData heart = IconData(57586, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// layers
  static const IconData layers = IconData(58665, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// layout-dashboard
  static const IconData layoutDashboard = IconData(57793, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// linkedin
  static const IconData linkedin = IconData(57605, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// mail
  static const IconData mail = IconData(57615, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// menu
  static const IconData menu = IconData(57621, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// palette
  static const IconData palette = IconData(57821, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// pen-tool
  static const IconData penTool = IconData(57649, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// plus
  static const IconData plus = IconData(57661, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// pointer
  static const IconData pointer = IconData(57832, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// smartphone
  static const IconData smartphone = IconData(57699, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// sparkles
  static const IconData sparkles = IconData(58386, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');

  /// x
  static const IconData x = IconData(57778, fontFamily: 'Lucide', fontPackage: 'lucide_icons_flutter');
}
