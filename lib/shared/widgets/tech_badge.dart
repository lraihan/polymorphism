import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';

/// Mono-faced tech/stack chip — `FLUTTER`, `REST APIS`, …
class TechBadge extends StatefulWidget {
  const TechBadge(this.label, {super.key, this.icon, this.interactive = true});

  final String label;
  final IconData? icon;

  /// Disable for dense read-only contexts (project cards).
  final bool interactive;

  @override
  State<TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<TechBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = _hovered && widget.interactive;
    final chip = AnimatedScale(
      scale: accent ? 1.05 : 1,
      duration: AppDurations.fast,
      curve: AppCurves.enter,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppCurves.enter,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: accent ? AppColors.accentSubtle : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: accent ? AppColors.borderActive : AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 14, color: accent ? AppColors.textAccent : AppColors.textSecondary),
              const SizedBox(width: Spacing.sm),
            ],
            Text(
              widget.label.toUpperCase(),
              style: AppTypography.badge.copyWith(color: accent ? AppColors.textAccent : AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );

    if (!widget.interactive) {
      return chip;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: chip,
    );
  }
}
