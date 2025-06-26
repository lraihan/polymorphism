abstract class AppEnvironment {
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';
}

class Environment {
  static const String _environment = String.fromEnvironment('ENV', defaultValue: AppEnvironment.development);

  static String get environment => _environment;

  static bool get isDevelopment => _environment == AppEnvironment.development;
  static bool get isStaging => _environment == AppEnvironment.staging;
  static bool get isProduction => _environment == AppEnvironment.production;

  // API Base URLs
  static String get apiBaseUrl {
    switch (_environment) {
      case AppEnvironment.development:
        return 'https://api-dev.example.com';
      case AppEnvironment.staging:
        return 'https://api-staging.example.com';
      case AppEnvironment.production:
        return 'https://api.example.com';
      default:
        return 'https://api-dev.example.com';
    }
  }

  // WebSocket URLs
  static String get websocketUrl {
    switch (_environment) {
      case AppEnvironment.development:
        return 'wss://ws-dev.example.com';
      case AppEnvironment.staging:
        return 'wss://ws-staging.example.com';
      case AppEnvironment.production:
        return 'wss://ws.example.com';
      default:
        return 'wss://ws-dev.example.com';
    }
  }

  // Feature Flags
  static bool get enableLogging => isDevelopment || isStaging;
  static bool get enableDebugTools => isDevelopment;
  static bool get enableAnalytics => isStaging || isProduction;
  static bool get enableCrashReporting => isStaging || isProduction;

  // App Configuration
  static String get appName {
    switch (_environment) {
      case AppEnvironment.development:
        return 'App (Dev)';
      case AppEnvironment.staging:
        return 'App (Staging)';
      case AppEnvironment.production:
        return 'App';
      default:
        return 'App (Dev)';
    }
  }

  // Database Configuration
  static String get databaseName {
    switch (_environment) {
      case AppEnvironment.development:
        return 'app_dev.db';
      case AppEnvironment.staging:
        return 'app_staging.db';
      case AppEnvironment.production:
        return 'app.db';
      default:
        return 'app_dev.db';
    }
  }

  // Cache Configuration
  static Duration get cacheTimeout {
    switch (_environment) {
      case AppEnvironment.development:
        return const Duration(minutes: 5);
      case AppEnvironment.staging:
        return const Duration(minutes: 15);
      case AppEnvironment.production:
        return const Duration(hours: 1);
      default:
        return const Duration(minutes: 5);
    }
  }
}
