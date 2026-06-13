import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/shared/painters/glow_painter.dart';
import 'package:polymorphism/shared/widgets/constellation_field.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Cinematic interlude — a poetic verse: "(A promise,) made of pixels,
/// blossoms in the dart."
///
/// Layered craft: giant pull-quote marks frame the verse; a soft glow sits
/// behind it; the words illuminate word-by-word as you scroll; and the accent
/// line is filled with the teal→violet gradient and glows. Scroll progress
/// flows through a [ValueNotifier], so only the words repaint.
class StatementSection extends StatefulWidget {
  const StatementSection({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<StatementSection> createState() => _StatementSectionState();
}

class _Line {
  const _Line(
    this.text, {
    required this.alignment,
    required this.size,
    this.accent = false,
    this.spacing = -2,
  });

  final String text;
  final Alignment alignment;
  final double size;
  final bool accent;
  final double spacing;
}

class _StatementSectionState extends State<StatementSection> {
  final ValueNotifier<double> _progress = ValueNotifier(0);
  // Cursor in section-local space, fed to the constellation. Driven by an
  // ancestor MouseRegion so the verse layer can't occlude it.
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);
  bool _visible = true;

  static const List<_Line> _lines = [
    _Line(
      '(A promise,)',
      alignment: Alignment.centerLeft,
      size: 44,
      spacing: -1,
    ),
    _Line(
      'made of pixels,',
      alignment: Alignment.centerRight,
      size: 124,
      accent: true,
      spacing: -4,
    ),
    _Line(
      'blossoms in',
      alignment: Alignment.centerLeft,
      size: 104,
      spacing: 10,
    ),
    _Line('the dart.', alignment: Alignment.center, size: 140, spacing: -5),
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _progress.dispose();
    _pointer.dispose();
    super.dispose();
  }

  double _lastPixels = double.negativeInfinity;

  void _onScroll() {
    if (!mounted || !widget.scrollController.hasClients) {
      return;
    }
    // Skip the render-object walk when the scroll has barely moved (Lenis fires
    // many sub-pixel momentum ticks).
    final pixels = widget.scrollController.position.pixels;
    if ((pixels - _lastPixels).abs() < 3) {
      return;
    }
    _lastPixels = pixels;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) {
      return;
    }
    final viewport = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    final travel = box.size.height + viewport * 0.4;
    final travelled = (viewport * 0.85 - top).clamp(0.0, travel);
    final next = (travelled / travel).clamp(0.0, 1.0);
    if ((next - _progress.value).abs() > 0.002) {
      _progress.value = next;
    }
  }

  int get _totalWords =>
      _lines.fold(0, (sum, l) => sum + l.text.split(' ').length);

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight * (context.isMobile ? 1.0 : 1.6);
    final gutter = context.pageGutter;
    final quoteSize = context.responsive<double>(
      mobile: 160,
      tablet: 240,
      desktop: 300,
      wide: 340,
    );

    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.deepSpace,
      // Ancestor MouseRegion: feeds the cursor to the constellation regardless
      // of the verse layered above it.
      child: MouseRegion(
        opaque: false,
        onHover: (e) => _pointer.value = e.localPosition,
        onExit: (_) => _pointer.value = null,
        child: Stack(
          children: [
            // Living constellation behind the verse, following the cursor.
            // Visibility-gated so its ticker pauses when the section is offscreen.
            Positioned.fill(
              child: VisibilityDetector(
                key: const Key('statement-constellation'),
                onVisibilityChanged: (info) {
                  final v = info.visibleFraction > 0.02;
                  if (v != _visible && mounted) {
                    setState(() => _visible = v);
                  }
                },
                child: TickerMode(
                  enabled: _visible,
                  child: ConstellationField(pointer: _pointer),
                ),
              ),
            ),
            // Soft glow behind the verse — biased toward the accent line.
            const GlowOrb(
              color: AppColors.accentSubtle,
              center: Alignment(0.15, -0.1),
              radiusFactor: 0.5,
            ),
            // Pull-quote marks framing the verse.
            Positioned(
              top: -quoteSize * 0.18,
              left: gutter * 0.5,
              child: _QuoteMark('“', quoteSize),
            ),
            Positioned(
              bottom: -quoteSize * 0.42,
              right: gutter * 0.5,
              child: _QuoteMark('”', quoteSize),
            ),
            // The verse, distributed across the tall section.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: _verse(context),
            ),
            // Closing mark.
            Positioned(
              bottom: gutter,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 1,
                      color: AppColors.borderActive,
                    ),
                    const SizedBox(width: Spacing.md),
                    Text('WRITTEN IN DART', style: AppTypography.mono),
                    const SizedBox(width: Spacing.md),
                    Container(
                      width: 28,
                      height: 1,
                      color: AppColors.borderActive,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verse(BuildContext context) {
    var wordOffset = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final line in _lines)
          Builder(
            builder: (context) {
              final start = wordOffset;
              wordOffset += line.text.split(' ').length;
              return _buildLine(context, line, start);
            },
          ),
      ],
    );
  }

