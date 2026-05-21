import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A button with a subtle magnetic pull on hover (web/desktop only).
///
/// Wraps any [child] with a [MouseRegion] that tracks the cursor and applies
/// a smoothed translation to suggest the button is "pulling" toward the
/// pointer. Falls back to a static [Transform] on mobile and when reduced
/// motion is requested.
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

class _MagneticButtonState extends State<MagneticButton> with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  Size _size = Size.zero;
  late AnimationController _settleController;
  Offset _settleFrom = Offset.zero;

  @override
  void initState() {
    super.initState();
    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _offset = Offset.lerp(_settleFrom, Offset.zero, Curves.easeOutCubic.transform(_settleController.value))!;
      });
    });
  }

  @override
  void dispose() {
    _settleController.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent event) {
    if (_size == Size.zero) {
      return;
    }
    final centerX = _size.width / 2;
    final centerY = _size.height / 2;
    final dx = (event.localPosition.dx - centerX) * widget.strength;
    final dy = (event.localPosition.dy - centerY) * widget.strength;
    final clamped = Offset(
      dx.clamp(-widget.maxOffset, widget.maxOffset),
      dy.clamp(-widget.maxOffset, widget.maxOffset),
    );
    setState(() => _offset = clamped);
  }

  void _onExit() {
    _settleFrom = _offset;
    _settleController
      ..stop()
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final supports = (kIsWeb && screenWidth >= 800) && !reduceMotion;

    var content = widget.child;
    if (supports) {
      content = AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(_offset.dx, _offset.dy, 0),
        child: widget.child,
      );
    }

    final tappable = GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );

    if (!supports) {
      return tappable;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: _onHover,
      onExit: (_) => _onExit(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _size = Size(constraints.maxWidth, constraints.maxHeight);
          return tappable;
        },
      ),
    );
  }
}
