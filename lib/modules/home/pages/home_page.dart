import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/contact/contact_section.dart';
import 'package:polymorphism/modules/home/about_section.dart';
import 'package:polymorphism/modules/home/cursor_reveal_hero_section.dart';
import 'package:polymorphism/modules/standout/standout_section.dart';
import 'package:polymorphism/modules/timeline/timeline_section.dart';
import 'package:polymorphism/modules/works/works_section.dart';
import 'package:polymorphism/shared/footer/footer.dart';
import 'package:polymorphism/shared/scroll_timeline_indicator.dart';
import 'package:polymorphism/shared/widgets/glass_navbar.dart';

/// Custom scroll physics that provides hero section snap-to behavior
/// while maintaining heavy scrolling for other sections
class HeroSnapScrollPhysics extends ScrollPhysics {
  const HeroSnapScrollPhysics({super.parent});

  @override
  HeroSnapScrollPhysics applyTo(ScrollPhysics? ancestor) => HeroSnapScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // Get screen height to determine hero section bounds
    final heroSectionHeight = position.viewportDimension;

    // Only apply snap behavior if we're in the hero section area (first screen height)
    if (position.pixels < heroSectionHeight) {
      // Snap to either top (0) or bottom of hero section (heroSectionHeight)
      final snapOffset = position.pixels < heroSectionHeight / 2 ? 0.0 : heroSectionHeight;

      // Only snap if we're not already at the target position
      if ((position.pixels - snapOffset).abs() > 1.0) {
        return ScrollSpringSimulation(spring, position.pixels, snapOffset, velocity, tolerance: toleranceFor(position));
      }
    }

    // For all other sections, use heavy momentum-based scrolling
    return super.createBallisticSimulation(position, velocity);
  }

  // Make scrolling feel heavy and momentum-based outside hero section
  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  double get minFlingVelocity => 100;

  @override
  double get maxFlingVelocity => 5000;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey()); // Updated to 6 sections
  final List<String> _sectionTitles = [
    'Hero',
    'About',
    'Timeline',
    'Works',
    'Stand Out',
    'Contact',
  ]; // Added Stand Out section
  Timer? _scrollNavigationTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollNavigationTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    if (index < 0 || index >= _sectionKeys.length) {
      return;
    }

    // Cancel any existing navigation timer
    _scrollNavigationTimer?.cancel();

    // Add enhanced experiential delay before scrolling for better UX
    _scrollNavigationTimer = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }

      final context = _sectionKeys[index].currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject()! as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        // Scroll to the section with some offset for better visibility
        final targetOffset = _scrollController.offset + position.dy - 80; // 80px offset for timeline indicator

        _scrollController.animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 2000), // Much slower, heavier scroll duration
          curve: Curves.easeInOutCubic,
        );
      } else {
        // Fallback: simple calculation if render box is not available
        final position = _scrollController.position;
        final maxScroll = position.maxScrollExtent;

        double targetOffset;
        if (index == 0) {
          targetOffset = 0;
        } else if (index >= _sectionTitles.length - 1) {
          targetOffset = maxScroll;
        } else {
          final sectionProgress = index / (_sectionTitles.length - 1);
          targetOffset = maxScroll * sectionProgress;
        }

        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 2000), // Much slower, heavier scroll duration
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _scrollToSectionFromNavbar(int index) {
    if (index < 0 || index >= _sectionKeys.length) {
      return;
    }

    // Cancel any existing navigation timer
    _scrollNavigationTimer?.cancel();

    // Add enhanced experiential delay before scrolling for better UX
    _scrollNavigationTimer = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }

      final context = _sectionKeys[index].currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject()! as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        // Scroll to the section with adjusted offset for navbar clicks
        // More space from top to account for navbar height and better section visibility
        final targetOffset = _scrollController.offset + position.dy; // Larger offset for navbar navigation

        _scrollController.animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOutCubic,
        );
      } else {
        // Fallback: simple calculation if render box is not available
        final position = _scrollController.position;
        final maxScroll = position.maxScrollExtent;

        double targetOffset;
        if (index == 0) {
          targetOffset = 0;
        } else if (index >= _sectionTitles.length - 1) {
          targetOffset = maxScroll;
        } else {
          final sectionProgress = index / (_sectionTitles.length - 1);
          targetOffset = maxScroll * sectionProgress;
        }

        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bgDark,
    body: Stack(
      children: [
        // Main scrollable content with hero snap + heavy scroll physics
        SingleChildScrollView(
          controller: _scrollController,
          physics: const HeroSnapScrollPhysics(
            parent: BouncingScrollPhysics(),
          ), // Hero section snaps, other sections have heavy momentum
          child: Column(
            children: [
              SizedBox(
                key: _sectionKeys[0],
                height: MediaQuery.of(context).size.height,
                child: CursorRevealHeroSection(
                  onExplorePressed: () => _scrollToSection(3),
                ), // Updated to scroll to Works section
              ),
              Container(key: _sectionKeys[1], child: const AboutSection()),
              Container(key: _sectionKeys[2], child: TimelineSection(scrollController: _scrollController)),
              Container(key: _sectionKeys[3], child: WorksSection(scrollController: _scrollController)),
              Container(key: _sectionKeys[4], child: StandOutSection(scrollController: _scrollController)),
              Container(key: _sectionKeys[5], child: const ContactSection()),
              const Footer(),
            ],
          ),
        ),

        // Fixed navbar at the top
        Positioned(top: 0, left: 0, right: 0, child: GlassNavbar(onNavigationTap: _scrollToSectionFromNavbar)),

        // Scroll timeline indicator
        ScrollTimelineIndicator(
          scrollController: _scrollController,
          sectionTitles: _sectionTitles,
          onSectionTap: _scrollToSection,
        ),
      ],
    ),
  );
}
