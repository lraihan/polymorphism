import 'package:get/get.dart';

class AppShellController extends GetxController {
  final RxBool isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startPreloader();
  }

  void _startPreloader() {
    // Show preloader for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      isReady.value = true;
    });
  }
}
