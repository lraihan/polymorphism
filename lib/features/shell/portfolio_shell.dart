import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_scroll/flutter_web_scroll.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/features/about/about_section.dart';
import 'package:polymorphism/features/contact/contact_section.dart';
import 'package:polymorphism/features/contact/portfolio_footer.dart';
import 'package:polymorphism/features/experience/experience_section.dart';
import 'package:polymorphism/features/hero/hero_section.dart';
import 'package:polymorphism/features/intro/intro_screen.dart';
import 'package:polymorphism/features/shell/floating_nav.dart';
import 'package:polymorphism/features/statement/statement_section.dart';
import 'package:polymorphism/features/works/works_section.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/noise_overlay.dart';
import 'package:polymorphism/shared/widgets/section_rail.dart';

/// Keeps the wheel position glued to the hero until the visitor commits to
/// scrolling past it — the first "chapter turn" feels intentional.
class HeroSnapScrollPhysics extends ScrollPhysics {
  const HeroSnapScrollPhysics({super.parent});

  @override
  HeroSnapScrollPhysics applyTo(ScrollPhysics? ancestor) => HeroSnapScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final heroHeight = position.viewportDimension;
    if (position.pixels < heroHeight) {
      final snapTo = position.pixels < heroHeight / 2 ? 0.0 : heroHeight;
      if ((position.pixels - snapTo).abs() > 1.0) {
        return ScrollSpringSimulation(spring, position.pixels, snapTo, velocity, tolerance: toleranceFor(position));
      }
    }
    return super.createBallisticSimulation(position, velocity);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

/// Root shell: one scroll surface of full-bleed "chapters", floating nav,
/// progress rail, film grain, and the custom cursor — exactly in that
/// z-order.
class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  /// Session flag — the intro must not replay on back-navigation.
  static bool _introSeen = false;

