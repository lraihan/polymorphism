import 'package:flutter/material.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// Stand out section inspired by Karim Saab's website
/// Features large typographic design with scroll-reveal image fragments
/// Exact replica of the "BE THE ONE TO Stand Out IN A WORLD FULL OF NOISE" section
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

    // Calculate section visibility
    final sectionTop = sectionPosition.dy + scrollPosition;
    final sectionBottom = sectionTop + sectionBox.size.height;
    final viewportTop = scrollPosition;
    final viewportBottom = scrollPosition + screenHeight;

    // Check if section is visible (logic preserved for future enhancements)
    if (sectionTop <= viewportBottom && sectionBottom >= viewportTop) {
      // Section is visible
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      key: _sectionKey,
      width: double.infinity,
      height: screenHeight * (isMobile ? 1 : 1.8), // Shorter on mobile
      color: AppColors.bgDark,
      child: Stack(children: [_buildTypographyOverlay(context)]),
    );
  }

  /// Build typography overlay that appears over the images
  Widget _buildTypographyOverlay(BuildContext context) => Positioned.fill(child: _buildMainTypography(context));

  /// Get responsive font size based on screen width
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseFontSize * 0.4; // Mobile - much smaller
    } else if (screenWidth < 900) {
      return baseFontSize * 0.6; // Tablet - smaller
    } else if (screenWidth < 1200) {
      return baseFontSize * 0.8; // Small desktop
    }
    return baseFontSize; // Full desktop size
  }

  /// Build the main typography layout with custom poetic text
  /// "A promises, made of pixels, blossoms in the dart."
  Widget _buildMainTypography(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: screenHeight * (isMobile ? 1.0 : 1.8), // Use full section height
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute evenly
          children: [
            // "A promises," text
            ScrollReveal(
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  '(A promises,)',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 50), // Reduced font size
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

            const SizedBox(height: AppSpacing.lg), // Reduced spacing
            // "made of pixels," text with accent color and right alignment
            ScrollReveal(
              delay: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text(
                  'made of\npixels,',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 140), // Reduced font size
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

            const SizedBox(height: AppSpacing.lg), // Reduced spacing
            // "blossoms in" text
            ScrollReveal(
              delay: const Duration(milliseconds: 400),
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  'blossoms in',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 120), // Reduced font size
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

            const SizedBox(height: AppSpacing.xxxl), // Reduced spacing
            // "the dart." text with primary color and center alignment
            ScrollReveal(
              delay: const Duration(milliseconds: 600),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'the dart.',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: _getResponsiveFontSize(context, 160), // Reduced font size
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
