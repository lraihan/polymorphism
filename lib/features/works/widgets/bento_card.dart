import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/shared/widgets/hover_card.dart';
import 'package:polymorphism/shared/widgets/shimmer_placeholder.dart';

/// A single bento-grid cell: the project's hero shot fills the cell over an
/// ambient glow, with the category, name, and tagline overlaid on a scrim.
/// 3D-tilts on hover (via [HoverCard]) and opens the case study when pressed.
class BentoCard extends StatefulWidget {
  const BentoCard({
    required this.project,
    required this.onOpen,
    super.key,
    this.featured = false,
    this.compact = false,
  });

  final Project project;
  final VoidCallback onOpen;

  /// Larger title + two-line tagline for the big 2× cells.
  final bool featured;

  /// Drop the tagline on short cells where space is tight.
  final bool compact;

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final accent = p.accentColor;

    return HoverCard(
      onTap: widget.onOpen,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: AppCurves.enter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: _hovered ? accent.withValues(alpha: 0.55) : AppColors.borderSubtle,
              width: 0.8,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ambient glow
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.2, -0.7),
                      radius: 1.5,
                      colors: [p.dominantColor.withValues(alpha: 0.5), AppColors.inkBlack],
                    ),
                  ),
                ),
                // hero media, filling the cell
                _Media(project: p, hovered: _hovered, featured: widget.featured),
                // legibility scrim — dark top (for the category/arrow) and bottom
                const Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x66000000), Color(0x00000000), Color(0x00000000), Color(0xCC05050A)],
                          stops: [0, 0.32, 0.55, 1],
                        ),
                      ),
                    ),
                  ),
                ),
                // accent wash on hover
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: AppDurations.normal,
                      opacity: _hovered ? 1 : 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [accent.withValues(alpha: 0.12), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // hover scrim — strengthens the bottom so the revealed detail reads over any shot
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: AppDurations.normal,
                      opacity: _hovered ? 1 : 0,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00000000), Color(0x33000000), Color(0xF205050A)],
                            stops: [0, 0.4, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // category — top-left
                Positioned(top: Spacing.lg, left: Spacing.lg, child: _category(p)),
                // arrow — top-right
                Positioned(top: Spacing.lg, right: Spacing.lg, child: _Arrow(accent: accent, hovered: _hovered)),
                // name + tagline, with a brief detail revealed on hover — bottom-left
                Positioned(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  bottom: Spacing.lg,
                  child: AnimatedSize(
                    duration: AppDurations.normal,
                    curve: AppCurves.enter,
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          p.name,
                          style: (widget.featured ? AppTypography.titleL : AppTypography.titleM)
                              .copyWith(color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!widget.compact || _hovered) ...[
                          const SizedBox(height: Spacing.xs),
                          Text(
                            p.tagline,
                            style: AppTypography.bodyM.copyWith(fontSize: 13, color: AppColors.textSecondary),
                            maxLines: _hovered ? 2 : (widget.featured ? 2 : 1),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        // brief detail on hover
                        if (_hovered) ...[
                          const SizedBox(height: Spacing.md),
                          Text(
                            p.shortDesc,
                            style: AppTypography.bodyM
                                .copyWith(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                            maxLines: widget.compact ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!widget.compact) ...[
                            const SizedBox(height: Spacing.md),
                            Wrap(
                              spacing: Spacing.sm,
                              runSpacing: Spacing.sm,
                              children: [for (final t in p.tech.take(3)) _chip(t)],
                            ),
                          ],
                          const SizedBox(height: Spacing.md),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View case study', style: AppTypography.mono.copyWith(fontSize: 10, color: accent)),
                              const SizedBox(width: Spacing.xs),
                              Icon(LucideIcons.arrowRight, size: 13, color: accent),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _category(Project p) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.deepSpace.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: p.accentColor, shape: BoxShape.circle)),
            const SizedBox(width: Spacing.sm),
            Text(p.category, style: AppTypography.mono.copyWith(color: p.accentColor, fontSize: 10)),
          ],
        ),
      );

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.deepSpace.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.badge.copyWith(fontSize: 9, color: AppColors.textSecondary),
        ),
      );
}

/// Fills the cell with the project hero: cover for landscape screenshots, a
/// large bottom-anchored phone for portrait mockups.
class _Media extends StatelessWidget {
  const _Media({required this.project, required this.hovered, required this.featured});

  final Project project;
  final bool hovered;
  final bool featured;

  Widget _phone(String path) => Align(
        alignment: Alignment.bottomCenter,
        child: ProjectImage(path: path, tint: project.dominantColor, fit: BoxFit.contain),
      );

  @override
  Widget build(BuildContext context) {
    final p = project;

    final Widget media;
    if (p.isPortraitMedia) {
      // A featured (wide) portrait cell shows two phones so it fills; otherwise one.
      final body = featured && p.images.length >= 2
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _phone(p.images[0])),
                const SizedBox(width: Spacing.lg),
                Expanded(child: _phone(p.images[1])),
              ],
            )
          : _phone(p.images.first);
      media = Padding(
        padding: const EdgeInsets.only(top: 44, left: Spacing.sm, right: Spacing.sm),
        child: body,
      );
    } else {
      media = ProjectImage(path: p.images.first, tint: p.dominantColor);
    }

    return AnimatedScale(
      scale: hovered ? 1.04 : 1,
      duration: AppDurations.slow,
      curve: AppCurves.enter,
      child: media,
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.accent, required this.hovered});

  final Color accent;
  final bool hovered;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppCurves.enter,
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hovered ? accent : AppColors.deepSpace.withValues(alpha: 0.5),
          border: Border.all(color: hovered ? accent : AppColors.borderSubtle),
        ),
        child: Icon(
          LucideIcons.arrowUpRight,
          size: 16,
          color: hovered ? AppColors.deepSpace : AppColors.textPrimary,
        ),
      );
}
