import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_master_template/app/core/services/logger_service.dart';
import 'package:project_master_template/app/core/theme/theme_controller.dart';
import 'package:project_master_template/app/data/service/storage_service.dart';
import 'package:project_master_template/app/widgets/dialogs/app_dialogs.dart';

enum AppLanguage { english, spanish, french, german, chinese }

class SettingsController extends GetxController {
  // Services
  final LoggerService _logger = Get.find<LoggerService>();
  final StorageService _storage = Get.find<StorageService>();
  final ThemeController _themeController = Get.find<ThemeController>();

  // Observable variables
  final isLoading = false.obs;

  // Notification settings
  final pushNotificationsEnabled = true.obs;
  final emailNotificationsEnabled = false.obs;
  final smsNotificationsEnabled = false.obs;
  final newsNotificationsEnabled = true.obs;
  final marketingNotificationsEnabled = false.obs;

  // Privacy settings
  final profileVisibility = true.obs;
  final activityTracking = true.obs;
  final dataCollection = false.obs;
  final locationServices = true.obs;
  final biometricAuth = false.obs;

  // App preferences
  final selectedLanguage = AppLanguage.english.obs;
  final autoSave = true.obs;
  final offlineMode = false.obs;
  final debugMode = false.obs;

  // Cache and storage
  final cacheSize = '0 MB'.obs;
  final storageUsed = '0 MB'.obs;

  @override
  void onInit() {
    super.onInit();
    _logger.info('SettingsController initialized');
    _loadSettings();
  }

  @override
  void onReady() {
    super.onReady();
    _logger.info('SettingsController ready');
  }

  @override
  void onClose() {
    _logger.info('SettingsController disposed');
    super.onClose();
  }

