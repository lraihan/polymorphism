import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class AssetLoadingScreen extends StatefulWidget {
  const AssetLoadingScreen({super.key});

  @override
  State<AssetLoadingScreen> createState() => _AssetLoadingScreenState();
}

class _AssetLoadingScreenState extends State<AssetLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bgDark,
    body: Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading text
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'Loading Assets...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.8),
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Minimalist progress indicator
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.textPrimary.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent.withValues(alpha: _fadeAnimation.value)),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
      ),
    ),
  );
}
