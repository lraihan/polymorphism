import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/project_card.dart';

class WorksSection extends StatelessWidget {
  const WorksSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('works'),
    padding: const EdgeInsets.only(
      top: AppSpacing.xxxl,
      bottom: AppSpacing.xxl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: AppSpacing.xl),
        _buildProjectsGrid(context),
        const SizedBox(height: AppSpacing.xxxl),
        _buildGalleryHeader(context),
        const SizedBox(height: AppSpacing.xl),
        _buildGalleryGrid(context),
      ],
    ),
  );

  Widget _buildHeader(BuildContext context) => ScrollReveal(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Works',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'A showcase of featured projects and visual explorations.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
        ),
      ],
    ),
  );

  Widget _buildProjectsGrid(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = _getProjectsCrossAxisCount(constraints.maxWidth);
      final isDesktop = kIsWeb && constraints.maxWidth >= 1024;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.5,
        ),
        itemCount: 3,
        itemBuilder:
            (context, index) => ScrollReveal(
              delay: Duration(milliseconds: index * 150),
              duration: const Duration(milliseconds: 900),
              child: ProjectCard(index: index, isDesktop: isDesktop),
            ),
      );
    },
  );

  Widget _buildGalleryHeader(BuildContext context) => ScrollReveal(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visual Explorations',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Motion studies and design experiments.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
        ),
      ],
    ),
  );

  Widget _buildGalleryGrid(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = _getGalleryCrossAxisCount(constraints.maxWidth);
      final isDesktop = kIsWeb && constraints.maxWidth >= 800;

      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        itemCount: 8,
        itemBuilder:
            (context, index) => ScrollReveal(
              delay: Duration(milliseconds: (index + 3) * 120), // Offset delay after projects
              duration: const Duration(milliseconds: 850),
              child: _GalleryTile(index: index, isDesktop: isDesktop),
            ),
      );
    },
  );

  int _getProjectsCrossAxisCount(double width) {
    if (width >= 1024) {
      return 3; // Desktop
    }
    if (width >= 768) {
      return 2; // Tablet
    }
    return 1; // Mobile
  }

  int _getGalleryCrossAxisCount(double width) {
    if (width >= 1280) {
      return 4; // Desktop large
    }
    if (width >= 800) {
      return 3; // Desktop/Tablet
    }
    if (width >= 600) {
      return 2; // Small tablet
    }
    return 1; // Mobile
  }
}

class _GalleryTile extends StatefulWidget {
  const _GalleryTile({required this.index, required this.isDesktop});

  final int index;
  final bool isDesktop;

  @override
  State<_GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<_GalleryTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Vary aspect ratios for masonry effect
    final aspectRatios = [1.2, 0.8, 1.5, 0.9, 1.1, 1.3, 0.7, 1.0];
    final aspectRatio = aspectRatios[widget.index % aspectRatios.length];
    final height = 200 / aspectRatio;

    return GestureDetector(
      onTap: () {
        // TODO(raihan): Add gallery lightbox functionality without router
      },
      child: MouseRegion(
        onEnter: widget.isDesktop ? (_) => _setHovered(true) : null,
        onExit: widget.isDesktop ? (_) => _setHovered(false) : null,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          transform: widget.isDesktop && _isHovered ? (Matrix4.identity()..scale(1.03)) : Matrix4.identity(),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(AppSpacing.md),
              boxShadow:
                  widget.isDesktop && _isHovered
                      ? [
                        BoxShadow(
                          color: AppColors.moonGlow.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                      : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              child: Stack(
                children: [
                  // Placeholder content
                  Hero(
                    tag: 'gallery-img-${widget.index}',
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 32, color: AppColors.textPrimary.withValues(alpha: 0.6)),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Visual ${widget.index + 1}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Hover overlay
                  if (widget.isDesktop && _isHovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.moonGlow.withValues(alpha: 0.1)],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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
