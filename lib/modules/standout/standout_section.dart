import 'package:flutter/material.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

class StandOutSection extends StatefulWidget {
  const StandOutSection({super.key, this.scrollController, this.onStartProjectPressed});

  final ScrollController? scrollController;
  final VoidCallback? onStartProjectPressed;

  @override
  State<StandOutSection> createState() => _StandOutSectionState();
}

class _StandOutSectionState extends State<StandOutSection> {
  late final GlobalKey _sectionKey;

  @override
  void initState() {
    super.initState();
    _sectionKey = GlobalKey();
    widget.scrollController?.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_updateScrollProgress);
    super.dispose();
  }

  void _updateScrollProgress() {
    if (!mounted || widget.scrollController == null || !widget.scrollController!.hasClients) {
      return;
    }

    final sectionContext = _sectionKey.currentContext;
    if (sectionContext == null) {
      return;
    }

    final sectionBox = sectionContext.findRenderObject() as RenderBox?;
    if (sectionBox == null) {
      return;
    }

    final sectionPosition = sectionBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollPosition = widget.scrollController!.offset;

    final sectionTop = sectionPosition.dy + scrollPosition;
    final sectionBottom = sectionTop + sectionBox.size.height;
    final viewportTop = scrollPosition;
    final viewportBottom = scrollPosition + screenHeight;

    if (sectionTop <= viewportBottom && sectionBottom >= viewportTop) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      key: _sectionKey,
      width: double.infinity,
      height: screenHeight * (isMobile ? 1 : 1.8),
      color: AppColors.bgDark,
      child: Stack(children: [_buildTypographyOverlay(context)]),
    );
  }

  Widget _buildTypographyOverlay(BuildContext context) => Positioned.fill(child: _buildMainTypography(context));

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseFontSize * 0.4;
    } else if (screenWidth < 900) {
      return baseFontSize * 0.6;
    } else if (screenWidth < 1200) {
      return baseFontSize * 0.8;
    }
    return baseFontSize;
  }

  Widget _buildMainTypography(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: screenHeight * (isMobile ? 1.0 : 1.8),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ScrollReveal(
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  '(A promises,)',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 50),
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                    height: 0.85,
                    letterSpacing: -3,
                    shadows: [
                      Shadow(color: AppColors.bgDark.withValues(alpha: 0.8), offset: const Offset(2, 2), blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            ScrollReveal(
              delay: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text(
                  'made of\npixels,',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 140),
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                    height: 0.75,
                    letterSpacing: -4,
                    shadows: [
                      Shadow(color: AppColors.bgDark.withValues(alpha: 0.8), offset: const Offset(2, 2), blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            ScrollReveal(
              delay: const Duration(milliseconds: 400),
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  'blossoms in',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 120),
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                    height: 0.85,
                    letterSpacing: 30,
                    shadows: [
                      Shadow(color: AppColors.bgDark.withValues(alpha: 0.8), offset: const Offset(2, 2), blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),
            ScrollReveal(
              delay: const Duration(milliseconds: 600),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'the dart.',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 160),
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 0.75,
                    letterSpacing: -5,
                    shadows: [
                      Shadow(color: AppColors.bgDark.withValues(alpha: 0.8), offset: const Offset(2, 2), blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
