import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polymorphism/modules/contact/contact_section.dart';
import 'package:polymorphism/modules/contact/pages/contact_page.dart';

void main() {
  group('ContactSection Tests', () {
    testWidgets('displays heading and email link', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 800, child: SingleChildScrollView(child: ContactSection(enableAnimations: false))),
          ),
        ),
      );

      expect(find.text("Let's build something together."), findsOneWidget);
      expect(find.text('hello@polymorphism.dev'), findsOneWidget);
    });

    testWidgets('shows validation errors for empty form', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 800, child: SingleChildScrollView(child: ContactSection(enableAnimations: false))),
          ),
        ),
      );

      // Try to submit empty form
      await tester.tap(find.text('Send'));
      await tester.pump();

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Message is required'), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 800, child: SingleChildScrollView(child: ContactSection(enableAnimations: false))),
          ),
        ),
      );

      // Fill form with invalid email
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(2), 'Test message');

      await tester.tap(find.text('Send'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('form fields have proper labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 800, child: SingleChildScrollView(child: ContactSection(enableAnimations: false))),
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
    });

    testWidgets('submit button is present', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 800, child: SingleChildScrollView(child: ContactSection(enableAnimations: false))),
          ),
        ),
      );

      expect(find.text('Send'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('respects animation enablement', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 800, child: SingleChildScrollView(child: ContactSection(enableAnimations: false))),
          ),
        ),
      );

      expect(find.byType(ContactSection), findsOneWidget);
    });
  });

  group('ContactPage Tests', () {
    testWidgets('displays contact section', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ContactPage()));

      expect(find.byType(ContactSection), findsOneWidget);
    });

    testWidgets('is scrollable', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ContactPage()));

      expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
    });
  });
}
