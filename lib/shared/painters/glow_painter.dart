import 'package:flutter/material.dart';

/// A soft radial glow orb — used behind the hero statement and on
/// hover states. Pure paint, no blur filters, so it costs almost nothing.
class GlowPainter extends CustomPainter {
  const GlowPainter({required this.color, this.center = const Alignment(0, -0.2), this.radiusFactor = 0.6});

  final Color color;
  final Alignment center;

  /// Glow radius as a fraction of the shorter side.
  final double radiusFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final c = center.alongSize(size);
    final radius = size.shortestSide * radiusFactor;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: c, radius: radius));
    canvas.drawCircle(c, radius, paint);
  }

  @override
  bool shouldRepaint(covariant GlowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.center != center || oldDelegate.radiusFactor != radiusFactor;
}

/// Non-interactive glow layer widget.
class GlowOrb extends StatelessWidget {
  const GlowOrb({required this.color, super.key, this.center = const Alignment(0, -0.2), this.radiusFactor = 0.6});

  final Color color;
  final Alignment center;
  final double radiusFactor;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: CustomPaint(
        painter: GlowPainter(color: color, center: center, radiusFactor: radiusFactor),
        size: Size.infinite,
      ),
    ),
  );
}
