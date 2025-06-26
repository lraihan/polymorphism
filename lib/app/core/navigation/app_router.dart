import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/services/logger_service.dart';
import 'package:project_master_template/app/modules/auth/views/login_view.dart';
import 'package:project_master_template/app/modules/auth/views/register_view.dart';
import 'package:project_master_template/app/modules/home/bindings/home_binding.dart';
import 'package:project_master_template/app/modules/home/views/home_view.dart';
import 'package:project_master_template/app/modules/profile/bindings/profile_binding.dart';
import 'package:project_master_template/app/modules/profile/views/profile_view.dart';
import 'package:project_master_template/app/modules/settings/bindings/settings_binding.dart';
import 'package:project_master_template/app/modules/settings/views/settings_view.dart';
import 'package:project_master_template/app/modules/splash/views/splash_view.dart';
import 'package:project_master_template/app/widgets/states/app_states.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    observers: [AppNavigationObserver()],
    errorBuilder:
        (context, state) => ErrorState(
          title: 'Page Not Found',
          description: 'The page you are looking for does not exist.',
          onRetry: () => context.go(AppRoutes.home),
        ),
    routes: [
      // Splash Route
      GoRoute(path: AppRoutes.splash, name: AppRoutes.splashRouteName, builder: (context, state) => const SplashView()),

      // Home Route
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeRouteName,
        builder: (context, state) {
          // Initialize binding when navigating to home
          if (!Get.isRegistered<HomeBinding>()) {
            HomeBinding().dependencies();
          }
          return const HomeView();
        },
      ),

      // Auth Routes
      GoRoute(path: AppRoutes.login, name: AppRoutes.loginRouteName, builder: (context, state) => const LoginView()),

      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerRouteName,
        builder: (context, state) => const RegisterView(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPasswordRouteName,
        builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Forgot Password View'))),
      ),

      // Profile Routes
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileRouteName,
        builder: (context, state) {
          // Initialize binding when navigating to profile
          if (!Get.isRegistered<ProfileBinding>()) {
            ProfileBinding().dependencies();
          }
          return const ProfileView();
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: AppRoutes.profileEditRouteName,
            builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Profile Edit View'))),
          ),
          GoRoute(
            path: 'settings',
            name: AppRoutes.profileSettingsRouteName,
            builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Profile Settings View'))),
          ),
        ],
      ),

      // Settings Routes
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsRouteName,
        builder: (context, state) {
          // Initialize binding when navigating to settings
          if (!Get.isRegistered<SettingsBinding>()) {
            SettingsBinding().dependencies();
          }
          return const SettingsView();
        },
        routes: [
          GoRoute(
            path: 'theme',
            name: AppRoutes.settingsThemeRouteName,
            builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Theme Settings View'))),
          ),
          GoRoute(
            path: 'language',
            name: AppRoutes.settingsLanguageRouteName,
            builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Language Settings View'))),
          ),
          GoRoute(
            path: 'notifications',
            name: AppRoutes.settingsNotificationsRouteName,
            builder:
                (context, state) => const Scaffold(body: Center(child: AutoSizeText('Notification Settings View'))),
          ),
          GoRoute(
            path: 'about',
            name: AppRoutes.settingsAboutRouteName,
            builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('About View'))),
          ),
        ],
      ),

      // Feature Routes
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.searchRouteName,
        builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Search View'))),
      ),

      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notificationsRouteName,
        builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Notifications View'))),
      ),

      GoRoute(
        path: AppRoutes.help,
        name: AppRoutes.helpRouteName,
        builder: (context, state) => const Scaffold(body: Center(child: AutoSizeText('Help View'))),
      ),
    ],
  );

  static GoRouter get router => _router;
}

// Navigation observer for logging and analytics
class AppNavigationObserver extends NavigatorObserver {
  final LoggerService _logger = Get.find<LoggerService>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logger.info('Navigation: Pushed ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logger.info('Navigation: Popped ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logger.info('Navigation: Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }
}
