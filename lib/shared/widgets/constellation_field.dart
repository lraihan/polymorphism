import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';

/// A living constellation background: several drifting clusters whose particles
/// link to their neighbours and are drawn toward the cursor, gathering into a
/// web wherever you point. Without a pointer (touch / reduced motion) the
/// clusters chase slow autonomous attractors of their own.
///
/// Pure `CustomPainter` + a `createTicker` simulation — wrap the host section
/// in a visibility-gated [TickerMode] to pause it offscreen. Pass [pointer]
/// from an ancestor `MouseRegion` so an overlaid text layer can't occlude it.
class ConstellationField extends StatefulWidget {
  const ConstellationField({
    required this.pointer,
    super.key,
    this.clusters = 3,
    this.perCluster = 16,
    this.linkColor = AppColors.accentPrimary,
    this.dotColor = AppColors.textPrimary,
    this.dotOpacity = 0.55,
  });

  /// Pointer in this widget's local space, or null when no mouse hovers.
  final ValueListenable<Offset?> pointer;

  /// How many distinct constellations drift in the field.
  final int clusters;
  final int perCluster;
  final Color linkColor;
  final Color dotColor;
  final double dotOpacity;

  @override
  State<ConstellationField> createState() => _ConstellationFieldState();
}

class _Node {
  _Node(this.x, this.y, this.vx, this.vy, this.cluster);
  double x;
  double y;
  double vx;
  double vy;
  final int cluster;
}

class _ConstellationFieldState extends State<ConstellationField> with SingleTickerProviderStateMixin {
  // An AnimationController (a Listenable) drives the painter's repaint directly
  // — no per-frame setState, so the simulation advances and the canvas redraws
  // without ever rebuilding the widget subtree.
  late final AnimationController _clock;
  final math.Random _rng = math.Random(11);
  final List<_Node> _nodes = [];
  Size _size = Size.zero;
  double _t = 0;

  static const double _linkDist = 116;
  static const double _pointerPull = 0.6;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(vsync: this, duration: const Duration(seconds: 60))..addListener(_advance);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion) {
      _clock.stop();
    } else if (!_clock.isAnimating) {
      _clock.repeat();
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  void _seed(Size size) {
    _size = size;
    _nodes.clear();
    for (var c = 0; c < widget.clusters; c++) {
      // Each cluster is born around its own patch of the field.
      final cx = size.width * (0.2 + 0.6 * _rng.nextDouble());
      final cy = size.height * (0.2 + 0.6 * _rng.nextDouble());
      for (var i = 0; i < widget.perCluster; i++) {
        _nodes.add(
          _Node(
            (cx + (_rng.nextDouble() - 0.5) * size.width * 0.4).clamp(0, size.width),
            (cy + (_rng.nextDouble() - 0.5) * size.height * 0.4).clamp(0, size.height),
            (_rng.nextDouble() - 0.5) * 0.6,
            (_rng.nextDouble() - 0.5) * 0.6,
            c,
          ),
        );
      }
    }
  }

  /// Per-cluster autonomous attractor (used when there's no pointer), each on
  /// its own slow Lissajous path so the constellations roam independently.
  Offset _clusterAttractor(int c) {
    final phase = c * 2.1;
    return Offset(
      _size.width * (0.5 + 0.3 * math.cos(_t * (0.5 + c * 0.12) + phase)),
      _size.height * (0.5 + 0.26 * math.sin(_t * (0.7 + c * 0.1) + phase)),
    );
  }

  void _advance() {
    if (_size.isEmpty) {
      return;
    }
    _t += 1 / 60;
    final pointer = widget.pointer.value;
    for (final n in _nodes) {
      final attractor = pointer ?? _clusterAttractor(n.cluster);
      final toAx = attractor.dx - n.x;
      final toAy = attractor.dy - n.y;
      final dist = math.sqrt(toAx * toAx + toAy * toAy) + 0.001;
      if (dist < 220) {
        final f = _pointerPull * (1 - dist / 220) / dist;
        n
          ..vx += toAx * f
          ..vy += toAy * f;
      }
      n
        ..vx *= 0.95
        ..vy *= 0.95
        ..x += n.vx
        ..y += n.vy;
      if (n.x < 0) {
        n
          ..x = 0
          ..vx = n.vx.abs() * 0.6;
      } else if (n.x > _size.width) {
        n
          ..x = _size.width
          ..vx = -n.vx.abs() * 0.6;
      }
      if (n.y < 0) {
        n
          ..y = 0
          ..vy = n.vy.abs() * 0.6;
      } else if (n.y > _size.height) {
        n
          ..y = _size.height
          ..vy = -n.vy.abs() * 0.6;
      }
    }
    // No setState — the painter repaints off [_clock] (and the pointer).
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          if (size != _size || _nodes.isEmpty) {
            _seed(size);
          }
          return CustomPaint(
            size: size,
            painter: _ConstellationPainter(
              nodes: _nodes,
              pointer: widget.pointer,
              linkDist: _linkDist,
              linkColor: widget.linkColor,
              dotColor: widget.dotColor.withValues(alpha: widget.dotOpacity),
              repaint: Listenable.merge([_clock, widget.pointer]),
            ),
          );
        },
      ),
    ),
  );
}

class _ConstellationPainter extends CustomPainter {
  _ConstellationPainter({
    required this.nodes,
    required this.pointer,
    required this.linkDist,
    required this.linkColor,
    required this.dotColor,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<_Node> nodes;
  final ValueListenable<Offset?> pointer;
  final double linkDist;
  final Color linkColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linkPaint = Paint()..strokeWidth = 1;
    // Links between nearby nodes of the same cluster.
    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final a = nodes[i];
        final b = nodes[j];
        if (a.cluster != b.cluster) {
          continue;
        }
        final dx = a.x - b.x;
        final dy = a.y - b.y;
        final d = math.sqrt(dx * dx + dy * dy);
        if (d < linkDist) {
          linkPaint.color = linkColor.withValues(alpha: 0.16 * (1 - d / linkDist));
          canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), linkPaint);
        }
      }
    }
    // Links to the pointer.
    final p = pointer.value;
    if (p != null) {
      for (final n in nodes) {
        final d = (Offset(n.x, n.y) - p).distance;
        if (d < linkDist * 1.4) {
          linkPaint.color = linkColor.withValues(alpha: 0.42 * (1 - d / (linkDist * 1.4)));
          canvas.drawLine(Offset(n.x, n.y), p, linkPaint);
        }
      }
      canvas.drawCircle(p, 3.5, Paint()..color = linkColor.withValues(alpha: 0.9));
    }
    // Nodes.
    final dot = Paint()..color = dotColor;
    for (final n in nodes) {
      canvas.drawCircle(Offset(n.x, n.y), 1.5, dot);
    }
  }

  // Repaints are driven by the [repaint] listenable (the clock + pointer),
  // not by widget rebuilds.
  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) => false;
}
