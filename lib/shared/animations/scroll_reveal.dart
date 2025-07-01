import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800), // Slightly longer for more experience
    this.offset = 50.0, // Slightly more offset for better reveal effect
    this.addScrollDelay = true, // New parameter for experiential scroll delay
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;
  final bool addScrollDelay; // Whether to add extra delay when scrolling

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;
  bool _hasAnimated = false;
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
    // Check if animations are disabled for accessibility
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1.0;
      _hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.1) {
      _hasAnimated = true;

      // Check again for disabled animations in case context changed
      if (MediaQuery.disableAnimationsOf(context)) {
        _controller.value = 1.0;
      } else {
        // Calculate total delay including optional scroll experience delay
        final totalDelay =
            widget.delay +
            (widget.addScrollDelay
                ? const Duration(milliseconds: 150) // Extra experiential delay
                : Duration.zero);

        _delayTimer = Timer(totalDelay, () {
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
