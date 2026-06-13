import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';

/// Deep-space particle field.
///
/// - 60–80 particles on desktop, 30 on mobile (set via [count]).
/// - White/teal dots, 1–3 px, 15–40 % opacity, slow drift (0.2–0.8 px/frame).
/// - Particles respawn at the opposite edge when they drift out.
/// - An occasional "shooting star" streaks across the field.
/// - No connecting lines, ever.
///
/// Performance: one [AnimationController] mutates the particle model and is
/// also the painter's `repaint` listenable — frames repaint the isolated
/// [CustomPaint] layer without a single widget rebuild. Reduced motion gets
/// one static frame.
class ParticleField extends StatefulWidget {
  const ParticleField({super.key, this.count});

  /// Particle count override; defaults to 70 desktop / 30 mobile.
  final int? count;

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField> with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  final math.Random _rng = math.Random(42);
  final _FieldModel _field = _FieldModel();

  @override
  void initState() {
    super.initState();
    // Frame clock; duration is arbitrary because it repeats.
    _ticker = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..addListener(_advance);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion) {
      _ticker.stop();
    } else if (!_ticker.isAnimating) {
      _ticker.repeat();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _ensureParticles(Size size) {
    if (_field.particles.isNotEmpty) {
      return;
    }
    final n = widget.count ?? (context.isMobile ? 30 : 70);
    _field
      ..bounds = size
      ..particles.addAll(List.generate(n, (_) => _Particle.spawn(_rng, size, anywhere: true)));
  }

  /// Advances the model. No setState — the painter repaints off the ticker.
  void _advance() {
    final size = _field.bounds;
    if (size.isEmpty) {
      return;
    }
    for (final p in _field.particles) {
      p
        ..x += p.vx
        ..y += p.vy;
      // Respawn at an edge once fully out of frame.
      if (p.x < -6 || p.x > size.width + 6 || p.y < -6 || p.y > size.height + 6) {
        final fresh = _Particle.spawn(_rng, size);
        p
          ..x = fresh.x
          ..y = fresh.y
          ..vx = fresh.vx
          ..vy = fresh.vy;
      }
    }
    final star = _field.star;
    if (star != null) {
      star.t += 0.02;
      if (star.t >= 1) {
        _field.star = null;
        _field.starCooldown = 5 + _rng.nextDouble() * 8;
      }
    } else {
      _field.starCooldown -= 1 / 60;
      if (_field.starCooldown <= 0) {
        _field.star = _ShootingStar.spawn(_rng, size);
      }
    }
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _field.bounds = size;
          _ensureParticles(size);
          return CustomPaint(
            painter: _ParticleFieldPainter(field: _field, repaint: _ticker),
            size: size,
          );
        },
      ),
    ),
  );
}

/// Mutable model shared between the tick listener and the painter.
class _FieldModel {
  Size bounds = Size.zero;
  final List<_Particle> particles = [];
  _ShootingStar? star;
  double starCooldown = 6; // seconds until first possible streak
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
    required this.teal,
  });

  factory _Particle.spawn(math.Random rng, Size size, {bool anywhere = false}) {
    final speed = 0.2 + rng.nextDouble() * 0.6; // 0.2–0.8 px/frame
    final angle = rng.nextDouble() * math.pi * 2;
    return _Particle(
      x: anywhere ? rng.nextDouble() * size.width : (rng.nextBool() ? -4 : size.width + 4),
      y: rng.nextDouble() * size.height,
      vx: math.cos(angle) * speed,
      vy: math.sin(angle) * speed,
      radius: 0.5 + rng.nextDouble(), // 1–3 px diameter
      opacity: 0.15 + rng.nextDouble() * 0.25, // 15–40 %
      teal: rng.nextDouble() < 0.3,
    );
  }

  double x;
  double y;
  double vx;
  double vy;
  final double radius;
  final double opacity;
  final bool teal;
}

class _ShootingStar {
  _ShootingStar({required this.start, required this.end});

  factory _ShootingStar.spawn(math.Random rng, Size size) {
    final fromLeft = rng.nextBool();
    final y = size.height * (0.1 + rng.nextDouble() * 0.5);
    return _ShootingStar(
      start: Offset(fromLeft ? -40 : size.width + 40, y),
      end: Offset(fromLeft ? size.width + 40 : -40, y + size.height * (rng.nextDouble() * 0.3 - 0.15)),
    );
  }

  final Offset start;
  final Offset end;
  double t = 0;
}

class _ParticleFieldPainter extends CustomPainter {
  _ParticleFieldPainter({required this.field, super.repaint});

  final _FieldModel field;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in field.particles) {
      paint.color = (p.teal ? AppColors.accentPrimary : AppColors.textPrimary).withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }

    final s = field.star;
    if (s != null) {
      final head = Offset.lerp(s.start, s.end, Curves.easeIn.transform(s.t))!;
      final tail = Offset.lerp(s.start, s.end, Curves.easeIn.transform((s.t - 0.06).clamp(0.0, 1.0)))!;
      final fade = (1 - (s.t - 0.5).abs() * 2).clamp(0.0, 1.0);
      canvas
        ..drawLine(
          tail,
          head,
          Paint()
            ..shader = LinearGradient(
              colors: [
                AppColors.accentPrimary.withValues(alpha: 0),
                AppColors.accentPrimary.withValues(alpha: 0.6 * fade),
              ],
            ).createShader(Rect.fromPoints(tail, head))
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round,
        )
        ..drawCircle(head, 1.6, Paint()..color = AppColors.textPrimary.withValues(alpha: 0.8 * fade));
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) => oldDelegate.field != field;
}
