import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/works/project_card.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/widgets/cta_button.dart';
import 'package:polymorphism/shared/widgets/section_header.dart';

/// 02 / WORKS — editorial bento grid of real, shipped projects.
///
/// Desktop rows: featured(2)+small(1) · small(1)+featured(2) ·
/// small(1)+small(1)+CTA(1). Tablet: featured full-width, standards in
/// pairs. Mobile: single column. Cards stagger in at 80 ms × index.
class WorksSection extends StatelessWidget {
  const WorksSection({required this.onOpenProject, required this.onStartProject, super.key});

  final void Function(String projectId) onOpenProject;
  final VoidCallback onStartProject;

  @override
  Widget build(BuildContext context) {
    final gutter = context.pageGutter;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: gutter, vertical: context.sectionSpacing),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Spacing.pageMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: AppStrings.worksEyebrow,
                title: AppStrings.worksTitle,
                subtitle: AppStrings.worksSubtitle,
              ),
              SizedBox(height: context.responsive(mobile: Spacing.xl, desktop: Spacing.xxl)),
              context.responsive<Widget>(
                mobile: _singleColumn(),
                tablet: _tabletGrid(),
                desktop: _bentoGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ProjectCard _card(int index) => ProjectCard(
    project: PortfolioData.projects[index],
    onOpen: () => onOpenProject(PortfolioData.projects[index].id),
  );

  ScrollReveal _reveal(int order, Widget child) =>
      ScrollReveal(delay: Duration(milliseconds: order * 80), child: child);

  /// Desktop: the asymmetric editorial layout.
  Widget _bentoGrid(BuildContext context) {
    final rowHeight = context.isWide ? 460.0 : 420.0;
    return Column(
      children: [
        SizedBox(
          height: rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _reveal(0, _card(0))),
              const SizedBox(width: Spacing.gridGap),
              Expanded(child: _reveal(1, _card(1))),
            ],
          ),
        ),
        const SizedBox(height: Spacing.gridGap),
        SizedBox(
          height: rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _reveal(2, _card(2))),
              const SizedBox(width: Spacing.gridGap),
              Expanded(flex: 2, child: _reveal(3, _card(3))),
            ],
          ),
        ),
        const SizedBox(height: Spacing.gridGap),
        SizedBox(
          height: rowHeight * 0.92,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _reveal(4, _card(4))),
              const SizedBox(width: Spacing.gridGap),
              Expanded(child: _reveal(5, _card(5))),
              const SizedBox(width: Spacing.gridGap),
              Expanded(child: _reveal(6, _NextProjectTile(onTap: onStartProject))),
            ],
          ),
        ),
      ],
    );
  }

  /// Tablet: featured cards full-width, standard cards in pairs.
  Widget _tabletGrid() {
    final featured = <int>[];
    final standard = <int>[];
    for (var i = 0; i < PortfolioData.projects.length; i++) {
      (PortfolioData.projects[i].scale == ProjectScale.featured ? featured : standard).add(i);
    }
    var order = 0;
    return Column(
      children: [
        for (final i in featured) ...[
          SizedBox(height: 420, child: _reveal(order++, _card(i))),
          const SizedBox(height: Spacing.gridGap),
        ],
        for (var p = 0; p < standard.length; p += 2) ...[
          SizedBox(
            height: 420,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _reveal(order++, _card(standard[p]))),
                const SizedBox(width: Spacing.gridGap),
                Expanded(
                  child: p + 1 < standard.length
                      ? _reveal(order++, _card(standard[p + 1]))
                      : _reveal(order++, _NextProjectTile(onTap: onStartProject)),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.gridGap),
        ],
        if (standard.length.isEven) SizedBox(height: 240, child: _reveal(order, _NextProjectTile(onTap: onStartProject))),
      ],
    );
  }

  /// Mobile: one column.
  Widget _singleColumn() => Column(
    children: [
      for (var i = 0; i < PortfolioData.projects.length; i++) ...[
        SizedBox(height: 400, child: _reveal(i, _card(i))),
        const SizedBox(height: Spacing.gridGap),
      ],
      SizedBox(height: 220, child: _reveal(PortfolioData.projects.length, _NextProjectTile(onTap: onStartProject))),
    ],
  );
}

/// The seventh bento cell — an invitation instead of an empty slot.
class _NextProjectTile extends StatelessWidget {
  const _NextProjectTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Spacing.lg),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Radii.lg),
      border: Border.all(color: AppColors.borderSubtle),
      gradient: const RadialGradient(
        center: Alignment(0.8, 1),
        radius: 1.8,
        colors: [AppColors.accentSubtle, Colors.transparent],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('NEXT', style: AppTypography.mono),
        // Flexible so the block never overflows a short bento cell; the body
        // line ellipsizes before it would push the CTA out of bounds.
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.nextProjectCardTitle, style: AppTypography.titleM, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: Spacing.sm),
              Flexible(
                child: Text(AppStrings.nextProjectCardBody, style: AppTypography.bodyM, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: Spacing.md),
              CtaButton.ghost(label: AppStrings.nextProjectCardCta, icon: LucideIcons.arrowUpRight, onTap: onTap),
            ],
          ),
        ),
      ],
    ),
  );
}
