import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';

/// A wrapper that gives its child a subtle magnetic pull toward the cursor
/// (hover-capable devices only). Falls back to a plain tappable on touch
/// and under reduced motion.
class MagneticButton extends StatefulWidget {
  const MagneticButton({
    required this.child,
    super.key,
    this.onTap,
    this.strength = 0.35,
    this.maxOffset = 14,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// 0..1 — how strongly the button follows the cursor.
  final double strength;

  /// Maximum translation in logical pixels.
  final double maxOffset;

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settle;
  Offset _offset = Offset.zero;
  Offset _settleFrom = Offset.zero;

  @override
  void initState() {
    super.initState();
    _settle = AnimationController(vsync: this, duration: AppDurations.normal)
      ..addListener(() {
        if (mounted) {
          setState(() {
            _offset =
                Offset.lerp(
                  _settleFrom,
                  Offset.zero,
                  AppCurves.enter.transform(_settle.value),
                )!;
          });
        }
      });
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent event) {
    // Read the laid-out size from the render object rather than a LayoutBuilder:
    // LayoutBuilder cannot be dry-laid-out, which crashes any intrinsic-measuring
    // ancestor (e.g. the hero's IntrinsicHeight / a Wrap computing its height).
    final size = context.size;
    if (size == null || size.isEmpty) {
      return;
    }
    _settle.stop();
    final dx = (event.localPosition.dx - size.width / 2) * widget.strength;
    final dy = (event.localPosition.dy - size.height / 2) * widget.strength;
    setState(() {
      _offset = Offset(
        dx.clamp(-widget.maxOffset, widget.maxOffset),
        dy.clamp(-widget.maxOffset, widget.maxOffset),
      );
    });
  }

  void _onExit() {
    _settleFrom = _offset;
    _settle.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final supports = context.supportsHover && !context.reducedMotion;

    final tappable = GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );

    if (!supports) {
      return tappable;
    }

    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      onExit: (_) => _onExit(),
      child: Transform.translate(offset: _offset, child: tappable),
    );
  }
}
