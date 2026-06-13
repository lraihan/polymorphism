import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/contact/contact_section.dart';
import 'package:polymorphism/features/hero/hero_section.dart';
import 'package:polymorphism/features/statement/statement_section.dart';
import 'package:polymorphism/features/works/project_detail.dart';
import 'package:polymorphism/features/works/works_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Runtime layout smoke tests. They pump each heavy section at realistic and
/// deliberately-cramped viewports and assert no exception escaped — catching
/// both unbounded-constraint crashes and RenderFlex overflow (both throw in
/// debug), the class of bug compile + analyze cannot see.

Widget _app(Widget child) => MaterialApp(theme: AppTheme.dark, home: Scaffold(body: child));

void _view(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 800));
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('HeroSection lays out without overflow', () {
    for (final size in const [Size(1440, 900), Size(1024, 600), Size(390, 780)]) {
      testWidgets('at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        _view(tester, size);
        await tester.pumpWidget(
          _app(SizedBox(width: size.width, height: size.height, child: const HeroSection(play: true))),
        );
        await _pumpFrames(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('WorksSection bento lays out without overflow', () {
    for (final width in const [1280.0, 1100.0, 1024.0, 800.0, 390.0]) {
      testWidgets('at width ${width.toInt()}', (tester) async {
        _view(tester, Size(width, 1400));
        await tester.pumpWidget(
          _app(
            SingleChildScrollView(
              child: WorksSection(onOpenProject: (_) {}, onStartProject: () {}),
            ),
          ),
        );
        await _pumpFrames(tester);
        expect(tester.takeException(), isNull);
        expect(find.text('FE Touch'), findsOneWidget);
      });
    }
  });

  testWidgets('StatementSection lays out without overflow', (tester) async {
    _view(tester, const Size(1280, 900));
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(
        SingleChildScrollView(
          controller: controller,
          child: StatementSection(scrollController: controller),
        ),
      ),
    );
    await _pumpFrames(tester);
    expect(tester.takeException(), isNull);
  });

  group('ContactSection lays out without overflow', () {
    for (final size in const [Size(1280, 1200), Size(390, 1400)]) {
      testWidgets('at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        _view(tester, size);
        await tester.pumpWidget(_app(const SingleChildScrollView(child: ContactSection())));
        await _pumpFrames(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('ProjectDetailPage lays out without overflow', () {
    // A landscape and a portrait project, at desktop, mobile, and a short
    // height that mirrors the card→detail Hero-flight box that used to overflow.
    final projects = [PortfolioData.projects.first, PortfolioData.projects[1]];
    for (final project in projects) {
      for (final size in const [Size(1280, 900), Size(390, 800), Size(900, 480)]) {
        testWidgets('${project.id} at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
          _view(tester, size);
          await tester.pumpWidget(_app(ProjectDetailPage(project: project)));
          await _pumpFrames(tester);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
