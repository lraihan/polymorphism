import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/noise_overlay.dart';
import 'package:polymorphism/shared/widgets/tech_badge.dart';

/// Fullscreen project detail, pushed as its own route (`/work/<id>`).
///
/// The card's visual flies in via [Hero]; screenshots page through a
/// carousel; Esc or the prominent close button dismisses.
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final gutter = context.pageGutter;

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
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Spacing.xl),
                          Text(project.category, style: AppTypography.monoAccent),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            project.title,
                            style: context.responsive(mobile: AppTypography.displayM, desktop: AppTypography.displayL),
                          ),
                          const SizedBox(height: Spacing.xl),
                          SizedBox(
                            height: context.responsive<double>(mobile: 360, tablet: 480, desktop: 560),
                            child: Hero(
                              tag: project.heroTag,
                              child: _ScreenshotCarousel(project: project),
                            ),
                          ),
                          const SizedBox(height: Spacing.xl),
                          Flex(
                            direction: context.isMobile ? Axis.vertical : Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: context.isMobile ? 0 : 3,
                                child: Text(project.description, style: AppTypography.bodyL),
                              ),
                              SizedBox(
                                width: context.isMobile ? 0 : Spacing.xxl,
                                height: context.isMobile ? Spacing.xl : 0,
                              ),
                              Expanded(
                                flex: context.isMobile ? 0 : 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('STACK', style: AppTypography.mono),
                                    const SizedBox(height: Spacing.md),
                                    Wrap(
                                      spacing: Spacing.sm,
                                      runSpacing: Spacing.sm,
                                      children: [for (final t in project.tech) TechBadge(t)],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const NoiseOverlay(),
              // Close — prominent, top-right.
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

/// 3-shot carousel: arrows on hover, tappable progress dots beneath.
class _ScreenshotCarousel extends StatefulWidget {
  const _ScreenshotCarousel({required this.project});

  final Project project;

  @override
  State<_ScreenshotCarousel> createState() => _ScreenshotCarouselState();
}

class _ScreenshotCarouselState extends State<_ScreenshotCarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _to(int page) {
    _controller.animateToPage(page.clamp(0, widget.project.images.length - 1),
        duration: AppDurations.normal, curve: AppCurves.travel);
  }

  @override
  Widget build(BuildContext context) {
    final portrait = widget.project.screenshots == ScreenshotKind.portrait;

    // Image area is Expanded so the Column fits whatever height it's given —
    // the bounded SizedBox on the detail page, or the smaller interpolated box
    // during the card→detail Hero flight (which previously overflowed).
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -0.8),
                  radius: 1.6,
                  colors: [widget.project.accent.withValues(alpha: 0.14), AppColors.inkBlack],
                ),
              ),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: widget.project.images.length,
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.all(portrait ? Spacing.lg : Spacing.md),
                      child: Image.asset(widget.project.images[i], fit: BoxFit.contain),
                    ),
                  ),
                  if (_page > 0)
                    _Arrow(icon: LucideIcons.chevronLeft, alignment: Alignment.centerLeft, onTap: () => _to(_page - 1)),
                  if (_page < widget.project.images.length - 1)
                    _Arrow(
                      icon: LucideIcons.chevronRight,
                      alignment: Alignment.centerRight,
                      onTap: () => _to(_page + 1),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.project.images.length; i++)
              CursorTarget(
                child: GestureDetector(
                  onTap: () => _to(i),
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    curve: AppCurves.enter,
                    margin: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                    width: _page == i ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i ? AppColors.accentPrimary : AppColors.borderSubtle,
                      borderRadius: BorderRadius.circular(Radii.xs),
                    ),
                  ),
                ),
              ),
          ],
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
