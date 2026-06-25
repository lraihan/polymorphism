import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/features/works/widgets/abstract_art_panel.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/device_frames/browser_frame.dart';
import 'package:polymorphism/shared/widgets/device_frames/tablet_frame.dart';
import 'package:polymorphism/shared/widgets/parallax_box.dart';
import 'package:polymorphism/shared/widgets/shimmer_placeholder.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The breathing media side of a spotlight card. Routes by [Project.media] and
/// floats the content over an ambient glow in the project's dominant color.
class MediaPanel extends StatelessWidget {
  const MediaPanel({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final content = switch (project.media) {
      ProjectMedia.framedGallery => _FramedGallery(project: project),
      ProjectMedia.mockupGallery => _MockupGallery(project: project),
      ProjectMedia.abstractArt => AbstractArtPanel(project: project),
    };

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.4, -0.6),
                  radius: 1.4,
                  colors: [project.dominantColor.withValues(alpha: 0.34), AppColors.inkBlack],
                ),
              ),
            ),
            Positioned(
              right: -60,
              bottom: -60,
              child: IgnorePointer(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [project.accentColor.withValues(alpha: 0.18), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.responsive(mobile: Spacing.lg, desktop: Spacing.xxl)),
              child: ParallaxBox(child: content),
            ),
          ],
        ),
      ),
    );
  }
}

