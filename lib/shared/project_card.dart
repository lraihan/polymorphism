import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.index, this.isDesktop = false, super.key});

  final int index;
  final bool isDesktop;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
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
