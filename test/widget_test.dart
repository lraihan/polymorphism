import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:polymorphism/shell/app_shell.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('App starts and shows home page', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AppShell());

    // Wait for initial frame
    await tester.pump();

    // Wait for preloader to finish (shorter duration to avoid timeout)
    await tester.pump(const Duration(milliseconds: 1000));

    // Pump a few more frames without settling to avoid infinite loop
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify that our app shows the expected UI elements
    expect(find.text('I craft fluid interfaces\nthat behave.'), findsOneWidget);

    // Complete any pending animations and timers
    await tester.pumpAndSettle();
  });
}
