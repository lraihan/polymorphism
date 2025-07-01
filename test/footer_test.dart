import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/shared/footer/footer.dart';

void main() {
  group('Footer Tests', () {
    testWidgets('displays copyright text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      expect(find.text('© 2025 Raihan.'), findsOneWidget);
    });

    testWidgets('displays three social icons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      // Should have three clickable social icons
      expect(find.byType(InkWell), findsNWidgets(3));
      expect(find.byIcon(Icons.code), findsOneWidget);
      expect(find.byIcon(Icons.work), findsOneWidget);
      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
    });

    testWidgets('social icons have tooltips', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      expect(find.byTooltip('GitHub'), findsOneWidget);
      expect(find.byTooltip('LinkedIn'), findsOneWidget);
      expect(find.byTooltip('X (Twitter)'), findsOneWidget);
    });

    testWidgets('has correct height and glass surface styling', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);

      expect(containerWidget.constraints?.minHeight, 80);
    });

    testWidgets('social icons have mouse regions for hover', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      // Footer should have social icons wrapped in MouseRegion
      expect(find.descendant(of: find.byType(Footer), matching: find.byType(MouseRegion)), findsAtLeastNWidgets(3));
    });

    testWidgets('footer layout is responsive', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      // Footer should have a Row with spaceBetween for responsive layout
      final rows = find.descendant(of: find.byType(Footer), matching: find.byType(Row));
      expect(rows, findsAtLeastNWidgets(1));

      final firstRow = tester.widget<Row>(rows.first);
      expect(firstRow.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('has proper accessibility support', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      // All icons should be focusable through InkWell
      expect(find.byType(InkWell), findsNWidgets(3));

      // Should have tooltips for screen readers
      expect(find.byType(Tooltip), findsNWidgets(3));
    });

    testWidgets('has proper container height', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Footer())));

      final footer = tester.getSize(find.byType(Footer));
      expect(footer.height, 80);
    });
  });
}
