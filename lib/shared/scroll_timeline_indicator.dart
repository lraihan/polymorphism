import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class ScrollTimelineIndicator extends StatefulWidget {
  const ScrollTimelineIndicator({
    required this.scrollController,
    required this.sectionTitles,
    super.key,
    this.onSectionTap,
  });

  final ScrollController scrollController;
  final List<String> sectionTitles;
  final void Function(int)? onSectionTap;

  @override
  State<ScrollTimelineIndicator> createState() => _ScrollTimelineIndicatorState();
}

class _ScrollTimelineIndicatorState extends State<ScrollTimelineIndicator> {
  double _scrollProgress = 0;
  int _hoveredDot = -1;

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
    if (!widget.scrollController.hasClients || !mounted) {
      return;
    }
    final position = widget.scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    final next = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    if ((next - _scrollProgress).abs() > 0.001) {
      setState(() => _scrollProgress = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return const SizedBox.shrink();
    }
    final screenHeight = MediaQuery.of(context).size.height;
    final indicatorHeight = screenHeight * 0.6;
    final titles = widget.sectionTitles;
    final lastIndex = titles.length - 1;

    return Positioned(
      right: 20,
      top: screenHeight * 0.2,
      child: SizedBox(
        width: 28,
        height: indicatorHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                width: 2,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 2,
                height: indicatorHeight * _scrollProgress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.6)],
                  ),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            for (int i = 0; i < titles.length; i++)
              Positioned(
                top: lastIndex == 0
                    ? indicatorHeight / 2 - 6
                    : (indicatorHeight - 12) * (i / lastIndex),
                child: _SectionDot(
                  isActive: _scrollProgress + 0.02 >= (lastIndex == 0 ? 0 : i / lastIndex),
                  isHovered: _hoveredDot == i,
                  label: titles[i],
                  onHover: (hover) {
                    setState(() => _hoveredDot = hover ? i : -1);
                  },
                  onTap: () => widget.onSectionTap?.call(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionDot extends StatelessWidget {
  const _SectionDot({
    required this.isActive,
    required this.isHovered,
    required this.label,
    required this.onHover,
    required this.onTap,
  });

  final bool isActive;
  final bool isHovered;
  final String label;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Tooltip(
            message: label,
            preferBelow: false,
            verticalOffset: 0,
            child: AnimatedContainer(
              duration: AppMotion.fast,
              width: isHovered ? 14 : 10,
              height: isHovered ? 14 : 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.accent : AppColors.bgDark,
                border: Border.all(
                  color: isActive
                      ? AppColors.accent
                      : AppColors.textPrimary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: isHovered || isActive
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      );
}
