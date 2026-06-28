import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';

/// A project-tinted shimmer shown while an asset decodes — an animated diagonal
/// sweep, so loading reads as intentional rather than broken.
class ShimmerPlaceholder extends StatefulWidget {
  const ShimmerPlaceholder({required this.tint, super.key});

  final Color tint;

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.dramatic)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - t), -1),
              end: Alignment(1 + 2 * t, 1),
              colors: [
                widget.tint.withValues(alpha: 0.05),
                widget.tint.withValues(alpha: 0.13),
                widget.tint.withValues(alpha: 0.05),
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
          child: const SizedBox.expand(),
        );
      },
    );
}

/// An asset image that fades in over a [ShimmerPlaceholder] once decoded.
class ProjectImage extends StatelessWidget {
  const ProjectImage({
    required this.path,
    required this.tint,
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
    this.cacheWidth,
  });

  final String path;
  final Color tint;
  final BoxFit fit;
  final Alignment alignment;

  /// Decode the asset at this pixel width to cap decode RAM — use only for
  /// thumbnails. Leave null for full-resolution viewers.
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) => Image.asset(
      path,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSync) {
        if (wasSync) {
          return child;
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            if (frame == null) ShimmerPlaceholder(tint: tint),
            AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: AppDurations.slow,
              curve: AppCurves.enter,
              child: child,
            ),
          ],
        );
      },
      errorBuilder: (context, error, stack) => ColoredBox(
        color: AppColors.surfaceMuted,
        child: Center(
          child: Icon(Icons.broken_image_outlined, color: tint.withValues(alpha: 0.4), size: 32),
        ),
      ),
    );
}
