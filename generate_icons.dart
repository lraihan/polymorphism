import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Script to generate custom code-themed icons for web
/// Run this to create new favicon and app icons with Icons.code theme
class IconGenerator {
  static Future<void> generateCodeIcons() async {
    // Generate different sizes
    await _generateIcon(32, 'favicon');
    await _generateIcon(192, 'Icon-192');
    await _generateIcon(512, 'Icon-512');
    await _generateIcon(192, 'Icon-maskable-192', maskable: true);
    await _generateIcon(512, 'Icon-maskable-512', maskable: true);
  }

  static Future<void> _generateIcon(int size, String filename, {bool maskable = false}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()

    // Background
    ..color = const Color(0xFF1A1A1A); // Dark background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), paint);

    if (maskable) {
      // Add safe area padding for maskable icons
      final padding = size * 0.1;
      _drawCodeIcon(canvas, size.toDouble(), padding);
    } else {
      _drawCodeIcon(canvas, size.toDouble(), 0);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final file = File('web/icons/$filename.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      debugPrint('Generated: $filename.png');
    }
  }

  static void _drawCodeIcon(Canvas canvas, double size, double padding) {
    final paint = Paint();
    final strokeWidth = size * 0.08;

    // Code brackets and symbols
    paint..color = const Color(0xFF64FFDA) // Accent color (cyan)
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round;

    final iconSize = size - (padding * 2);
    final left = padding + iconSize * 0.2;
    final right = padding + iconSize * 0.8;
    final top = padding + iconSize * 0.3;
    final bottom = padding + iconSize * 0.7;
    final center = padding + iconSize * 0.5;

    // Left bracket '<'
    final leftPath = Path()
    ..moveTo(left + strokeWidth, top)
    ..lineTo(left, center)
    ..lineTo(left + strokeWidth, bottom);
    canvas.drawPath(leftPath, paint);

    // Right bracket '>'
    final rightPath = Path()
    ..moveTo(right - strokeWidth, top)
    ..lineTo(right, center)
    ..lineTo(right - strokeWidth, bottom);
    canvas.drawPath(rightPath, paint);

    // Slash in the middle '/'
    final slashPath = Path()
    ..moveTo(center - strokeWidth, bottom)
    ..lineTo(center + strokeWidth, top);
    canvas.drawPath(slashPath, paint);
  }
}

void main() async {
  await IconGenerator.generateCodeIcons();
  debugPrint('Code-themed icons generated successfully!');
}
