import 'package:flutter_test/flutter_test.dart';

import 'package:polymorphism/main.dart';

void main() {
  testWidgets('App starts and shows home page', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PolymorphismApp());

    // Verify that the app shows the home page.
    expect(find.text('Home Page'), findsOneWidget);
  });
}
