import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/features/contact/availability_badge.dart';
import 'package:polymorphism/features/hero/hero_portrait.dart';
import 'package:polymorphism/shared/painters/particle_painter.dart';
import 'package:polymorphism/shared/widgets/cta_button.dart';

/// Full-viewport hero. The masked-reveal portrait ([HeroPortrait]) fills the
/// stage; the statement typography wipes in line by line over its left scrim.
///
/// Entrance choreography (starts when [play] flips true, ~1.2 s total):
/// 100 ms badge → 200/400/600 ms line wipes → 800 ms subtitle →
/// 950 ms CTAs → 1100 ms scroll hint.
class HeroSection extends StatefulWidget {
  const HeroSection({
    required this.play,
    super.key,
    this.onViewWork,
    this.onContact,
  });

  /// Flips true once the intro has dissolved.
  final bool play;

  final VoidCallback? onViewWork;
  final VoidCallback? onContact;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _loop; // scroll hint + "ALIVE." dot pulse
  bool _started = false;

  /// Pointer in hero-local space, fed to the portrait's reveal mask. Driven by
  /// an ancestor MouseRegion (below) so the scroll-view/text layer can never
  /// occlude it — that was the "only reveals on the sides" bug.
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: AppDurations.dramatic,
    );
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.play) {
      // MediaQuery (reduced motion) is not readable from initState; defer one frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _start();
        }
      });
    }
  }

  @override
  void didUpdateWidget(HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      _start();
    }
  }

  void _start() {
    if (_started) {
      return;
    }
    _started = true;
    if (context.reducedMotion) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
      _loop.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _loop.dispose();
    _pointer.dispose();
    super.dispose();
  }

  /// Soft drop shadow keeping body text legible over the colour reveal.
  static const List<Shadow> _textShadow = [
    Shadow(color: AppColors.deepSpace, blurRadius: 12),
  ];

  /// Eased progress of an entrance beat between [start] and [end] ms
  /// (of the 1200 ms timeline).
  double _beat(double start, double end) => AppCurves.dramatic.transform(
    _entrance.value.subProgress(start / 1200, end / 1200),
  );

  @override
  Widget build(BuildContext context) {
    final gutter = context.pageGutter;
    // Keep the text on the left so the revealed face (centre-right) stays clear.
    final textMaxWidth = context.responsive<double>(
      mobile: double.infinity,
      tablet: 480,
      desktop: 600,
      wide: 680,
    );

    // Ancestor MouseRegion: fires for every position over the hero (children
    // never block an ancestor's hover), so the reveal mask always tracks.
    return MouseRegion(
      opaque: false,
      onHover: (event) => _pointer.value = event.localPosition,
      onExit: (_) => _pointer.value = null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HeroPortrait(pointer: _pointer),
          // Faint drifting motes over the portrait — keeps the deep-space
          // ambiance and ties the hero to the rest of the site. IgnorePointer so
          // hover still reaches the ancestor region.
          const Positioned.fill(
            child: IgnorePointer(
              child: Opacity(opacity: 0.5, child: ParticleField(count: 26)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: AnimatedBuilder(
                animation: _entrance,
                // Fill the viewport on normal screens, but scroll instead of
                // overflowing on short ones (e.g. 1024×600 landscape laptops):
                // ConstrainedBox pins the minimum to the viewport height so the
                // Spacers distribute, while IntrinsicHeight lets the column grow
                // past it when the content genuinely needs more room.
                builder:
                    (context, _) => LayoutBuilder(
                      builder:
                          (context, constraints) => SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: textMaxWidth,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: context.screenHeight * 0.12,
                                        ),
                                        // Status badge — slides in from the left.
                                        Opacity(
                                          opacity: _beat(100, 400),
                                          child: Transform.translate(
                                            offset: Offset(
                                              -(1 - _beat(100, 400)) * 24,
                                              0,
                                            ),
                                            child: const AvailabilityBadge(
                                              label: AppStrings.statusAvailable,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        _statement(context),
                                        SizedBox(
                                          height: context.responsive(
                                            mobile: Spacing.lg,
                                            desktop: Spacing.xl,
                                          ),
                                        ),
                                        // Subtitle fades up.
                                        Opacity(
                                          opacity: _beat(800, 1150),
                                          child: Transform.translate(
                                            offset: Offset(
                                              0,
                                              (1 - _beat(800, 1150)) * 16,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${AppStrings.role} · ${AppStrings.location}',
                                                  style: AppTypography.bodyL
                                                      .copyWith(
                                                        color:
                                                            AppColors
                                                                .textPrimary,
                                                        shadows: _textShadow,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  height: Spacing.xs,
                                                ),
                                                Text(
                                                  AppStrings.heroSubtitle,
                                                  style: AppTypography.bodyM
                                                      .copyWith(
                                                        shadows: _textShadow,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: context.responsive(
                                            mobile: Spacing.lg,
                                            desktop: Spacing.xl,
                                          ),
                                        ),
                                        // CTAs slide up.
                                        Opacity(
                                          opacity: _beat(950, 1200),
                                          child: Transform.translate(
                                            offset: Offset(
                                              0,
                                              (1 - _beat(950, 1200)) * 24,
                                            ),
                                            child: Wrap(
                                              spacing: Spacing.lg,
                                              runSpacing: Spacing.md,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                CtaButton.primary(
                                                  label: AppStrings.ctaViewWork,
                                                  icon:
                                                      LucideIcons
                                                          .arrowDownRight,
                                                  onTap:
                                                      () =>
                                                          widget.onViewWork
                                                              ?.call(),
                                                ),
                                                CtaButton.ghost(
                                                  label: AppStrings.ctaContact,
                                                  icon:
                                                      LucideIcons.arrowUpRight,
                                                  onTap:
                                                      () =>
                                                          widget.onContact
                                                              ?.call(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.lg),
                                        // Reveal hint — invites the masked interaction.
                                        Opacity(
                                          opacity: _beat(1100, 1200),
                                          child: const HeroRevealHint(),
                                        ),
                                        const Spacer(),
                                        // (scroll hint lives below, centered)
                                        const SizedBox(height: Spacing.xxl),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
              ),
            ),
          ),
          // Scroll hint — centered across the full hero width.
          Positioned(
            left: 0,
            right: 0,
            bottom: Spacing.lg,
            child: SafeArea(
              top: false,
              child: AnimatedBuilder(
                animation: _entrance,
                builder:
                    (context, _) => Center(
                      child: Opacity(
                        opacity: _beat(1100, 1200),
                        child: _ScrollHint(loop: _loop),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The kinetic statement — each line wipes in from the left.
  Widget _statement(BuildContext context) {
    final size = context.responsive<double>(
      mobile: 52,
      tablet: TypographyTokens.displayXL,
      desktop: TypographyTokens.heroDisplay,
      wide: 108,
    );
    final style = AppTypography.heroDisplay.copyWith(
      fontSize: size,
      letterSpacing: size * TypographyTokens.trackedTight,
      // Keep the headline legible if the colour reveal drifts behind it.
      shadows: [
        Shadow(
          color: AppColors.deepSpace.withValues(alpha: 0.55),
          blurRadius: 18,
        ),
      ],
    );
    // One staggered wipe per line — derived from the line count so the copy
    // can change without an index-out-of-range crash.
    final count = AppStrings.heroLines.length;
    final beats = [
      for (var i = 0; i < count; i++) _beat(200 + i * 200, 700 + i * 200),
    ];

    return Semantics(
      header: true,
      label: AppStrings.heroLines.join(' '),
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < AppStrings.heroLines.length; i++)
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: beats[i].clamp(0.001, 1.0),
                    child:
                        i == AppStrings.heroLines.length - 1
                            ? _lastLineWithPulsingDot(style)
                            : Text(AppStrings.heroLines[i], style: style),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// `ALIVE.` — the period pulses with the accent color.
  ///
  /// Performance: the [Shadow] is held constant (animating the `shadows`
  /// list lands in TextStyle's *layout* comparison branch, which would force
  /// a full paragraph re-shape inside the [FittedBox] every frame). Only the
  /// period's `color` is lerped — a paint-only change — and the whole builder
  /// is isolated in a [RepaintBoundary] so its 60 fps repaint never escapes
  /// into the page layer.
  Widget _lastLineWithPulsingDot(TextStyle style) {
    final line = AppStrings.heroLines.last;
    final word = line.endsWith('.') ? line.substring(0, line.length - 1) : line;
    const dotShadow = [Shadow(color: AppColors.accentGlow, blurRadius: 24)];
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _loop,
        builder:
            (context, _) => Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: word, style: style),
                  TextSpan(
                    text: '.',
                    style: style.copyWith(
                      color: Color.lerp(
                        AppColors.accentPrimary,
                        AppColors.textPrimary,
                        _loop.value,
                      ),
                      shadows: dotShadow,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.loop});

  final AnimationController loop;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: loop,
    builder:
        (context, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.scrollHint, style: AppTypography.mono),
            const SizedBox(height: Spacing.sm),
            Container(
              width: 1.5,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accentPrimary.withValues(
                      alpha: 0.7 - loop.value * 0.4,
                    ),
                    AppColors.accentPrimary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
  );
}
