import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  group('ScrollReveal', () {
    setUp(() {
      // Initialize VisibilityDetectorController for testing
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('renders child widget correctly', (tester) async {
      const testChild = Text('Test Content');

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ScrollReveal(child: testChild))));

      expect(find.text('Test Content'), findsOneWidget);

      // Complete any pending animations and timers
      await tester.pumpAndSettle();
    });

    testWidgets('starts with 0 opacity and animates to 1 when visible', (tester) async {
      const testChild = Text('Test Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 1000), // Push content below fold
                  ScrollReveal(
                    key: const ValueKey('scroll-reveal-scroll-test'),
                    duration: const Duration(milliseconds: 300),
                    child: testChild,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Find the Opacity widget
      final opacityFinder = find.descendant(
        of: find.byKey(const ValueKey('scroll-reveal-scroll-test')),
        matching: find.byType(Opacity),
      );

      // Initially should be invisible (opacity 0)
      expect(opacityFinder, findsOneWidget);
      final initialOpacity = tester.widget<Opacity>(opacityFinder).opacity;
      expect(initialOpacity, equals(0.0));

      // Scroll to make the widget visible
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      // Trigger visibility detection
      await tester.pump();

      // Should start animating
      await tester.pump(const Duration(milliseconds: 150));
      final midOpacity = tester.widget<Opacity>(opacityFinder).opacity;
      expect(midOpacity, greaterThan(0.0));

      // Complete animation
      await tester.pumpAndSettle();
      final finalOpacity = tester.widget<Opacity>(opacityFinder).opacity;
      expect(finalOpacity, equals(1.0));
    });

    testWidgets('respects MediaQuery.disableAnimations', (tester) async {
      const testChild = Text('Test Content');

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(body: ScrollReveal(key: const ValueKey('scroll-reveal-accessibility'), child: testChild)),
          ),
        ),
      );

      // Find the Opacity widget
      final opacityFinder = find.descendant(
        of: find.byKey(const ValueKey('scroll-reveal-accessibility')),
        matching: find.byType(Opacity),
      );

      // Should immediately be at full opacity when animations are disabled
      expect(opacityFinder, findsOneWidget);
      final opacity = tester.widget<Opacity>(opacityFinder).opacity;
      expect(opacity, equals(1.0));
    });

    testWidgets('applies staggered delay correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ScrollReveal(
                  key: ValueKey('reveal-first'),
                  delay: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 300),
                  child: Text('First'),
                ),
                ScrollReveal(
                  key: ValueKey('reveal-second'),
                  delay: Duration(milliseconds: 200),
                  duration: Duration(milliseconds: 300),
                  child: Text('Second'),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify widgets are rendered
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);

      // Check if keys are unique
      expect(find.byKey(const ValueKey('reveal-first')), findsOneWidget);
      expect(find.byKey(const ValueKey('reveal-second')), findsOneWidget);

      // Complete any pending animations
      await tester.pumpAndSettle();
    });
  });
}
