import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/playground/playground_controller.dart';

class PlaygroundShell extends StatelessWidget {
  const PlaygroundShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlaygroundController());

    return Scaffold(
      body: Stack(
        children: [
          // Main page content (can be empty or show other content)
          const Center(child: Text('GetX Playground', style: TextStyle(fontSize: 24, color: AppColors.textPrimary))),

          // Draggable window
          Obx(() => controller.isWindowVisible.value ? _buildDraggableWindow(controller) : const SizedBox.shrink()),
        ],
      ),

      // FAB for reopening window
      floatingActionButton: Obx(
        () =>
            !controller.isWindowVisible.value
                ? FloatingActionButton.extended(
                  onPressed: controller.openWindow,
                  backgroundColor: AppColors.accent,
                  label: const Text('Playground', style: TextStyle(color: AppColors.textPrimary)),
                  icon: const Icon(Icons.code, color: AppColors.textPrimary),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDraggableWindow(PlaygroundController controller) => Obx(
      () => Positioned(
        left: controller.windowX.value,
        top: controller.windowY.value,
        child: _buildAnimatedWindow(controller),
      ),
    );

  Widget _buildAnimatedWindow(PlaygroundController controller) => TweenAnimationBuilder<double>(
      duration: AppMotion.medium,
      tween: Tween(begin: 0.9, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: _buildWindow(controller),
    );

  Widget _buildWindow(PlaygroundController controller) => GestureDetector(
      onPanUpdate: (details) {
        controller.updatePosition(
          controller.windowX.value + details.delta.dx,
          controller.windowY.value + details.delta.dy,
        );
      },
      child: Container(
        width: 360,
        height: 480,
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(children: [_buildTitleBar(controller), Expanded(child: _buildContent(controller))]),
          ),
        ),
      ),
    );

  Widget _buildTitleBar(PlaygroundController controller) => Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.glassSurface.withValues(alpha: .5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.md),
          topRight: Radius.circular(AppSpacing.md),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.code, color: AppColors.textPrimary, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Builder(
            builder:
                (context) => Text(
                  'GetX Playground',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: controller.closeWindow,
            icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            splashRadius: 12,
            tooltip: 'Close',
          ),
        ],
      ),
    );

  Widget _buildContent(PlaygroundController controller) => Column(
      children: [
        // Counter demo pane
        Expanded(child: _buildCounterDemo(controller)),

        // Divider
        Container(height: 1, color: AppColors.glassSurface),

        // Code snippet pane
        Expanded(child: _buildCodeSnippet(controller)),
      ],
    );

  Widget _buildCounterDemo(PlaygroundController controller) => Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder:
                (context) => Text(
                  'Reactive Counter',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Counter display
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.glassSurface,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Builder(
                builder:
                    (context) => Text(
                      '${controller.counter.value}',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(icon: Icons.remove, onPressed: controller.decrement, tooltip: 'Decrement'),
              _buildControlButton(icon: Icons.refresh, onPressed: controller.reset, tooltip: 'Reset'),
              _buildControlButton(icon: Icons.add, onPressed: controller.increment, tooltip: 'Increment'),
            ],
          ),
        ],
      ),
    );

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed, required String tooltip}) => DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.textPrimary),
        tooltip: tooltip,
        splashRadius: 20,
      ),
    );

  Widget _buildCodeSnippet(PlaygroundController controller) => Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder:
                (context) => Text(
                  'Controller Code',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
          ),
          const SizedBox(height: AppSpacing.md),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.glassSurface.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(color: AppColors.glassSurface),
              ),
              child: SingleChildScrollView(
                child: Builder(
                  builder:
                      (context) => SelectableText(
                        controller.codeSnippet,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: .8),
                          fontFamily: 'monospace',
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
