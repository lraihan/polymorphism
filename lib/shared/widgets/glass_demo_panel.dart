import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

/// Reusable glass demo panel widget that showcases glass morphism effects
class GlassDemoPanel extends StatelessWidget {
  const GlassDemoPanel({required this.blurSigma, required this.opacity, super.key});

  final double blurSigma;
  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
    width: 420,
    height: 240,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSpacing.md)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.glassSurface.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2)),
            boxShadow: [
              // Subtle shadow effect
              BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Demo content
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 2),
                  ),
                  child: const Icon(Icons.science, color: AppColors.accent, size: 40),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Glass Demo Panel',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Blur: ${blurSigma.toStringAsFixed(1)}px',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.7)),
                ),
                Text(
                  'Opacity: ${(opacity * 100).toStringAsFixed(0)}%',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
