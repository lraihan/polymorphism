import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';

/// Overlays [revealChild] on top of [child], clipped to the hero's keyhole
/// reveal circle — the same circle HeroPortrait uses (centered on the cursor,
/// radius ≈ 0.22·min(viewport)). Use it to swap light content for a dark copy
/// exactly where the bright reveal sits behind it, so text stays legible.
///
/// Desktop hover only; on touch / no-pointer it's just [child].
class KeyholeReveal extends StatelessWidget {
  const KeyholeReveal({required this.child, required this.revealChild, super.key});

  /// Default content (e.g. light text).
  final Widget child;

  /// Same content in the reveal color (e.g. black text) — must match [child]'s
  /// layout so the overlay registers pixel-for-pixel.
  final Widget revealChild;

  @override
  Widget build(BuildContext context) {
    if (!context.supportsHover) {
      return child;
    }
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: ValueListenableBuilder<bool>(
              valueListenable: CursorController.visible,
              builder: (context, visible, _) {
                if (!visible) {
                  return const SizedBox.shrink();
                }
                return ValueListenableBuilder<Offset>(
                  valueListenable: CursorController.position,
                  builder: (context, cursor, _) => _KeyholeClip(cursor: cursor, child: revealChild),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _KeyholeClip extends StatelessWidget {
  const _KeyholeClip({required this.cursor, required this.child});

  final Offset cursor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) {
      // Before first layout — nothing to clip yet; aligns on the next frame.
      return const SizedBox.shrink();
    }
    final media = MediaQuery.sizeOf(context);
    final radius = math.min(media.width, media.height) * 0.22;
    return ClipPath(
      clipper: _CircleClipper(box.globalToLocal(cursor), radius),
      child: child,
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  const _CircleClipper(this.center, this.radius);

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) => Path()..addOval(Rect.fromCircle(center: center, radius: radius));

  @override
  bool shouldReclip(covariant _CircleClipper old) => old.center != center || old.radius != radius;
}
