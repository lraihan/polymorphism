import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';

Future<BuildContext> _pumpAt(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData.fromView(tester.view),
      child: const SizedBox(key: Key('probe')),
    ),
  );
  return tester.element(find.byKey(const Key('probe')));
}

void main() {
  group('TypographyTokens', () {
    test('display scale matches the design spec', () {
      expect(TypographyTokens.heroDisplay, 96);
      expect(TypographyTokens.displayXL, 72);
      expect(TypographyTokens.displayL, 56);
      expect(TypographyTokens.displayM, 40);
      expect(TypographyTokens.titleL, 32);
      expect(TypographyTokens.titleM, 24);
      expect(TypographyTokens.titleS, 18);
      expect(TypographyTokens.bodyL, 17);
      expect(TypographyTokens.bodyM, 15);
      expect(TypographyTokens.caption, 13);
      expect(TypographyTokens.mono, 12);
    });

    test('letter spacing tokens match the design spec', () {
      expect(TypographyTokens.trackedWide, 0.15);
      expect(TypographyTokens.trackedTight, -0.02);
      expect(TypographyTokens.trackedNormal, 0);
    });
  });

  group('Spacing', () {
    test('scale matches the design spec', () {
      expect(Spacing.xs, 4);
      expect(Spacing.sm, 8);
      expect(Spacing.md, 16);
      expect(Spacing.lg, 24);
      expect(Spacing.xl, 32);
      expect(Spacing.xxl, 48);
      expect(Spacing.xxxl, 64);
      expect(Spacing.section, 120);
      expect(Spacing.sectionTablet, 80);
      expect(Spacing.sectionMobile, 60);
    });

    test('grid tokens match the design spec', () {
      expect(Spacing.pageMaxWidth, 1280);
      expect(Spacing.pageGutter, 24);
      expect(Spacing.gridGap, 20);
    });
  });

  group('Radii', () {
    test('scale matches the design spec', () {
      expect(Radii.none, 0);
      expect(Radii.xs, 4);
      expect(Radii.sm, 8);
      expect(Radii.md, 12);
      expect(Radii.lg, 16);
      expect(Radii.xl, 24);
      expect(Radii.pill, 100);
      expect(Radii.circle, 9999);
    });
  });

  group('AppColors', () {
    test('background and accent colors have exact ARGB values', () {
      expect(AppColors.deepSpace, const Color(0xFF080810));
      expect(AppColors.accentPrimary, const Color(0xFF00F5C4));
      expect(AppColors.accentGlow, const Color(0x8000F5C4));
      expect(AppColors.accentSubtle, const Color(0x2000F5C4));
    });

    test('glow and subtle variants share the accent RGB channels', () {
      const rgbMask = 0x00FFFFFF;
      expect(AppColors.accentGlow.toARGB32() & rgbMask, AppColors.accentPrimary.toARGB32() & rgbMask);
      expect(AppColors.accentSubtle.toARGB32() & rgbMask, AppColors.accentPrimary.toARGB32() & rgbMask);
    });
  });

  group('AppDurations', () {
    test('values match the motion spec', () {
      expect(AppDurations.instant, const Duration(milliseconds: 100));
      expect(AppDurations.fast, const Duration(milliseconds: 200));
      expect(AppDurations.normal, const Duration(milliseconds: 350));
      expect(AppDurations.slow, const Duration(milliseconds: 500));
      expect(AppDurations.sluggish, const Duration(milliseconds: 800));
      expect(AppDurations.dramatic, const Duration(milliseconds: 1200));
      expect(AppDurations.crawl, const Duration(milliseconds: 2000));
    });
  });

  group('ResponsiveContext', () {
    testWidgets('375px wide is mobile', (tester) async {
      final context = await _pumpAt(tester, 375);
      expect(context.isMobile, isTrue);
      expect(context.isTablet, isFalse);
      expect(context.isDesktopOrWider, isFalse);
      expect(context.breakpoint, Breakpoint.mobile);
      expect(context.responsive(mobile: 1, desktop: 3), 1);
    });

    testWidgets('800px wide is tablet and falls back toward mobile', (tester) async {
      final context = await _pumpAt(tester, 800);
      expect(context.isTablet, isTrue);
      expect(context.isMobile, isFalse);
      expect(context.isDesktopOrWider, isFalse);
      expect(context.breakpoint, Breakpoint.tablet);
      expect(context.responsive(mobile: 1, desktop: 3), 1);
      expect(context.responsive(mobile: 1, tablet: 2, desktop: 3), 2);
    });

    testWidgets('1100px wide is desktop', (tester) async {
      final context = await _pumpAt(tester, 1100);
      expect(context.isDesktop, isTrue);
      expect(context.isDesktopOrWider, isTrue);
      expect(context.isWide, isFalse);
      expect(context.breakpoint, Breakpoint.desktop);
      expect(context.responsive(mobile: 1, desktop: 3), 3);
      expect(context.responsive(mobile: 1, tablet: 2), 2);
    });

    testWidgets('1600px wide is wide and falls back toward desktop', (tester) async {
      final context = await _pumpAt(tester, 1600);
      expect(context.isWide, isTrue);
      expect(context.isDesktop, isFalse);
      expect(context.isDesktopOrWider, isTrue);
      expect(context.breakpoint, Breakpoint.wide);
      expect(context.responsive(mobile: 1, desktop: 3), 3);
      expect(context.responsive(mobile: 1, tablet: 2, desktop: 3, wide: 4), 4);
      expect(context.responsive(mobile: 1), 1);
    });
  });

  group('UnitInterval.subProgress', () {
    test('maps a value inside the window to its relative progress', () {
      expect(0.5.subProgress(0, 1), 0.5);
      expect(0.25.subProgress(0, 1), 0.25);
      expect(0.4.subProgress(0.2, 0.6), closeTo(0.5, 1e-9));
    });

    test('clamps values at or before the window start to 0', () {
      expect(0.1.subProgress(0.2, 0.6), 0);
      expect(0.2.subProgress(0.2, 0.6), 0);
      expect(0.0.subProgress(0.5, 1), 0);
    });

    test('clamps values at or after the window end to 1', () {
      expect(0.9.subProgress(0.2, 0.6), 1);
      expect(0.6.subProgress(0.2, 0.6), 1);
      expect(1.0.subProgress(0, 0.5), 1);
    });
  });
}