/// Auto-advance + hover-pause + visibility-gating, shared by both galleries.
/// The concrete state owns and disposes [controller]; the mixin only manages
/// the timer that drives it.
mixin _CarouselController<T extends StatefulWidget> on State<T> {
  PageController get controller;
  int get itemCount;
  Duration get interval => const Duration(milliseconds: 4200);

  int page = 0;
  Timer? _timer;
  bool _hovered = false;
  bool _visible = false;
  bool _disposed = false;

  void _evaluateTimer() {
    // A late VisibilityDetector callback must not resurrect the timer.
    if (_disposed) {
      return;
    }
    final shouldRun = _visible && !_hovered && itemCount > 1;
    if (shouldRun && _timer == null) {
      _timer = Timer.periodic(interval, (_) => _advance());
    } else if (!shouldRun && _timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _advance() {
    if (!mounted || !controller.hasClients) {
      return;
    }
    final next = (page + 1) % itemCount;
    controller.animateToPage(next, duration: AppDurations.slow, curve: AppCurves.travel);
  }

  void onHover({required bool hovering}) {
    _hovered = hovering;
    _evaluateTimer();
  }

  void onVisible(VisibilityInfo info) {
    _visible = info.visibleFraction > 0.25;
    _evaluateTimer();
  }

  void goTo(int i) {
    controller.animateToPage(i.clamp(0, itemCount - 1), duration: AppDurations.normal, curve: AppCurves.travel);
  }

  void cancelTimer() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
  }
}

// ── Framed gallery (landscape screenshots in a device frame) ───────────────

class _FramedGallery extends StatefulWidget {
  const _FramedGallery({required this.project});

  final Project project;

  @override
  State<_FramedGallery> createState() => _FramedGalleryState();
}

class _FramedGalleryState extends State<_FramedGallery> with _CarouselController {
  @override
  final PageController controller = PageController();

  @override
  int get itemCount => widget.project.images.length;

  String get _url => switch (widget.project.id) {
        'profund-manager' => 'app.profundmanager.id',
        'fe-touch' => 'teller.collega.co.id',
        _ => '${widget.project.id}.app',
      };

  @override
  void dispose() {
    cancelTimer();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carousel = PageView.builder(
      controller: controller,
      onPageChanged: (i) => setState(() => page = i),
      itemCount: itemCount,
      itemBuilder: (context, i) => ProjectImage(path: widget.project.images[i], tint: widget.project.dominantColor),
    );

    final framed = switch (widget.project.frame) {
      ProjectFrame.browser => BrowserDeviceFrame(url: _url, accent: widget.project.accentColor, child: carousel),
      ProjectFrame.tablet => TabletDeviceFrame(accent: widget.project.accentColor, child: carousel),
      ProjectFrame.none => ClipRRect(borderRadius: BorderRadius.circular(Radii.md), child: carousel),
    };

    return VisibilityDetector(
      key: ValueKey('framed-${widget.project.id}'),
      onVisibilityChanged: onVisible,
      child: MouseRegion(
        onEnter: (_) => onHover(hovering: true),
        onExit: (_) => onHover(hovering: false),
        child: Column(
          children: [
            Expanded(child: Center(child: AspectRatio(aspectRatio: 16 / 10, child: framed))),
            const SizedBox(height: Spacing.lg),
            _GalleryDots(count: itemCount, active: page, accent: widget.project.accentColor, onTap: goTo),
          ],
        ),
      ),
    );
  }
}

// ── Mockup gallery (pre-framed phone mockups with depth) ───────────────────

class _MockupGallery extends StatefulWidget {
  const _MockupGallery({required this.project});

  final Project project;

  @override
  State<_MockupGallery> createState() => _MockupGalleryState();
}

class _MockupGalleryState extends State<_MockupGallery> with _CarouselController {
  // viewport < 1 so neighbouring phones peek in.
  @override
  final PageController controller = PageController(viewportFraction: 0.66);

  @override
  int get itemCount => widget.project.images.length;

  @override
  void dispose() {
    cancelTimer();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
      key: ValueKey('mockup-${widget.project.id}'),
      onVisibilityChanged: onVisible,
      child: MouseRegion(
        onEnter: (_) => onHover(hovering: true),
        onExit: (_) => onHover(hovering: false),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (i) => setState(() => page = i),
                itemCount: itemCount,
                itemBuilder: (context, i) => AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    // position is positions.single internally — guard for exactly one.
                    final pos = controller.positions.length == 1 ? controller.positions.single : null;
                    final current =
                        pos != null && pos.haveDimensions ? (controller.page ?? page.toDouble()) : page.toDouble();
                    final distance = (current - i).abs().clamp(0.0, 1.0);
                    // Dim via a clipped scrim (cheap draw) rather than Opacity (saveLayer per tick).
                    return Center(
                      child: Transform.scale(
                        scale: 1 - distance * 0.16,
                        child: _PhoneMockup(
                          path: widget.project.images[i],
                          tint: widget.project.dominantColor,
                          accent: widget.project.accentColor,
                          dim: distance * 0.42,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            _GalleryDots(count: itemCount, active: page, accent: widget.project.accentColor, onTap: goTo),
          ],
        ),
      ),
    );
}

/// A rendered phone mockup — the captured bezel already supplies the device
/// look, so we just clip its background corners and float it with a glow.
class _PhoneMockup extends StatelessWidget {
  const _PhoneMockup({required this.path, required this.tint, required this.accent, this.dim = 0});

  final String path;
  final Color tint;
  final Color accent;

  /// 0–1 darkening for peeking (non-active) phones, applied as a clipped scrim.
  final double dim;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 40, offset: const Offset(0, 22)),
            BoxShadow(color: accent.withValues(alpha: 0.18), blurRadius: 50, spreadRadius: -8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProjectImage(path: path, tint: tint, fit: BoxFit.contain, alignment: Alignment.center),
              if (dim > 0.01)
                Positioned.fill(
                  child: IgnorePointer(child: ColoredBox(color: Colors.black.withValues(alpha: dim))),
                ),
            ],
          ),
        ),
      ),
    );
}

// ── Page indicator ─────────────────────────────────────────────────────────

class _GalleryDots extends StatelessWidget {
  const _GalleryDots({required this.count, required this.active, required this.accent, required this.onTap});

  final int count;
  final int active;
  final Color accent;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) {
      return const SizedBox(height: 8);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          CursorTarget(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                curve: AppCurves.enter,
                margin: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                width: active == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active == i ? accent : AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(Radii.xs),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
