abstract class AppRoutes {
  // Root routes
  static const String home = '/';
  static const String splash = '/splash';

  // Auth routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // Profile routes
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profileSettings = '/profile/settings';

  // Settings routes
  static const String settings = '/settings';
  static const String settingsTheme = '/settings/theme';
  static const String settingsLanguage = '/settings/language';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsAbout = '/settings/about';

  // Feature routes
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String help = '/help';

  // Error routes
  static const String notFound = '/404';
  static const String error = '/error';

  // Route names for easy reference
  static const String homeRouteName = 'home';
  static const String splashRouteName = 'splash';
  static const String loginRouteName = 'login';
  static const String registerRouteName = 'register';
  static const String forgotPasswordRouteName = 'forgotPassword';
  static const String profileRouteName = 'profile';
  static const String profileEditRouteName = 'profileEdit';
  static const String profileSettingsRouteName = 'profileSettings';
  static const String settingsRouteName = 'settings';
  static const String settingsThemeRouteName = 'settingsTheme';
  static const String settingsLanguageRouteName = 'settingsLanguage';
  static const String settingsNotificationsRouteName = 'settingsNotifications';
  static const String settingsAboutRouteName = 'settingsAbout';
  static const String searchRouteName = 'search';
  static const String notificationsRouteName = 'notifications';
  static const String helpRouteName = 'help';
  static const String notFoundRouteName = 'notFound';
  static const String errorRouteName = 'error';
}
