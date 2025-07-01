import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PlaygroundController extends GetxController {
  GetStorage? _storage;

  // Reactive counter
  final RxInt counter = 0.obs;

  // Window position
  final RxDouble windowX = 100.0.obs;
  final RxDouble windowY = 100.0.obs;

  // Window visibility
  final RxBool isWindowVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initStorage();
  }

  void _initStorage() {
    try {
      _storage = GetStorage();
      _loadPosition();
    } on Exception catch (e) {
      // Storage not available (e.g., in tests), use memory-only mode
      debugPrint('GetStorage not available: $e');
      _storage = null;
    }
  }

  // Counter methods
  void increment() => counter.value++;

  void decrement() => counter.value--;

  void reset() => counter.value = 0;

  // Window management
  void closeWindow() {
    isWindowVisible.value = false;
  }

  void openWindow() {
    isWindowVisible.value = true;
  }

  void updatePosition(double x, double y) {
    windowX.value = x;
    windowY.value = y;
    _savePosition();
  }

  // Persistence
  void _loadPosition() {
    if (_storage != null) {
      windowX.value = _storage!.read('playground_x') ?? 100.0;
      windowY.value = _storage!.read('playground_y') ?? 100.0;
    }
  }

  void _savePosition() {
    if (_storage != null) {
      _storage!.write('playground_x', windowX.value);
      _storage!.write('playground_y', windowY.value);
    }
  }

  // Code snippet for display
  String get codeSnippet => r'''
class PlaygroundController extends GetxController {
  final RxInt counter = 0.obs;
  
  void increment() => counter.value++;
  void decrement() => counter.value--;
  void reset() => counter.value = 0;
}

// In widget:
// Obx(() => Text('${controller.counter}'))
''';
}
