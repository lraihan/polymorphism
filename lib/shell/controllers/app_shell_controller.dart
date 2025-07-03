import 'package:get/get.dart';

class AppShellController extends GetxController {
  final RxBool isReady = false.obs;


  void setReady() {
    isReady.value = true;
  }
}
