import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/magnetic_button.dart';

/// Call-to-action buttons.
///
/// - [CtaButton.primary] — accent outline; fills with accent on hover and
///   the label flips to dark.
/// - [CtaButton.ghost] — text-only with an animated underline.
///
/// Both scale 1.0 → 1.03 over 200 ms ease-out, are magnetic on desktop,
/// and announce themselves to the custom cursor.
class CtaButton extends StatefulWidget {
  const CtaButton.primary({required this.label, required this.onTap, super.key, this.icon}) : _primary = true;

  const CtaButton.ghost({required this.label, required this.onTap, super.key, this.icon}) : _primary = false;

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool _primary;

  @override
  State<CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<CtaButton> {
  bool _hovered = false;
  bool _pressed = false; // tactile press feedback (touch + mouse)
  double? _cachedTextWidth;

  void _setPressed(bool v) {
    if (v != _pressed) {
      setState(() => _pressed = v);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = widget._primary
        ? (_hovered ? AppColors.textOnAccent : AppColors.textAccent)
        : AppColors.textPrimary;

    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTypography.titleS.copyWith(color: labelColor, fontSize: 15),
        ),
        // Icon slides in on hover.
        AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.enter,
          width: widget.icon != null && _hovered ? 24 : 0,
          child: widget.icon != null
              ? ClipRect(
                  child: AnimatedSlide(
                    duration: AppDurations.fast,
                    curve: AppCurves.enter,
                    offset: _hovered ? Offset.zero : const Offset(-0.6, 0),
                    child: Icon(widget.icon, size: 16, color: labelColor),
                  ),
                )
              : null,
        ),
      ],
    );

    final body = widget._primary
        ? AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.enter,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
            decoration: BoxDecoration(
              color: _hovered ? AppColors.accentPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(Radii.pill),
              border: Border.all(color: AppColors.accentPrimary),
              boxShadow: _hovered
                  ? const [BoxShadow(color: AppColors.accentSubtle, blurRadius: 24, spreadRadius: 4)]
                  : const [],
            ),
            child: label,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label,
                const SizedBox(height: 3),
                // Underline sweeps in from the left.
                AnimatedContainer(
                  duration: AppDurations.fast,
                  curve: AppCurves.enter,
                  height: 1.5,
                  width: _hovered ? _textWidth() : 0,
                  color: AppColors.accentPrimary,
                ),
              ],
            ),
          );

    return CursorTarget(
      child: Semantics(
        button: true,
        label: widget.label,
        child: MouseRegion(
          opaque: false,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          // Listener observes presses without claiming the gesture, so
          // MagneticButton's tap still fires — adds tactile feedback on touch.
          child: Listener(
            onPointerDown: (_) => _setPressed(true),
            onPointerUp: (_) => _setPressed(false),
            onPointerCancel: (_) => _setPressed(false),
            child: MagneticButton(
              onTap: widget.onTap,
              child: AnimatedScale(
                scale: _pressed ? 0.96 : (_hovered ? 1.03 : 1),
                duration: AppDurations.fast,
                curve: AppCurves.enter,
                child: body,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CtaButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.label != widget.label) {
      _cachedTextWidth = null;
    }
  }

  double _textWidth() {
    if (_cachedTextWidth != null) {
      return _cachedTextWidth!;
    }
    final painter = TextPainter(
      text: TextSpan(text: widget.label, style: AppTypography.titleS.copyWith(fontSize: 15)),
      textDirection: TextDirection.ltr,
    )..layout();
    _cachedTextWidth = painter.width;
    painter.dispose();
    return _cachedTextWidth!;
  }
}
