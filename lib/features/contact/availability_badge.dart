import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Pill badge with a living, pulsing dot — `●  Available for work`.
///
/// The pulse pauses when the badge scrolls offscreen (so the engine can idle)
/// and the animated dot is isolated in a [RepaintBoundary] so its repaint never
/// dirties the surrounding section.
class AvailabilityBadge extends StatefulWidget {
  const AvailabilityBadge({required this.label, super.key});

  final String label;

  @override
  State<AvailabilityBadge> createState() => _AvailabilityBadgeState();
}

class _AvailabilityBadgeState extends State<AvailabilityBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool _onscreen = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _sync() {
    if (context.reducedMotion || !_onscreen) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  void _onVisibility(VisibilityInfo info) {
    final v = info.visibleFraction > 0;
    if (v != _onscreen && mounted) {
      _onscreen = v;
      _sync();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: ValueKey('availability-${widget.label}'),
    onVisibilityChanged: _onVisibility,
    child: Semantics(
      label: widget.label,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dot + expanding pulse ring — isolated so its 60 fps repaint
            // stays in a 14 px layer.
            RepaintBoundary(
              child: SizedBox(
                width: 14,
                height: 14,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    final t = AppCurves.travel.transform(_pulse.value);
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 6 + t * 8,
                          height: 6 + t * 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.successGreen.withValues(
                              alpha: (1 - t) * 0.35,
                            ),
                          ),
                        ),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            // Flexible so a long availability sentence wraps within the section
            // width on mobile instead of overflowing the pill horizontally.
            Flexible(
              child: Text(
                widget.label,
                style: AppTypography.mono.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
