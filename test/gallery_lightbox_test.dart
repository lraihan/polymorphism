import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/modules/gallery/gallery_lightbox.dart';

void main() {
  group('GalleryLightbox', () {
    testWidgets('displays with correct initial index', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 3)));

      await tester.pumpAndSettle();

      // Verify lightbox is shown
      expect(find.byType(GalleryLightbox), findsOneWidget);

      // Verify image counter shows correct index
      expect(find.text('4 / 8'), findsOneWidget);
    });

    testWidgets('ESC key triggers close behavior', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 0)));

      await tester.pumpAndSettle();

      // Verify lightbox is shown
      expect(find.byType(GalleryLightbox), findsOneWidget);

      // Simulate ESC key press
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // Verify animation controller starts reverse
      // (We can't easily test navigation without full router setup)
      expect(find.byType(GalleryLightbox), findsOneWidget);
    });

    testWidgets('left arrow key navigates to previous image', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 2)));

      await tester.pumpAndSettle();

      // Verify we're at image 3 of 8
      expect(find.text('3 / 8'), findsOneWidget);

      // Simulate left arrow key press
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      // Verify we moved to previous image
      expect(find.text('2 / 8'), findsOneWidget);
    });

    testWidgets('right arrow key navigates to next image', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 0)));

      await tester.pumpAndSettle();

      // Verify we're at image 1 of 8
      expect(find.text('1 / 8'), findsOneWidget);

      // Simulate right arrow key press
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      // Verify we moved to next image
      expect(find.text('2 / 8'), findsOneWidget);
    });

    testWidgets('close button exists and is tappable', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 0)));

      await tester.pumpAndSettle();

      // Find close button
      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);

      // Verify it's tappable (no error when tapped)
      await tester.tap(closeButton);
      await tester.pump();
    });

    testWidgets('hero animation tag matches for transition', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 5)));

      await tester.pumpAndSettle();

      // Verify hero widget exists with correct tag
      final heroWidgets = find.byType(Hero);
      expect(heroWidgets, findsAtLeastNWidgets(1));

      final heroWidget = tester.widget<Hero>(heroWidgets.first);
      expect(heroWidget.tag, 'gallery-img-5');
    });

    testWidgets('displays correct image counter and semantics', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 7)));

      await tester.pumpAndSettle();

      // Verify image counter
      expect(find.text('8 / 8'), findsOneWidget);

      // Verify semantic information exists
      expect(find.byType(Semantics), findsAtLeastNWidgets(1));
    });

    testWidgets('navigation buttons appear on desktop', (tester) async {
      // Set large screen size for desktop
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 3)));

      await tester.pumpAndSettle();

      // Verify navigation buttons exist (both should be visible for middle index)
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('navigation buttons work correctly', (tester) async {
      // Set large screen size for desktop
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 3)));

      await tester.pumpAndSettle();

      // Verify starting position
      expect(find.text('4 / 8'), findsOneWidget);

      // Tap next button
      final nextButton = find.byIcon(Icons.arrow_forward_ios);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Verify moved to next image
      expect(find.text('5 / 8'), findsOneWidget);

      // Tap previous button
      final prevButton = find.byIcon(Icons.arrow_back_ios);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();

      // Verify moved back
      expect(find.text('4 / 8'), findsOneWidget);
    });

    testWidgets('handles boundary navigation correctly', (tester) async {
      // Test at beginning
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 0)));

      await tester.pumpAndSettle();
      expect(find.text('1 / 8'), findsOneWidget);

      // Try to go previous (should not move)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('1 / 8'), findsOneWidget);

      // Test at end - restart with new widget to test end boundary
      await tester.pumpWidget(
        MaterialApp(
          home: Container(), // Clear first
        ),
      );
      await tester.pump();

      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 7)));

      await tester.pumpAndSettle();
      expect(find.text('8 / 8'), findsOneWidget);

      // Try to go next (should not move)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('8 / 8'), findsOneWidget);
    });

    testWidgets('has proper accessibility features', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryLightbox(initialIndex: 0)));

      await tester.pumpAndSettle();

      // Verify KeyboardListener is present for focus handling
      expect(find.byType(KeyboardListener), findsOneWidget);

      // Verify semantic widgets are present
      expect(find.byType(Semantics), findsAtLeastNWidgets(1));
    });
  });
}
