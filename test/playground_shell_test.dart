import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:polymorphism/modules/playground/playground_controller.dart';
import 'package:polymorphism/modules/playground/playground_shell.dart';

void main() {
  group('PlaygroundShell', () {
    setUp(Get.reset);

    tearDown(Get.reset);

    testWidgets('renders playground window on route', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Verify window is visible
      expect(find.text('GetX Playground'), findsNWidgets(2)); // Title bar + main text
      expect(find.text('Reactive Counter'), findsOneWidget);
      expect(find.text('Controller Code'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Initial counter value
    });

    testWidgets('counter increments when + button tapped', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('0'), findsOneWidget);

      // Tap increment button
      final incrementButton = find.byIcon(Icons.add);
      expect(incrementButton, findsOneWidget);
      await tester.tap(incrementButton);
      await tester.pump();

      // Verify counter incremented
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('counter decrements when - button tapped', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // First increment to have something to decrement
      final incrementButton = find.byIcon(Icons.add);
      await tester.tap(incrementButton);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Tap decrement button
      final decrementButton = find.byIcon(Icons.remove);
      expect(decrementButton, findsOneWidget);
      await tester.tap(decrementButton);
      await tester.pump();

      // Verify counter decremented
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('counter resets when reset button tapped', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Increment a few times
      final incrementButton = find.byIcon(Icons.add);
      await tester.tap(incrementButton);
      await tester.pump();
      await tester.tap(incrementButton);
      await tester.pump();
      await tester.tap(incrementButton);
      await tester.pump();
      expect(find.text('3'), findsOneWidget);

      // Tap reset button
      final resetButton = find.byIcon(Icons.refresh);
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pump();

      // Verify counter reset
      expect(find.text('0'), findsOneWidget);
      expect(find.text('3'), findsNothing);
    });

    testWidgets('window can be dragged to update position', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Get the controller to check position
      final controller = Get.find<PlaygroundController>();
      final initialX = controller.windowX.value;
      final initialY = controller.windowY.value;

      // Find the window container
      final windowFinder = find.byType(GestureDetector).first;
      expect(windowFinder, findsOneWidget);

      // Drag the window 100px to the right
      await tester.drag(windowFinder, const Offset(100, 0));
      await tester.pump();

      // Verify position updated (allow for small variations due to constraints)
      expect(controller.windowX.value, greaterThan(initialX + 50));
      expect(controller.windowY.value, equals(initialY));
    });

    testWidgets('close button hides window and shows FAB', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Verify window is initially visible
      expect(find.text('GetX Playground'), findsNWidgets(2));
      expect(find.byType(FloatingActionButton), findsNothing);

      // Tap close button
      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pump();

      // Verify window is hidden and FAB is shown
      expect(find.text('Reactive Counter'), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Playground'), findsOneWidget);
    });

    testWidgets('FAB reopens window when tapped', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Close window first
      final closeButton = find.byIcon(Icons.close);
      await tester.tap(closeButton);
      await tester.pump();

      // Verify FAB is visible
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Reactive Counter'), findsNothing);

      // Tap FAB to reopen window
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pump();

      // Verify window is visible again
      expect(find.text('Reactive Counter'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('window contains code snippet', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Verify code snippet is displayed
      expect(find.text('Controller Code'), findsOneWidget);
      expect(find.byType(SelectableText), findsOneWidget);

      // Check for parts of the code snippet
      expect(find.textContaining('PlaygroundController'), findsOneWidget);
      expect(find.textContaining('RxInt counter'), findsOneWidget);
      expect(find.textContaining('increment()'), findsOneWidget);
    });

    testWidgets('window has glass morphism styling', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Verify BackdropFilter exists for glass effect
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Verify container has proper decoration
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));
    });

    testWidgets('title bar displays correct title and close button', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      await tester.pumpAndSettle();

      // Verify title bar content
      expect(find.byIcon(Icons.code), findsAtLeastNWidgets(1));
      expect(find.text('GetX Playground'), findsNWidgets(2)); // Title bar + main content
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('window animates on appearance', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: PlaygroundShell()));

      // Don't settle to see animation
      await tester.pump();

      // Verify TweenAnimationBuilder exists
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();

      // Verify final state
      expect(find.text('Reactive Counter'), findsOneWidget);
    });
  });

  group('PlaygroundController', () {
    late PlaygroundController controller;

    setUp(() {
      Get.reset();
      controller = PlaygroundController();
    });

    tearDown(Get.reset);

    test('initial counter value is 0', () {
      expect(controller.counter.value, equals(0));
    });

    test('increment increases counter by 1', () {
      controller.increment();
      expect(controller.counter.value, equals(1));

      controller.increment();
      expect(controller.counter.value, equals(2));
    });

    test('decrement decreases counter by 1', () {
      controller.counter.value = 5;
      controller.decrement();
      expect(controller.counter.value, equals(4));

      controller.decrement();
      expect(controller.counter.value, equals(3));
    });

    test('reset sets counter to 0', () {
      controller.counter.value = 10;
      controller.reset();
      expect(controller.counter.value, equals(0));
    });

    test('window visibility can be toggled', () {
      expect(controller.isWindowVisible.value, isTrue);

      controller.closeWindow();
      expect(controller.isWindowVisible.value, isFalse);

      controller.openWindow();
      expect(controller.isWindowVisible.value, isTrue);
    });

    test('window position can be updated', () {
      controller.updatePosition(200, 150);
      expect(controller.windowX.value, equals(200));
      expect(controller.windowY.value, equals(150));
    });

    test('code snippet contains expected content', () {
      final snippet = controller.codeSnippet;
      expect(snippet, contains('PlaygroundController'));
      expect(snippet, contains('RxInt counter'));
      expect(snippet, contains('increment()'));
      expect(snippet, contains('decrement()'));
      expect(snippet, contains('reset()'));
      expect(snippet, contains('Obx('));
    });
  });
}
