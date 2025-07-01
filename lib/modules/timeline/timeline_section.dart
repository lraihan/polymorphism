import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/timeline/timeline_strip.dart';

/// Timeline section for the home page
class TimelineSection extends StatelessWidget {

  const TimelineSection({super.key, this.enableAnimations = true});
  final bool enableAnimations;

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xxl),
      color: AppColors.bgDark,
      child: Column(
        children: [
          // Section header
          Semantics(
            header: true,
            child: Text(
              'Career Timeline',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Section subtitle
          Text(
            'A journey through professional milestones and growth',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Timeline strip
          TimelineStrip(enableAnimations: enableAnimations),

          const SizedBox(height: AppSpacing.xl),

          // Additional info
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Scroll through the timeline to explore different career milestones. Each position contributed to expertise in Flutter development and technical leadership.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
