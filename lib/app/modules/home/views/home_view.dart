import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/navigation/navigation_extensions.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';
import 'package:project_master_template/app/modules/home/controllers/home_controller.dart';
import 'package:project_master_template/app/widgets/widgets.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText('Project Master Template'),
        centerTitle: true,
        actions: [
          Obx(
            () => AppIconButton(
              icon: controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              onPressed: controller.toggleTheme,
              tooltip: 'Toggle theme',
            ),
          ),
          AppIconButton(icon: Icons.wifi, onPressed: controller.checkConnectivity, tooltip: 'Check connectivity'),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingState(message: 'Loading data...');
        }

        return AppLoadingOverlay(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: AppSpacing.m,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Card
                AppCard(
                  child: Column(
                    children: [
                      Icon(Icons.home, size: AppSizes.iconXL, color: theme.colorScheme.primary),
                      const SizedBox(height: AppSizes.paddingM),
                      AutoSizeText(
                        'Welcome to Project Master Template!',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.paddingS),
                      AutoSizeText(
                        'This is a comprehensive Flutter template with GetX state management, designed to accelerate your development process.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(179)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Counter Section
                AppCard(
                  child: Column(
                    children: [
                      AutoSizeText('Counter Demo', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSizes.paddingM),
                      Container(
                        padding: AppSpacing.l,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: AppBorderRadius.m,
                        ),
                        child: AutoSizeText(
                          '${controller.count.value}',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Decrement',
                              onPressed: controller.decrement,
                              isOutlined: true,
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: AppButton(
                              text: 'Increment',
                              onPressed: controller.increment,
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      AppButton(
                        text: 'Reset',
                        onPressed: controller.reset,
                        isExpanded: true,
                        backgroundColor: theme.colorScheme.error,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Features Demo
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText('Template Features', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSizes.paddingM),
                      const _FeatureTile(
                        icon: Icons.palette,
                        title: 'Theme Management',
                        subtitle: 'Light/Dark theme support with GetX',
                      ),
                      const _FeatureTile(
                        icon: Icons.architecture,
                        title: 'Clean Architecture',
                        subtitle: 'Organized folder structure with GetX pattern',
                      ),
                      const _FeatureTile(
                        icon: Icons.api,
                        title: 'API Integration',
                        subtitle: 'Dio HTTP client with interceptors',
                      ),
                      const _FeatureTile(
                        icon: Icons.storage,
                        title: 'Local Storage',
                        subtitle: 'SharedPreferences wrapper service',
                      ),
                      const _FeatureTile(
                        icon: Icons.wifi,
                        title: 'Connectivity',
                        subtitle: 'Network status monitoring',
                      ),
                      const _FeatureTile(
                        icon: Icons.bug_report,
                        title: 'Logging',
                        subtitle: 'Comprehensive logging system',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Action Buttons
                AppCard(
                  child: Column(
                    children: [
                      AutoSizeText('Demo Actions', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSizes.paddingM),
                      AppButton(
                        text: 'Show Loading Demo',
                        onPressed: controller.showLoadingDemo,
                        isExpanded: true,
                        icon: const Icon(Icons.hourglass_empty),
                      ),
                      const SizedBox(height: AppSizes.paddingS),
                      AppButton(
                        text: 'Simulate Error',
                        onPressed: controller.simulateError,
                        isExpanded: true,
                        isOutlined: true,
                        icon: const Icon(Icons.error_outline),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Navigation Demo
                AppCard(
                  child: Column(
                    children: [
                      AutoSizeText('Navigation Demo', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSizes.paddingM),
                      AutoSizeText(
                        'Test GoRouter declarative navigation',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Login',
                              onPressed: () => context.go(AppRoutes.login),
                              isOutlined: true,
                              icon: const Icon(Icons.login),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          const Expanded(
                            child: AppButton(
                              text: 'Register',
                              onPressed: AppNavigation.goToRegister,
                              isOutlined: true,
                              icon: Icon(Icons.person_add),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingS),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Profile',
                              onPressed: () => context.push(AppRoutes.profile),
                              isOutlined: true,
                              icon: const Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          const Expanded(
                            child: AppButton(
                              text: 'Settings',
                              onPressed: AppNavigation.pushToSettings,
                              isOutlined: true,
                              icon: Icon(Icons.settings),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingXL),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXS),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.s,
            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: AppBorderRadius.s),
            child: Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: AppSizes.iconM),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(title, style: theme.textTheme.titleMedium),
                AutoSizeText(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(153)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
