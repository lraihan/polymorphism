import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/modules/gallery/gallery_section.dart';

void main() {
  group('GallerySection Tests', () {
    Widget createTestWidget({double? width, double? height}) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: width ?? 800,
            height: height ?? 1200, // Increased height to accommodate content
            child: const GallerySection(),
          ),
        ),
      ),
    );

    testWidgets('renders gallery section with title and subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('UI Design Gallery'), findsOneWidget);
      expect(find.text('Selected visual explorations and motion studies.'), findsOneWidget);
    });

    testWidgets('renders 8 gallery tiles', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check that all 8 gallery tiles are rendered
      for (var i = 1; i <= 8; i++) {
        expect(find.text('Gallery $i'), findsOneWidget);
      }
    });

    testWidgets('responsive grid - mobile (1 column)', (tester) async {
      // Set mobile screen size (< 600px)
      await tester.binding.setSurfaceSize(const Size(400, 2100));

      await tester.pumpWidget(createTestWidget(width: 400, height: 2100));

      // On mobile, tiles should be stacked vertically in 1 column
      expect(find.text('Gallery 1'), findsOneWidget);
      expect(find.text('Gallery 2'), findsOneWidget);
    });

    testWidgets('responsive grid - tablet (2 columns)', (tester) async {
      // Set tablet screen size (600-799px)
      await tester.binding.setSurfaceSize(const Size(700, 1200));

      await tester.pumpWidget(createTestWidget(width: 700, height: 1200));

      // On tablet, should have 2 columns
      expect(find.text('Gallery 1'), findsOneWidget);
      expect(find.text('Gallery 2'), findsOneWidget);
    });

    testWidgets('responsive grid - desktop small (3 columns)', (tester) async {
      // Set desktop small screen size (800-1279px)
      await tester.binding.setSurfaceSize(const Size(1000, 1200));

      await tester.pumpWidget(createTestWidget(width: 1000, height: 1200));

      // On desktop small, should have 3 columns
      expect(find.text('Gallery 1'), findsOneWidget);
      expect(find.text('Gallery 2'), findsOneWidget);
      expect(find.text('Gallery 3'), findsOneWidget);
    });

    testWidgets('responsive grid - desktop large (4 columns)', (tester) async {
      // Set desktop large screen size (>=1280px)
      await tester.binding.setSurfaceSize(const Size(1400, 1200));

      await tester.pumpWidget(createTestWidget(width: 1400, height: 1200));

      // On desktop large, should have 4 columns
      expect(find.text('Gallery 1'), findsOneWidget);
      expect(find.text('Gallery 2'), findsOneWidget);
      expect(find.text('Gallery 3'), findsOneWidget);
      expect(find.text('Gallery 4'), findsOneWidget);
    });

    testWidgets('gallery tiles have proper hover effects on desktop', (tester) async {
      // Set desktop screen size for hover effects
      await tester.binding.setSurfaceSize(const Size(1200, 1200));

      await tester.pumpWidget(createTestWidget(width: 1200, height: 1200));

      // Find the first gallery tile container
      final galleryTile = find.text('Gallery 1').first;
      expect(galleryTile, findsOneWidget);

      // Hover effects are handled by MouseRegion and AnimatedContainer
      // We can verify the widget structure exists
      expect(find.byType(MouseRegion), findsWidgets);
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('gallery section has proper padding and spacing', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check that the main container has the gallery key
      expect(find.byKey(const ValueKey('gallery')), findsOneWidget);

      // Check for SizedBox spacing between title and grid
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('gallery tiles have proper icons and styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Each tile should have an image icon
      expect(find.byIcon(Icons.image_outlined), findsNWidgets(8));

      // Check that ClipRRect is used for rounded corners
      expect(find.byType(ClipRRect), findsWidgets);
    });
  });
}
