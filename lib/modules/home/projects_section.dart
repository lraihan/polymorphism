import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
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
  }

  Widget _buildProjectsGrid(BuildContext context) {
    return LayoutBuilder(
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
          itemBuilder: (context, index) => _ProjectCard(index: index, isDesktop: isDesktop),
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1024) return 3; // Desktop
    if (width >= 768) return 2; // Tablet
    return 1; // Mobile
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.index, required this.isDesktop});

  final int index;
  final bool isDesktop;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.isDesktop ? (_) => _setHovered(true) : null,
      onExit: widget.isDesktop ? (_) => _setHovered(false) : null,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: widget.isDesktop && _isHovered ? Border.all(color: AppColors.accent, width: 1) : null,
          boxShadow:
              widget.isDesktop && _isHovered
                  ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder content - will be replaced with actual project data
              Icon(Icons.code, size: 48, color: AppColors.textPrimary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Project Placeholder',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setHovered(bool hovered) {
    if (widget.isDesktop) {
      setState(() {
        _isHovered = hovered;
      });
    }
  }
}
