import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetPreloader {
  factory AssetPreloader() => _instance;
  AssetPreloader._internal();
  static final AssetPreloader _instance = AssetPreloader._internal();

  bool _isPreloaded = false;

  bool get isPreloaded => _isPreloaded;

  static const List<String> _imageAssets = [
    'assets/images/avatar.png',
    'assets/images/logo.png',
    'assets/images/workBg.png',
    'assets/images/Foreground.jpg',
    'assets/images/Background.jpg',
    'assets/images/fragment1.png',
    'assets/images/fragment2.png',
    'assets/images/fragment3.png',
    'assets/images/fragment4.png',
    'assets/images/fragment5.png',
    'assets/images/fragment6.png',
    'assets/images/complete.png',
    'assets/images/paper.png',
    'assets/images/works/project1-1.png',
    'assets/images/works/project1-2.png',
    'assets/images/works/project1-3.png',
    'assets/images/works/project2-1.png',
    'assets/images/works/project2-2.png',
    'assets/images/works/project2-3.png',
    'assets/images/works/project3-1.png',
    'assets/images/works/project3-2.png',
    'assets/images/works/project3-3.png',
    'assets/images/works/project4-1.png',
    'assets/images/works/project4-2.png',
    'assets/images/works/project4-3.png',
    'assets/images/works/project5-1.png',
    'assets/images/works/project5-2.png',
    'assets/images/works/project5-3.png',
    'assets/images/works/project6-1.png',
    'assets/images/works/project6-2.png',
    'assets/images/works/project6-3.png',
  ];

  Future<void> preloadAssets() async {
    if (_isPreloaded) {
      return;
    }

    try {
      final preloadTasks = <Future>[];

      for (final imagePath in _imageAssets) {
        preloadTasks.add(_preloadImage(imagePath));
      }

      await Future.wait(preloadTasks);

      _isPreloaded = true;
    } on Exception catch (e) {
      debugPrint('Asset preloading failed: $e');
      _isPreloaded = true;
    }
  }

  Future<void> _preloadImage(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      if (data.lengthInBytes > 0) {
        debugPrint('Preloaded image: $assetPath');
      }
    } on Exception catch (e) {
      debugPrint('Failed to preload image $assetPath: $e');
    }
  }

  void reset() {
    _isPreloaded = false;
  }
}
