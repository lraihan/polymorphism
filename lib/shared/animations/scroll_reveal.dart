import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Entry direction for [ScrollReveal].
enum ScrollRevealDirection { up, down, left, right, scale, fade }

/// Reveals its child when it first enters the viewport, then stays revealed.
///
/// Defaults: fade in + slide up 30 px over [AppDurations.slow]. Use [delay]
/// to stagger siblings. Honors reduced motion by rendering immediately.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = AppDurations.slow,
    this.direction = ScrollRevealDirection.up,
    this.offset = 30.0,
    this.visibleFraction = 0.15,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final ScrollRevealDirection direction;

  /// How far off-position the child starts, in logical px.
  final double offset;

  /// Fraction of the child that must be visible to trigger.
  final double visibleFraction;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _eased;
  bool _triggered = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _eased = CurvedAnimation(parent: _controller, curve: AppCurves.enter);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion) {
      _controller.value = 1;
      _triggered = true;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _eased.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (!mounted || _triggered || info.visibleFraction < widget.visibleFraction) {
      return;
    }
    _triggered = true;
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  Offset _slideFor(double t) {
    final travel = widget.offset * (1 - t);
    switch (widget.direction) {
      case ScrollRevealDirection.up:
        return Offset(0, travel);
      case ScrollRevealDirection.down:
        return Offset(0, -travel);
      case ScrollRevealDirection.left:
        return Offset(travel, 0);
      case ScrollRevealDirection.right:
        return Offset(-travel, 0);
      case ScrollRevealDirection.scale:
      case ScrollRevealDirection.fade:
        return Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: ValueKey(_controller),
    onVisibilityChanged: _onVisibility,
    child: AnimatedBuilder(
      animation: _eased,
      builder: (context, child) {
        final t = _eased.value;
        Widget result = Opacity(opacity: t, child: child);
        if (widget.direction == ScrollRevealDirection.scale) {
          result = Transform.scale(scale: 0.92 + 0.08 * t, child: result);
        } else if (widget.direction != ScrollRevealDirection.fade) {
          result = Transform.translate(offset: _slideFor(t), child: result);
        }
        return result;
      },
      child: widget.child,
    ),
  );
}
