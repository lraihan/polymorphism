import 'package:get/get.dart';
import 'package:project_master_template/app/core/services/connectivity_service.dart';
import 'package:project_master_template/app/core/services/logger_service.dart';
import 'package:project_master_template/app/core/theme/theme_controller.dart';
import 'package:project_master_template/app/widgets/dialogs/app_dialogs.dart';

class HomeController extends GetxController {
  // Services
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  final LoggerService _logger = Get.find<LoggerService>();
  final ThemeController _themeController = Get.find<ThemeController>();

  // Observable variables
  final count = 0.obs;
  final isLoading = false.obs;
  final userName = 'Developer'.obs;

  // Getters
  bool get isConnected => _connectivityService.hasConnection;
  bool get isDarkMode => _themeController.isDarkMode;

  @override
  void onInit() {
    super.onInit();
    _logger.info('HomeController initialized');
    _initializeData();
  }

  @override
  void onReady() {
    super.onReady();
    _logger.info('HomeController ready');
  }

  @override
  void onClose() {
    _logger.info('HomeController disposed');
    super.onClose();
  }

  void _initializeData() {
    // Simulate loading data
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      _logger.info('Data loaded successfully');
    });
  }

  void increment() {
    count.value++;
    _logger.debug('Counter incremented to ${count.value}');

    AppSnackbar.success(title: 'Success!', message: 'Counter incremented to ${count.value}');
  }

  void decrement() {
    if (count.value > 0) {
      count.value--;
      _logger.debug('Counter decremented to ${count.value}');
    } else {
      AppSnackbar.warning(title: 'Warning', message: 'Counter cannot go below zero');
    }
  }

  Future<void> reset() async {
    final confirmed = await AppDialog.confirm(
      title: 'Reset Counter',
      message: 'Are you sure you want to reset the counter to zero?',
    );

    if (confirmed ?? false) {
      count.value = 0;
      _logger.info('Counter reset to zero');

      AppSnackbar.info(title: 'Reset', message: 'Counter has been reset to zero');
    }
  }

  void toggleTheme() {
    _themeController.toggleTheme();
    _logger.info('Theme toggled to ${isDarkMode ? 'light' : 'dark'} mode');
  }

  void checkConnectivity() {
    if (isConnected) {
      AppSnackbar.success(title: 'Connected', message: 'You are connected to the internet');
    } else {
      AppSnackbar.error(title: 'No Connection', message: 'Please check your internet connection');
    }
  }

  void simulateError() {
    _logger.error('Simulated error for testing');

    AppSnackbar.error(title: 'Error', message: 'This is a simulated error message');
  }

  Future<void> showLoadingDemo() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 3));

    isLoading.value = false;

    AppSnackbar.success(title: 'Complete', message: 'Loading demo completed!');
  }
}
