import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/shared/widgets/count_up_text.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/tech_badge.dart';

/// The text side of a spotlight card: category, name, tagline, description,
/// tech, metrics, and the case-study CTA. Every accent is the project's own.
class DetailPanel extends StatelessWidget {
  const DetailPanel({required this.project, required this.onOpen, super.key, this.crossAxis = CrossAxisAlignment.start});

  final Project project;
  final VoidCallback onOpen;
  final CrossAxisAlignment crossAxis;

  @override
  Widget build(BuildContext context) {
    final nameStyle = context.responsive(mobile: AppTypography.titleL, desktop: AppTypography.displayM);

    return Column(
      crossAxisAlignment: crossAxis,
      mainAxisSize: MainAxisSize.min,
      children: [
        _CategoryBadge(project: project),
        const SizedBox(height: Spacing.md),
        Text(project.name, style: nameStyle),
        const SizedBox(height: Spacing.sm),
        Text(
          project.tagline,
          style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: Spacing.lg),
        Text(project.shortDesc, style: AppTypography.bodyM.copyWith(height: 1.7)),
        const SizedBox(height: Spacing.lg),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [for (final t in project.tech.take(5)) TechBadge(t, interactive: false)],
        ),
        if (project.metrics.isNotEmpty) ...[
          const SizedBox(height: Spacing.xl),
          _MetricsRow(project: project),
        ],
        const SizedBox(height: Spacing.lg),
        _MetaLine(project: project),
        const SizedBox(height: Spacing.xl),
        _CaseStudyCta(accent: project.accentColor, onTap: onOpen),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: project.accentColor,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: project.accentColor.withValues(alpha: 0.6), blurRadius: 6)],
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          project.category,
          style: AppTypography.mono.copyWith(color: project.accentColor, letterSpacing: 12 * 0.14),
        ),
      ],
    );
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final metrics = project.metrics;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0)
              Container(width: 0.5, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: Spacing.md)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountUpText(
                    metrics[i].value,
                    style: AppTypography.titleL.copyWith(color: project.accentColor, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    metrics[i].label,
                    style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final parts = [if (project.year != null) project.year!, if (project.status != null) project.status!];
    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(parts.join('  ·  '), style: AppTypography.mono.copyWith(color: AppColors.textMuted));
  }
}

/// Outlined CTA that fills with the project accent on hover; arrow slides right.
class _CaseStudyCta extends StatefulWidget {
  const _CaseStudyCta({required this.accent, required this.onTap});

  final Color accent;
  final VoidCallback onTap;

  @override
  State<_CaseStudyCta> createState() => _CaseStudyCtaState();
}

class _CaseStudyCtaState extends State<_CaseStudyCta> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final labelColor = _hovered ? AppColors.deepSpace : widget.accent;
    return CursorTarget(
      child: Semantics(
        button: true,
        label: 'View case study',
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppCurves.enter,
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              decoration: BoxDecoration(
                color: _hovered ? widget.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.pill),
                border: Border.all(color: widget.accent.withValues(alpha: _hovered ? 1 : 0.5), width: 1.5),
                boxShadow: _hovered
                    ? [BoxShadow(color: widget.accent.withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 2)]
                    : const [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Case Study',
                    style: AppTypography.titleS.copyWith(fontSize: 14, color: labelColor),
                  ),
                  AnimatedSlide(
                    duration: AppDurations.fast,
                    curve: AppCurves.enter,
                    offset: _hovered ? const Offset(0.18, 0) : Offset.zero,
                    child: Padding(
                      padding: const EdgeInsets.only(left: Spacing.sm),
                      child: Icon(LucideIcons.arrowRight, size: 16, color: labelColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
