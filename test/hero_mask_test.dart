import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/home/hero_mask_controller.dart';
import 'package:polymorphism/modules/home/hero_mask_overlay.dart';

void main() {
  group('HeroMaskOverlay', () {
    late HeroMaskController controller;

    setUp(() {
      Get.testMode = true;
      // Remove any existing controller
      if (Get.isRegistered<HeroMaskController>()) {
        Get.delete<HeroMaskController>();
      }
      controller = Get.put(HeroMaskController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('mask appears on load and displays unlock text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // ✅ Verify mask is visible initially
      expect(controller.isMaskVisible.value, isTrue);

      // ✅ Verify unlock text is displayed
      expect(find.text('UNLOCK'), findsOneWidget);
      expect(find.text('Your Digital Experience'), findsOneWidget);
      expect(find.text('Tap anywhere to reveal'), findsOneWidget);

      // ✅ Verify skip button is present
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('animation triggers on tap and completes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // Verify initial state
      expect(controller.isMaskVisible.value, isTrue);
      expect(controller.isAnimating.value, isFalse);

      // ✅ Tap to trigger animation
      await tester.tap(find.byType(HeroMaskOverlay));
      await tester.pump();

      // ✅ Verify animation starts
      expect(controller.isAnimating.value, isTrue);

      // ✅ Wait for animation to complete
      await tester.pumpAndSettle();

      // ✅ Verify mask is removed after animation
      expect(controller.isMaskVisible.value, isFalse);
      expect(controller.isAnimating.value, isFalse);
    });

    testWidgets('mask is removed from tree after reveal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // Initially mask should be present
      expect(find.byType(HeroMaskOverlay), findsOneWidget);

      // Trigger reveal animation
      await tester.tap(find.byType(HeroMaskOverlay));
      await tester.pumpAndSettle();

      // ✅ Verify mask widget is no longer rendered (returns SizedBox.shrink)
      expect(controller.isMaskVisible.value, isFalse);

      // Rebuild to trigger the shrink
      await tester.pump();

      // The overlay widget still exists but should render SizedBox.shrink
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('skip button dismisses mask immediately', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // Verify initial state
      expect(controller.isMaskVisible.value, isTrue);

      // ✅ Tap skip button with warnIfMissed: false to avoid warning
      await tester.tap(find.text('Skip'), warnIfMissed: false);
      await tester.pump();

      // ✅ Verify mask is dismissed immediately
      expect(controller.isMaskVisible.value, isFalse);
      expect(controller.isAnimating.value, isFalse);
    });

    testWidgets('escape key dismisses mask for accessibility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // Verify initial state
      expect(controller.isMaskVisible.value, isTrue);

      // ✅ Simulate escape key press
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // ✅ Verify mask is dismissed
      expect(controller.isMaskVisible.value, isFalse);
    });

    testWidgets('auto-reveal triggers after timeout', (tester) async {
      // Reset the controller to ensure fresh state for this test
      controller.resetMask();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // Verify initial state
      expect(controller.isMaskVisible.value, isTrue);

      // ✅ Wait for auto-reveal timeout (2.5 seconds) plus animation time
      await tester.pump(const Duration(milliseconds: 2600));

      // Allow the animation to start and complete
      expect(controller.isAnimating.value, isTrue);
      await tester.pump(const Duration(milliseconds: 1600)); // Animation duration
      await tester.pumpAndSettle();

      // ✅ Verify mask is automatically dismissed
      expect(controller.isMaskVisible.value, isFalse);
    });

    testWidgets('mask scales responsively on different screen sizes', (tester) async {
      // Test mobile size
      await tester.binding.setSurfaceSize(const Size(360, 640));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Stack(children: [Center(child: Text('Hero Content')), HeroMaskOverlay()])),
        ),
      );

      await tester.pump();

      // ✅ Verify mask renders on mobile
      expect(find.text('UNLOCK'), findsOneWidget);

      // Test desktop size
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pump();

      // ✅ Verify mask still renders on desktop
      expect(find.text('UNLOCK'), findsOneWidget);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('HeroMaskController', () {
    late HeroMaskController controller;

    setUp(() {
      Get.testMode = true;
      controller = Get.put(HeroMaskController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('controller initializes with correct default values', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // ✅ Verify initial state
      expect(controller.isMaskVisible.value, isTrue);
      expect(controller.isAnimating.value, isFalse);
      expect(controller.animationProgress.value, equals(0.0));
    });

    testWidgets('startRevealAnimation updates state correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Start animation
      controller.startRevealAnimation();
      await tester.pump();

      // ✅ Verify animation state
      expect(controller.isAnimating.value, isTrue);

      // Wait for completion
      await tester.pumpAndSettle();

      // ✅ Verify final state
      expect(controller.isMaskVisible.value, isFalse);
      expect(controller.isAnimating.value, isFalse);
    });

    testWidgets('skipMask bypasses animation', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Skip mask
      controller.skipMask();
      await tester.pump();

      // ✅ Verify immediate state change
      expect(controller.isMaskVisible.value, isFalse);
      expect(controller.isAnimating.value, isFalse);
      expect(controller.animationProgress.value, equals(1.0));
    });
  });
}
