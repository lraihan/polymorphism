import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/about/about_section.dart';
import 'package:polymorphism/features/contact/availability_badge.dart';
import 'package:polymorphism/features/experience/experience_section.dart';
import 'package:polymorphism/features/works/widgets/bento_card.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/widgets/cta_button.dart';
import 'package:polymorphism/shared/widgets/section_header.dart';
import 'package:polymorphism/shared/widgets/tech_badge.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wraps a test subject in the app theme so typography and colors resolve.
Widget _shell(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: child),
);

/// Sizes the test surface and restores it after the test.
void _useViewSize(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('SectionHeader renders eyebrow and title', (tester) async {
    _useViewSize(tester, const Size(1280, 900));

    await tester.pumpWidget(
      _shell(
        const SectionHeader(eyebrow: '02 / WORKS', title: 'Selected Projects'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('02 / WORKS'), findsOneWidget);
    expect(find.text('Selected Projects'), findsOneWidget);
  });

  testWidgets('TechBadge uppercases its label', (tester) async {
    _useViewSize(tester, const Size(1280, 900));

    await tester.pumpWidget(_shell(const TechBadge('flutter')));

    expect(find.text('FLUTTER'), findsOneWidget);
    expect(find.text('flutter'), findsNothing);
  });

  testWidgets('AvailabilityBadge shows its label', (tester) async {
    _useViewSize(tester, const Size(1280, 900));

    await tester.pumpWidget(
      _shell(const AvailabilityBadge(label: 'Available for work')),
    );
    // Looping pulse animation — pump fixed frames, never settle.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Available for work'), findsOneWidget);
  });

  testWidgets('CtaButton.primary renders label and responds to tap', (tester) async {
    _useViewSize(tester, const Size(1280, 900));
    var tapped = false;

    await tester.pumpWidget(
      _shell(
        Center(
          child: CtaButton.primary(label: 'View Work', onTap: () => tapped = true),
        ),
      ),
    );

    expect(find.text('View Work'), findsOneWidget);

    await tester.tap(find.byType(CtaButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('AboutSection renders the greeting', (tester) async {
    _useViewSize(tester, const Size(500, 900));

    await tester.pumpWidget(
      _shell(const SingleChildScrollView(child: AboutSection())),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text("Hi, I'm Raihan."), findsOneWidget);
  });

  testWidgets('ExperienceSection shows role and company', (tester) async {
    _useViewSize(tester, const Size(1280, 2000));

    await tester.pumpWidget(
      _shell(const SingleChildScrollView(child: ExperienceSection())),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Flutter & Visual Engineer'), findsOneWidget);
    expect(find.textContaining('PT Collega Inti Pratama'), findsWidgets);
  });

  testWidgets('ScrollReveal keeps child in tree and honors reduced motion', (tester) async {
    _useViewSize(tester, const Size(1280, 900));

    // Child is present from the first frame even while animating in.
    await tester.pumpWidget(
      _shell(const ScrollReveal(child: Text('revealed'))),
    );
    expect(find.text('revealed'), findsOneWidget);

    // Reduced motion renders fully visible immediately.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: ScrollReveal(child: Text('revealed')),
          ),
        ),
      ),
    );

    final opacity = tester.widget<Opacity>(
      find.descendant(of: find.byType(ScrollReveal), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 1);
  });

  testWidgets('BentoCard renders name and category and opens on tap', (tester) async {
    _useViewSize(tester, const Size(1280, 900));
    final project = PortfolioData.projects.first;
    var opened = false;

    await tester.pumpWidget(
      _shell(
        Center(
          child: SizedBox(
            width: 400,
            height: 420,
            child: BentoCard(project: project, onOpen: () => opened = true),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(project.name), findsOneWidget);
    expect(find.text(project.category), findsOneWidget);

    await tester.tap(find.byType(BentoCard));
    await tester.pump();

    expect(opened, isTrue);
  });
}
