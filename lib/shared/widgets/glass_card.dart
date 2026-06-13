import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';

/// Glassmorphism container — the sanctioned glass primitive, reserved so
/// backdrop blur (the most expensive effect in the app) stays budgeted.
///
/// NOTE: currently unused — the live UI hand-rolls its single blur in the
/// floating navigation bar. Kept as design-system API; any adoption must keep
/// it inside a [RepaintBoundary] and respect the one-blur-per-viewport budget
/// documented in docs/PERFORMANCE.md.
///
/// Variants:
/// - [GlassCard.standard] — base style.
/// - [GlassCard.elevated] — stronger blur + drop shadow.
/// - [GlassCard.ghost] — nearly transparent, for overlaid text areas.
class GlassCard extends StatefulWidget {
  const GlassCard.standard({required this.child, super.key, this.radius = Radii.lg, this.padding, this.glowOnHover = false})
    : _blur = 20,
      _surfaceAlpha = 1,
      _shadow = false;

  const GlassCard.elevated({required this.child, super.key, this.radius = Radii.lg, this.padding, this.glowOnHover = false})
    : _blur = 28,
      _surfaceAlpha = 1.4,
      _shadow = true;

  const GlassCard.ghost({required this.child, super.key, this.radius = Radii.lg, this.padding, this.glowOnHover = false})
    : _blur = 12,
      _surfaceAlpha = 0.5,
      _shadow = false;

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;

  /// Animate the border toward [AppColors.accentGlow] on hover.
  final bool glowOnHover;

  final double _blur;
  final double _surfaceAlpha;
  final bool _shadow;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.glowOnHover && _hovered ? AppColors.borderActive : AppColors.borderSubtle;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget._blur, sigmaY: widget._blur),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.enter,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: AppColors.glassWhite.withValues(alpha: AppColors.glassWhite.a * widget._surfaceAlpha),
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: borderColor),
          ),
          child: widget.child,
        ),
      ),
    );

    final decorated = widget._shadow
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(color: AppColors.deepSpace.withValues(alpha: 0.5), blurRadius: 32, offset: const Offset(0, 12)),
              ],
            ),
            child: card,
          )
        : card;

    if (!widget.glowOnHover) {
      return decorated;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: decorated,
    );
  }
}
