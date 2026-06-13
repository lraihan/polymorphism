import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polymorphism/core/router/app_router.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Full-composition smoke test: the real router + shell (intro, hero, all six
/// sections, floating nav, section rail, noise, custom cursor) pumped at
/// desktop and mobile. Asserts the whole tree builds and lays out with no
/// exception — the integration counterpart to the per-section smoke tests.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  Widget app() => MaterialApp.router(theme: AppTheme.dark, routerConfig: AppRouter.router);

  for (final size in const [Size(1440, 900), Size(390, 800)]) {
    testWidgets('PortfolioShell builds at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(app());
      // Walk through the intro counter and entrance choreography with fixed
      // frames (perpetual tickers mean we must never pumpAndSettle).
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 400));
      }

      expect(tester.takeException(), isNull);
    });
  }
}