  Widget _buildLine(BuildContext context, _Line line, int wordStart) {
    final scale = context.responsive<double>(
      mobile: 0.4,
      tablet: 0.62,
      desktop: 0.85,
      wide: 1,
    );
    final words = line.text.split(' ');
    final reduceMotion = context.reducedMotion;
    final total = _totalWords;

    return Container(
      width: double.infinity,
      alignment: line.alignment,
      child: ValueListenableBuilder<double>(
        valueListenable: _progress,
        builder:
            (context, progress, _) => Wrap(
              alignment:
                  line.alignment == Alignment.centerLeft
                      ? WrapAlignment.start
                      : line.alignment == Alignment.centerRight
                      ? WrapAlignment.end
                      : WrapAlignment.center,
              children: [
                for (var i = 0; i < words.length; i++)
                  _word(
                    words[i],
                    shown:
                        reduceMotion
                            ? 1.0
                            : AppCurves.enter.transform(
                              progress.subProgress(
                                (wordStart + i) / total,
                                (wordStart + i + 1) / total,
                              ),
                            ),
                    size: line.size * scale,
                    spacing: line.spacing * scale,
                    accent: line.accent,
                    trailing: i != words.length - 1,
                    gap: line.size * scale * 0.2,
                  ),
              ],
            ),
      ),
    );
  }

  Widget _word(
    String word, {
    required double shown,
    required double size,
    required double spacing,
    required bool accent,
    required bool trailing,
    required double gap,
  }) {
    final style = AppTypography.heroDisplay.copyWith(
      fontSize: size,
      letterSpacing: spacing,
      height: 0.95,
      color: accent ? AppColors.accentPrimary : AppColors.textPrimary,
      shadows: [
        Shadow(
          color: (accent ? AppColors.accentPrimary : AppColors.deepSpace)
              .withValues(alpha: accent ? 0.45 : 0.6),
          blurRadius: accent ? 32 : 14,
        ),
      ],
    );

    Widget text = Text(word, style: style);
    // Fill the accent words with the teal→violet gradient.
    if (accent) {
      text = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback:
            (bounds) => const LinearGradient(
              colors: [AppColors.accentPrimary, AppColors.accentSecondary],
            ).createShader(Offset.zero & bounds.size),
        child: text,
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: trailing ? gap : 0),
      child: Transform.translate(
        offset: Offset(0, (1 - shown) * 24),
        child: Opacity(opacity: shown, child: text),
      ),
    );
  }
}

/// A giant, faint pull-quote glyph.
class _QuoteMark extends StatelessWidget {
  const _QuoteMark(this.glyph, this.size);

  final String glyph;
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Text(
      glyph,
      style: GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: AppColors.accentPrimary.withValues(alpha: 0.06),
        height: 1,
      ),
    ),
  );
}
