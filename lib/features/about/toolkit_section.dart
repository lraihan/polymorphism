import 'package:flutter/material.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/data/models/skill.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The toolkit, rendered as a vertical stack of immersive capability pillars
/// (rather than a flat chip grid) — each a hover-reactive card with an icon
/// tile that fills with its accent, a proficiency level, a tagline, the tools
/// beneath it, a faint watermark, lift + glow, and a left accent edge that
/// grows in. Sits below the bio, beside the fragment portrait.
class ToolkitSection extends StatelessWidget {
  const ToolkitSection({super.key});

  @override
  Widget build(BuildContext context) {
    const pillars = PortfolioData.toolkitPillars;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(child: Text(AppStrings.skillsLabel, style: AppTypography.monoAccent)),
        const SizedBox(height: Spacing.lg),
        for (var i = 0; i < pillars.length; i++) ...[
          ScrollReveal(delay: Duration(milliseconds: i * 90), child: _PillarCard(pillar: pillars[i])),
          if (i != pillars.length - 1) const SizedBox(height: Spacing.md),
        ],
      ],
    );
  }
}

class _PillarCard extends StatefulWidget {
  const _PillarCard({required this.pillar});

  final ToolkitPillar pillar;

  @override
  State<_PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<_PillarCard> {
  bool _hovered = false;
  bool _inView = false; // touch: lit while centred in the viewport

  @override
  Widget build(BuildContext context) {
    final pillar = widget.pillar;
    // Desktop lights on hover; touch lights the pillar centred in view as you
    // scroll, so the toolkit is alive without a cursor.
    final active = context.supportsHover ? _hovered : _inView;

    final card = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        label: '${pillar.name}: ${pillar.tagline}',
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: AppCurves.enter,
          transform: active ? Matrix4.translationValues(4, 0, 0) : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: active ? pillar.accent.withValues(alpha: 0.5) : AppColors.borderSubtle),
            gradient: LinearGradient(
              colors: [
                Color.lerp(AppColors.surfaceCard, pillar.accent.withValues(alpha: 0.14), active ? 1 : 0.4)!,
                AppColors.surfaceCard,
              ],
            ),
            boxShadow: active
                ? [BoxShadow(color: pillar.accent.withValues(alpha: 0.16), blurRadius: 30, offset: const Offset(0, 12))]
                : const [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: Stack(
              children: [
                // Left accent edge that thickens on hover.
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: AppDurations.normal,
                    curve: AppCurves.enter,
                    width: active ? 4 : 2,
                    color: pillar.accent.withValues(alpha: active ? 1 : 0.4),
                  ),
                ),
                // Faint oversized watermark of the discipline icon.
                Positioned(
                  right: -16,
                  bottom: -16,
                  child: IgnorePointer(
                    child: Icon(pillar.icon, size: 96, color: pillar.accent.withValues(alpha: active ? 0.12 : 0.05)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, Spacing.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon tile — fills with the accent on hover.
                      AnimatedContainer(
                        duration: AppDurations.normal,
                        curve: AppCurves.enter,
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Radii.md),
                          color: active ? pillar.accent : pillar.accent.withValues(alpha: 0.12),
                          border: Border.all(color: pillar.accent.withValues(alpha: active ? 1 : 0.3)),
                        ),
                        child: Icon(pillar.icon, size: 26, color: active ? AppColors.textOnAccent : pillar.accent),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(pillar.name, style: AppTypography.titleM)),
                                const SizedBox(width: Spacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Radii.pill),
                                    border: Border.all(color: pillar.accent.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(pillar.level, style: AppTypography.badge.copyWith(color: pillar.accent, fontSize: 10)),
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(pillar.tagline, style: AppTypography.bodyM),
                            const SizedBox(height: Spacing.md),
                            Wrap(
                              spacing: Spacing.sm,
                              runSpacing: Spacing.sm,
                              children: [
                                for (final skill in pillar.skills) _ToolChip(skill: skill, accent: pillar.accent, active: active),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (context.supportsHover) {
      return card;
    }
    // Touch: light the pillar while it's centred in the viewport.
    return VisibilityDetector(
      key: ValueKey('pillar-${pillar.name}'),
      onVisibilityChanged: (info) {
        final v = info.visibleFraction > 0.55;
        if (v != _inView && mounted) {
          setState(() => _inView = v);
        }
      },
      child: card,
    );
  }
}

/// Compact tool chip inside a pillar.
class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.skill, required this.accent, required this.active});

  final Skill skill;
  final Color accent;
  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: AppDurations.fast,
    curve: AppCurves.enter,
    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
    decoration: BoxDecoration(
      color: active ? accent.withValues(alpha: 0.1) : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(Radii.sm),
      border: Border.all(color: active ? accent.withValues(alpha: 0.35) : AppColors.borderSubtle),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(skill.icon, size: 13, color: active ? accent : AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          skill.label,
          style: AppTypography.badge.copyWith(color: active ? AppColors.textPrimary : AppColors.textSecondary),
        ),
      ],
    ),
  );
}
