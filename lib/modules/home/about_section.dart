import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      height: screenHeight(context),
      width: screenWidth - horizontalPadding(context) * 2,
      key: const ValueKey('about'),
      padding: EdgeInsets.only(
        top: AppSpacing.xxxl,
        bottom: AppSpacing.xxl,
        left: isMobile ? AppSpacing.md : AppSpacing.lg,
        right: isMobile ? AppSpacing.md : AppSpacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context, isTablet)),
          _buildStatsFooter(context),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ScrollReveal(
        delay: const Duration(milliseconds: 100),
        duration: const Duration(milliseconds: 1200),
        child: Text(
          '(About.)',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: AppSpacing.xl),
      ScrollReveal(
        delay: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: AutoSizeText(
            "I'm Raihan, visual engineer. I use Flutter and Figma to craft digital anatomies where the elegance of architecture and the beauty of design assembled to deliver efficient- high performing solutions.",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 6,
            minFontSize: 16,
          ),
        ),
      ),
    ],
  );

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    final titleWidth = isTablet ? 0.35 : 0.3;
    final contentWidth = isTablet ? 0.55 : 0.5;

    return Row(
      children: [
        ScrollReveal(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 1200),
          child: Container(
            width: screenWidth(context) * titleWidth - horizontalPadding(context),
            alignment: Alignment.center,
            child: Text(
              '(About.)',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ScrollReveal(
          delay: const Duration(milliseconds: 300),
          duration: const Duration(milliseconds: 1200),
          child: SizedBox(
            width: screenWidth(context) * contentWidth - horizontalPadding(context),
            child: AutoSizeText(
              "I'm Raihan, visual engineer. I use Flutter and Figma to craft digital anatomies where the elegance of architecture and the beauty of design assembled to deliver efficient- high performing solutions.",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsFooter(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.md : AppSpacing.xl, vertical: AppSpacing.lg),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.1)))),
      child: isMobile ? _buildMobileStats(context) : _buildDesktopStats(context),
    );
  }

  Widget _buildMobileStats(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ScrollReveal(
            delay: const Duration(milliseconds: 1100),
            child: _buildStatItem(context, '5+', 'Years\nExperience'),
          ),
          ScrollReveal(
            delay: const Duration(milliseconds: 1150),
            duration: const Duration(milliseconds: 1200),
            child: _buildStatItem(context, '10+', 'Projects\nCompleted'),
          ),
          ScrollReveal(
            delay: const Duration(milliseconds: 1200),
            duration: const Duration(milliseconds: 1200),
            child: _buildStatItem(context, 'Millions', 'of Codes\nWritten'),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 60), // Spacer for alignment
          ScrollReveal(
            delay: const Duration(milliseconds: 1250),
            duration: const Duration(milliseconds: 1200),
            child: _buildStatItem(context, 'Hundreds', 'of Screen\nDesigned'),
          ),
          ScrollReveal(
            delay: const Duration(milliseconds: 1300),
            duration: const Duration(milliseconds: 1200),
            child: _buildStatItem(context, '∞', 'Coffee\nConsumed'),
          ),
          const SizedBox(width: 60), // Spacer for alignment
        ],
      ),
    ],
  );

  Widget _buildDesktopStats(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ScrollReveal(
        delay: const Duration(milliseconds: 1100),
        child: _buildStatItem(context, '5+', 'Years\nExperience'),
      ),
      ScrollReveal(
        delay: const Duration(milliseconds: 1150),
        duration: const Duration(milliseconds: 1200),
        child: _buildStatItem(context, '10+', 'Projects\nCompleted'),
      ),
      ScrollReveal(
        delay: const Duration(milliseconds: 1200),
        duration: const Duration(milliseconds: 1200),
        child: _buildStatItem(context, 'Millions', 'of Codes\nWritten'),
      ),
      ScrollReveal(
        delay: const Duration(milliseconds: 1250),
        duration: const Duration(milliseconds: 1200),
        child: _buildStatItem(context, 'Hundreds', 'of Screen\nDesigned'),
      ),
      ScrollReveal(
        delay: const Duration(milliseconds: 1300),
        duration: const Duration(milliseconds: 1200),
        child: _buildStatItem(context, '∞', 'Coffee\nConsumed'),
      ),
    ],
  );

  Widget _buildStatItem(BuildContext context, String number, String label) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Column(
      children: [
        Text(
          number,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 24 : null, // Smaller on mobile
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.7),
            letterSpacing: 0.5,
            fontSize: isMobile ? 12 : null, // Smaller on mobile
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
