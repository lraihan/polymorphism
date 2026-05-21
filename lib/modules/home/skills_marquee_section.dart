import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// A two-row continuously-scrolling marquee of skill chips.
///
/// Uses two infinite-running [AnimationController]s (one per row, opposite
/// directions). Pauses on hover when a pointer is over either row. Honors
/// reduced-motion by rendering a static row with horizontal scrolling.
class SkillsMarqueeSection extends StatefulWidget {
  const SkillsMarqueeSection({super.key});

  @override
  State<SkillsMarqueeSection> createState() => _SkillsMarqueeSectionState();
}

class _SkillsMarqueeSectionState extends State<SkillsMarqueeSection> with TickerProviderStateMixin {
  late final AnimationController _topController;
  late final AnimationController _bottomController;

  static const List<_Skill> _topRow = <_Skill>[
    _Skill('Flutter', Icons.smartphone),
    _Skill('Dart', Icons.code),
    _Skill('Figma', Icons.design_services),
    _Skill('GetX', Icons.flash_on),
    _Skill('REST APIs', Icons.cable),
    _Skill('UI / UX', Icons.dashboard_customize),
    _Skill('Animation', Icons.auto_awesome),
    _Skill('Material 3', Icons.palette),
    _Skill('Firebase', Icons.local_fire_department),
    _Skill('Git', Icons.account_tree),
  ];

  static const List<_Skill> _bottomRow = <_Skill>[
    _Skill('CI / CD', Icons.sync),
    _Skill('Vercel', Icons.change_history),
    _Skill('Responsive', Icons.devices),
    _Skill('Accessibility', Icons.accessibility_new),
    _Skill('Performance', Icons.speed),
    _Skill('Testing', Icons.science),
    _Skill('Architecture', Icons.view_quilt),
    _Skill('State Mgmt', Icons.layers),
    _Skill('Type Safety', Icons.verified_user),
    _Skill('Tooling', Icons.build),
  ];

  @override
  void initState() {
    super.initState();
    _topController = AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _bottomController = AnimationController(vsync: this, duration: const Duration(seconds: 36));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce) {
      _topController.stop();
      _bottomController.stop();
    } else {
      if (!_topController.isAnimating) {
        _topController.repeat();
      }
      if (!_bottomController.isAnimating) {
        _bottomController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _topController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? AppSpacing.xl : AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: Border(
          top: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.06)),
          bottom: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.06)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.md : AppSpacing.xl),
            child: ScrollReveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(Skills.)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tools and disciplines I rely on every day.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),
          _MarqueeRow(
            controller: _topController,
            skills: _topRow,
            reverse: false,
          ),
          const SizedBox(height: AppSpacing.md),
          _MarqueeRow(
            controller: _bottomController,
            skills: _bottomRow,
            reverse: true,
          ),
        ],
      ),
    );
  }
}

class _Skill {
  const _Skill(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _MarqueeRow extends StatelessWidget {
  const _MarqueeRow({
    required this.controller,
    required this.skills,
    required this.reverse,
  });

  final AnimationController controller;
  final List<_Skill> skills;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final chipsRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final s in skills) _SkillChip(skill: s),
      ],
    );

    if (reduceMotion) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [chipsRow, chipsRow]),
      );
    }

    return SizedBox(
        height: 56,
        child: LayoutBuilder(
          builder: (context, constraints) => AnimatedBuilder(
            animation: controller,
            builder: (context, _) => ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    maxWidth: double.infinity,
                    child: Transform.translate(
                      offset: Offset(_offsetFor(controller.value), 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [chipsRow, chipsRow, chipsRow],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }

  double _offsetFor(double t) {
    // Each `chipsRow` width is unknown at compose time, but two copies tile
    // the screen at a comfortable width (~1600px for the typical row). Using
    // a fixed translation distance keeps the cycle smooth without a layout
    // measurement pass.
    const cycle = 1600.0;
    final progress = reverse ? (1.0 - t) : t;
    return -progress * cycle;
  }
}

class _SkillChip extends StatefulWidget {
  const _SkillChip({required this.skill});
  final _Skill skill;

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: _hovering ? AppColors.accent.withValues(alpha: 0.12) : AppColors.glassSurface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _hovering
                ? AppColors.accent.withValues(alpha: 0.6)
                : AppColors.textPrimary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.skill.icon,
              size: 16,
              color: _hovering ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 8),
            Text(
              widget.skill.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _hovering ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
