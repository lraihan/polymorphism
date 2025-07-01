import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/router/app_routes.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/home/hero_section.dart';

void main() {
  group('HeroSection', () {
    testWidgets('renders headline text correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: HeroSection())));

      await tester.pump();

      // Verify headline text is present
      expect(find.text('I craft fluid interfaces\nthat behave.'), findsOneWidget);

      // Verify it uses displayLarge style
      final textWidget = tester.widget<Text>(find.text('I craft fluid interfaces\nthat behave.'));
      expect(textWidget.style?.fontSize, AppTheme.darkTheme.textTheme.displayLarge?.fontSize);
    });

    testWidgets('renders CTA button with correct label', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: HeroSection())));

      await tester.pump();

      // Verify CTA button is present
      expect(find.text('Explore Projects'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('CTA button navigates to projects route', (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const Scaffold(body: HeroSection())),
          GoRoute(
            path: AppRoutes.projectsPath,
            builder: (context, state) {
              navigatedRoute = AppRoutes.projectsPath;
              return const Scaffold(body: Text('Projects Page'));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(theme: AppTheme.darkTheme, routerConfig: router));

      await tester.pump();

      // Find and tap the CTA button
      final ctaButton = find.text('Explore Projects');
      expect(ctaButton, findsOneWidget);

      await tester.tap(ctaButton);
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(navigatedRoute, equals(AppRoutes.projectsPath));
    });

    testWidgets('has proper accessibility semantics', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: HeroSection())));

      await tester.pump();

      // Check headline semantics
      final headlineSemantics = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.header ?? false) == true,
      );
      expect(headlineSemantics, findsOneWidget);

      // Check button semantics
      final buttonSemantics = find.byWidgetPredicate((widget) => widget is FilledButton);
      expect(buttonSemantics, findsOneWidget);
    });

    testWidgets('applies parallax effect on desktop layout', (tester) async {
      // Set up a desktop-sized widget
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: HeroSection())));

      await tester.pump();

      // On desktop size (width > 800), MouseRegion should be present for parallax
      final mouseRegions = find.byType(MouseRegion);
      expect(mouseRegions, findsWidgets);

      // Verify parallax components are present
      expect(find.byType(Positioned), findsWidgets);
      expect(find.byType(Transform), findsWidgets);

      // Reset the view size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('renders gradient background', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: HeroSection())));

      await tester.pump();

      // Verify gradient container is present
      final gradientContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).gradient is LinearGradient,
      );
      expect(gradientContainer, findsOneWidget);
    });

    testWidgets('contains parallax layers with proper structure', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.darkTheme, home: const Scaffold(body: HeroSection())));

      await tester.pump();

      // Verify Stack is present for layers - should find the HeroSection's stack
      final heroStack = find.byWidgetPredicate((widget) => widget is Stack && widget.children.length >= 3);
      expect(heroStack, findsOneWidget);

      // Verify Transform widgets are present for parallax layers
      expect(find.byType(Transform), findsWidgets);

      // Verify BackdropFilter is present for glass effects
      expect(find.byType(BackdropFilter), findsWidgets);

      // Verify Positioned widgets are present
      expect(find.byType(Positioned), findsWidgets);
    });
  });
}
