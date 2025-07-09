import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class ElegantLoader extends StatefulWidget {
  const ElegantLoader({required this.onComplete, super.key, this.message = 'Loading...'});

  final VoidCallback onComplete;
  final String message;

  @override
  State<ElegantLoader> createState() => _ElegantLoaderState();
}

class _ElegantLoaderState extends State<ElegantLoader> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _logoController;
  late AnimationController _progressController;
  late AnimationController _exitController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _exitOpacityAnimation;
  late Animation<double> _exitScaleAnimation;

  double _progress = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _logoController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    _progressController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _exitController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _logoOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.6, curve: Curves.easeOut)));

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));

    _exitOpacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeInOut));

    _exitScaleAnimation = Tween<double>(
      begin: 1,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeInOut));
  }

  Future<void> _startLoadingSequence() async {
    await _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    await _progressController.forward();

    _progressController.addListener(() {
      if (mounted) {
        setState(() {
          _progress = _progressAnimation.value;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 2200));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      await _exitController.forward();
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
    _progressController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: Listenable.merge([_fadeController, _logoController, _progressController, _exitController]),
      builder: (context, child) => Opacity(
          opacity: _exitOpacityAnimation.value,
          child: Transform.scale(
            scale: _exitScaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.bgDark, AppColors.bgDark.withValues(alpha: 0.98), AppColors.bgDark],
                ),
              ),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Opacity(opacity: _logoOpacityAnimation.value, child: _buildLogo()),
                    ),

                    const SizedBox(height: 32),

                    _buildLoadingIndicator(),

                    const SizedBox(height: 24),

                    Text(
                      _isLoading ? widget.message : 'Ready',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
    );

  Widget _buildLogo() => Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent.withValues(alpha: 0.8), AppColors.accent],
        ),
        boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2)],
      ),
      child: const Icon(Icons.code, color: Colors.white, size: 36),
    );

  Widget _buildLoadingIndicator() => Container(
      width: 200,
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 200 * _progress,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.accent.withValues(alpha: 0.8), AppColors.accent]),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)],
          ),
        ),
      ),
    );
}
