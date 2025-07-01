import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// About section for the home page
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('about'),
    padding: const EdgeInsets.only(
      top: AppSpacing.xxxl,
      bottom: AppSpacing.xxl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
    ),
    child: ScrollReveal(
      delay: const Duration(milliseconds: 100), // Add experiential delay
      duration: const Duration(milliseconds: 1200), // Longer animation for better experience
      addScrollDelay: true, // Enable experiential scroll delay
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(context), const SizedBox(height: AppSpacing.xl), _buildContent(context)],
      ),
    ),
  );

  Widget _buildHeader(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'About Me',
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        'Crafting digital experiences through code and design.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
      ),
    ],
  );

  Widget _buildContent(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Column(children: [if (isWide) _buildWideLayout(context) else _buildNarrowLayout(context)]);
  }

  Widget _buildWideLayout(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Left column - Text content
      Expanded(flex: 2, child: _buildTextContent(context)),
      const SizedBox(width: AppSpacing.xl),
      // Right column - Stats/Skills
      Expanded(flex: 1, child: _buildStatsContent(context)),
    ],
  );

  Widget _buildNarrowLayout(BuildContext context) => Column(
    children: [_buildTextContent(context), const SizedBox(height: AppSpacing.xl), _buildStatsContent(context)],
  );

  Widget _buildTextContent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'I\'m a passionate Flutter developer and designer with a love for creating beautiful, functional digital experiences. With expertise in mobile development, UI/UX design, and modern web technologies, I bridge the gap between design and development.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, height: 1.6),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text(
        'My journey began in frontend development and evolved into specializing in Flutter applications. I believe in the power of clean code, intuitive design, and seamless user experiences that make technology feel natural and accessible.',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.9), height: 1.6),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text(
        'When I\'m not coding, you\'ll find me exploring new design trends, contributing to open source projects, or experimenting with the latest technologies in the Flutter ecosystem.',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8), height: 1.6),
      ),
    ],
  );

  Widget _buildStatsContent(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.glassSurface,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStatItem(context, '5+', 'Years Experience'),
        _buildStatItem(context, '30+', 'Projects Completed'),
        _buildStatItem(context, '6', 'Technologies Mastered'),
        _buildStatItem(context, '∞', 'Coffee Consumed'),
      ],
    ),
  );

  Widget _buildStatItem(BuildContext context, String number, String label) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      children: [
        Text(
          number,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
          ),
        ),
      ],
    ),
  );
}
