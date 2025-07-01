import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/router/app_router.dart';
import 'package:polymorphism/core/router/app_routes.dart';

void main() {
  group('AppRouter', () {
    testWidgets('should navigate to home route by default', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

      expect(find.text('I craft fluid interfaces\nthat behave.'), findsOneWidget);
      
      // Complete any pending animations and timers
      await tester.pumpAndSettle();
    });

    testWidgets('should navigate to projects route', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

      // Navigate to projects
      AppRouter.instance.go(AppRoutes.projectsPath);
      await tester.pumpAndSettle();

      expect(find.text('Projects Page'), findsOneWidget);
    });

    testWidgets('should navigate to gallery route', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

      // Navigate to gallery
      AppRouter.instance.go(AppRoutes.galleryPath);
      await tester.pumpAndSettle();

      expect(find.text('Gallery Page'), findsOneWidget);
    });

    testWidgets('should navigate to contact route', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

      // Navigate to contact
      AppRouter.instance.go(AppRoutes.contactPath);
      await tester.pumpAndSettle();

      expect(find.text('Contact Page'), findsOneWidget);
    });

    testWidgets('should handle 404 route', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

      // Navigate to 404 route
      AppRouter.instance.go(AppRoutes.notFoundPath);
      await tester.pumpAndSettle();

      expect(find.text('404'), findsOneWidget);
    });

    testWidgets('should fallback to 404 for unknown routes', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

      // Navigate to unknown route
      AppRouter.instance.go('/unknown-route');
      await tester.pumpAndSettle();

      expect(find.text('404'), findsOneWidget);
    });

    group('Query Parameters', () {
      testWidgets('should handle home page with section parameter', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/?section=about');
        await tester.pumpAndSettle();

        // The home page now shows the hero section regardless of section parameter
        expect(find.text('I craft fluid interfaces\nthat behave.'), findsOneWidget);
      });

      testWidgets('should handle projects page with query parameters', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/projects?q=flutter&category=mobile');
        await tester.pumpAndSettle();

        expect(find.text('Projects Page'), findsOneWidget);
        expect(find.text('Search: flutter'), findsOneWidget);
        expect(find.text('Category: mobile'), findsOneWidget);
      });

      testWidgets('should handle gallery page with query parameters', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/gallery?q=design&tag=ui');
        await tester.pumpAndSettle();

        expect(find.text('Gallery Page'), findsOneWidget);
        expect(find.text('Search: design'), findsOneWidget);
        expect(find.text('Tag: ui'), findsOneWidget);
      });

      testWidgets('should handle playground page with query parameters', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/playground?demo=animation&category=interactive');
        await tester.pumpAndSettle();

        expect(find.text('Playground Page (Demo: animation, Category: interactive)'), findsOneWidget);
      });

      testWidgets('should handle timeline page with query parameters', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/timeline?year=2024&filter=career');
        await tester.pumpAndSettle();

        expect(find.text('Timeline Page (Year: 2024, Filter: career)'), findsOneWidget);
      });

      testWidgets('should handle contact page with query parameters', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/contact?subject=inquiry&message=hello');
        await tester.pumpAndSettle();

        expect(find.text('Contact Page (Subject: inquiry, Message: hello)'), findsOneWidget);
      });

      testWidgets('should handle case studies page with query parameters', (tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.instance));

        AppRouter.instance.go('/case-studies?category=web');
        await tester.pumpAndSettle();

        expect(find.text('Case Studies Page'), findsOneWidget);
        expect(find.text('Category: web'), findsOneWidget);
      });
    });
  });
}
