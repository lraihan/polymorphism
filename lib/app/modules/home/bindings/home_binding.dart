import 'package:get/get.dart';
import 'package:project_master_template/app/core/theme/theme_controller.dart';

import 'package:project_master_template/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register ThemeController if not already registered
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }

    Get.lazyPut<HomeController>(HomeController.new);
  }
}
