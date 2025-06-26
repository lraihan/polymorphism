import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final RxBool isConnected = true.obs;
  final Rx<ConnectivityResult> connectionType = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _startListening();
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception {
      result = [ConnectivityResult.none];
    }

    _updateConnectionStatus(result);
  }

  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    connectionType.value = result;
    isConnected.value = result != ConnectivityResult.none;

    // Only show snackbars if GetX context is available
    if (Get.context != null) {
      if (isConnected.value) {
        _showConnectedSnackbar();
      } else {
        _showDisconnectedSnackbar();
      }
    }
  }

  void _showConnectedSnackbar() {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      'Connected',
      'Internet connection restored',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary.withAlpha(25),
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  void _showDisconnectedSnackbar() {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      'No Connection',
      'Please check your internet connection',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      backgroundColor: Get.theme.colorScheme.error.withAlpha(25),
      colorText: Get.theme.colorScheme.onError,
      isDismissible: false,
    );
  }

  bool get hasConnection => isConnected.value;

  bool get isWifi => connectionType.value == ConnectivityResult.wifi;

  bool get isMobile => connectionType.value == ConnectivityResult.mobile;

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
