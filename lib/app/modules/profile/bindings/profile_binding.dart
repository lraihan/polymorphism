import 'package:get/get.dart';
import 'package:project_master_template/app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(ProfileController.new);
  }
}
