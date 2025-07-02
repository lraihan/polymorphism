import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing the keyhole hero mask reveal animation
class HeroMaskController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _maskAnimation;
  late Animation<double> _opacityAnimation;

  Timer? _autoRevealTimer;

  /// Whether the mask is currently visible
  final RxBool isMaskVisible = true.obs;

  /// Whether the animation is currently playing
  final RxBool isAnimating = false.obs;

  /// Animation progress (0.0 to 1.0)
  final RxDouble animationProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _scheduleAutoReveal();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    // Keyhole scale animation - starts small and expands to reveal content
    _maskAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutExpo, // Dramatic curve matching karim-saab.com style
      ),
    );

    // Opacity animation for the black overlay
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1, curve: Curves.easeOut), // Fade out in final 30%
      ),
    );

    // Listen to animation changes
    _animationController.addListener(() {
      animationProgress.value = _animationController.value;
    });

    _animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          isAnimating.value = true;
          break;
        case AnimationStatus.completed:
          isAnimating.value = false;
          isMaskVisible.value = false;
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.reverse:
          isAnimating.value = false;
          break;
      }
    });
  }

  void _scheduleAutoReveal() {
    // Auto-reveal after 2.5 seconds as fallback for accessibility
    _autoRevealTimer = Timer(const Duration(milliseconds: 2500), () {
      if (isMaskVisible.value) {
        startRevealAnimation();
      }
    });
  }

  /// Start the keyhole reveal animation
  void startRevealAnimation() {
    if (!_animationController.isAnimating) {
      _autoRevealTimer?.cancel();
      _animationController.forward();
    }
  }

  /// Skip the mask immediately (accessibility feature)
  void skipMask() {
    _autoRevealTimer?.cancel();
    _animationController.stop();
    _animationController.value = 1.0;
    isMaskVisible.value = false;
    isAnimating.value = false;
  }

  /// Reset the mask to initial state
  void resetMask() {
    _autoRevealTimer?.cancel();
    _animationController.reset();
    isMaskVisible.value = true;
    isAnimating.value = false;
    _scheduleAutoReveal();
  }

  /// Get the current mask scale value
  double get maskScale => _maskAnimation.value;

  /// Get the current overlay opacity
  double get overlayOpacity => _opacityAnimation.value;

  /// Get the animation controller for external access
  AnimationController get animationController => _animationController;

  @override
  void onClose() {
    _autoRevealTimer?.cancel();
    _animationController.dispose();
    super.onClose();
  }
}
