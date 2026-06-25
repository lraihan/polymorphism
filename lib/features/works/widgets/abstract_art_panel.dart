import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/data/models/project.dart';

/// Editorial "gallery spotlight" art for a project with no screenshots (Balai):
/// a spotlight beam, a tightening countdown ring, and a wall of lots — the
/// auction's drama, rendered. Pulses gently unless reduced motion is on.
class AbstractArtPanel extends StatefulWidget {
  const AbstractArtPanel({required this.project, super.key});

  final Project project;

  @override
  State<AbstractArtPanel> createState() => _AbstractArtPanelState();
}

class _AbstractArtPanelState extends State<AbstractArtPanel> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.crawl)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pulse = context.reducedMotion ? const AlwaysStoppedAnimation(0.5) : _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: pulse,
          builder: (context, _) => CustomPaint(
            painter: _GallerySpotlightPainter(accent: widget.project.accentColor, pulse: pulse.value),
          ),
        ),
        // editorial overlay
        Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: widget.project.accentColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'LIVE DROP · LOT 01 / 03',
                    style: AppTypography.mono.copyWith(fontSize: 10, color: widget.project.accentColor),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Balai',
                style: AppTypography.displayM.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.92),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'Curated drops — in design',
                style: AppTypography.caption.copyWith(color: widget.project.accentColor.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GallerySpotlightPainter extends CustomPainter {
  _GallerySpotlightPainter({required this.accent, required this.pulse});

  final Color accent;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final spot = Offset(w * 0.5, h * 0.34);
    final unit = math.min(w, h);

    // spotlight beam — a soft cone from the top toward the hero lot
    final beam = Path()
      ..moveTo(w * 0.5, -20)
      ..lineTo(w * 0.5 - unit * 0.34, h * 0.86)
      ..lineTo(w * 0.5 + unit * 0.34, h * 0.86)
      ..close();
    canvas
      ..drawPath(
        beam,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [accent.withValues(alpha: 0.16), Colors.transparent],
          ).createShader(Rect.fromLTWH(0, 0, w, h)),
      )
      // soft spotlight glow
      ..drawCircle(
        spot,
        unit * 0.30,
        Paint()
          ..shader = RadialGradient(
            colors: [accent.withValues(alpha: 0.22), Colors.transparent],
          ).createShader(Rect.fromCircle(center: spot, radius: unit * 0.30)),
      );

    // countdown rings — the inner one tightens with the pulse
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final r = unit * (0.16 + i * 0.085);
      ringPaint
        ..color = accent.withValues(alpha: 0.5 - i * 0.14)
        ..strokeWidth = 1.5;
      final sweep = i == 0 ? math.pi * 2 * (0.55 + 0.18 * pulse) : math.pi * 2 * (0.9 - i * 0.1);
      canvas.drawArc(Rect.fromCircle(center: spot, radius: r), -math.pi / 2, sweep, false, ringPaint);
    }

    // gallery wall — three lot frames, the centre one lit under the spotlight
    final wallY = h * 0.74;
    final frameW = unit * 0.16;
    final frameH = h * 0.22;
    for (var i = -1; i <= 1; i++) {
      final cx = w * 0.5 + i * frameW * 1.7;
      final rect = Rect.fromCenter(center: Offset(cx, wallY), width: frameW, height: frameH);
      final lit = i == 0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = lit ? 1.6 : 1
          ..color = lit ? accent.withValues(alpha: 0.85) : AppColors.textMuted.withValues(alpha: 0.5),
      );
      if (lit) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(3), const Radius.circular(2)),
          Paint()..color = accent.withValues(alpha: 0.10),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GallerySpotlightPainter old) => old.pulse != pulse || old.accent != accent;
}
