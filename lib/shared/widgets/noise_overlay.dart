import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Film-grain noise overlay at ~3 % opacity.
///
/// A 96×96 monochrome noise tile is generated once at startup and tiled
/// across the screen — one texture upload, zero per-frame cost. Sits above
/// all content inside an [IgnorePointer].
class NoiseOverlay extends StatefulWidget {
  const NoiseOverlay({super.key, this.opacity = 0.03});

  final double opacity;

  @override
  State<NoiseOverlay> createState() => _NoiseOverlayState();
}

class _NoiseOverlayState extends State<NoiseOverlay> {
  static ui.Image? _tile; // shared across instances; generated once per session

  @override
  void initState() {
    super.initState();
    if (_tile == null) {
      _generateTile();
    }
  }

  void _generateTile() {
    const side = 96;
    final rng = math.Random(7);
    final pixels = Uint8List(side * side * 4);
    for (var i = 0; i < side * side; i++) {
      final v = rng.nextInt(256);
      pixels[i * 4] = v;
      pixels[i * 4 + 1] = v;
      pixels[i * 4 + 2] = v;
      pixels[i * 4 + 3] = 255;
    }
    ui.decodeImageFromPixels(pixels, side, side, ui.PixelFormat.rgba8888, (image) {
      if (mounted) {
        setState(() => _tile = image);
      } else {
        _tile = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tile = _tile;
    if (tile == null) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: RepaintBoundary(
        child: Opacity(
          opacity: widget.opacity,
          child: CustomPaint(painter: _NoisePainter(tile), size: Size.infinite),
        ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  const _NoisePainter(this.tile);

  final ui.Image tile;

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: tile,
      repeat: ImageRepeat.repeat,
      filterQuality: FilterQuality.none,
      fit: BoxFit.none,
    );
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) => oldDelegate.tile != tile;
}
