//Layouter
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Layouter extends StatelessWidget {
  const Layouter({super.key, this.height, this.width, this.child});
  final double? height;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      Container(decoration: BoxDecoration(border: Border.all()), width: width, height: height, child: child);
}

// Utility class for common app functions
class AppUtils {
  AppUtils._();

  // Hide keyboard
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Show loading dialog
  static void showLoading({String? message}) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[const SizedBox(height: 16), AutoSizeText(message)],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Show success snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Show error snackbar
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Show warning snackbar
  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Show info snackbar
  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Haptic feedback
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  // Confirmation dialog
  static Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: AutoSizeText(title),
        content: AutoSizeText(message),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: AutoSizeText(cancelText)),
          TextButton(onPressed: () => Get.back(result: true), child: AutoSizeText(confirmText)),
        ],
      ),
    );
    return result ?? false;
  }

  // Format numbers
  static String formatNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Validate email
  static bool isValidEmail(String email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  // Validate phone
  static bool isValidPhone(String phone) => RegExp(r'^\+?[\d\s-()]{10,}$').hasMatch(phone);

  // Check if dark mode
  static bool isDarkMode() => Get.isDarkMode;

  // Get app version
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
