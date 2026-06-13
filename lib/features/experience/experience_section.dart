import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/career_event.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/widgets/section_header.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 03 / EXPERIENCE — vertical timeline.
///
/// As each entry scrolls into view its dot fills with the accent, the
/// connecting line draws downward, and the card slides in from the right.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: context.pageGutter, vertical: context.sectionSpacing),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Spacing.pageMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: AppStrings.experienceEyebrow,
              title: AppStrings.experienceTitle,
              subtitle: AppStrings.experienceSubtitle,
            ),
            SizedBox(height: context.responsive(mobile: Spacing.xl, desktop: Spacing.xxl)),
            for (var i = 0; i < PortfolioData.careerEvents.length; i++)
              _TimelineTile(
                event: PortfolioData.careerEvents[i],
                isLast: i == PortfolioData.careerEvents.length - 1,
              ),
          ],
        ),
      ),
    ),
  );
}

class _TimelineTile extends StatefulWidget {
  const _TimelineTile({required this.event, required this.isLast});

  final CareerEvent event;
  final bool isLast;

  @override
  State<_TimelineTile> createState() => _TimelineTileState();
}

class _TimelineTileState extends State<_TimelineTile> with SingleTickerProviderStateMixin {
  late final AnimationController _draw;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _draw = AnimationController(vsync: this, duration: AppDurations.sluggish);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reducedMotion) {
      _draw.value = 1;
      _triggered = true;
    }
  }

  @override
  void dispose() {
    _draw.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (!_triggered && mounted && info.visibleFraction > 0.25) {
      _triggered = true;
      _draw.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final yearWidth = isMobile ? 0.0 : 96.0;
    const railCenterInRegion = 16.0; // center of the 32px rail region

    return VisibilityDetector(
      key: ValueKey('timeline-${widget.event.year}-${widget.event.title}'),
      onVisibilityChanged: _onVisibility,
      child: AnimatedBuilder(
        animation: _draw,
        // Stack (not IntrinsicHeight): the card is the non-positioned child, so
        // it defines the height — and the rail line, positioned top→bottom,
        // follows the card as it expands on hover. IntrinsicHeight measured the
        // collapsed card once and never re-measured, so hovering overflowed it.
        builder: (context, child) {
          final t = AppCurves.enter.transform(_draw.value);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Content (year offset + card) — defines the tile height.
              Padding(padding: EdgeInsets.only(left: yearWidth + 32 + Spacing.md), child: child),
              if (!isMobile)
                Positioned(
                  left: 0,
                  top: 2,
                  child: Opacity(
                    opacity: t,
                    child: Text('${widget.event.year}', style: AppTypography.monoAccent.copyWith(fontSize: 14)),
                  ),
                ),
              // Connecting line — from below this dot to the next (bottom of tile).
              if (!widget.isLast)
                Positioned(
                  left: yearWidth + railCenterInRegion - 0.75,
                  top: 7,
                  bottom: 0,
                  width: 1.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: AppColors.borderSubtle),
                      Align(
                        alignment: Alignment.topCenter,
                        child: FractionallySizedBox(
                          heightFactor: t.clamp(0.0, 1.0),
                          widthFactor: 1,
                          child: const ColoredBox(color: AppColors.accentPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              // Dot at the top of the tile.
              Positioned(
                left: yearWidth + railCenterInRegion - 7,
                top: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(AppColors.deepSpace, AppColors.accentPrimary, t),
                    border: Border.all(color: t > 0.1 ? AppColors.accentPrimary : AppColors.textMuted, width: 1.5),
                    boxShadow: t > 0.6
                        ? const [BoxShadow(color: AppColors.accentSubtle, blurRadius: 12, spreadRadius: 2)]
                        : const [],
                  ),
                ),
              ),
            ],
          );
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.isLast ? 0 : Spacing.xl),
          child: ScrollReveal(
            direction: ScrollRevealDirection.right,
            offset: 40,
            child: _EventCard(event: widget.event, showYearInline: isMobile),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({required this.event, required this.showYearInline});

  final CareerEvent event;
  final bool showYearInline;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    // Hover expands on desktop; touch / reduced-motion stay expanded so the
    // detail is always reachable.
    final expanded = _hovered || !context.supportsHover || context.reducedMotion;

    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        label: '${event.year}: ${event.title}${event.company == null ? '' : ' at ${event.company}'}',
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.enter,
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: expanded ? AppColors.surfaceMuted : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: expanded ? AppColors.borderActive : AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(event.period ?? '${event.year}', style: AppTypography.monoAccent),
                  ),
                  // Expand affordance — a plus that turns to a minus.
                  AnimatedRotation(
                    turns: expanded ? 0.125 : 0,
                    duration: AppDurations.normal,
                    curve: AppCurves.enter,
                    child: Icon(
                      LucideIcons.plus,
                      size: 16,
                      color: expanded ? AppColors.textAccent : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Wrap(
                spacing: Spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(event.title, style: AppTypography.titleM),
                  if (event.company != null)
                    Text('· ${event.company}', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              if (event.location != null) ...[
                const SizedBox(height: Spacing.xs),
                Text(event.location!, style: AppTypography.caption),
              ],
              // Expandable detail — description + highlights. AnimatedSize
              // swaps to a zero-height box when collapsed (never constrains a
              // Column to 0, which would overflow).
              AnimatedSize(
                duration: AppDurations.normal,
                curve: AppCurves.enter,
                alignment: Alignment.topLeft,
                child: expanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: Spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(event.description, style: AppTypography.bodyM),
                            if (event.highlights.isNotEmpty) const SizedBox(height: Spacing.md),
                            for (final highlight in event.highlights)
                              Padding(
                                padding: const EdgeInsets.only(bottom: Spacing.xs),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 7),
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.accentPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                    Expanded(child: Text(highlight, style: AppTypography.bodyM)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
