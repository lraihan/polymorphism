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
  double _scrollProgress = 0.0;
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
    if (sectionContext == null) return;

    final sectionBox = sectionContext.findRenderObject() as RenderBox?;
    if (sectionBox == null) return;

    final sectionPosition = sectionBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollPosition = widget.scrollController!.offset;

    // Calculate section visibility and scroll progress
    final sectionTop = sectionPosition.dy + scrollPosition;
    final sectionBottom = sectionTop + sectionBox.size.height;
    final viewportTop = scrollPosition;
    final viewportBottom = scrollPosition + screenHeight;

    if (sectionTop <= viewportBottom && sectionBottom >= viewportTop) {
      // Section is visible - calculate progress through the section
      final sectionProgress = ((scrollPosition - (sectionTop - screenHeight)) / (sectionBox.size.height + screenHeight))
          .clamp(0.0, 1.0);

      setState(() {
        _scrollProgress = sectionProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      key: _sectionKey,
      width: double.infinity,
      height: screenHeight * 1.8,
      color: AppColors.bgDark,
      child: Stack(
        children: [
          // Background image fragments that reveal as user scrolls
          _buildImageReveal(context),
          // Typography overlay
          _buildTypographyOverlay(context),
        ],
      ),
    );
  }

  /// Build the image reveal effect with fragments
  Widget _buildImageReveal(BuildContext context) => Positioned.fill(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Complete background image that fades in as fragments appear
        Positioned.fill(
          child: Opacity(
            opacity: (_scrollProgress * 2.5).clamp(0.0, 0.3), // Subtle background image
            child: Image.asset(
              'assets/images/complete.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.bgDark.withValues(alpha: 0.1)),
            ),
          ),
        ),

        // Image fragments that appear and move as user scrolls
        ...List.generate(6, (index) => _buildImageFragment(context, index + 1)),

        // Dark overlay to maintain readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bgDark.withValues(alpha: 0.7),
                  AppColors.bgDark.withValues(alpha: 0.4),
                  AppColors.bgDark.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  /// Build individual image fragment with scroll-based animation
  Widget _buildImageFragment(BuildContext context, int fragmentIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate when this fragment should appear based on scroll progress
    final fragmentStart = (fragmentIndex - 1) * 0.15; // Stagger fragments
    final fragmentEnd = fragmentStart + 0.4; // Each fragment has some overlap

    final fragmentProgress = ((_scrollProgress - fragmentStart) / (fragmentEnd - fragmentStart)).clamp(0.0, 1.0);

    // Different positioning for each fragment
    final positions = [
      {'left': screenWidth * 0.1, 'top': screenHeight * 2 * 0.2},
      {'left': screenWidth * 0.6, 'top': screenHeight * 2 * 0.15},
      {'left': screenWidth * 0.3, 'top': screenHeight * 2 * 0.4},
      {'left': screenWidth * 0.8, 'top': screenHeight * 2 * 0.35},
      {'left': screenWidth * 0.15, 'top': screenHeight * 2 * 0.6},
      {'left': screenWidth * 0.5, 'top': screenHeight * 2 * 0.7},
    ];

    final position = positions[fragmentIndex - 1];

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: position['left']! - (fragmentProgress * 50), // Slight movement effect
      top: position['top']! + (fragmentProgress * 30),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: fragmentProgress,
        child: Transform.scale(
          scale: 0.8 + (fragmentProgress * 0.3), // Scale effect
          child: Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.2 * fragmentProgress),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/fragment$fragmentIndex.png',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build typography overlay that appears over the images
  Widget _buildTypographyOverlay(BuildContext context) => Positioned.fill(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: AppSpacing.xxxl * 2),
          _buildMainTypography(context),
          const SizedBox(height: AppSpacing.xxxl * 2),
        ],
      ),
    ),
  );

  /// Build the main typography layout with custom poetic text
  /// "A promises, made of pixels, blossoms in the dart."
  Widget _buildMainTypography(BuildContext context) => Container(
    height: screenHeight(context) * 1.4, // Adjust height for better spacing
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  letterSpacing: -3,
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

  /// Get responsive button font size
  double _getResponsiveButtonFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return 14.0; // Mobile
    } else if (screenWidth < 900) {
      return 16.0; // Tablet
    } else {
      return 18.0; // Desktop
    }
  }

  /// Get responsive icon size
  double _getResponsiveIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return 20.0; // Mobile
    } else if (screenWidth < 900) {
      return 22.0; // Tablet
    } else {
      return 24.0; // Desktop
    }
  }
}
