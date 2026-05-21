import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

/// A subtle, GPU-cheap ambient particle background.
///
/// Renders a small number of slow-drifting dots behind content using a single
/// [AnimationController] and a [CustomPaint]. Honors reduced-motion settings
/// by rendering a static frame.
class AmbientParticleLayer extends StatefulWidget {
  const AmbientParticleLayer({
    super.key,
    this.particleCount = 22,
    this.color,
    this.opacity = 0.35,
  });

  final int particleCount;
  final Color? color;
  final double opacity;

  @override
  State<AmbientParticleLayer> createState() => _AmbientParticleLayerState();
}

class _AmbientParticleLayerState extends State<AmbientParticleLayer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final math.Random _rng = math.Random(7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _particles = List<_Particle>.generate(
      widget.particleCount,
      (_) => _Particle(
        seedX: _rng.nextDouble(),
        seedY: _rng.nextDouble(),
        radius: 0.6 + _rng.nextDouble() * 1.6,
        speed: 0.15 + _rng.nextDouble() * 0.45,
        phase: _rng.nextDouble() * math.pi * 2,
        amplitude: 8 + _rng.nextDouble() * 22,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.accent;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            t: _controller.value,
            color: color.withValues(alpha: widget.opacity),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.seedX,
    required this.seedY,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.amplitude,
  });

  final double seedX;
  final double seedY;
  final double radius;
  final double speed;
  final double phase;
  final double amplitude;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.particles, required this.t, required this.color});

  final List<_Particle> particles;
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (final p in particles) {
      final angle = (t * math.pi * 2 * p.speed) + p.phase;
      final dx = p.seedX * size.width + math.cos(angle) * p.amplitude;
      final dy = p.seedY * size.height + math.sin(angle) * p.amplitude * 0.7;
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.color != color;
}
