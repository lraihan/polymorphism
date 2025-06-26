import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';

extension AppNavigationExtension on GoRouter {
  // Home navigation
  void goToHome() => go(AppRoutes.home);

  // Auth navigation
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToForgotPassword() => go(AppRoutes.forgotPassword);

  // Profile navigation
  void goToProfile() => go(AppRoutes.profile);
  void goToProfileEdit() => go(AppRoutes.profileEdit);
  void goToProfileSettings() => go(AppRoutes.profileSettings);

  // Settings navigation
  void goToSettings() => go(AppRoutes.settings);
  void goToSettingsTheme() => go(AppRoutes.settingsTheme);
  void goToSettingsLanguage() => go(AppRoutes.settingsLanguage);
  void goToSettingsNotifications() => go(AppRoutes.settingsNotifications);
  void goToSettingsAbout() => go(AppRoutes.settingsAbout);

  // Feature navigation
  void goToSearch() => go(AppRoutes.search);
  void goToNotifications() => go(AppRoutes.notifications);
  void goToHelp() => go(AppRoutes.help);

  // Navigation with parameters
  void goToProfileWithId(String userId) {
    go('${AppRoutes.profile}?userId=$userId');
  }

  // Push navigation (keeps current route in stack)
  void pushToProfile() => push(AppRoutes.profile);
  void pushToSettings() => push(AppRoutes.settings);
  void pushToLogin() => push(AppRoutes.login);

  // Replace navigation (replaces current route)
  void replaceWithHome() => pushReplacement(AppRoutes.home);
  void replaceWithLogin() => pushReplacement(AppRoutes.login);
}

// Static navigation helper class
class AppNavigation {
  // Home navigation
  static void goToHome() => AppRouter.router.go(AppRoutes.home);

  // Auth navigation
  static void goToLogin() => AppRouter.router.go(AppRoutes.login);
  static void goToRegister() => AppRouter.router.go(AppRoutes.register);
  static void goToForgotPassword() => AppRouter.router.go(AppRoutes.forgotPassword);

  // Profile navigation
  static void goToProfile() => AppRouter.router.go(AppRoutes.profile);
  static void goToProfileEdit() => AppRouter.router.go(AppRoutes.profileEdit);
  static void goToProfileSettings() => AppRouter.router.go(AppRoutes.profileSettings);

  // Settings navigation
  static void goToSettings() => AppRouter.router.go(AppRoutes.settings);
  static void goToSettingsTheme() => AppRouter.router.go(AppRoutes.settingsTheme);
  static void goToSettingsLanguage() => AppRouter.router.go(AppRoutes.settingsLanguage);
  static void goToSettingsNotifications() => AppRouter.router.go(AppRoutes.settingsNotifications);
  static void goToSettingsAbout() => AppRouter.router.go(AppRoutes.settingsAbout);

  // Feature navigation
  static void goToSearch() => AppRouter.router.go(AppRoutes.search);
  static void goToNotifications() => AppRouter.router.go(AppRoutes.notifications);
  static void goToHelp() => AppRouter.router.go(AppRoutes.help);

  // Navigation with parameters
  static void goToProfileWithId(String userId) {
    AppRouter.router.go('${AppRoutes.profile}?userId=$userId');
  }

  // Push navigation (keeps current route in stack)
  static void pushToProfile() => AppRouter.router.push(AppRoutes.profile);
  static void pushToSettings() => AppRouter.router.push(AppRoutes.settings);
  static void pushToLogin() => AppRouter.router.push(AppRoutes.login);

  // Replace navigation (replaces current route)
  static void replaceWithHome() => AppRouter.router.pushReplacement(AppRoutes.home);
  static void replaceWithLogin() => AppRouter.router.pushReplacement(AppRoutes.login);

  // Utility methods
  static void goBack() => AppRouter.router.pop();
  static bool canGoBack() => AppRouter.router.canPop();

  // Navigation with custom path
  static void goToPath(String path) => AppRouter.router.go(path);
  static void pushPath(String path) => AppRouter.router.push(path);
}
