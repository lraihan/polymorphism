import 'package:flutter_test/flutter_test.dart';

import 'package:polymorphism/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PolymorphismApp());

    // Verify that the app shows the title.
    expect(find.text('Polymorphism Portfolio'), findsOneWidget);
  });
}
