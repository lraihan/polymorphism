import 'package:get/get.dart';
import 'package:project_master_template/app/core/theme/theme_controller.dart';
import 'package:project_master_template/app/modules/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Register ThemeController if not already registered
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }

    Get.lazyPut<SettingsController>(SettingsController.new);
  }
}
