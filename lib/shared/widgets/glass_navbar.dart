import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polymorphism/core/constant.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class GlassNavbar extends StatelessWidget {
  const GlassNavbar({super.key, this.onNavigationTap});

  final Function(int)? onNavigationTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final isMediumScreen = screenWidth < 1200;

    final horizontalPadding = isSmallScreen ? 20.0 : 40.0;
    final itemSpacing =
        isSmallScreen
            ? 16.0
            : isMediumScreen
            ? 24.0
            : 40.0;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: screenHeight(context) * .08,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(color: AppColors.bgDark.withValues(alpha: 0.12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () => onNavigationTap?.call(0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: isSmallScreen ? 28 : 32,
                    fit: BoxFit.contain,
                    color: AppColors.textPrimary,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: isSmallScreen ? 28 : 32,
                          width: 60,
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                          child: const Icon(Icons.image_not_supported, color: AppColors.textPrimary, size: 16),
                        ),
                  ),
                ),
              ),

              Flexible(flex: 2, child: isSmallScreen ? _buildCompactNav(itemSpacing) : _buildFullNav(itemSpacing)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullNav(double spacing) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      _AnimatedNavItem(text: 'About', index: 1, onTap: onNavigationTap),
      SizedBox(width: spacing),
      _AnimatedNavItem(text: 'Timeline', index: 2, onTap: onNavigationTap),
      SizedBox(width: spacing),
      _AnimatedNavItem(text: 'Works', index: 3, onTap: onNavigationTap),
      SizedBox(width: spacing),
      _AnimatedNavItem(text: 'Contact', index: 5, onTap: onNavigationTap),
    ],
  );

  Widget _buildCompactNav(double spacing) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _AnimatedNavItem(text: 'About', index: 1, onTap: onNavigationTap),
        SizedBox(width: spacing),
        _AnimatedNavItem(text: 'Works', index: 3, onTap: onNavigationTap),
        SizedBox(width: spacing),
        _AnimatedNavItem(text: 'Contact', index: 5, onTap: onNavigationTap),
      ],
    ),
  );
}

class _AnimatedNavItem extends StatefulWidget {
  const _AnimatedNavItem({required this.text, required this.index, this.onTap});

  final String text;
  final int index;
  final Function(int)? onTap;

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovering = false;
  String _displayText = '';
  String _originalText = '';
  Timer? _scrambleTimer;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _originalText = widget.text;
    _displayText = _originalText;

    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scrambleTimer?.cancel();
    _resetTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startRandomizeAnimation() {
    if (!_isHovering) {
      return;
    }

    final random = Random();
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

    var randomizedText = '';
    for (var i = 0; i < _originalText.length; i++) {
      if (_originalText[i] == ' ') {
        randomizedText += ' ';
      } else {
        if (random.nextDouble() > 0.3) {
          randomizedText += _originalText[i];
        } else {
          randomizedText += letters[random.nextInt(letters.length)];
        }
      }
    }

    setState(() {
      _displayText = randomizedText;
    });

    _scrambleTimer = Timer(const Duration(milliseconds: 80), () {
      if (_isHovering && mounted) {
        _startRandomizeAnimation();
      }
    });
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });

    if (hovering) {
      _controller.forward();
      _startRandomizeAnimation();

      _resetTimer = Timer(const Duration(milliseconds: 600), () {
        if (_isHovering && mounted) {
          _scrambleTimer?.cancel();
          setState(() {
            _displayText = _originalText;
          });
        }
      });
    } else {
      _controller.reverse();
      _scrambleTimer?.cancel();
      _resetTimer?.cancel();
      setState(() {
        _displayText = _originalText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final fontSize = isSmallScreen ? 12.0 : 14.0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () => widget.onTap?.call(widget.index),
        child: AnimatedBuilder(
          animation: _animation,
          builder:
              (context, child) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _isHovering ? AppColors.glassSurface.withValues(alpha: 0.3) : Colors.transparent,
                  border: _isHovering ? Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2)) : null,
                  boxShadow:
                      _isHovering
                          ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Text(
                  _displayText,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary.withValues(alpha: _isHovering ? 1.0 : 0.8),
                    fontFamily: 'Nunito', // Using the same font as the theme
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
