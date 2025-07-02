import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/home/cursor_reveal_hero_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  group('CursorRevealHeroSection', () {
    setUp(() {
      // Initialize VisibilityDetectorController for testing
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    tearDown(() {
      // Reset VisibilityDetectorController after each test
      VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 500);
    });

    testWidgets('renders main headline correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: CursorRevealHeroSection())),
      );

      await tester.pump();

      // Verify headline text is present
      expect(find.text('UNLOCK'), findsOneWidget);
      expect(find.text('Your Brand\'s Personality'), findsOneWidget);
    });

    testWidgets('renders subtitle and CTA button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: CursorRevealHeroSection())),
      );

      await tester.pump();

      // Verify subtitle text
      expect(find.textContaining('I design and develop websites'), findsOneWidget);

      // Verify CTA button is present
      expect(find.text('Explore My Work'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('CTA button triggers callback', (tester) async {
      bool callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: CursorRevealHeroSection(
              onExplorePressed: () {
                callbackTriggered = true;
              },
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the CTA button
      final ctaButton = find.byType(FilledButton);
      expect(ctaButton, findsOneWidget);

      await tester.tap(ctaButton);
      await tester.pump();

      expect(callbackTriggered, isTrue);
    });

    testWidgets('contains background layers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: CursorRevealHeroSection())),
      );

      await tester.pump();

      // Verify Stack structure for layers
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('has proper responsive behavior', (tester) async {
      // Test mobile size
      await tester.binding.setSurfaceSize(const Size(360, 640));

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: CursorRevealHeroSection())),
      );

      await tester.pump();

      // Verify content is still accessible on mobile
      expect(find.text('UNLOCK'), findsOneWidget);
      expect(find.text('Explore My Work'), findsOneWidget);

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('shows scroll indicator on desktop', (tester) async {
      // Set desktop size
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: CursorRevealHeroSection())),
      );

      await tester.pump();

      // Verify scroll indicator text is present on desktop
      expect(find.text('Scroll to explore'), findsOneWidget);

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });
}
