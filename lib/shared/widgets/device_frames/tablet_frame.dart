import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';

/// A landscape tablet wrapping a screenshot — uniform dark bezel, rounded
/// screen, a tiny front-camera dot, and a soft device shadow tinted by [accent].
class TabletDeviceFrame extends StatelessWidget {
  const TabletDeviceFrame({
    required this.child,
    required this.accent,
    super.key,
    this.bezel = 14,
  });

  final Widget child;
  final Color accent;
  final double bezel;

  static const Color _body = Color(0xFF14141C);

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
        color: _body,
        borderRadius: BorderRadius.circular(Radii.xl),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 48, offset: const Offset(0, 24)),
          BoxShadow(color: accent.withValues(alpha: 0.12), blurRadius: 64, spreadRadius: -12),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(bezel, bezel, bezel, bezel),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.sm),
              child: ColoredBox(color: AppColors.inkBlack, child: child),
            ),
            // front camera, centered on the left bezel (landscape)
            Positioned(
              left: -bezel + 5,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2A2A38), width: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
