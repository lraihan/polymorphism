import 'package:flutter/material.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/about/fragment_portrait.dart';
import 'package:polymorphism/features/about/toolkit_section.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/widgets/section_header.dart';

/// 01 / ABOUT — human connection plus technical credibility.
///
/// Desktop: the fragment portrait (assembles on scroll) on the left, bio on
/// the right; toolkit grid + stats below. Mobile: everything stacks.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final gutter = context.pageGutter;
    final vertical = context.sectionSpacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: gutter, vertical: vertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Spacing.pageMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: AppStrings.aboutEyebrow,
                title: AppStrings.aboutTitle,
              ),
              SizedBox(height: context.responsive(mobile: Spacing.xl, desktop: Spacing.xxl)),
              if (context.isMobile) _mobileLayout(context) else _wideLayout(context),
              SizedBox(height: context.responsive(mobile: Spacing.xl, desktop: Spacing.xxl)),
              const _StatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wideLayout(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Expanded(flex: 2, child: FragmentPortrait()),
      const SizedBox(width: Spacing.xxl),
      Expanded(
        flex: 3,
        child: ScrollReveal(
          direction: ScrollRevealDirection.right,
          offset: 40,
          delay: AppDurations.instant,
          child: _bioAndSkills(context),
        ),
      ),
    ],
  );

  Widget _mobileLayout(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Center(child: SizedBox(width: 280, child: FragmentPortrait())),
      const SizedBox(height: Spacing.xl),
      ScrollReveal(delay: AppDurations.instant, child: _bioAndSkills(context)),
    ],
  );

  Widget _bioAndSkills(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppStrings.aboutGreeting, style: AppTypography.titleL),
      const SizedBox(height: Spacing.md),
      Text(AppStrings.aboutBio, style: AppTypography.bodyL),
      const SizedBox(height: Spacing.md),
      Text(AppStrings.aboutBioSecond, style: AppTypography.bodyM),
      const SizedBox(height: Spacing.xl),
      // Toolkit pillars sit below the introduction, beside the portrait.
      const ToolkitSection(),
    ],
  );
}

/// Animated stat strip under the bio — real numbers from the data layer.
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: Spacing.lg),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSubtle))),
    child: Wrap(
      spacing: Spacing.xxl,
      runSpacing: Spacing.lg,
      alignment: WrapAlignment.spaceBetween,
      children: [
        for (var i = 0; i < PortfolioData.stats.length; i++)
          ScrollReveal(
            delay: Duration(milliseconds: 80 * i),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioData.stats[i].value,
                  style: AppTypography.titleL.copyWith(color: AppColors.textAccent),
                ),
                const SizedBox(height: Spacing.xs),
                Text(PortfolioData.stats[i].label, style: AppTypography.caption),
              ],
            ),
          ),
      ],
    ),
  );
}
