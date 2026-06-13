import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/assets.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:url_launcher/url_launcher.dart';

/// One floating-nav destination.
typedef NavItem = ({String label, int sectionIndex});

/// Floating glass navigation.
///
/// Hidden during the hero; fades + slides in from the top once [visible]
/// flips true. Highlights the active section. On mobile it collapses to a
/// hamburger that opens a fullscreen menu with staggered item reveals.
class FloatingNav extends StatefulWidget {
  const FloatingNav({
    required this.visible,
    required this.activeSection,
    required this.items,
    required this.onNavTap,
    required this.contactSectionIndex,
    super.key,
  });

  final ValueListenable<bool> visible;
  final ValueListenable<int> activeSection;
  final List<NavItem> items;
  final ValueChanged<int> onNavTap;
  final int contactSectionIndex;

  @override
  State<FloatingNav> createState() => _FloatingNavState();
}

class _FloatingNavState extends State<FloatingNav> {
  bool _menuOpen = false;

  void _go(int sectionIndex) {
    setState(() => _menuOpen = false);
    widget.onNavTap(sectionIndex);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: widget.visible,
    builder: (context, visible, _) {
      final show = visible || _menuOpen;
      return Stack(
        children: [
          if (_menuOpen) _MobileMenu(items: widget.items, onTap: _go, onClose: () => setState(() => _menuOpen = false)),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedSlide(
              duration: AppDurations.normal,
              curve: show ? AppCurves.enter : AppCurves.exit,
              offset: show ? Offset.zero : const Offset(0, -1.2),
              child: AnimatedOpacity(
                duration: AppDurations.normal,
                opacity: show ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !show,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: Spacing.md),
                      child: _bar(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _bar(BuildContext context) {
    // Collapse to the hamburger before the desktop cluster (logo + 4 links +
    // socials + Say Hello) would crowd the pill — its own breakpoint, wider
    // than the global mobile one, because real mono/display font metrics are
    // wider than the fallbacks used in tests.
    final compact = context.screenWidth < 920;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.pill),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: compact ? context.screenWidth - Spacing.xl : 880,
          ),
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo — back to top.
              CursorTarget(
                child: GestureDetector(
                  onTap: () => _go(0),
                  child: Semantics(
                    button: true,
                    label: 'Back to top',
                    child: Image.asset(
                      AppAssets.logo,
                      height: 22,
                      color: AppColors.textPrimary,
                      errorBuilder: (context, error, stackTrace) =>
                          Text('R.', style: AppTypography.titleS.copyWith(color: AppColors.textAccent)),
                    ),
                  ),
                ),
              ),
              if (compact) ...[
                const SizedBox(width: Spacing.xl),
                CursorTarget(
                  child: IconButton(
                    onPressed: () => setState(() => _menuOpen = !_menuOpen),
                    icon: Icon(_menuOpen ? LucideIcons.x : LucideIcons.menu, color: AppColors.textPrimary, size: 20),
                    tooltip: _menuOpen ? 'Close menu' : 'Open menu',
                  ),
                ),
              ] else ...[
                const SizedBox(width: Spacing.xl),
                ValueListenableBuilder<int>(
                  valueListenable: widget.activeSection,
                  builder: (context, active, _) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in widget.items)
                        _NavLink(
                          label: item.label,
                          active: active == item.sectionIndex,
                          onTap: () => _go(item.sectionIndex),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.lg),
                Container(width: 1, height: 18, color: AppColors.borderSubtle),
                const SizedBox(width: Spacing.sm),
                const _SocialIconButton(icon: LucideIcons.github, tooltip: 'GitHub', url: PortfolioData.githubUrl),
                const _SocialIconButton(icon: LucideIcons.linkedin, tooltip: 'LinkedIn', url: PortfolioData.linkedInUrl),
                const SizedBox(width: Spacing.sm),
                _SayHelloButton(onTap: () => _go(widget.contactSectionIndex)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.active || _hovered;
    return CursorTarget(
      child: MouseRegion(
        opaque: false,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: AppDurations.fast,
                  style: AppTypography.mono.copyWith(
                    color: highlight ? AppColors.textAccent : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  child: Text(widget.label.toUpperCase()),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: AppDurations.fast,
                  curve: AppCurves.enter,
                  height: 1.5,
                  width: widget.active ? 16 : 0,
                  color: AppColors.accentPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  const _SocialIconButton({required this.icon, required this.tooltip, required this.url});

  final IconData icon;
  final String tooltip;
  final String url;

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => CursorTarget(
    child: MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.sm),
            child: AnimatedScale(
              scale: _hovered ? 1.15 : 1,
              duration: AppDurations.fast,
              curve: AppCurves.enter,
              child: Icon(widget.icon, size: 17, color: _hovered ? AppColors.textAccent : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SayHelloButton extends StatefulWidget {
  const _SayHelloButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_SayHelloButton> createState() => _SayHelloButtonState();
}

class _SayHelloButtonState extends State<_SayHelloButton> {
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
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.enter,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accentPrimary : AppColors.accentSubtle,
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(color: _hovered ? AppColors.accentPrimary : AppColors.borderActive),
          ),
          child: Text(
            'SAY HELLO',
            style: AppTypography.mono.copyWith(
              color: _hovered ? AppColors.textOnAccent : AppColors.textAccent,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Fullscreen mobile menu with staggered item reveals.
class _MobileMenu extends StatefulWidget {
  const _MobileMenu({required this.items, required this.onTap, required this.onClose});

  final List<NavItem> items;
  final ValueChanged<int> onTap;
  final VoidCallback onClose;

  @override
  State<_MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<_MobileMenu> with SingleTickerProviderStateMixin {
  late final AnimationController _reveal;

  @override
  void initState() {
    super.initState();
    _reveal = AnimationController(vsync: this, duration: AppDurations.slow);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (context.reducedMotion) {
          _reveal.value = 1;
        } else {
          _reveal.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: AnimatedBuilder(
      animation: _reveal,
      builder: (context, _) => ColoredBox(
        color: AppColors.deepSpace.withValues(alpha: 0.96 * _reveal.value),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < widget.items.length; i++)
                  _menuItem(i, widget.items[i]),
                const SizedBox(height: Spacing.xl),
                Opacity(
                  opacity: _itemBeat(widget.items.length),
                  child: Row(
                    children: [
                      for (final social in PortfolioData.socials) ...[
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(social.url)),
                          child: Text(social.label.toUpperCase(), style: AppTypography.monoAccent),
                        ),
                        const SizedBox(width: Spacing.lg),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  double _itemBeat(int index) {
    final start = index * 0.12;
    final t = ((_reveal.value - start) / (1 - start)).clamp(0.0, 1.0);
    return AppCurves.enter.transform(t);
  }

  Widget _menuItem(int index, NavItem item) {
    final beat = _itemBeat(index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: Opacity(
        opacity: beat,
        child: Transform.translate(
          offset: Offset(0, (1 - beat) * 24),
          child: GestureDetector(
            onTap: () => widget.onTap(item.sectionIndex),
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('0${index + 1}', style: AppTypography.monoAccent),
                const SizedBox(width: Spacing.md),
                Text(item.label, style: AppTypography.displayM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
