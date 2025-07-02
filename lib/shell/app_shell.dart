import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grain/grain.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/modules/home/pages/home_page.dart';
import 'package:polymorphism/shared/widgets/curtain_loader.dart';
import 'package:polymorphism/shell/controllers/app_shell_controller.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade and scale animations for home page
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Smooth, elegant fade
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic)));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onCurtainComplete() {
    final controller = Get.find<AppShellController>();
    controller.setReady();

    // Start fade-in animation after curtain completes
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppShellController());

    return MaterialApp(
      title: 'Raihan-Polymorphism',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bgDark, // Set dark background to match curtain loader
        body: Obx(() {
          return Stack(
            children: [
              // Main home page with fade-in and scale animation after curtain completes
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.isReady.value ? _fadeAnimation.value : 0.0,
                    child: Transform.scale(
                      scale: controller.isReady.value ? _scaleAnimation.value : 0.98,
                      child: const GrainFiltered(child: HomePage()),
                    ),
                  );
                },
              ),

              // Curtain loader overlay (only when not ready)
              if (!controller.isReady.value) CurtainLoader(onComplete: _onCurtainComplete),
            ],
          );
        }),
      ),
    );
  }
}
