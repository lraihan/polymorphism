import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/works/widgets/spotlight_card.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/widgets/cta_button.dart';
import 'package:polymorphism/shared/widgets/section_header.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 02 / WORKS — immersive spotlight case studies.
///
/// Each project is a full-width chapter that alternates left/right on desktop.
/// As a chapter scrolls through the viewport centre, the section's ambient glow
/// crossfades to that project's dominant color — the "chapter change" signal.
class WorksSection extends StatefulWidget {
  const WorksSection({required this.onOpenProject, required this.onStartProject, super.key});

  final void Function(String projectId) onOpenProject;
  final VoidCallback onStartProject;

  @override
  State<WorksSection> createState() => _WorksSectionState();
}

class _WorksSectionState extends State<WorksSection> {
  final Map<int, double> _fractions = {};
  late Color _ambient = PortfolioData.projects.first.dominantColor;

  void _onCardVisibility(int index, VisibilityInfo info) {
    if (!mounted || context.isMobile) {
      return; // ambient disabled on mobile
    }
    _fractions[index] = info.visibleFraction;
    var bestIndex = 0;
    var best = -1.0;
    _fractions.forEach((i, f) {
      if (f > best) {
        best = f;
        bestIndex = i;
      }
    });
    final next = PortfolioData.projects[bestIndex].dominantColor;
    if (next != _ambient) {
      setState(() => _ambient = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;

    return Stack(
      children: [
        if (!context.isMobile)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: AppDurations.sluggish,
                curve: AppCurves.travel,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.05),
                    radius: 0.95,
                    colors: [_ambient.withValues(alpha: 0.10), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.pageGutter, vertical: context.sectionSpacing),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Spacing.pageMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    eyebrow: AppStrings.worksEyebrow,
                    title: AppStrings.worksTitle,
                    subtitle: 'Seven products I designed and built — each one its own chapter.',
                  ),
                  SizedBox(height: context.responsive(mobile: Spacing.xxl, desktop: Spacing.section * 0.5)),
                  for (var i = 0; i < projects.length; i++) ...[
                    VisibilityDetector(
                      key: ValueKey('spotlight-${projects[i].id}'),
                      onVisibilityChanged: (info) => _onCardVisibility(i, info),
                      child: SpotlightCard(
                        project: projects[i],
                        index: i,
                        onOpen: () => widget.onOpenProject(projects[i].id),
                      ),
                    ),
                    if (i < projects.length - 1) SpotlightDivider(accent: projects[i].accentColor),
                  ],
                  SizedBox(height: context.responsive(mobile: Spacing.xxl, desktop: Spacing.section * 0.5)),
                  _ClosingInvite(onTap: widget.onStartProject),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The section's closing note — an invitation, not an empty slot.
class _ClosingInvite extends StatelessWidget {
  const _ClosingInvite({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ScrollReveal(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: Spacing.lg, desktop: Spacing.xxl),
          vertical: context.responsive(mobile: Spacing.xl, desktop: Spacing.xxl),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.xl),
          border: Border.all(color: AppColors.borderSubtle),
          gradient: const RadialGradient(
            center: Alignment(0.9, 1),
            radius: 1.6,
            colors: [AppColors.accentSubtle, Colors.transparent],
          ),
        ),
        child: Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: context.isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: context.isMobile ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('NEXT', style: AppTypography.monoAccent),
                  const SizedBox(height: Spacing.sm),
                  Text(AppStrings.nextProjectCardTitle, style: context.responsive(mobile: AppTypography.titleL, desktop: AppTypography.displayM)),
                  const SizedBox(height: Spacing.sm),
                  Text(AppStrings.nextProjectCardBody, style: AppTypography.bodyM),
                ],
              ),
            ),
            SizedBox(width: context.isMobile ? 0 : Spacing.xxl, height: context.isMobile ? Spacing.xl : 0),
            CtaButton.primary(label: AppStrings.nextProjectCardCta, icon: LucideIcons.arrowUpRight, onTap: onTap),
          ],
        ),
      ),
    );
}
