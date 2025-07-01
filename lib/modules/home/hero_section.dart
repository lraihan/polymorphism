import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/router/app_routes.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  Offset _mousePosition = Offset.zero;
  Size _screenSize = Size.zero;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        _screenSize = Size(constraints.maxWidth, constraints.maxHeight);

        // Check if we should enable parallax (desktop only)
        final isDesktop = kIsWeb && constraints.maxWidth > 800;

        Widget heroContent = Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.bgDark, AppColors.moonGlow.withValues(alpha: 0.4)],
              stops: const [0.0, 1],
            ),
          ),
          child: Stack(
            children: [
              // Layer 0: Blurred radial glow (slow parallax 0.2x)
              _buildRadialGlow(_calculateParallaxOffset(0.2)),

              // Layer 1: Glass rectangle (0.5x)
              _buildGlassRectangle(_calculateParallaxOffset(0.5)),

              // Layer 2: Headline & CTA (1x)
              _buildHeadlineAndCTA(context, _calculateParallaxOffset(1)),
            ],
          ),
        );

        // Wrap with MouseRegion for desktop parallax
        if (isDesktop) {
          heroContent = MouseRegion(
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

  Offset _calculateParallaxOffset(double intensity) {
    if (_screenSize == Size.zero) {
      return Offset.zero;
    }

    // Calculate relative mouse position (-1 to 1)
    final relativeX = (_mousePosition.dx / _screenSize.width - 0.5) * 2;
    final relativeY = (_mousePosition.dy / _screenSize.height - 0.5) * 2;

    // Apply intensity and scale
    const maxOffset = 20.0;
    return Offset(relativeX * maxOffset * intensity, relativeY * maxOffset * intensity);
  }

  Widget _buildRadialGlow(Offset parallaxOffset) => Positioned(
      top: -100 + parallaxOffset.dy,
      left: -100 + parallaxOffset.dx,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.moonGlow.withValues(alpha: 0.3),
              AppColors.moonGlow.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.transparent),
        ),
      ),
    );

  Widget _buildGlassRectangle(Offset parallaxOffset) => Positioned(
      top: 100 + parallaxOffset.dy,
      right: 50 - parallaxOffset.dx,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 200,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.glassSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.moonGlow.withValues(alpha: 0.2)),
            ),
          ),
        ),
      ),
    );

  Widget _buildHeadlineAndCTA(BuildContext context, Offset parallaxOffset) => Positioned.fill(
      child: Transform.translate(
        offset: parallaxOffset,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                header: true,
                label: 'Main headline: I craft fluid interfaces that behave',
                child: Text(
                  'I craft fluid interfaces\nthat behave.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.textPrimary, height: 1.2),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () => context.go(AppRoutes.projectsPath),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.moonGlow,
                  foregroundColor: AppColors.bgDark,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Explore Projects', semanticsLabel: 'Explore Projects'),
              ),
            ],
          ),
        ),
      ),
    );
}
