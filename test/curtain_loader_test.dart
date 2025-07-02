import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/widgets/curtain_loader.dart';

void main() {
  group('CurtainLoader', () {
    testWidgets('displays loading text correctly', (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: CurtainLoader(
            onComplete: () => completed = true,
            duration: const Duration(milliseconds: 100), // Short duration for testing
          ),
        ),
      );

      await tester.pump();

      // Verify loading text is present
      expect(find.text('RAIHAN FADLI'), findsOneWidget);
      expect(find.text('My logic blossoms into experience.'), findsOneWidget);
    });

    testWidgets('calls onComplete after animation', (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: CurtainLoader(
            onComplete: () => completed = true,
            duration: const Duration(milliseconds: 100), // Short duration for testing
          ),
        ),
      );

      await tester.pump();
      expect(completed, isFalse);

      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
    });

    testWidgets('renders curtain elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: CurtainLoader(onComplete: () {}, duration: const Duration(milliseconds: 100)),
        ),
      );

      await tester.pump();

      // Verify scaffold and container structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('has proper accessibility structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: CurtainLoader(onComplete: () {}, duration: const Duration(milliseconds: 100)),
        ),
      );

      await tester.pump();

      // Verify text is accessible
      expect(find.text('RAIHAN FADLI'), findsOneWidget);
      expect(find.text('My logic blossoms into experience.'), findsOneWidget);
    });
  });
}
