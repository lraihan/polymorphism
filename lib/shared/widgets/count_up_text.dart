import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Counts a metric up from zero when it scrolls into view, preserving any
/// non-numeric prefix/suffix (`~30`, `680+`, `15 min`). Values with no number
/// (`Proxy`, `Live`) render statically. Honors reduced motion.
class CountUpText extends StatefulWidget {
  const CountUpText(this.value, {required this.style, super.key, this.duration = AppDurations.sluggish});

  final String value;
  final TextStyle style;
  final Duration duration;

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText> with SingleTickerProviderStateMixin {
  static final RegExp _numeric = RegExp(r'^([^0-9]*)([0-9]+(?:\.[0-9]+)?)(.*)$');

  late final AnimationController _controller;
  late final Animation<double> _eased;
  bool _triggered = false;

  // Parsed parts.
  String _prefix = '';
  String _suffix = '';
  double _target = 0;
  int _decimals = 0;
  bool _isNumeric = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _eased = CurvedAnimation(parent: _controller, curve: AppCurves.enter);
    final match = _numeric.firstMatch(widget.value);
    if (match != null) {
      _isNumeric = true;
      _prefix = match.group(1) ?? '';
      final number = match.group(2) ?? '0';
      _suffix = match.group(3) ?? '';
      _target = double.tryParse(number) ?? 0;
      final dot = number.indexOf('.');
      _decimals = dot == -1 ? 0 : number.length - dot - 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion && !_triggered) {
      _triggered = true;
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    // VisibilityDetector fires asynchronously, so this can arrive after dispose.
    if (!mounted || _triggered || info.visibleFraction <= 0.2) {
      return;
    }
    _triggered = true;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isNumeric) {
      return Text(widget.value, style: widget.style);
    }
    return VisibilityDetector(
      key: ValueKey('countup-${widget.value}-${identityHashCode(this)}'),
      onVisibilityChanged: _onVisibility,
      child: AnimatedBuilder(
        animation: _eased,
        builder: (context, _) {
          final current = (_target * _eased.value).toStringAsFixed(_decimals);
          return Text('$_prefix$current$_suffix', style: widget.style);
        },
      ),
    );
  }
}
