import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/works/widgets/abstract_art_panel.dart';
import 'package:polymorphism/shared/widgets/count_up_text.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/noise_overlay.dart';
import 'package:polymorphism/shared/widgets/shimmer_placeholder.dart';
import 'package:polymorphism/shared/widgets/tech_badge.dart';

/// Fullscreen case study, pushed as its own route (`/work/<id>`).
///
/// A full gallery up top, then overview, "The Build", tech, metrics, links, and
/// a jump to the next project. Esc or the close button dismisses.
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({required this.project, super.key});

  final Project project;

  String _platformLabel(ProjectPlatform p) => switch (p) {
        ProjectPlatform.mobile => 'Mobile',
        ProjectPlatform.web => 'Web',
        ProjectPlatform.tablet => 'Tablet',
        ProjectPlatform.pos => 'POS',
        ProjectPlatform.crossPlatform => 'Cross-platform',
      };

  Project get _next {
    final list = PortfolioData.projects;
    final i = list.indexWhere((p) => p.id == project.id);
    return list[(i + 1) % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final gutter = context.pageGutter;
    final accent = project.accentColor;

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): () => Navigator.of(context).maybePop()},
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.deepSpace,
          body: Stack(
            children: [
              SelectionArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: gutter, vertical: Spacing.xxl),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Spacing.xl),
                          // ── title block ──
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Text(project.category, style: AppTypography.mono.copyWith(color: accent)),
                              const SizedBox(width: Spacing.md),
                              Text('· ${_platformLabel(project.platform)}', style: AppTypography.mono),
                            ],
                          ),
                          const SizedBox(height: Spacing.md),
                          Text(
                            project.name,
                            style: context.responsive(mobile: AppTypography.displayM, desktop: AppTypography.displayL),
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            project.tagline,
                            style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: Spacing.xl),
                          // ── gallery ──
                          SizedBox(
                            height: context.responsive<double>(mobile: 320, tablet: 460, desktop: 540),
                            child: project.hasImages
                                ? _CaseStudyGallery(project: project)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(Radii.lg),
                                    child: AbstractArtPanel(project: project),
                                  ),
                          ),
                          const SizedBox(height: Spacing.xxl),
                          // ── overview ──
                          _Flow(
                            context: context,
                            left: _Labelled(
                              label: 'OVERVIEW',
                              child: Text(project.fullDesc, style: AppTypography.bodyL),
                            ),
                            right: _MetaCard(project: project, platformLabel: _platformLabel(project.platform)),
                          ),
                          if (project.highlights.isNotEmpty) ...[
                            const SizedBox(height: Spacing.xxl),
                            _Flow(
                              context: context,
                              left: _Labelled(
                                label: 'THE BUILD',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final h in project.highlights)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: Spacing.md),
                                        child: _HighlightRow(text: h, accent: accent),
                                      ),
                                  ],
                                ),
                              ),
                              right: _Labelled(
                                label: 'TECH STACK',
                                child: Wrap(
                                  spacing: Spacing.sm,
                                  runSpacing: Spacing.sm,
                                  children: [for (final t in project.tech) TechBadge(t)],
                                ),
                              ),
                            ),
                          ],
                          if (project.metrics.isNotEmpty) ...[
                            const SizedBox(height: Spacing.xxl),
                            _BigMetrics(project: project),
                          ],
                          if (project.githubUrl != null || project.liveUrl != null) ...[
                            const SizedBox(height: Spacing.xxl),
                            Row(
                              children: [
                                if (project.githubUrl != null)
                                  _LinkButton(icon: LucideIcons.github, label: 'Source', accent: accent, url: project.githubUrl!),
                                if (project.liveUrl != null) ...[
                                  const SizedBox(width: Spacing.md),
                                  _LinkButton(icon: LucideIcons.arrowUpRight, label: 'Live', accent: accent, url: project.liveUrl!),
                                ],
                              ],
                            ),
                          ],
                          const SizedBox(height: Spacing.xxl),
                          const Divider(color: AppColors.borderSubtle, thickness: 0.5),
                          const SizedBox(height: Spacing.lg),
                          _NextProjectCard(next: _next, onTap: () => context.go('/work/${_next.id}')),
                          const SizedBox(height: Spacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const NoiseOverlay(),
              Positioned(
                top: Spacing.lg,
                right: Spacing.lg,
                child: CursorTarget(
                  child: Semantics(
                    button: true,
                    label: 'Close project',
                    child: _CloseButton(onTap: () => Navigator.of(context).maybePop()),
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

/// Two-column on desktop, stacked on mobile — used for the body sections.
class _Flow extends StatelessWidget {
  const _Flow({required this.context, required this.left, required this.right});

  final BuildContext context;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    return Flex(
      direction: mobile ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: mobile ? 0 : 3, child: left),
        SizedBox(width: mobile ? 0 : Spacing.xxl, height: mobile ? Spacing.xl : 0),
        Expanded(flex: mobile ? 0 : 2, child: right),
      ],
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.mono),
          const SizedBox(height: Spacing.md),
          child,
        ],
      );
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.project, required this.platformLabel});

  final Project project;
  final String platformLabel;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      if (project.role != null) ('Role', project.role!),
      ('Platform', platformLabel),
      if (project.year != null) ('Year', project.year!),
      if (project.status != null) ('Status', project.status!),
    ];
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: Spacing.md),
            Text(rows[i].$1.toUpperCase(), style: AppTypography.mono.copyWith(color: AppColors.textMuted, fontSize: 10)),
            const SizedBox(height: 2),
            Text(rows[i].$2, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary)),
          ],
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(LucideIcons.chevronRight, size: 16, color: accent),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(child: Text(text, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary, height: 1.6))),
        ],
      );
}

