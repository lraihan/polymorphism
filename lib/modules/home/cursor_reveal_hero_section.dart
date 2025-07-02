import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// Hero section with cursor-following mask reveal inspired by karim-saab.com
class CursorRevealHeroSection extends StatefulWidget {
  const CursorRevealHeroSection({super.key, this.onExplorePressed});

  final VoidCallback? onExplorePressed;

  @override
  State<CursorRevealHeroSection> createState() => _CursorRevealHeroSectionState();
}

class _CursorRevealHeroSectionState extends State<CursorRevealHeroSection> with TickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  Size _screenSize = Size.zero;
  bool _isHovering = false;

  late AnimationController _pulseController;
  late AnimationController _breathController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _breathAnimation;

  // Circle parameters
  double _blobRadius = 130.0; // Base circle radius

  @override
  void initState() {
    super.initState();

    // Pulse animation for the reveal indicator
    _pulseController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Slow breathing animation for circle scaling
    _breathController = AnimationController(duration: const Duration(milliseconds: 6000), vsync: this);
    _breathAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _breathController, curve: Curves.easeInOut));

    // Start animations
    _pulseController.repeat(reverse: true);
    _breathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        _screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        final isDesktop = kIsWeb && constraints.maxWidth > 800;

        Widget heroContent = Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.bgDark,
          child: Stack(
            children: [
              // Background image layer
              _buildBackgroundImage(),

              // Foreground image layer with mask reveal
              if (isDesktop) _buildMaskedForegroundImage(),

              // Content overlay
              _buildContentOverlay(context),

              // Cursor reveal indicator (desktop only)
              if (isDesktop && _isHovering) _buildCursorRevealIndicator(),
            ],
          ),
        );

        // Wrap with mouse region for desktop
        if (isDesktop) {
          heroContent = MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            onHover: (event) {
              setState(() {
                _mousePosition = event.localPosition;
              });
            },
            child: heroContent,
          );
        }

        return heroContent;
      },
    );

  Widget _buildBackgroundImage() => Positioned.fill(
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Foreground.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.bgDark, AppColors.moonGlow.withValues(alpha: 0.1), AppColors.bgDark],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
            ),
          ),
          // Subtle overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.bgDark.withValues(alpha: 0.1), AppColors.bgDark.withValues(alpha: 0.4)],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildMaskedForegroundImage() => AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) => Positioned.fill(
          child: ClipPath(
            clipper: _LiquidBlobClipper(
              center: _mousePosition,
              screenSize: _screenSize,
              breathProgress: _breathAnimation.value,
              liquidProgress: 0, // Not used for circle
              blobSeeds: const [], // Not used for circle
              blobRadius: _blobRadius,
              isHovering: _isHovering,
            ),
            child: Stack(
              children: [
                // Foreground image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Background.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 1.2,
                            colors: [
                              AppColors.accent.withValues(alpha: 0.4),
                              AppColors.moonGlow.withValues(alpha: 0.3),
                              AppColors.bgDark.withValues(alpha: 0.6),
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                  ),
                ),
                // Subtle glass effect overlay
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(color: AppColors.moonGlow.withValues(alpha: 0.05)),
                ),
              ],
            ),
          ),
        ),
    );

  Widget _buildContentOverlay(BuildContext context) => Positioned.fill(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main headline
            ScrollReveal(
              child: Column(
                children: [
                  Text(
                    'MY DESIGNS-',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveFontSize(context, 56),
                      letterSpacing: 8,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'whisper to the code.',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w300,
                      fontSize: _getResponsiveFontSize(context, 42),
                      letterSpacing: 2,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Subtitle
            ScrollReveal(
              delay: const Duration(milliseconds: 200),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'I design and develop websites that do more than look good—they tell stories, evoke emotions, and make brands feel alive.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    fontSize: _getResponsiveFontSize(context, 18),
                    height: 1.6,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Scroll indicator (desktop only)
            if (kIsWeb && MediaQuery.of(context).size.width > 800)
              ScrollReveal(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    Text(
                      'Scroll to explore',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

  Widget _buildCursorRevealIndicator() => AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Positioned(
          left: _mousePosition.dx - 20,
          top: _mousePosition.dy - 20,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 2),
                boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2)],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ColoredBox(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    child: const Icon(Icons.visibility, color: AppColors.accent, size: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
    );

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseFontSize * 0.7; // Mobile
    } else if (screenWidth < 1024) {
      return baseFontSize * 0.85; // Tablet
    }
    return baseFontSize; // Desktop
  }
}

/// Simple circle clipper for cursor reveal
class _LiquidBlobClipper extends CustomClipper<Path> {
  const _LiquidBlobClipper({
    required this.center,
    required this.screenSize,
    required this.breathProgress,
    required this.liquidProgress,
    required this.blobSeeds,
    required this.blobRadius,
    required this.isHovering,
  });

  final Offset center;
  final Size screenSize;
  final double breathProgress;
  final double liquidProgress;
  final List<double> blobSeeds;
  final double blobRadius;
  final bool isHovering;

  @override
  Path getClip(Size size) {
    final path = Path();

    if (!isHovering || screenSize == Size.zero) {
      return path;
    }

    // Simple breathing effect for circle scaling
    final breathScale = 1.0 + math.sin(breathProgress * math.pi * 2) * 0.15;

    // Calculate final radius with breathing
    final finalRadius = blobRadius * breathScale;

    // Create a simple circle at the cursor position
    path.addOval(Rect.fromCircle(center: center, radius: finalRadius));

    return path;
  }

  @override
  bool shouldReclip(covariant _LiquidBlobClipper oldClipper) => center != oldClipper.center ||
        breathProgress != oldClipper.breathProgress ||
        isHovering != oldClipper.isHovering;
}
