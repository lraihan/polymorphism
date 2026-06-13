import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';

/// Subtle dot-grid background — 40 px pitch, ~4 % opacity.
///
/// Static (paints once); always wrap in a [RepaintBoundary] via [GridDotField].
class GridDotPainter extends CustomPainter {
  const GridDotPainter({this.pitch = 40, this.opacity = 0.04});

  final double pitch;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.textPrimary.withValues(alpha: opacity);
    for (var x = pitch / 2; x < size.width; x += pitch) {
      for (var y = pitch / 2; y < size.height; y += pitch) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridDotPainter oldDelegate) =>
      oldDelegate.pitch != pitch || oldDelegate.opacity != opacity;
}

/// Convenience widget: isolated, non-interactive dot grid layer.
class GridDotField extends StatelessWidget {
  const GridDotField({super.key});

  @override
  Widget build(BuildContext context) => const IgnorePointer(
    child: RepaintBoundary(
      child: CustomPaint(painter: GridDotPainter(), size: Size.infinite),
    ),
  );
}
