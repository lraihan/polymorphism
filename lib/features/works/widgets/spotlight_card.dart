import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/features/works/widgets/detail_panel.dart';
import 'package:polymorphism/features/works/widgets/media_panel.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// One project chapter. Desktop alternates media left/right by [index] parity;
/// tablet and mobile stack media over detail. The card border warms to the
/// project accent on hover.
class SpotlightCard extends StatefulWidget {
  const SpotlightCard({required this.project, required this.index, required this.onOpen, super.key});

  final Project project;
  final int index;
  final VoidCallback onOpen;

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final mediaLeft = widget.index.isEven;

    final media = ScrollReveal(
      direction: ScrollRevealDirection.scale,
      child: MediaPanel(project: widget.project),
    );
    final detail = ScrollReveal(
      delay: AppDurations.instant,
      direction: mediaLeft ? ScrollRevealDirection.right : ScrollRevealDirection.left,
      child: DetailPanel(project: widget.project, onOpen: widget.onOpen),
    );

    final Widget body;
    if (context.isDesktopOrWider) {
      final height = (context.screenHeight * 0.66).clamp(560.0, 760.0);
      final mediaSide = Expanded(flex: 3, child: media);
      final detailSide = Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(child: detail),
          ),
        ),
      );
      body = SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: mediaLeft
              ? [mediaSide, detailSide]
              : [detailSide, mediaSide],
        ),
      );
    } else {
      final mediaHeight = widget.project.isPortraitMedia
          ? context.responsive<double>(mobile: 460, tablet: 560)
          : context.responsive<double>(mobile: 250, tablet: 400);
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: mediaHeight, child: media),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.responsive(mobile: Spacing.lg, tablet: Spacing.xl),
              Spacing.xl,
              context.responsive(mobile: Spacing.lg, tablet: Spacing.xl),
              Spacing.lg,
            ),
            child: detail,
          ),
        ],
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: AppCurves.enter,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(Radii.xl),
          border: Border.all(
            color: _hovered ? widget.project.accentColor.withValues(alpha: 0.45) : AppColors.borderSubtle,
            width: 0.8,
          ),
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(Radii.xl), child: body),
      ),
    );
  }
}

/// A thin rule with the project accent dot centered — the breath between cards.
class SpotlightDivider extends StatelessWidget {
  const SpotlightDivider({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: Spacing.xxl,
      child: Center(
        child: Row(
          children: [
            const Expanded(child: Divider(color: AppColors.borderSubtle, thickness: 0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.8),
                    boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.5), blurRadius: 8)],
                  ),
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.borderSubtle, thickness: 0.5)),
          ],
        ),
      ),
    );
}
