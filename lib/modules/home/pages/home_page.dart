import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/contact/contact_section.dart';
import 'package:polymorphism/modules/gallery/gallery_section.dart';
import 'package:polymorphism/modules/home/about_section.dart';
import 'package:polymorphism/modules/home/hero_section.dart';
import 'package:polymorphism/modules/home/projects_section.dart';
import 'package:polymorphism/modules/timeline/timeline_section.dart';
import 'package:polymorphism/shared/footer/footer.dart';
import 'package:polymorphism/shared/scroll_timeline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey());
  final List<String> _sectionTitles = ['Hero', 'About', 'Projects', 'Gallery', 'Timeline', 'Contact'];
  Timer? _scrollNavigationTimer;

  @override
  void dispose() {
    _scrollNavigationTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    if (index < 0 || index >= _sectionKeys.length) return;

    // Cancel any existing navigation timer
    _scrollNavigationTimer?.cancel();

    // Add enhanced experiential delay before scrolling for better UX
    _scrollNavigationTimer = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;

      final context = _sectionKeys[index].currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        // Scroll to the section with some offset for better visibility
        final targetOffset = _scrollController.offset + position.dy - 80; // 80px offset for better UX

        _scrollController.animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 1200), // Extended duration for more experiential feeling
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
          duration: const Duration(milliseconds: 1200), // Extended duration for more experiential feeling
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
        // Main scrollable content
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                key: _sectionKeys[0],
                height: MediaQuery.of(context).size.height,
                child: HeroSection(onExplorePressed: () => _scrollToSection(2)),
              ),
              Container(key: _sectionKeys[1], child: const AboutSection()),
              Container(key: _sectionKeys[2], child: const ProjectsSection()),
              Container(key: _sectionKeys[3], child: const GallerySection()),
              Container(key: _sectionKeys[4], child: TimelineSection(scrollController: _scrollController)),
              Container(key: _sectionKeys[5], child: const ContactSection()),
              const Footer(),
            ],
          ),
        ),
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
