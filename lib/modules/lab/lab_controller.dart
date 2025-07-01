import 'package:get/get.dart';

/// Controller for managing liquid-glass lab parameters and states
class LabController extends GetxController {
  // Reactive parameters for glass effects
  RxDouble blurSigma = 14.0.obs;
  RxDouble opacity = 0.75.obs;
  RxBool lowPower = false.obs;

  // Default values
  static const double defaultBlurSigma = 14;
  static const double defaultOpacity = 0.75;
  static const bool defaultLowPower = false;

  // Low power mode values
  static const double lowPowerBlurSigma = 4;
  static const double lowPowerOpacity = 0.85;

  /// Initialize controller with default values
  @override
  void onInit() {
    super.onInit();

    // Listen to low power mode changes
    ever(lowPower, (isLowPower) {
      if (isLowPower) {
        blurSigma.value = lowPowerBlurSigma;
        opacity.value = lowPowerOpacity;
      }
    });
  }

  /// Reset all parameters to default values
  void reset() {
    lowPower.value = defaultLowPower;
    blurSigma.value = defaultBlurSigma;
    opacity.value = defaultOpacity;
  }

  /// Update blur sigma value
  void updateBlurSigma(double value) {
    if (!lowPower.value) {
      blurSigma.value = value;
    }
  }

  /// Update opacity value
  void updateOpacity(double value) {
    if (!lowPower.value) {
      opacity.value = value;
    }
  }

  /// Toggle low power mode
  void toggleLowPowerMode() {
    lowPower.value = !lowPower.value;
  }
}
