import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    testWidgets('should use Playfair Display for headlineLarge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Text(
              'Test Headline',
              style: TextStyle(fontSize: 32), // Will inherit headlineLarge style
            ),
          ),
        ),
      );

      final theme = AppTheme.darkTheme;
      
      // Check that headlineLarge uses Playfair Display
      expect(
        theme.textTheme.headlineLarge?.fontFamily,
        contains('Playfair'),
      );
      
      // Verify the widget was created successfully
      expect(find.text('Test Headline'), findsOneWidget);
    });

    testWidgets('should use Inter for bodyLarge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Text('Test Body'),
          ),
        ),
      );

      final theme = AppTheme.darkTheme;
      
      // Check that bodyLarge uses Inter
      expect(
        theme.textTheme.bodyLarge?.fontFamily,
        contains('Inter'),
      );
      
      // Verify the widget was created successfully
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('should have correct color scheme', (tester) async {
      final theme = AppTheme.darkTheme;
      
      // Verify dark theme colors
      expect(theme.colorScheme.primary, equals(const Color(0xFF4E9AF1)));
      expect(theme.colorScheme.secondary, equals(const Color(0xFFE6B980)));
      expect(theme.scaffoldBackgroundColor, equals(const Color(0xFF1A1F2B)));
    });

    testWidgets('should have Material 3 enabled', (tester) async {
      final theme = AppTheme.darkTheme;
      
      expect(theme.useMaterial3, isTrue);
    });

    testWidgets('should have splash effects disabled', (tester) async {
      final theme = AppTheme.darkTheme;
      
      expect(theme.splashFactory, equals(NoSplash.splashFactory));
      expect(theme.highlightColor, equals(Colors.transparent));
    });
  });
}
