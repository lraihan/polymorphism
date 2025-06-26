import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
    Widget? icon,
    VoidCallback? onTap,
  }) {
    final context = Get.context;
    if (context == null) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    IconData defaultIcon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        defaultIcon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        defaultIcon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        defaultIcon = Icons.warning;
        break;
      case SnackbarType.info:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        defaultIcon = Icons.info;
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: AppSpacing.m,
      borderRadius: AppSizes.radiusS,
      icon: icon ?? Icon(defaultIcon, color: textColor),
      onTap: onTap != null ? (_) => onTap() : null,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static void success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(title: title, message: message, type: SnackbarType.success, duration: duration);
  }

  static void error({required String title, required String message, Duration duration = const Duration(seconds: 4)}) {
    show(title: title, message: message, type: SnackbarType.error, duration: duration);
  }

  static void warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(title: title, message: message, type: SnackbarType.warning, duration: duration);
  }

  static void info({required String title, required String message, Duration duration = const Duration(seconds: 3)}) {
    show(title: title, message: message, duration: duration);
  }
}

class AppBottomSheet {
  static Future<T?> show<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    final context = Get.context;
    if (context == null) return Future.value();

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape:
          shape ??
          const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL))),
      builder: (context) => child,
    );
  }
}

class AppDialog {
  static Future<T?> show<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    final context = Get.context;
    if (context == null) return Future.value();

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (context) => child,
    );
  }

  static Future<bool?> confirm({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    bool isDanger = false,
  }) {
    final context = Get.context;
    if (context == null) return Future.value();

    final theme = Theme.of(context);

    return show<bool>(
      child: AlertDialog(
        title: AutoSizeText(title),
        content: AutoSizeText(message),
        shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.m),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: AutoSizeText(cancelText)),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
            child: AutoSizeText(confirmText),
          ),
        ],
      ),
    );
  }
}
