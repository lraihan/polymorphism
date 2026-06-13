import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/constants/assets.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';

/// The hero's masked-reveal portrait.
///
/// Base layer: the low-poly, composed face on near-black ([AppAssets.heroForeground]).
/// Under the cursor, a soft circular mask reveals the colourful, smiling self
/// surrounded by real work ([AppAssets.heroBackground]) — a literal "look
/// closer" of the polymorphism theme.
///
/// - Desktop: the reveal follows [pointer] with a gentle breathing radius.
///   ([pointer] is fed by an ancestor MouseRegion in the hero so the
///   scroll-view / text layer can't occlude it.)
/// - Touch / reduced motion: the reveal drifts on a slow autonomous orbit so
///   the colour is still discoverable without a mouse.
/// - The background photo loads lazily after mount so it never gates the intro.
class HeroPortrait extends StatefulWidget {
  const HeroPortrait({required this.pointer, super.key});

  /// Pointer position in the hero's local coordinate space, or null when no
  /// mouse is hovering. Drives the reveal centre and ramp.
  final ValueListenable<Offset?> pointer;

  @override
  State<HeroPortrait> createState() => _HeroPortraitState();
}

class _HeroPortraitState extends State<HeroPortrait>
    with TickerProviderStateMixin {
  late final AnimationController _breath; // radius breathing
  late final AnimationController _orbit; // autonomous reveal path (touch)
  late final AnimationController _enter; // reveal ramp on pointer enter/exit

  Size _size = Size.zero;
  bool _bgLoaded = false;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _enter = AnimationController(vsync: this, duration: AppDurations.slow);
    widget.pointer.addListener(_onPointerChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion) {
      _breath.stop();
      _orbit.stop();
    }
    // Lazily pull the 4 MB reveal photo into the cache after first frame.
    if (!_bgLoaded) {
      _bgLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          precacheImage(
            AppAssets.heroProvider(AppAssets.heroBackground),
            context,
            onError: (_, __) {},
          );
        }
      });
    }
  }

  @override
  void dispose() {
    widget.pointer.removeListener(_onPointerChange);
    _breath.dispose();
    _orbit.dispose();
    _enter.dispose();
    super.dispose();
  }

  bool get _autonomous => !context.supportsHover; // touch devices

  /// Ramp the reveal in when the pointer is present, out when it leaves.
  void _onPointerChange() {
    if (_autonomous) {
      return;
    }
    if (widget.pointer.value != null) {
      _enter.forward();
    } else {
      _enter.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = context.reducedMotion;
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          _size = Size(constraints.maxWidth, constraints.maxHeight);
          // Static layers (base face + scrim) are drawn once and composited;
          // only the animated reveal layer re-records each frame.
          return Stack(
            fit: StackFit.expand,
            children: [
              // Base — the composed, low-poly face.
              _PortraitImage(path: AppAssets.heroForeground, alignment: _imageAlignment),
              // Edge scrim (below the reveal) so left-side text keeps contrast
              // without dimming the colourful reveal.
              const IgnorePointer(child: _HeroScrim()),
              // Reveal + ring — isolated so its per-frame repaint never
              // re-records the static base image behind it.
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_breath, _orbit, _enter, widget.pointer]),
                  builder: (context, _) {
                    final center = _resolveCenter(reduceMotion);
                    final radius = _resolveRadius(reduceMotion);
                    if (radius <= 0.5) {
                      return const SizedBox.expand();
                    }
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Reveal — colour + work, clipped to the soft circle.
                        ClipPath(
                          clipper: _CircleRevealClipper(center: center, radius: radius),
                          child: _PortraitImage(path: AppAssets.heroBackground, alignment: _imageAlignment),
                        ),
                        // Faint ring marking the lens of the reveal.
                        if (!reduceMotion)
                          Positioned(
                            left: center.dx - radius,
                            top: center.dy - radius,
                            child: IgnorePointer(
                              child: Container(
                                width: radius * 2,
                                height: radius * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.accentPrimary.withValues(alpha: 0.3)),
                                  boxShadow: const [
                                    BoxShadow(color: AppColors.accentSubtle, blurRadius: 18, spreadRadius: 1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// The face sits a touch above centre in both photos; bias the crop up.
  Alignment get _imageAlignment => const Alignment(0, -0.15);

  Offset _resolveCenter(bool reduceMotion) {
    if (_size.isEmpty) {
      return Offset.zero;
    }
    final pointer = widget.pointer.value;
    if (!_autonomous && pointer != null) {
      return pointer;
    }
    // Autonomous / reduced-motion: a slow Lissajous drift across the face.
    final t = reduceMotion ? 0.25 : _orbit.value;
    final angle = t * math.pi * 2;
    return Offset(
      _size.width * (0.5 + 0.18 * math.cos(angle)),
      _size.height * (0.42 + 0.14 * math.sin(angle * 1.3)),
    );
  }

  double _resolveRadius(bool reduceMotion) {
    final base = math.min(_size.width, _size.height) * 0.22;
    final breath =
        reduceMotion ? 1.0 : (1 + math.sin(_breath.value * math.pi * 2) * 0.08);
    if (_autonomous || reduceMotion) {
      return base * breath * (reduceMotion ? 0.9 : 1);
    }
    // Pointer-driven: ramp from 0 via the enter controller.
    return base * breath * AppCurves.spring.transform(_enter.value);
  }
}

/// One full-bleed hero photo, decoded at the shared capped width.
class _PortraitImage extends StatelessWidget {
  const _PortraitImage({required this.path, required this.alignment});

  final String path;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Image(
    image: AppAssets.heroProvider(path),
    fit: BoxFit.cover,
    alignment: alignment,
    gaplessPlayback: true,
    errorBuilder:
        (context, error, stackTrace) =>
            const ColoredBox(color: AppColors.deepSpace),
    frameBuilder:
        (context, child, frame, wasSync) => AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: AppDurations.slow,
          child: child,
        ),
  );
}

/// Vignette + left scrim: blends the photo into deep space and guarantees
/// contrast for the statement text on the left.
class _HeroScrim extends StatelessWidget {
  const _HeroScrim();

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepSpace.withValues(alpha: 0.92),
              AppColors.deepSpace.withValues(alpha: 0.35),
              AppColors.deepSpace.withValues(alpha: 0.15),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.deepSpace.withValues(alpha: 0.75),
              AppColors.deepSpace.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.4],
          ),
        ),
      ),
    ],
  );
}

/// Soft-edged circle clip for the reveal.
class _CircleRevealClipper extends CustomClipper<Path> {
  const _CircleRevealClipper({required this.center, required this.radius});

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) =>
      Path()..addOval(Rect.fromCircle(center: center, radius: radius));

  @override
  bool shouldReclip(covariant _CircleRevealClipper oldClipper) =>
      oldClipper.center != center || oldClipper.radius != radius;
}

/// Tiny inline hint shown once near the portrait inviting the hover reveal.
class HeroRevealHint extends StatelessWidget {
  const HeroRevealHint({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentPrimary,
        ),
      ),
      const SizedBox(width: Spacing.sm),
      Text(
        context.supportsHover ? 'hover the portrait' : 'tap to explore',
        style: AppTypography.mono,
      ),
    ],
  );
}
