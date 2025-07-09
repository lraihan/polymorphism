import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.offset = 50.0,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;
  bool _hasTriggered = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _translateAnimation = Tween<double>(
      begin: widget.offset,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1.0;
      _hasTriggered = true;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _hasTriggered) {
      return;
    }

    final isVisible = info.visibleFraction > 0.2; // Increased from 0.1 to 0.2 for better bottom-biased reveals

    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1.0;
      _hasTriggered = true;
      return;
    }

    if (isVisible) {
      _hasTriggered = true;

      _delayTimer?.cancel();

      if (widget.delay == Duration.zero) {
        if (mounted) {
          _controller.forward();
        }
      } else {
        _delayTimer = Timer(widget.delay, () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: Key('${widget.key ?? UniqueKey()}_visibility'),
    onVisibilityChanged: _onVisibilityChanged,
    child: AnimatedBuilder(
      animation: _controller,
      builder:
          (context, child) => Transform.translate(
            offset: Offset(0, _translateAnimation.value),
            child: Opacity(opacity: _opacityAnimation.value, child: widget.child),
          ),
    ),
  );
}