  final ScrollController _scroll = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());
  static const List<String> _sectionTitles = ['Home', 'About', 'Works', 'Experience', 'Statement', 'Contact'];
  static const List<NavItem> _navItems = [
    (label: 'About', sectionIndex: 1),
    (label: 'Works', sectionIndex: 2),
    (label: 'Experience', sectionIndex: 3),
    (label: 'Contact', sectionIndex: 5),
  ];
  static const int _contactIndex = 5;

  final ValueNotifier<double> _progress = ValueNotifier(0);
  final ValueNotifier<int> _activeSection = ValueNotifier(0);
  final ValueNotifier<bool> _navVisible = ValueNotifier(false);

  /// True while the hero occupies the viewport. Drives a [TickerMode] so the
  /// hero's perpetual tickers (statement-dot loop, gradient drift, particle
  /// field, availability pulse) are muted the moment it scrolls offscreen —
  /// restoring idle frames for the rest of the page.
  final ValueNotifier<bool> _heroVisible = ValueNotifier(true);

  bool _introDone = _introSeen;
  double _lastMeasuredOffset = double.negativeInfinity;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _progress.dispose();
    _activeSection.dispose();
    _navVisible.dispose();
    _heroVisible.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) {
      return;
    }
    final position = _scroll.position;
    final max = position.maxScrollExtent;
    _progress.value = max > 0 ? (position.pixels / max).clamp(0.0, 1.0) : 0;
    _navVisible.value = position.pixels > position.viewportDimension * 0.8;
    _heroVisible.value = position.pixels < position.viewportDimension;

    // Section hit-testing is GlobalKey-based; throttle to every ~24 px.
    if ((position.pixels - _lastMeasuredOffset).abs() < 24) {
      return;
    }
    _lastMeasuredOffset = position.pixels;
    final viewport = position.viewportDimension;
    var active = 0;
    for (var i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      final box = ctx?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) {
        continue;
      }
      if (box.localToGlobal(Offset.zero).dy <= viewport * 0.45) {
        active = i;
      }
    }
    _activeSection.value = active;
  }

  void _scrollToSection(int index) {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null || !_scroll.hasClients) {
      return;
    }
    final box = ctx.findRenderObject()! as RenderBox;
    final target = (_scroll.offset + box.localToGlobal(Offset.zero).dy - (index == 0 ? 0 : Spacing.xxl))
        .clamp(0.0, _scroll.position.maxScrollExtent);
    final distance = (target - _scroll.offset).abs();
    _scroll.animateTo(
      target,
      duration: Duration(milliseconds: (600 + distance * 0.25).clamp(600, 1800).round()),
      curve: AppCurves.travel,
    );
  }

  void _onIntroFinished() {
    _introSeen = true;
    if (mounted) {
      setState(() => _introDone = true);
    }
  }

  void _openProject(String id) => context.push('/work/$id');

  @override
  Widget build(BuildContext context) {
    final supportsHover = context.supportsHover;
    final useSmoothScroll = supportsHover && !context.reducedMotion;

    // Each section is isolated in a RepaintBoundary so an animating section
    // never re-records its siblings during a scroll frame.
    final content = SingleChildScrollView(
      controller: _scroll,
      physics: const HeroSnapScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        children: [
          // Hero tickers pause via TickerMode once it scrolls out of view.
          RepaintBoundary(
            child: SizedBox(
              key: _sectionKeys[0],
              height: context.screenHeight,
              child: ValueListenableBuilder<bool>(
                valueListenable: _heroVisible,
                builder: (context, heroVisible, child) => TickerMode(enabled: heroVisible, child: child!),
                child: HeroSection(
                  play: _introDone,
                  onViewWork: () => _scrollToSection(2),
                  onContact: () => _scrollToSection(_contactIndex),
                ),
              ),
            ),
          ),
          RepaintBoundary(child: KeyedSubtree(key: _sectionKeys[1], child: const AboutSection())),
          RepaintBoundary(
            child: KeyedSubtree(
              key: _sectionKeys[2],
              child: WorksSection(onOpenProject: _openProject, onStartProject: () => _scrollToSection(_contactIndex)),
            ),
          ),
          RepaintBoundary(child: KeyedSubtree(key: _sectionKeys[3], child: const ExperienceSection())),
          RepaintBoundary(
            child: KeyedSubtree(key: _sectionKeys[4], child: StatementSection(scrollController: _scroll)),
          ),
          RepaintBoundary(child: KeyedSubtree(key: _sectionKeys[5], child: const ContactSection())),
          const RepaintBoundary(child: PortfolioFooter()),
        ],
      ),
    );

    Widget page = Stack(
      children: [
        if (useSmoothScroll)
          SmoothScrollWeb(
            controller: _scroll,
            config: SmoothScrollConfig.lenis(scrollSpeed: 1.1, damping: 0.09),
            child: content,
          )
        else
          content,
        Positioned.fill(
          child: FloatingNav(
            visible: _navVisible,
            activeSection: _activeSection,
            items: _navItems,
            onNavTap: _scrollToSection,
            contactSectionIndex: _contactIndex,
          ),
        ),
        SectionRail(
          progress: _progress,
          activeSection: _activeSection,
          sectionTitles: _sectionTitles,
          onSectionTap: _scrollToSection,
        ),
        if (!_introDone) Positioned.fill(child: IntroScreen(onFinished: _onIntroFinished)),
        const Positioned.fill(child: NoiseOverlay()),
        if (supportsHover) const Positioned.fill(child: CustomCursorOverlay()),
      ],
    );

    if (supportsHover) {
      // Hide the OS cursor and feed the custom one. Listener (not
      // MouseRegion) so hit-testing stays untouched. Visibility is gated on a
      // real mouse pointer — a touch tablet (width ≥ 768) never emits a mouse
      // hover, so the custom cursor stays hidden instead of stranding a dot
      // in the corner and chasing finger-drags.
      page = MouseRegion(
        cursor: SystemMouseCursors.none,
        child: Listener(
          onPointerHover: (event) {
            if (event.kind == PointerDeviceKind.mouse) {
              CursorController.visible.value = true;
              CursorController.position.value = event.position;
            }
          },
          onPointerMove: (event) {
            if (event.kind == PointerDeviceKind.mouse) {
              CursorController.position.value = event.position;
            }
          },
          behavior: HitTestBehavior.translucent,
          child: page,
        ),
      );
    }

    return Scaffold(backgroundColor: AppColors.deepSpace, body: page);
  }
}
