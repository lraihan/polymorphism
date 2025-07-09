import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/data/models/project.dart';

class CreamuProjectCard extends StatefulWidget {
  final Project project;
  final bool isLarge;
  final bool isDesktop;

  const CreamuProjectCard({required this.project, this.isLarge = false, this.isDesktop = false, super.key});

  @override
  State<CreamuProjectCard> createState() => _CreamuProjectCardState();
}

class _CreamuProjectCardState extends State<CreamuProjectCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.01,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeCard = widget.isLarge;
    final cardHeight = isLargeCard ? 560.0 : 420.0;

    return MouseRegion(
      onEnter: widget.isDesktop ? (_) => _setHovered(true) : null,
      onExit: widget.isDesktop ? (_) => _setHovered(false) : null,
      child: GestureDetector(
        onTap: () {
          // TODO: Add project detail modal or navigation
          if (widget.project.projectUrl != null) {
            // Handle project URL navigation
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: cardHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
                    if (_isHovered && widget.isDesktop)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section
                      Expanded(flex: isLargeCard ? 3 : 2, child: _buildImageSection()),

                      // Content section
                      _buildContentSection(context, isLargeCard),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.glassSurface.withValues(alpha: 0.1)),
      child: Stack(
        children: [
          // Background pattern or placeholder
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassSurface.withValues(alpha: 0.05),
                  AppColors.accent.withValues(alpha: 0.03),
                  AppColors.moonGlow.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),

          // Project icon or image placeholder
          Center(
            child: Icon(
              _getProjectIcon(),
              size: widget.isLarge ? 80 : 60,
              color: AppColors.textPrimary.withValues(alpha: 0.08),
            ),
          ),

          // Hover overlay
          if (widget.isDesktop)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isHovered ? 0.02 : 0.0,
              child: Container(decoration: const BoxDecoration(color: Colors.black)),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, bool isLargeCard) {
    return Container(
      padding: EdgeInsets.all(isLargeCard ? AppSpacing.xl : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Text(
            widget.project.category.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
              letterSpacing: 2.0,
              fontSize: 11,
            ),
          ),

          SizedBox(height: isLargeCard ? AppSpacing.lg : AppSpacing.md),

          // Title
          Text(
            widget.project.title,
            style: (isLargeCard ? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.titleLarge)
                ?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, height: 1.1, letterSpacing: -0.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isLargeCard ? AppSpacing.sm : AppSpacing.xs),

          // Subtitle
          Text(
            widget.project.subtitle,
            style: (isLargeCard ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium)
                ?.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isLargeCard ? AppSpacing.md : AppSpacing.sm),

          // Scope
          Text(
            widget.project.scope,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          if (isLargeCard) ...[
            const SizedBox(height: AppSpacing.xl),

            // View Project link
            _buildViewProjectLink(context),
          ],
        ],
      ),
    );
  }

  Widget _buildViewProjectLink(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: widget.isDesktop ? (_isHovered ? 1.0 : 0.6) : 0.8,
      child: Row(
        children: [
          Text(
            'View Project',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textPrimary.withValues(alpha: 0.2),
              decorationThickness: 1,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Transform.translate(
            offset: const Offset(0, -1),
            child: Icon(Icons.arrow_outward, size: 12, color: AppColors.textPrimary.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  IconData _getProjectIcon() {
    switch (widget.project.category.toLowerCase()) {
      case 'digital design':
        return Icons.design_services_outlined;
      case 'innovation':
        return Icons.psychology_outlined;
      case 'digital art':
        return Icons.palette_outlined;
      case 'personal':
        return Icons.person_outline;
      case 'open source':
        return Icons.code_outlined;
      case 'typography':
        return Icons.text_fields_outlined;
      default:
        return Icons.work_outline;
    }
  }

  void _setHovered(bool hovered) {
    if (widget.isDesktop) {
      setState(() {
        _isHovered = hovered;
      });

      if (hovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
}
