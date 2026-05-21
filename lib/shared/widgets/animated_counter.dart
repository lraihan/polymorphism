import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Counts up from `0` to [end] when first becoming visible.
///
/// If [end] is null, the [staticLabel] is shown without animation. Honors
/// the platform reduced-motion setting by skipping straight to the final
/// value.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    required this.style,
    super.key,
    this.end,
    this.staticLabel,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1400),
  });

  final int? end;
  final String? staticLabel;
  final String suffix;
  final Duration duration;
  final TextStyle style;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasTriggered || info.visibleFraction < 0.3 || !mounted) {
      return;
    }
    _hasTriggered = true;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.end == null) {
      return Text(widget.staticLabel ?? '', style: widget.style);
    }

    return VisibilityDetector(
      key: ValueKey('counter_${widget.end}_${widget.suffix}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final eased = Curves.easeOutCubic.transform(_controller.value);
          final current = (eased * widget.end!).round();
          return Text('$current${widget.suffix}', style: widget.style);
        },
      ),
    );
  }
}
