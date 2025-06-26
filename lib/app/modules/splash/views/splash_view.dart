import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToHome();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.8, curve: Curves.elasticOut)));

    _animationController.forward();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder:
              (context, child) => FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary,
                          borderRadius: AppBorderRadius.xl,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Icon(Icons.flutter_dash, size: AppSizes.iconXXL, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      AutoSizeText(
                        'Project Master Template',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.paddingS),
                      AutoSizeText(
                        'Flutter + GetX + GoRouter',
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary.withAlpha(204)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.paddingXL),
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          backgroundColor: theme.colorScheme.onPrimary.withAlpha(77),
                          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
