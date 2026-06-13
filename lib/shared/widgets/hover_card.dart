import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/extensions.dart';

/// 3D perspective tilt wrapper for cards.
///
/// - Tracks the pointer relative to the card center.
/// - Applies a perspective matrix, max ±8° on both axes.
/// - A specular highlight sweeps opposite the tilt.
/// - Springs back to neutral on exit.
/// - Inert on touch devices and under reduced motion.
class HoverCard extends StatefulWidget {
  const HoverCard({
    required this.child,
    super.key,
    this.maxAngle = 8,
    this.lift = true,
    this.onTap,
  });

  final Widget child;

  /// Maximum tilt, in degrees.
  final double maxAngle;

  /// Add a soft drop shadow while hovered.
  final bool lift;

  final VoidCallback? onTap;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settle;
  Offset _tilt = Offset.zero; // normalized -1..1 on both axes
  Offset _settleFrom = Offset.zero;
  bool _hovered = false;
  bool _pressed = false; // touch press feedback when 3D tilt is unavailable

  @override
  void initState() {
    super.initState();
    _settle = AnimationController(vsync: this, duration: AppDurations.normal)
      ..addListener(() {
        setState(() {
          _tilt =
              Offset.lerp(
                _settleFrom,
                Offset.zero,
                AppCurves.spring.transform(_settle.value),
              )!;
        });
      });
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    // context.size (not a LayoutBuilder) so this card stays dry-layout-safe
    // and can sit under an IntrinsicHeight / size-measuring parent.
    final size = context.size;
    if (size == null || size.isEmpty) {
      return;
    }
    _settle.stop();
    setState(() {
      _hovered = true;
      _tilt = Offset(
        (event.localPosition.dx / size.width * 2 - 1).clamp(-1.0, 1.0),
        (event.localPosition.dy / size.height * 2 - 1).clamp(-1.0, 1.0),
      );
    });
  }

  void _onExit() {
    _hovered = false;
    _settleFrom = _tilt;
    _settle.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final interactive = context.supportsHover && !context.reducedMotion;

    final content = GestureDetector(onTap: widget.onTap, child: widget.child);

    if (!interactive) {
      // Touch: a press-scale stands in for the 3D tilt.
      return Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: AppDurations.fast,
          curve: AppCurves.enter,
          child: content,
        ),
      );
    }

    final maxRad = widget.maxAngle * (3.14159265 / 180);
    final transform =
        Matrix4.identity()
          ..setEntry(3, 2, 0.0008) // perspective
          ..rotateX(-_tilt.dy * maxRad)
          ..rotateY(_tilt.dx * maxRad);

    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: AppCurves.enter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.lg),
          boxShadow:
              widget.lift && _hovered
                  ? [
                    BoxShadow(
                      color: AppColors.deepSpace.withValues(alpha: 0.7),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ]
                  : const [],
        ),
        child: Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Stack(
            children: [
              content,
              // Specular highlight — slides opposite the pointer.
              Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.lg),
                    child: AnimatedOpacity(
                      duration: AppDurations.fast,
                      opacity: _hovered ? 1 : 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(-_tilt.dx, -_tilt.dy),
                            radius: 1.4,
                            colors: [
                              AppColors.textPrimary.withValues(alpha: 0.06),
                              AppColors.textPrimary.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
