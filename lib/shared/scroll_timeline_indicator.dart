import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class ScrollTimelineIndicator extends StatefulWidget {

  const ScrollTimelineIndicator({
    required this.scrollController, required this.sectionTitles, super.key,
    this.onSectionTap,
  });
  final ScrollController scrollController;
  final List<String> sectionTitles;
  final Function(int)? onSectionTap;

  @override
  State<ScrollTimelineIndicator> createState() => _ScrollTimelineIndicatorState();
}

class _ScrollTimelineIndicatorState extends State<ScrollTimelineIndicator> {
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollProgress);
    super.dispose();
  }

  void _updateScrollProgress() {
    if (!widget.scrollController.hasClients) {
      return;
    }

    final position = widget.scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;

    setState(() {
      _scrollProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final indicatorHeight = screenHeight * 0.6; // 60% of screen height

    return Positioned(
      right: 20,
      top: screenHeight * 0.2, // Start at 20% from top
      child: SizedBox(
        width: 4,
        height: indicatorHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 2,
              height: indicatorHeight,
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 2,
                height: indicatorHeight * _scrollProgress,
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
