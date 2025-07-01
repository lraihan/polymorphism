import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/lab/lab_controller.dart';
import 'package:polymorphism/shared/widgets/glass_demo_panel.dart';

/// Interactive liquid-glass effects laboratory
class LiquidGlassLab extends StatelessWidget {
  const LiquidGlassLab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabController());

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              Text('Liquid-Glass Lab', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Experiment with dynamic glass morphism effects and real-time parameter adjustments.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Demo panel
              Center(
                child: Obx(
                  () => GlassDemoPanel(blurSigma: controller.blurSigma.value, opacity: controller.opacity.value),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Controls section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Glass Parameters', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.lg),

                    // Low power mode switch
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Low Power Mode', style: Theme.of(context).textTheme.bodyLarge),
                          Switch(
                            value: controller.lowPower.value,
                            onChanged: (_) => controller.toggleLowPowerMode(),
                            activeColor: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Blur sigma slider
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Blur Sigma', style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                controller.blurSigma.value.toStringAsFixed(1),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Slider(
                            value: controller.blurSigma.value,
                            max: 40,
                            divisions: 80,
                            activeColor: AppColors.accent,
                            inactiveColor: AppColors.textPrimary.withValues(alpha: 0.2),
                            onChanged: controller.lowPower.value ? null : controller.updateBlurSigma,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Opacity slider
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Opacity', style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                '${(controller.opacity.value * 100).toStringAsFixed(0)}%',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Slider(
                            value: controller.opacity.value,
                            min: 0.2,
                            max: 0.95,
                            divisions: 75,
                            activeColor: AppColors.accent,
                            inactiveColor: AppColors.textPrimary.withValues(alpha: 0.2),
                            onChanged: controller.lowPower.value ? null : controller.updateOpacity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Reset button
                    Center(
                      child: ElevatedButton(
                        onPressed: controller.reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                        ),
                        child: const Text('Reset to Defaults'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Info section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.glassSurface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      "This lab demonstrates real-time glass morphism effects using Flutter's BackdropFilter. "
                      'Adjust blur sigma and opacity to see immediate changes. Low power mode optimizes '
                      'settings for better performance on constrained devices.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
