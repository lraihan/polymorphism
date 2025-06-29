import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/navbar/navbar.dart';

void main() {
  group('Navbar', () {
    testWidgets('renders logo correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: Navbar())));

      await tester.pump();

      // Check that logo is present
      expect(find.text('POLYMORPHISM'), findsOneWidget);
    });

    testWidgets('renders all navigation buttons on desktop', (tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) =>
                    const Scaffold(body: Column(children: [Navbar(), Expanded(child: Text('Home Page'))])),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(theme: AppTheme.darkTheme, routerConfig: router));

      await tester.pump();

      // Check that logo is present
      expect(find.text('POLYMORPHISM'), findsOneWidget);

      // Check that all navigation buttons are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Playground'), findsOneWidget);
      expect(find.text('Case Studies'), findsOneWidget);
      expect(find.text('Timeline'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);

      // Should not show hamburger menu on desktop
      expect(find.byIcon(Icons.menu), findsNothing);

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('shows hamburger menu on mobile', (tester) async {
      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) =>
                    const Scaffold(body: Column(children: [Navbar(), Expanded(child: Text('Home Page'))])),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(theme: AppTheme.darkTheme, routerConfig: router));

      await tester.pump();

      // Check that logo is present
      expect(find.text('POLYMORPHISM'), findsOneWidget);

      // Should show hamburger menu on mobile
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Navigation buttons should not be visible (hidden behind hamburger)
      expect(find.text('Home'), findsNothing);
      expect(find.text('Projects'), findsNothing);

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('navigation works correctly', (tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      String currentRoute = '/';

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              currentRoute = '/';
              return const Scaffold(body: Column(children: [Navbar(), Expanded(child: Text('Home Page'))]));
            },
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) {
              currentRoute = '/projects';
              return const Scaffold(body: Column(children: [Navbar(), Expanded(child: Text('Projects Page'))]));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(theme: AppTheme.darkTheme, routerConfig: router));

      await tester.pump();

      // Initially should be on home page
      expect(find.text('Home Page'), findsOneWidget);
      expect(currentRoute, equals('/'));

      // Tap Projects button with warnIfMissed: false to handle scrolling
      await tester.tap(find.text('Projects'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should navigate to projects page
      expect(find.text('Projects Page'), findsOneWidget);
      expect(currentRoute, equals('/projects'));

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('has proper glass morphism styling', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: Navbar())));

      await tester.pump();

      // Check that BackdropFilter is present for glass effect
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Check that the container has the correct glass surface color
      final containerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == AppColors.glassSurface,
      );
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('hamburger menu opens mobile drawer', (tester) async {
      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) =>
                    const Scaffold(body: Column(children: [Navbar(), Expanded(child: Text('Home Page'))])),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(theme: AppTheme.darkTheme, routerConfig: router));

      await tester.pump();

      // Tap hamburger menu with warnIfMissed: false
      await tester.tap(find.byIcon(Icons.menu), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Check that mobile drawer is open with all navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Playground'), findsOneWidget);
      expect(find.text('Case Studies'), findsOneWidget);
      expect(find.text('Timeline'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });
}
