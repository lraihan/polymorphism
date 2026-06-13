import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/hover_card.dart';
import 'package:polymorphism/shared/widgets/tech_badge.dart';

/// Bento project card: category eyebrow, screenshot visual on a generative
/// accent backdrop, title, tech badges.
///
/// On hover the card expands a detail panel — the tagline, a description
/// snippet, and a "view project" cue slide in beneath the title while the
/// image area smoothly shrinks to make room (3D tilt + lift come from
/// [HoverCard]). Touch devices show the detail at rest.
class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.project, required this.onOpen, super.key});

  final Project project;
  final VoidCallback onOpen;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  Project get project => widget.project;

  @override
  Widget build(BuildContext context) {
    // Desktop expands on hover; touch shows the detail at rest.
    final expanded = _hovered || !context.supportsHover;

    return CursorTarget(
      intent: CursorIntent.view,
      child: MouseRegion(
        opaque: false,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Semantics(
          button: true,
          label: '${project.title} — ${project.tagline}',
          child: HoverCard(
            onTap: widget.onOpen,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppCurves.enter,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(color: expanded ? AppColors.borderActive : AppColors.borderSubtle),
              ),
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(project.category, style: AppTypography.mono),
                      AnimatedRotation(
                        turns: expanded ? 0 : -0.125,
                        duration: AppDurations.fast,
                        curve: AppCurves.enter,
                        child: Icon(
                          LucideIcons.arrowRight,
                          size: 16,
                          color: expanded ? AppColors.textAccent : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  // Image shrinks as the detail panel below expands.
                  Expanded(child: _visual(expanded)),
                  const SizedBox(height: Spacing.md),
                  Text(project.title, style: AppTypography.titleM),
                  _detailPanel(expanded),
                  const SizedBox(height: Spacing.sm),
                  Wrap(
                    spacing: Spacing.xs,
                    runSpacing: Spacing.xs,
                    children: [for (final t in project.tech.take(3)) TechBadge(t, interactive: false)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The expanding detail — tagline, a short description, and a view cue.
  ///
  /// Uses an [AnimatedSize] that swaps between the content and a zero-height
  /// box, so the collapsed state never constrains a [Column] to 0 height
  /// (which would overflow). The image [Expanded] above takes up the slack.
  Widget _detailPanel(bool expanded) => AnimatedSize(
    duration: AppDurations.normal,
    curve: AppCurves.enter,
    alignment: Alignment.topLeft,
    child: expanded
        ? Padding(
            padding: const EdgeInsets.only(top: Spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  project.tagline,
                  style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Spacing.sm),
                Text(project.description, style: AppTypography.bodyM, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.viewProject, style: AppTypography.monoAccent),
                    const SizedBox(width: Spacing.xs),
                    const Icon(LucideIcons.arrowUpRight, size: 14, color: AppColors.textAccent),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox(width: double.infinity),
  );

  /// Screenshot on a generative accent backdrop.
  Widget _visual(bool expanded) => ClipRRect(
    borderRadius: BorderRadius.circular(Radii.md),
    child: Hero(
      tag: project.heroTag,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Generative backdrop in the project's accent.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.6, -0.8),
                radius: 1.6,
                colors: [project.accent.withValues(alpha: 0.16), AppColors.inkBlack],
              ),
            ),
          ),
          // Screenshot — portrait shots float centered, landscape fills.
          if (project.screenshots == ScreenshotKind.portrait)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              child: AnimatedScale(
                scale: expanded ? 1.04 : 1,
                duration: AppDurations.normal,
                curve: AppCurves.enter,
                child: Image.asset(project.images.first, fit: BoxFit.contain),
              ),
            )
          else
            AnimatedScale(
              scale: expanded ? 1.05 : 1,
              duration: AppDurations.normal,
              curve: AppCurves.enter,
              child: Image.asset(project.images.first, fit: BoxFit.cover, alignment: Alignment.topCenter),
            ),
          // Subtle accent wash on hover — keeps the screenshot visible.
          IgnorePointer(
            child: AnimatedOpacity(
              duration: AppDurations.fast,
              opacity: expanded ? 1 : 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [project.accent.withValues(alpha: 0.18), Colors.transparent],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
