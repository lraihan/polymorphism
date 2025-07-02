import 'package:get/get.dart';

class AppShellController extends GetxController {
  final RxBool isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-start preloader, let curtain loader control timing
  }

  void setReady() {
    isReady.value = true;
  }
}
