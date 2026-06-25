import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';

/// A browser window wrapping a landscape screenshot — chrome bar with traffic
/// lights, an accent-favicon address pill, and a soft-shadowed body.
///
/// The screenshot fills the content area top-aligned, as a real page would.
class BrowserDeviceFrame extends StatelessWidget {
  const BrowserDeviceFrame({
    required this.child,
    required this.url,
    required this.accent,
    super.key,
    this.barHeight = 36,
  });

  final Widget child;
  final String url;
  final Color accent;
  final double barHeight;

  // Traffic-light colors are a browser metaphor, not part of the brand palette.
  static const Color _bodyChrome = Color(0xFF15151F);
  static const Color _addressBar = Color(0xFF0C0C14);
  static const List<Color> _lights = [Color(0xFFFF5F57), Color(0xFFFEBC2E), Color(0xFF28C840)];

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 48, offset: const Offset(0, 24)),
          BoxShadow(color: accent.withValues(alpha: 0.10), blurRadius: 60, spreadRadius: -10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.md),
        child: Column(
          children: [
            // ── chrome bar ──
            Container(
              height: barHeight,
              color: _bodyChrome,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                children: [
                  for (final c in _lights) ...[
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                    const SizedBox(width: 7),
                  ],
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                      decoration: BoxDecoration(
                        color: _addressBar,
                        borderRadius: BorderRadius.circular(Radii.pill),
                      ),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
                          const SizedBox(width: Spacing.sm),
                          Flexible(
                            child: Text(
                              url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.mono.copyWith(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  // trailing control hints
                  for (var i = 0; i < 3; i++) ...[
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle),
                    ),
                    if (i < 2) const SizedBox(width: 3),
                  ],
                ],
              ),
            ),
            // ── page content ──
            Expanded(
              child: ColoredBox(
                color: AppColors.inkBlack,
                child: ClipRect(child: child),
              ),
            ),
          ],
        ),
      ),
    );
}
