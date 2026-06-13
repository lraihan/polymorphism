import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';

/// Right-edge progress rail: a thin track, a teal fill that mirrors scroll
/// progress, and one dot per section. Desktop/tablet only.
///
/// Listens to [ValueNotifier]s owned by the shell — no scroll listeners of
/// its own, no broad rebuilds.
class SectionRail extends StatelessWidget {
  const SectionRail({
    required this.progress,
    required this.activeSection,
    required this.sectionTitles,
    required this.onSectionTap,
    super.key,
  });

  final ValueListenable<double> progress;
  final ValueListenable<int> activeSection;
  final List<String> sectionTitles;
  final ValueChanged<int> onSectionTap;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return const SizedBox.shrink();
    }
    final railHeight = context.screenHeight * 0.5;
    final lastIndex = sectionTitles.length - 1;

    return Positioned(
      right: Spacing.lg,
      top: context.screenHeight * 0.25,
      child: ExcludeSemantics(
        child: SizedBox(
          width: 32,
          height: railHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(child: Container(width: 1.5, height: railHeight, color: AppColors.borderSubtle)),
              ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (context, p, _) => Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 1.5,
                    height: railHeight * p,
                    decoration: const BoxDecoration(
                      color: AppColors.accentPrimary,
                      boxShadow: [BoxShadow(color: AppColors.accentSubtle, blurRadius: 6, spreadRadius: 1)],
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: activeSection,
                builder: (context, active, _) => Stack(
                  children: [
                    for (var i = 0; i < sectionTitles.length; i++)
                      Positioned(
                        top: lastIndex == 0 ? railHeight / 2 - 5 : (railHeight - 10) * (i / lastIndex),
                        left: 11,
                        child: _RailDot(
                          label: sectionTitles[i],
                          active: i <= active,
                          current: i == active,
                          onTap: () => onSectionTap(i),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailDot extends StatefulWidget {
  const _RailDot({required this.label, required this.active, required this.current, required this.onTap});

  final String label;
  final bool active;
  final bool current;
  final VoidCallback onTap;

  @override
  State<_RailDot> createState() => _RailDotState();
}

class _RailDotState extends State<_RailDot> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => CursorTarget(
    child: MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Tooltip(
          message: widget.label,
          preferBelow: false,
          textStyle: AppTypography.badge.copyWith(color: AppColors.textPrimary),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.enter,
            width: _hovered || widget.current ? 10 : 8,
            height: _hovered || widget.current ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.active ? AppColors.accentPrimary : AppColors.deepSpace,
              border: Border.all(color: widget.active ? AppColors.accentPrimary : AppColors.textMuted),
              boxShadow: widget.current
                  ? const [BoxShadow(color: AppColors.accentGlow, blurRadius: 8, spreadRadius: 1)]
                  : const [],
            ),
          ),
        ),
      ),
    ),
  );
}