  // Load settings from storage
  Future<void> _loadSettings() async {
    try {
      isLoading.value = true;

      // Load notification settings
      pushNotificationsEnabled.value = _storage.getBool('push_notifications') ?? true;
      emailNotificationsEnabled.value = _storage.getBool('email_notifications') ?? false;
      smsNotificationsEnabled.value = _storage.getBool('sms_notifications') ?? false;
      newsNotificationsEnabled.value = _storage.getBool('news_notifications') ?? true;
      marketingNotificationsEnabled.value = _storage.getBool('marketing_notifications') ?? false;

      // Load privacy settings
      profileVisibility.value = _storage.getBool('profile_visibility') ?? true;
      activityTracking.value = _storage.getBool('activity_tracking') ?? true;
      dataCollection.value = _storage.getBool('data_collection') ?? false;
      locationServices.value = _storage.getBool('location_services') ?? true;
      biometricAuth.value = _storage.getBool('biometric_auth') ?? false;

      // Load app preferences
      final languageName = _storage.getString('app_language') ?? 'english';
      selectedLanguage.value = AppLanguage.values.firstWhere(
        (lang) => lang.name == languageName,
        orElse: () => AppLanguage.english,
      );

      autoSave.value = _storage.getBool('auto_save') ?? true;
      offlineMode.value = _storage.getBool('offline_mode') ?? false;
      debugMode.value = _storage.getBool('debug_mode') ?? false;

      // Calculate cache and storage usage
      await _calculateStorageUsage();

      _logger.info('Settings loaded successfully');
    } on Exception catch (error) {
      _logger.error('Failed to load settings: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate storage usage
  Future<void> _calculateStorageUsage() async {
    try {
      // Simulate storage calculation
      await Future.delayed(const Duration(milliseconds: 500));

      cacheSize.value = '24.5 MB';
      storageUsed.value = '156.2 MB';
    } on Exception catch (error) {
      _logger.error('Failed to calculate storage usage: $error');
    }
  }

  // Notification settings
  Future<void> togglePushNotifications({required bool value}) async {
    pushNotificationsEnabled.value = value;
    await _storage.setBool('push_notifications', value: value);
    _logger.info('Push notifications toggled: $value');

    if (value) {
      // Request permission for push notifications
      AppSnackbar.info(title: 'Notifications Enabled', message: 'You will receive push notifications.');
    }
  }

  Future<void> toggleEmailNotifications({required bool value}) async {
    emailNotificationsEnabled.value = value;
    await _storage.setBool('email_notifications', value: value);
    _logger.info('Email notifications toggled: $value');
  }

  Future<void> toggleSmsNotifications({required bool value}) async {
    smsNotificationsEnabled.value = value;
    await _storage.setBool('sms_notifications', value: value);
    _logger.info('SMS notifications toggled: $value');
  }

  Future<void> toggleNewsNotifications({required bool value}) async {
    newsNotificationsEnabled.value = value;
    await _storage.setBool('news_notifications', value: value);
    _logger.info('News notifications toggled: $value');
  }

  Future<void> toggleMarketingNotifications({required bool value}) async {
    marketingNotificationsEnabled.value = value;
    await _storage.setBool('marketing_notifications', value: value);
    _logger.info('Marketing notifications toggled: $value');
  }

  // Privacy settings
  Future<void> toggleProfileVisibility({required bool value}) async {
    profileVisibility.value = value;
    await _storage.setBool('profile_visibility', value: value);
    _logger.info('Profile visibility toggled: $value');
  }

  Future<void> toggleActivityTracking({required bool value}) async {
    activityTracking.value = value;
    await _storage.setBool('activity_tracking', value: value);
    _logger.info('Activity tracking toggled: $value');
  }

  Future<void> toggleDataCollection({required bool value}) async {
    dataCollection.value = value;
    await _storage.setBool('data_collection', value: value);
    _logger.info('Data collection toggled: $value');
  }

  Future<void> toggleLocationServices({required bool value}) async {
    locationServices.value = value;
    await _storage.setBool('location_services', value: value);
    _logger.info('Location services toggled: $value');
  }

  Future<void> toggleBiometricAuth({required bool value}) async {
    try {
      if (value) {
        // Simulate biometric availability check
        final isAvailable = await _checkBiometricAvailability();
        if (!isAvailable) {
          AppSnackbar.warning(
            title: 'Biometric Unavailable',
            message: 'Biometric authentication is not available on this device.',
          );
          return;
        }
      }

      biometricAuth.value = value;
      await _storage.setBool('biometric_auth', value: value);
      _logger.info('Biometric auth toggled: $value');

      AppSnackbar.success(
        title: value ? 'Biometric Enabled' : 'Biometric Disabled',
        message: value ? 'Biometric authentication has been enabled.' : 'Biometric authentication has been disabled.',
      );
    } on Exception catch (error) {
      _logger.error('Failed to toggle biometric auth: $error');
    }
  }

  // App preferences
  Future<void> changeLanguage(AppLanguage language) async {
    selectedLanguage.value = language;
    await _storage.setString('app_language', language.name);
    _logger.info('Language changed to: ${language.name}');

    // Update app locale
    final locale = _getLocaleForLanguage(language);
    await Get.updateLocale(locale);

    AppSnackbar.success(title: 'Language Changed', message: 'App language has been updated.');
  }

  Future<void> toggleAutoSave({required bool value}) async {
    autoSave.value = value;
    await _storage.setBool('auto_save', value: value);
    _logger.info('Auto save toggled: $value');
  }

  Future<void> toggleOfflineMode({required bool value}) async {
    offlineMode.value = value;
    await _storage.setBool('offline_mode', value: value);
    _logger.info('Offline mode toggled: $value');
  }

  Future<void> toggleDebugMode({required bool value}) async {
    debugMode.value = value;
    await _storage.setBool('debug_mode', value: value);
    _logger.info('Debug mode toggled: $value');
  }

  // Cache and data management
  Future<void> clearCache() async {
    try {
      final confirmed = await AppDialog.confirm(
        title: 'Clear Cache',
        message: 'Are you sure you want to clear the app cache?',
      );

      if (confirmed != true) return;

      isLoading.value = true;

      // Simulate cache clearing
      await Future.delayed(const Duration(seconds: 2));

      cacheSize.value = '0 MB';

      _logger.info('Cache cleared successfully');

      AppSnackbar.success(title: 'Cache Cleared', message: 'App cache has been cleared successfully.');
    } on Exception catch (error) {
      _logger.error('Failed to clear cache: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to clear cache.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportData() async {
    try {
      isLoading.value = true;

      // Simulate data export
      await Future.delayed(const Duration(seconds: 3));

      _logger.info('Data exported successfully');

      AppSnackbar.success(title: 'Export Complete', message: 'Your data has been exported successfully.');
    } on Exception catch (error) {
      _logger.error('Failed to export data: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to export data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetSettings() async {
    try {
      final confirmed = await AppDialog.confirm(
        title: 'Reset Settings',
        message: 'Are you sure you want to reset all settings to default?',
        isDanger: true,
      );

      if (confirmed != true) return;

      isLoading.value = true;

      // Clear all settings from storage
      await _storage.remove('push_notifications');
      await _storage.remove('email_notifications');
      await _storage.remove('sms_notifications');
      await _storage.remove('news_notifications');
      await _storage.remove('marketing_notifications');
      await _storage.remove('profile_visibility');
      await _storage.remove('activity_tracking');
      await _storage.remove('data_collection');
      await _storage.remove('location_services');
      await _storage.remove('biometric_auth');
      await _storage.remove('app_language');
      await _storage.remove('auto_save');
      await _storage.remove('offline_mode');
      await _storage.remove('debug_mode');

      // Reload settings
      await _loadSettings();

      _logger.info('Settings reset successfully');

      AppSnackbar.success(title: 'Settings Reset', message: 'All settings have been reset to default.');
    } on Exception catch (error) {
      _logger.error('Failed to reset settings: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to reset settings.');
    } finally {
      isLoading.value = false;
    }
  }

  // Theme methods (delegating to ThemeController)
  void toggleTheme() => _themeController.toggleTheme();
  bool get isDarkMode => _themeController.isDarkMode;

  // Helper methods
  Future<bool> _checkBiometricAvailability() async {
    // Simulate biometric check
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Assume available for demo
  }

  Locale _getLocaleForLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.spanish:
        return const Locale('es', 'ES');
      case AppLanguage.french:
        return const Locale('fr', 'FR');
      case AppLanguage.german:
        return const Locale('de', 'DE');
      case AppLanguage.chinese:
        return const Locale('zh', 'CN');
    }
  }

  String getLanguageDisplayName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.german:
        return 'Deutsch';
      case AppLanguage.chinese:
        return '中文';
    }
  }
}
