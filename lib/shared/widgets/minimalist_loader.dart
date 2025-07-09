import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class MinimalistLoader extends StatefulWidget {
  const MinimalistLoader({required this.onComplete, super.key, this.message = 'Loading...'});

  final VoidCallback onComplete;
  final String message;

  @override
  State<MinimalistLoader> createState() => _MinimalistLoaderState();
}

class _MinimalistLoaderState extends State<MinimalistLoader> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _progressController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _progressController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));
  }

  Future<void> _startLoadingSequence() async {
    // Start fade in
    await _fadeController.forward();

    // Start progress animation
    await _progressController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: Listenable.merge([_fadeController, _progressController]),
      builder: (context, child) => Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.bgDark,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading text
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 24),

                // Progress indicator
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.textPrimary.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.accent.withValues(alpha: 0.3 + (_progressAnimation.value * 0.7)),
                    ),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
}
