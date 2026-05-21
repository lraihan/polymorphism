import 'package:flutter/material.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

/// "(A promises,) made of pixels, blossoms in the dart."
///
/// Each word's opacity and vertical translation is driven directly by the
/// section's scroll progress. As the user scrolls through the section, words
/// illuminate one by one — quiet, deliberate.
class StandOutSection extends StatefulWidget {
  const StandOutSection({super.key, this.scrollController, this.onStartProjectPressed});

  final ScrollController? scrollController;
  final VoidCallback? onStartProjectPressed;

  @override
  State<StandOutSection> createState() => _StandOutSectionState();
}

class _StandOutSectionState extends State<StandOutSection> {
  final GlobalKey _sectionKey = GlobalKey();
  double _progress = 0;

  static const List<_Line> _lines = <_Line>[
    _Line(
      text: '(A promises,)',
      alignment: Alignment.centerLeft,
      sizeBase: 50,
      weight: FontWeight.w600,
      isAccent: false,
      letterSpacing: -2,
      lineHeight: 0.85,
    ),
    _Line(
      text: 'made of pixels,',
      alignment: Alignment.centerRight,
      sizeBase: 140,
      weight: FontWeight.w900,
      isAccent: true,
      letterSpacing: -4,
      lineHeight: 0.78,
    ),
    _Line(
      text: 'blossoms in',
      alignment: Alignment.centerLeft,
      sizeBase: 120,
      weight: FontWeight.w900,
      isAccent: false,
      letterSpacing: 12,
      lineHeight: 0.85,
    ),
    _Line(
      text: 'the dart.',
      alignment: Alignment.center,
      sizeBase: 160,
      weight: FontWeight.w900,
      isAccent: false,
      letterSpacing: -5,
      lineHeight: 0.78,
    ),
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || widget.scrollController?.hasClients != true) {
      return;
    }
    final ctx = _sectionKey.currentContext;
    if (ctx == null) {
      return;
    }
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final topInViewport = box.localToGlobal(Offset.zero).dy;
    final sectionHeight = box.size.height;
    final travel = sectionHeight + screenHeight;
    final travelled = (screenHeight - topInViewport).clamp(0.0, travel);
    final next = (travelled / travel).clamp(0.0, 1.0);
    if ((next - _progress).abs() > 0.002) {
      setState(() => _progress = next);
    }
  }

  List<_WordRef> _flatWords() {
    final result = <_WordRef>[];
    for (var li = 0; li < _lines.length; li++) {
      final words = _lines[li].text.split(' ');
      for (var wi = 0; wi < words.length; wi++) {
        result.add(_WordRef(lineIndex: li, wordIndex: wi));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final flat = _flatWords();
    final totalWords = flat.length;

    return Container(
      key: _sectionKey,
      width: double.infinity,
      height: screenHeight * (isMobile ? 1 : 1.8),
      color: AppColors.bgDark,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var li = 0; li < _lines.length; li++)
            _buildLine(context, li, flat, totalWords, reduceMotion),
        ],
      ),
    );
  }

  Widget _buildLine(BuildContext context, int lineIndex, List<_WordRef> flat, int total, bool reduceMotion) {
    final line = _lines[lineIndex];
    final words = line.text.split(' ');
    final fontSize = _responsive(context, line.sizeBase);
    final color = line.isAccent
        ? AppColors.accent
        : AppColors.textPrimary.withValues(alpha: 0.95);

    return Container(
      width: double.infinity,
      alignment: line.alignment,
      child: Wrap(
        alignment: _wrapAlignment(line.alignment),
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var wi = 0; wi < words.length; wi++)
            _buildWord(
              context,
              word: words[wi],
              flatIndex: flat.indexWhere((w) => w.lineIndex == lineIndex && w.wordIndex == wi),
              total: total,
              fontSize: fontSize,
              color: color,
              weight: line.weight,
              letterSpacing: line.letterSpacing,
              lineHeight: line.lineHeight,
              reduceMotion: reduceMotion,
              isLast: wi == words.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildWord(
    BuildContext context, {
    required String word,
    required int flatIndex,
    required int total,
    required double fontSize,
    required Color color,
    required FontWeight weight,
    required double letterSpacing,
    required double lineHeight,
    required bool reduceMotion,
    required bool isLast,
  }) {
    final start = flatIndex / total;
    final end = (flatIndex + 1) / total;
    final raw = ((_progress - start) / (end - start)).clamp(0.0, 1.0);
    final eased = Curves.easeOutCubic.transform(raw);
    final shown = reduceMotion ? 1.0 : eased;
    final dy = (1.0 - shown) * 24;

    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : fontSize * 0.18),
      child: Transform.translate(
        offset: Offset(0, dy),
        child: Opacity(
          opacity: shown,
          child: Text(
            word,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: fontSize,
              fontWeight: weight,
              color: color,
              height: lineHeight,
              letterSpacing: letterSpacing,
              shadows: [
                Shadow(
                  color: AppColors.bgDark.withValues(alpha: 0.8),
                  offset: const Offset(2, 2),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  WrapAlignment _wrapAlignment(Alignment a) {
    if (a == Alignment.centerLeft) {
      return WrapAlignment.start;
    }
    if (a == Alignment.centerRight) {
      return WrapAlignment.end;
    }
    return WrapAlignment.center;
  }

  double _responsive(BuildContext context, double base) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) {
      return base * 0.4;
    }
    if (w < 900) {
      return base * 0.6;
    }
    if (w < 1200) {
      return base * 0.8;
    }
    return base;
  }
}

class _Line {
  const _Line({
    required this.text,
    required this.alignment,
    required this.sizeBase,
    required this.weight,
    required this.isAccent,
    required this.letterSpacing,
    required this.lineHeight,
  });

  final String text;
  final Alignment alignment;
  final double sizeBase;
  final FontWeight weight;
  final bool isAccent;
  final double letterSpacing;
  final double lineHeight;
}

class _WordRef {
  const _WordRef({required this.lineIndex, required this.wordIndex});
  final int lineIndex;
  final int wordIndex;
}
