import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The About portrait, built from the six B&W "ink-drip" fragments.
///
/// They are overlapping crops, not a tiling jigsaw, so they're composed as a
/// deliberately fragmented portrait. At rest the pieces sit **scattered and
/// tilted**; hover and they **unite** — sliding and rotating home in a stagger
/// into the assembled face. Touch devices (no hover) assemble on scroll-in.
class FragmentPortrait extends StatefulWidget {
  const FragmentPortrait({super.key});

  @override
  State<FragmentPortrait> createState() => _FragmentPortraitState();
}

/// Placement of one fragment within the frame, in fractions of frame size.
class _Frag {
  const _Frag({
    required this.asset,
    required this.left,
    required this.top,
    required this.width,
    required this.rotation,
    required this.scatter,
    required this.spin,
    required this.order,
  });

  final int asset; // 1..6
  final double left;
  final double top;
  final double width;
  final double rotation; // composed (united) tilt, radians
  final Offset scatter; // displacement when scattered (fraction of frame)
  final double spin; // rotation when scattered, radians
  final int order; // stagger index
}

class _FragmentPortraitState extends State<FragmentPortrait> with SingleTickerProviderStateMixin {
  late final AnimationController _assemble; // 0 = scattered, 1 = united
  bool _autoTriggered = false;

  // Composition tuned to read as a fragmented face: hair/brow up top, the
  // central strip down the nose, the smile and beard across the lower half.
  // `scatter` pushes each piece outward from centre; `spin` tilts it loose.
  static const List<_Frag> _frags = [
    _Frag(asset: 6, left: 0.04, top: -0.02, width: 0.62, rotation: -0.03, scatter: Offset(-0.10, -0.20), spin: -0.26, order: 0),
    _Frag(asset: 2, left: -0.02, top: 0.14, width: 0.44, rotation: 0.02, scatter: Offset(-0.20, -0.04), spin: 0.22, order: 2),
    _Frag(asset: 3, left: 0.40, top: 0.02, width: 0.17, rotation: 0, scatter: Offset(0.04, -0.24), spin: -0.30, order: 1),
    _Frag(asset: 4, left: 0.50, top: 0.28, width: 0.42, rotation: 0.035, scatter: Offset(0.20, 0.02), spin: 0.28, order: 3),
    _Frag(asset: 1, left: 0.06, top: 0.46, width: 0.42, rotation: -0.02, scatter: Offset(-0.16, 0.18), spin: -0.20, order: 4),
    _Frag(asset: 5, left: 0.22, top: 0.66, width: 0.72, rotation: 0.015, scatter: Offset(0.08, 0.22), spin: 0.18, order: 5),
  ];

  @override
  void initState() {
    super.initState();
    _assemble = AnimationController(vsync: this, duration: AppDurations.sluggish);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion) {
      _assemble.value = 1;
      _autoTriggered = true;
    }
  }

  @override
  void dispose() {
    _assemble.dispose();
    super.dispose();
  }

  /// Touch devices can't hover, so assemble once when scrolled into view.
  void _onVisibility(VisibilityInfo info) {
    if (!mounted || _autoTriggered || context.supportsHover) {
      return;
    }
    if (info.visibleFraction > 0.2) {
      _autoTriggered = true;
      _assemble.forward();
    }
  }

  double _fragProgress(int order) {
    const span = 0.6;
    final start = order * (1 - span) / (_frags.length - 1);
    return AppCurves.spring.transform(_assemble.value.subProgress(start, start + span).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final supportsHover = context.supportsHover;

    Widget content = VisibilityDetector(
      key: const Key('fragment-portrait'),
      onVisibilityChanged: _onVisibility,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return AnimatedBuilder(
              animation: _assemble,
              builder: (context, _) => Stack(
                clipBehavior: Clip.none,
                children: [
                  // Soft accent aura, brightening as the pieces unite.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0.1, -0.1),
                            radius: 0.9,
                            colors: [
                              AppColors.accentPrimary.withValues(alpha: 0.07 * _assemble.value),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (final f in _frags) _buildFragment(f, w, h),
                  // Viewfinder marks frame the whole composition.
                  const Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _CornerMarksPainter()))),
                  // Hint, fading out as the portrait unites.
                  if (supportsHover)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -Spacing.xl,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: (1 - _assemble.value).clamp(0.0, 1.0) * 0.8,
                          child: Center(child: Text('hover to assemble', style: AppTypography.mono)),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (supportsHover) {
      content = MouseRegion(
        opaque: false,
        onEnter: (_) => _assemble.forward(),
        onExit: (_) => _assemble.reverse(),
        child: content,
      );
    }

    return Semantics(
      image: true,
      label: 'Portrait of ${AppStrings.ownerFullName}, in fragments',
      child: content,
    );
  }

  Widget _buildFragment(_Frag f, double w, double h) {
    final p = _fragProgress(f.order);
    // Scattered (p=0) → composed (p=1).
    final dx = f.scatter.dx * w * (1 - p);
    final dy = f.scatter.dy * h * (1 - p);
    final angle = ui.lerpDouble(f.spin, f.rotation, p)!;

    return Positioned(
      left: f.left * w + dx,
      top: f.top * h + dy,
      width: f.width * w,
      child: Opacity(
        // `p` can overshoot 1 (spring curve), so clamp the alpha.
        opacity: (0.82 + 0.18 * p).clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: angle,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepSpace.withValues(alpha: 0.35 + 0.3 * p),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Image.asset('assets/images/fragment${f.asset}.webp', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

/// Camera-viewfinder corner brackets around the fragment cluster.
class _CornerMarksPainter extends CustomPainter {
  const _CornerMarksPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const arm = 18.0;
    final paint = Paint()
      ..color = AppColors.accentPrimary.withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final corners = [
      (Offset.zero, const Offset(arm, 0), const Offset(0, arm)),
      (Offset(size.width, 0), const Offset(-arm, 0), const Offset(0, arm)),
      (Offset(0, size.height), const Offset(arm, 0), const Offset(0, -arm)),
      (Offset(size.width, size.height), const Offset(-arm, 0), const Offset(0, -arm)),
    ];
    for (final (corner, dx, dy) in corners) {
      canvas
        ..drawLine(corner, corner + dx, paint)
        ..drawLine(corner, corner + dy, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CornerMarksPainter oldDelegate) => false;
}
