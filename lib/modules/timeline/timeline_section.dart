import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/timeline/timeline_strip.dart';

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key, this.enableAnimations = true, this.scrollController});
  final bool enableAnimations;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final horizontalPadding = isMobile ? AppSpacing.md : AppSpacing.lg;
    final verticalPadding = isMobile ? AppSpacing.xl : AppSpacing.xxl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      color: AppColors.bgDark,
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              'Career Timeline',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: _getResponsiveFontSize(context, 28),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : AppSpacing.xl),
            child: Text(
              'A journey through professional milestones and growth',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
                fontSize: _getResponsiveFontSize(context, 16),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),

          TimelineStrip(enableAnimations: enableAnimations, scrollController: scrollController),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseFontSize * 0.8; // Mobile - smaller
    } else if (screenWidth < 1024) {
      return baseFontSize * 0.9; // Tablet - slightly smaller
    }
    return baseFontSize; // Desktop - full size
  }
}
