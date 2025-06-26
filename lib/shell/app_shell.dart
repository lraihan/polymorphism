import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polymorphism/core/router/app_router.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/widgets/preloader_orb.dart';
import 'package:polymorphism/shell/controllers/app_shell_controller.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppShellController());

    return MaterialApp(
      title: 'Polymorphism',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        if (!controller.isReady.value) {
          // Show preloader
          return const Scaffold(backgroundColor: AppColors.bgDark, body: Center(child: PreloaderOrb()));
        }

        // Show main app
        return const _MainApp();
      }),
    );
  }
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Polymorphism',
    theme: AppTheme.darkTheme,
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouter.instance,
  );
}
