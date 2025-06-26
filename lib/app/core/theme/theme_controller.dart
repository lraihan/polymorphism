import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_master_template/app/data/service/storage_service.dart';

enum AppThemeMode { light, dark, system }

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final StorageService _storageService = Get.find<StorageService>();

  final Rx<AppThemeMode> _themeMode = AppThemeMode.system.obs;
  final RxBool _isDarkMode = false.obs;
  
  AppThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
    _updateDarkModeStatus();
  }

  void _updateDarkModeStatus() {
    _isDarkMode.value = Get.isDarkMode;
  }

  void _loadThemeMode() {
    final savedTheme = _storageService.getString('theme_mode');
    if (savedTheme != null) {
      _themeMode.value = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }
  }

  void changeThemeMode(AppThemeMode mode) {
    _themeMode.value = mode;
    _storageService.setString('theme_mode', mode.name);

    switch (mode) {
      case AppThemeMode.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case AppThemeMode.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
    
    // Update the observable dark mode status
    _updateDarkModeStatus();
  }

  void toggleTheme() {
    final currentMode = Get.isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    changeThemeMode(currentMode);
  }

  bool get isLightMode => !isDarkMode;
}