class _BigMetrics extends StatelessWidget {
  const _BigMetrics({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xl, horizontal: Spacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: AppColors.borderSubtle),
        gradient: RadialGradient(
          center: const Alignment(-0.8, -1),
          radius: 2,
          colors: [project.dominantColor.withValues(alpha: 0.18), Colors.transparent],
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < project.metrics.length; i++) ...[
              if (i > 0) Container(width: 0.5, color: AppColors.borderSubtle),
              Expanded(
                child: Column(
                  children: [
                    CountUpText(
                      project.metrics[i].value,
                      style: context
                          .responsive(mobile: AppTypography.titleL, desktop: AppTypography.displayM)
                          .copyWith(color: project.accentColor, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      project.metrics[i].label,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
}

class _NextProjectCard extends StatefulWidget {
  const _NextProjectCard({required this.next, required this.onTap});

  final Project next;
  final VoidCallback onTap;

  @override
  State<_NextProjectCard> createState() => _NextProjectCardState();
}

class _NextProjectCardState extends State<_NextProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => CursorTarget(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEXT PROJECT', style: AppTypography.mono.copyWith(color: widget.next.accentColor)),
                    const SizedBox(height: Spacing.sm),
                    AnimatedSlide(
                      duration: AppDurations.fast,
                      curve: AppCurves.enter,
                      offset: _hovered ? const Offset(0.02, 0) : Offset.zero,
                      child: Text(
                        widget.next.name,
                        style: context.responsive(mobile: AppTypography.titleL, desktop: AppTypography.displayM),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(widget.next.tagline, style: AppTypography.bodyM, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hovered ? widget.next.accentColor : AppColors.surfaceCard,
                  border: Border.all(color: _hovered ? widget.next.accentColor : AppColors.borderSubtle),
                ),
                child: Icon(
                  LucideIcons.arrowRight,
                  color: _hovered ? AppColors.deepSpace : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.icon, required this.label, required this.accent, required this.url});

  final IconData icon;
  final String label;
  final Color accent;
  final String url;

  @override
  Widget build(BuildContext context) => CursorTarget(
        child: GestureDetector(
          onTap: () {}, // url_launcher wiring lives in the shared link helper
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.pill),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: accent),
                const SizedBox(width: Spacing.sm),
                Text(label, style: AppTypography.titleS.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ),
      );
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        opaque: false,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.enter,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered ? AppColors.accentPrimary : AppColors.surfaceCard,
              border: Border.all(color: _hovered ? AppColors.accentPrimary : AppColors.borderSubtle),
            ),
            child: Icon(LucideIcons.x, size: 18, color: _hovered ? AppColors.textOnAccent : AppColors.textPrimary),
          ),
        ),
      );
}

/// Hero gallery: a paged viewer with a counter and a tappable thumbnail strip.
class _CaseStudyGallery extends StatefulWidget {
  const _CaseStudyGallery({required this.project});

  final Project project;

  @override
  State<_CaseStudyGallery> createState() => _CaseStudyGalleryState();
}

class _CaseStudyGalleryState extends State<_CaseStudyGallery> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _to(int page) {
    final clamped = page.clamp(0, widget.project.images.length - 1);
    _controller.animateToPage(clamped, duration: AppDurations.normal, curve: AppCurves.travel);
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.project.images;
    final portrait = widget.project.isPortraitMedia;
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.5, -0.7),
                  radius: 1.5,
                  colors: [widget.project.dominantColor.withValues(alpha: 0.3), AppColors.inkBlack],
                ),
              ),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: images.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(Spacing.lg),
                      child: ProjectImage(
                        path: images[i],
                        tint: widget.project.dominantColor,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  if (_page > 0)
                    _Arrow(icon: LucideIcons.chevronLeft, alignment: Alignment.centerLeft, onTap: () => _to(_page - 1)),
                  if (_page < images.length - 1)
                    _Arrow(icon: LucideIcons.chevronRight, alignment: Alignment.centerRight, onTap: () => _to(_page + 1)),
                  Positioned(
                    top: Spacing.md,
                    right: Spacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.deepSpace.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(Radii.pill),
                      ),
                      child: Text('${_page + 1} / ${images.length}', style: AppTypography.mono),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
            itemBuilder: (context, i) => CursorTarget(
              child: GestureDetector(
                onTap: () => _to(i),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  width: portrait ? 36 : 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Radii.sm),
                    border: Border.all(
                      color: _page == i ? widget.project.accentColor : AppColors.borderSubtle,
                      width: _page == i ? 1.5 : 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.sm - 1),
                    child: ProjectImage(path: images[i], tint: widget.project.dominantColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.alignment, required this.onTap});

  final IconData icon;
  final Alignment alignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: CursorTarget(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.deepSpace.withValues(alpha: 0.7),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Icon(icon, size: 20, color: AppColors.textPrimary),
              ),
            ),
          ),
        ),
      );
}
