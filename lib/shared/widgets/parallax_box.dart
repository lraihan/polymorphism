import 'package:flutter/material.dart';
import 'package:polymorphism/core/utils/extensions.dart';

/// Subtly translates its child against the page scroll — a parallax drift that
/// makes the media feel like it floats. Active only on hover-capable (desktop
/// web) layouts; elsewhere it renders inert. Reads the nearest ancestor
/// [Scrollable], so it must sit above any inner (horizontal) scrollables.
class ParallaxBox extends StatefulWidget {
  const ParallaxBox({required this.child, super.key, this.intensity = 18});

  final Widget child;

  /// Maximum drift in logical pixels, applied as ±[intensity].
  final double intensity;

  @override
  State<ParallaxBox> createState() => _ParallaxBoxState();
}

class _ParallaxBoxState extends State<ParallaxBox> {
  ScrollableState? _scrollable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollable = Scrollable.maybeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final position = _scrollable?.position;
    if (position == null || !context.supportsHover) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: position,
      builder: (context, child) => Transform.translate(offset: Offset(0, _offset()), child: child),
      child: widget.child,
    );
  }

  double _offset() {
    final scrollable = _scrollable;
    if (scrollable == null) {
      return 0;
    }
    final box = context.findRenderObject();
    final scrollBox = scrollable.context.findRenderObject();
    if (box is! RenderBox || scrollBox is! RenderBox || !box.hasSize || !scrollBox.hasSize) {
      return 0;
    }
    // Vertical centre of this box within the viewport, as a -0.5..0.5 fraction.
    final centre = box.localToGlobal(Offset(0, box.size.height / 2), ancestor: scrollBox).dy;
    final frac = (centre / scrollBox.size.height) - 0.5;
    return (-frac * 2 * widget.intensity).clamp(-widget.intensity, widget.intensity);
  }
}
