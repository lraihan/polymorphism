import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class PreloaderOrb extends StatelessWidget {
  const PreloaderOrb({super.key, this.enableAnimation = true});

  final bool enableAnimation;

  @override
  Widget build(BuildContext context) {
    final orbWidget = Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.moonGlow.withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 8)],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.moonGlow.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 48, color: AppColors.moonGlow.withValues(alpha: 0.8)),
                  const SizedBox(height: 8),
                  Text(
                    'Polymorphism',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.moonGlow.withValues(alpha: 0.6), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (!enableAnimation) {
      return Center(child: orbWidget);
    }

    return Center(
      child: orbWidget
          .animate(onPlay: (controller) => controller.repeat())
          .scale(begin: const Offset(1, 1), end: const Offset(0.9, 0.9), duration: 900.ms, curve: Curves.easeInOut)
          .then()
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 900.ms, curve: Curves.easeInOut),
    );
  }
}
