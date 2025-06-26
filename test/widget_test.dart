import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:polymorphism/shell/app_shell.dart';

void main() {
  tearDown(() {
    // Clean up GetX controllers after each test
    Get.reset();
  });

  testWidgets('App starts and shows home page', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AppShell());

    // Wait for preloader to finish and show home page
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify that the app shows the home page (hero section) after preloader.
    expect(find.text('I craft fluid interfaces\nthat behave.'), findsOneWidget);
  });
}
