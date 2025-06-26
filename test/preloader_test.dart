import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/shared/widgets/preloader_orb.dart';

void main() {
  group('Preloader', () {
    testWidgets('PreloaderOrb widget structure', (tester) async {
      // Build the widget without animations to avoid timer issues
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: PreloaderOrb(enableAnimation: false))));

      // Let the widget tree settle
      await tester.pump();

      // Verify the basic structure
      expect(find.byType(PreloaderOrb), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.text('Polymorphism'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('PreloaderOrb glassmorphism elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: PreloaderOrb(enableAnimation: false))));

      // Build the widget tree once
      await tester.pump();

      // Test glassmorphism components exist
      expect(find.byType(ClipOval), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Test that containers are present
      expect(find.byType(Container), findsWidgets);
    });
  });
}
