import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/router/app_routes.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(AppSpacing.xl + AppSpacing.md);
}

class _NavbarState extends State<Navbar> {
  final List<NavItem> _navItems = const [
    NavItem(label: 'Home', path: AppRoutes.homePath),
    NavItem(label: 'Projects', path: AppRoutes.projectsPath),
    NavItem(label: 'Gallery', path: AppRoutes.galleryPath),
    NavItem(label: 'Playground', path: AppRoutes.playgroundPath),
    NavItem(label: 'Case Studies', path: AppRoutes.caseStudiesPath),
    NavItem(label: 'Timeline', path: AppRoutes.timelinePath),
    NavItem(label: 'Contact', path: AppRoutes.contactPath),
  ];

  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 800;

        return Container(
          height: widget.preferredSize.height,
          decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.md))),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.md)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.md)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLogo(context),
                      if (isSmallScreen) _buildHamburgerMenu(context) else Flexible(child: _buildNavItems(context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Flexible(
      child: Text(
        'POLYMORPHISM',
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildNavItems(BuildContext context) {
    final goRouter = GoRouter.maybeOf(context);
    final currentLocation = goRouter?.routerDelegate.currentConfiguration.uri.path ?? '/';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            _navItems.map((item) {
              final isActive = currentLocation == item.path;
              return Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: TextButton(
                  onPressed: () => context.go(item.path),
                  style: TextButton.styleFrom(
                    foregroundColor: isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    item.label,
                    style: TextStyle(fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, fontSize: 14),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildHamburgerMenu(BuildContext context) {
    return IconButton(
      icon: Icon(_isDrawerOpen ? Icons.close : Icons.menu, color: AppColors.textPrimary),
      onPressed: () {
        setState(() {
          _isDrawerOpen = !_isDrawerOpen;
        });

        if (_isDrawerOpen) {
          _showMobileMenu(context);
        }
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMobileDrawer(context),
    ).then((_) {
      setState(() {
        _isDrawerOpen = false;
      });
    });
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final goRouter = GoRouter.maybeOf(context);
    final currentLocation = goRouter?.routerDelegate.currentConfiguration.uri.path ?? '/';

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: AppSpacing.sm),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children:
                        _navItems.map((item) {
                          final isActive = currentLocation == item.path;

                          return Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.sm),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  context.go(item.path);
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      isActive ? AppColors.accent : AppColors.textPrimary.withValues(alpha: 0.7),
                                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                                  alignment: Alignment.centerLeft,
                                ),
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  const NavItem({required this.label, required this.path});

  final String label;
  final String path;
}
