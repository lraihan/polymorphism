import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

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
  late AnimationController _cursorRevealController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _cursorRevealAnimation;

  final double _blobRadius = 130; // Base circle radius

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _pulseAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _breathController = AnimationController(duration: const Duration(milliseconds: 6000), vsync: this);
    _breathAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _breathController, curve: Curves.easeInOut));

    _cursorRevealController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _cursorRevealAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cursorRevealController, curve: const Interval(0.2, 1, curve: Curves.elasticOut)),
    );

    _pulseController.repeat(reverse: true);
    _breathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathController.dispose();
    _cursorRevealController.dispose();
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
            _buildBackgroundImage(),

            if (isDesktop) _buildMaskedForegroundImage(),

            _buildContentOverlay(context),

            if (isDesktop && _isHovering) _buildCursorRevealIndicator(),
          ],
        ),
      );

      if (isDesktop) {
        heroContent = MouseRegion(
          onEnter: (_) {
            setState(() => _isHovering = true);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (_isHovering && mounted) {
                _cursorRevealController.forward();
              }
            });
          },
          onExit: (_) {
            setState(() => _isHovering = false);
            _cursorRevealController.reverse();
          },
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
        Positioned.fill(
          child: Image.asset(
            'assets/images/Foreground.jpg',
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
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
    animation: Listenable.merge([_breathController, _cursorRevealController]),
    builder: (context, child) {
      final revealProgress = _cursorRevealAnimation.value;

      return Positioned.fill(
        child: ClipPath(
          clipper: _LiquidBlobClipper(
            center: _mousePosition,
            screenSize: _screenSize,
            breathProgress: _breathAnimation.value,
            liquidProgress: 0, // Not used for circle
            blobSeeds: const [], // Not used for circle
            blobRadius: _blobRadius * revealProgress, // Scale with reveal animation
            isHovering: _isHovering,
            revealProgress: revealProgress,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Background.jpg',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
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
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(color: AppColors.moonGlow.withValues(alpha: 0.05)),
              ),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildContentOverlay(BuildContext context) => Positioned.fill(
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: verticalPadding(context), horizontal: horizontalPadding(context)),
      child:
          kIsWeb && MediaQuery.of(context).size.width < 800
              ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight(context) * .1),
                        ScrollReveal(
                          child: Column(
                            children: [
                              Text(
                                'I BUILD THE QUIET SPACE-',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: _getResponsiveFontSize(context, 56),
                                  letterSpacing: 4,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'WHERE FUNCTION AND BEAUTY MEET.',
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

                        SizedBox(height: verticalPadding(context)),

                        ScrollReveal(
                          delay: const Duration(milliseconds: 200),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Text(
                              'I design and develop apps that do more than look good—\nthey tell stories, evoke emotions, and feel alive.',
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
                      ],
                    ),
                  ),

                  SizedBox(height: verticalPadding(context)),
                  ScrollReveal(
                    delay: const Duration(milliseconds: 800),
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
                  const SizedBox(height: 40),
                ],
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight(context) * .2),
                        ScrollReveal(
                          child: Column(
                            children: [
                              Text(
                                'I BUILD THE QUIET SPACE-',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: _getResponsiveFontSize(context, 56),
                                  letterSpacing: 4,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'WHERE FUNCTION AND BEAUTY MEET.',
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

                        SizedBox(height: verticalPadding(context)),
                      ],
                    ),
                  ),
                  if (kIsWeb && MediaQuery.of(context).size.width > 800)
                    SizedBox(
                      width: screenWidth(context) - verticalPadding(context) * 2,
                      child: ScrollReveal(
                        delay: const Duration(milliseconds: 800),
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
                    ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0),
                          AppColors.accent.withValues(alpha: 0.3),
                          AppColors.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: screenWidth(context) - horizontalPadding(context) * 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ScrollReveal(
                          delay: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: screenWidth(context) * .15,
                            child: Text(
                              'UI UX Designer',
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
                        ScrollReveal(
                          delay: const Duration(milliseconds: 200),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Text(
                              'I design and develop apps that do more than look good—\nthey tell stories, evoke emotions, and feel alive.',
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
                        ScrollReveal(
                          delay: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: screenWidth(context) * .15,
                            child: Text(
                              'Flutter Engineer',
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
                      ],
                    ),
                  ),
                ],
              ),
    ),
  );

  Widget _buildCursorRevealIndicator() => AnimatedBuilder(
    animation: Listenable.merge([_pulseAnimation, _cursorRevealAnimation]),
    builder: (context, child) {
      final revealScale = _cursorRevealAnimation.value.clamp(0.0, 1.0);
      final pulseScale = _pulseAnimation.value.clamp(1.0, 1.2);

      final clampedOpacity = _cursorRevealAnimation.value.clamp(0.0, 1.0);

      return Positioned(
        left: _mousePosition.dx - 20,
        top: _mousePosition.dy - 20,
        child: Transform.scale(
          scale: (revealScale * pulseScale).clamp(0.0, 1.5),
          child: Opacity(
            opacity: clampedOpacity,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: (0.6 * clampedOpacity).clamp(0.0, 1.0)),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: (0.3 * clampedOpacity).clamp(0.0, 1.0)),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ColoredBox(
                    color: AppColors.accent.withValues(alpha: (0.1 * clampedOpacity).clamp(0.0, 1.0)),
                    child: Icon(Icons.visibility, color: AppColors.accent.withValues(alpha: clampedOpacity), size: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 480) {
      return baseFontSize * 0.4; // Extra small mobile
    } else if (screenWidth < 600) {
      return baseFontSize * 0.5; // Small mobile
    } else if (screenWidth < 768) {
      return baseFontSize * 0.6; // Large mobile
    } else if (screenWidth < 1024) {
      return baseFontSize * 0.75; // Tablet
    } else if (screenWidth < 1440) {
      return baseFontSize * 0.9; // Small desktop
    }
    return baseFontSize; // Large desktop
  }
}

class _LiquidBlobClipper extends CustomClipper<Path> {
  const _LiquidBlobClipper({
    required this.center,
    required this.screenSize,
    required this.breathProgress,
    required this.liquidProgress,
    required this.blobSeeds,
    required this.blobRadius,
    required this.isHovering,
    this.revealProgress = 1.0,
  });

  final Offset center;
  final Size screenSize;
  final double breathProgress;
  final double liquidProgress;
  final List<double> blobSeeds;
  final double blobRadius;
  final bool isHovering;
  final double revealProgress;

  @override
  Path getClip(Size size) {
    final path = Path();

    if (!isHovering || screenSize == Size.zero || revealProgress <= 0) {
      return path;
    }

    final breathScale = 1.0 + math.sin(breathProgress * math.pi * 2) * 0.15;

    final finalRadius = blobRadius * breathScale * revealProgress;

    path.addOval(Rect.fromCircle(center: center, radius: finalRadius));

    return path;
  }

  @override
  bool shouldReclip(covariant _LiquidBlobClipper oldClipper) =>
      center != oldClipper.center ||
      breathProgress != oldClipper.breathProgress ||
      isHovering != oldClipper.isHovering ||
      revealProgress != oldClipper.revealProgress;
}
