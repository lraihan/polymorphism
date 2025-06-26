import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/router/app_router.dart';

void main() {
  group('AppRouter', () {
    testWidgets('should navigate to home route by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.instance,
        ),
      );

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('should navigate to projects route', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.instance,
        ),
      );

      // Navigate to projects
      AppRouter.instance.go('/projects');
      await tester.pumpAndSettle();

      expect(find.text('Projects Page'), findsOneWidget);
    });

    testWidgets('should navigate to gallery route', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.instance,
        ),
      );

      // Navigate to gallery
      AppRouter.instance.go('/gallery');
      await tester.pumpAndSettle();

      expect(find.text('Gallery Page'), findsOneWidget);
    });

    testWidgets('should navigate to contact route', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.instance,
        ),
      );

      // Navigate to contact
      AppRouter.instance.go('/contact');
      await tester.pumpAndSettle();

      expect(find.text('Contact Page'), findsOneWidget);
    });
  });
}
