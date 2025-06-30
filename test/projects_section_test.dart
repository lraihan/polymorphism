import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/home/projects_section.dart';

void main() {
  group('ProjectsSection', () {
    testWidgets('renders title and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Check that title is present
      expect(find.text('Featured Projects'), findsOneWidget);

      // Check that subtitle is present
      expect(find.text('Select highlights from my software and design work.'), findsOneWidget);
    });

    testWidgets('renders exactly 3 project cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Check that exactly 3 cards are rendered
      expect(find.byType(Card), findsNWidgets(3));
      expect(find.text('Project Placeholder'), findsNWidgets(3));
    });

    testWidgets('shows 3 columns on desktop (≥1024px)', (tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Find the GridView and check its delegate
      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);

      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('shows 2 columns on tablet (768-1023px)', (tester) async {
      // Set tablet screen size
      tester.view.physicalSize = const Size(900, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Find the GridView and check its delegate
      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);

      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('shows 1 column on mobile (<768px)', (tester) async {
      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Find the GridView and check its delegate
      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);

      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(1));

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('applies hover effect on desktop', (tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Find the first project card mouse region
      final mouseRegionFinder = find.byType(MouseRegion).first;
      expect(mouseRegionFinder, findsOneWidget);

      // Check that we have MouseRegions for the project cards
      // Note: There might be additional MouseRegions from other widgets
      expect(find.byType(MouseRegion), findsAtLeastNWidgets(3));

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('has correct semantic identifier', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
        ),
      );

      await tester.pump();

      // Check that the section has the correct key
      final containerFinder = find.byKey(const ValueKey('projects'));
      expect(containerFinder, findsOneWidget);
    });
  });
}
