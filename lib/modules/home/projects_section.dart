import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('projects'),
    padding: const EdgeInsets.only(
      top: AppSpacing.xxxl,
      bottom: AppSpacing.xxl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeader(context), const SizedBox(height: AppSpacing.xl), _buildProjectsGrid(context)],
    ),
  );

  Widget _buildHeader(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Featured Projects',
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        'Select highlights from my software and design work.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
      ),
    ],
  );

  Widget _buildProjectsGrid(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
      final isDesktop = kIsWeb && constraints.maxWidth >= 1024;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.5, // Changed from 1.2 to 1.5 for better sizing
        ),
        itemCount: 3,
        itemBuilder:
            (context, index) => ScrollReveal(
              delay: Duration(milliseconds: index * 150), // Slightly longer staggered delay
              duration: const Duration(milliseconds: 900), // Longer animation for more experience
              addScrollDelay: true, // Enable experiential scroll delay
              child: ProjectCard(index: index, isDesktop: isDesktop),
            ),
      );
    },
  );

  int _getCrossAxisCount(double width) {
    if (width >= 1024) {
      return 3; // Desktop
    }
    if (width >= 768) {
      return 2; // Tablet
    }
    return 1; // Mobile
  }
}
