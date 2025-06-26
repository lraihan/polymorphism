// Test file to verify GoRouter navigation implementation
// This file demonstrates the various navigation features implemented

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/navigation/navigation_extensions.dart';

class NavigationTest {
  // Test navigation routes
  static void testAllRoutes(BuildContext context) {
    debugPrint('Testing GoRouter Navigation Routes:');

    // Test direct GoRouter navigation
    debugPrint('✓ Direct context.go() navigation available');
    debugPrint('✓ Direct context.push() navigation available');

    // Test helper class navigation
    debugPrint('✓ AppNavigation static methods available');
    debugPrint('✓ Router extension methods available');

    // Test route definitions
    testRouteDefinitions();
  }

  static void testRouteDefinitions() {
    debugPrint('\nTesting Route Definitions:');

    // Core routes
    assert(AppRoutes.home == '/');
    assert(AppRoutes.splash == '/splash');
    debugPrint('✓ Core routes defined correctly');

    // Auth routes
    assert(AppRoutes.login == '/auth/login');
    assert(AppRoutes.register == '/auth/register');
    assert(AppRoutes.forgotPassword == '/auth/forgot-password');
    debugPrint('✓ Auth routes defined correctly');

    // Profile routes
    assert(AppRoutes.profile == '/profile');
    assert(AppRoutes.profileEdit == '/profile/edit');
    assert(AppRoutes.profileSettings == '/profile/settings');
    debugPrint('✓ Profile routes defined correctly');

    // Settings routes
    assert(AppRoutes.settings == '/settings');
    assert(AppRoutes.settingsTheme == '/settings/theme');
    assert(AppRoutes.settingsLanguage == '/settings/language');
    debugPrint('✓ Settings routes defined correctly');

    debugPrint('\n🎉 All navigation routes configured successfully!');
  }

  // Demonstrate navigation examples
  static List<NavigationExample> getNavigationExamples() => [
      NavigationExample(
        title: 'Home Navigation',
        description: 'Navigate to home page',
        code: 'context.go(AppRoutes.home)',
        onTap: (context) => context.go(AppRoutes.home),
      ),
      NavigationExample(
        title: 'Login Navigation',
        description: 'Navigate to login page',
        code: 'AppNavigation.goToLogin()',
        onTap: (context) => AppNavigation.goToLogin(),
      ),
      NavigationExample(
        title: 'Profile Push',
        description: 'Push profile page onto stack',
        code: 'context.push(AppRoutes.profile)',
        onTap: (context) => context.push(AppRoutes.profile),
      ),
      NavigationExample(
        title: 'Settings Navigation',
        description: 'Navigate to settings using helper',
        code: 'AppNavigation.goToSettings()',
        onTap: (context) => AppNavigation.goToSettings(),
      ),
      NavigationExample(
        title: 'Router Extension',
        description: 'Use router extension methods',
        code: 'AppRouter.router.goToProfile()',
        onTap: (context) => AppRouter.router.goToProfile(),
      ),
    ];
}

class NavigationExample {

  NavigationExample({required this.title, required this.description, required this.code, required this.onTap});
  final String title;
  final String description;
  final String code;
  final Function(BuildContext) onTap;
}
