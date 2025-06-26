// Example: How to use GoRouter navigation in the Flutter template

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/navigation/navigation_extensions.dart';

class NavigationUsageExamples {
  // METHOD 1: Direct GoRouter context methods (Recommended for local navigation)
  static void directGoRouterExamples(BuildContext context) {
    // Navigate to a route (replaces current route)
    context
      ..go(AppRoutes.home)
      ..go(AppRoutes.login)
      ..go(AppRoutes.profile)
      // Push a route (adds to navigation stack)
      ..push(AppRoutes.settings)
      ..push(AppRoutes.profileEdit)
      // Replace current route
      ..pushReplacement(AppRoutes.login)
      // Navigate back
      ..pop();

    // Check if can go back
    if (context.canPop()) {
      context.pop();
    }

    // Navigate with parameters
    context
      ..go('/profile?userId=123')
      ..pushNamed(AppRoutes.profileRouteName, extra: {'userId': '123'});
  }

  // METHOD 2: AppNavigation helper class (Recommended for global navigation)
  static void appNavigationExamples() {
    // Simple navigation methods
    AppNavigation.goToHome();
    AppNavigation.goToLogin();
    AppNavigation.goToRegister();
    AppNavigation.goToProfile();
    AppNavigation.goToSettings();

    // Push navigation (adds to stack)
    AppNavigation.pushToProfile();
    AppNavigation.pushToSettings();
    AppNavigation.pushToLogin();

    // Replace navigation
    AppNavigation.replaceWithHome();
    AppNavigation.replaceWithLogin();

    // Utility methods
    AppNavigation.goBack();
    if (AppNavigation.canGoBack()) {
      AppNavigation.goBack();
    }

    // Custom path navigation
    AppNavigation.goToPath('/custom/path');
    AppNavigation.pushPath('/another/path');

    // Navigation with parameters
    AppNavigation.goToProfileWithId('user123');
  }

  // METHOD 3: Router extension methods (Alternative approach)
  static void routerExtensionExamples() {
    // Access router instance
    // ignore: unused_local_variable
    final router =
        AppRouter.router
          // Use extension methods
          ..goToHome()
          ..goToLogin()
          ..goToProfile()
          ..pushToSettings()
          // Direct router methods
          ..go(AppRoutes.settings)
          ..push(AppRoutes.profile);
  }

  // PRACTICAL EXAMPLES: Real-world usage scenarios

  // Example 1: Login button handler
  static void handleLoginButtonPress(BuildContext context) {
    // Navigate to login page
    context.go(AppRoutes.login);
    // OR using helper
    AppNavigation.goToLogin();
  }

  // Example 2: After successful login
  static void handleSuccessfulLogin(BuildContext context) {
    // Replace login with home (user can't go back to login)
    context.pushReplacement(AppRoutes.home);
    // OR using helper
    AppNavigation.replaceWithHome();
  }

  // Example 3: Profile settings navigation
  static void navigateToProfileSettings(BuildContext context) {
    // Push settings so user can go back to profile
    context.push(AppRoutes.profileSettings);
  }

  // Example 4: Logout handling
  static void handleLogout(BuildContext context) {
    // Clear navigation stack and go to login
    context.go(AppRoutes.login);
  }

  // Example 5: Deep link handling
  static void handleDeepLink(String path, BuildContext context) {
    // Navigate to specific path from deep link
    context.go(path);
  }

  // Example 6: Conditional navigation
  static void conditionalNavigation(BuildContext context, {required bool isLoggedIn}) {
    if (isLoggedIn) {
      AppNavigation.goToHome();
    } else {
      AppNavigation.goToLogin();
    }
  }

  // Example 7: Navigation with error handling
  static void safeNavigation(BuildContext context, String route) {
    try {
      context.go(route);
    } on Exception {
      // Handle navigation error
      context.go(AppRoutes.home); // Fallback to home
    }
  }

  // Example 8: Form submission navigation
  static void handleFormSubmission(BuildContext context, {required bool isSuccess}) {
    if (isSuccess) {
      // Show success and navigate
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: AutoSizeText('Success!')));
      AppNavigation.goToHome();
    } else {
      // Show error but stay on current page
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: AutoSizeText('Error occurred')));
    }
  }

  // WIDGET EXAMPLES: How to use navigation in widgets

  // Example widget with navigation buttons
  static Widget buildNavigationWidget() => const Column(
    children: [
      ElevatedButton(onPressed: AppNavigation.goToLogin, child: AutoSizeText('Go to Login')),
      ElevatedButton(onPressed: AppNavigation.goToProfile, child: AutoSizeText('Go to Profile')),
      ElevatedButton(onPressed: AppNavigation.goToSettings, child: AutoSizeText('Go to Settings')),
    ],
  );

  // Example: Navigation in ListTile
  static Widget buildNavigationListTile(String title, String route) => ListTile(
    title: AutoSizeText(title),
    trailing: const Icon(Icons.arrow_forward),
    onTap: () => AppNavigation.goToPath(route),
  );

  // Example: Bottom navigation bar
  static Widget buildBottomNavigationBar(BuildContext context, int currentIndex) => BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) {
      switch (index) {
        case 0:
          context.go(AppRoutes.home);
          break;
        case 1:
          context.go(AppRoutes.profile);
          break;
        case 2:
          context.go(AppRoutes.settings);
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  );
}

// USAGE SUMMARY:
// 1. Use context.go() for simple navigation within widgets
// 2. Use AppNavigation.* for global navigation from anywhere
// 3. Use router.* extensions for advanced router manipulation
// 4. Always handle navigation errors in production
// 5. Use push() when user should be able to go back
// 6. Use go() when replacing current route
// 7. Use pushReplacement() for login flows
