import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

class GalleryLightbox extends StatefulWidget {
  const GalleryLightbox({
    super.key,
    required this.initialIndex,
  });

  final int initialIndex;

  @override
  State<GalleryLightbox> createState() => _GalleryLightboxState();
}

class _GalleryLightboxState extends State<GalleryLightbox>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _currentIndex = 0;
  final int _totalImages = 8;
  
  // Focus node for keyboard handling
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    
    // Setup animations
    _animationController = AnimationController(
      duration: AppMotion.medium,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start enter animation
    _animationController.forward();
    
    // Request focus for keyboard handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _closeLightbox() {
    _animationController.reverse().then((_) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else if (mounted) {
        context.go('/');
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.escape:
          _closeLightbox();
          break;
        case LogicalKeyboardKey.arrowLeft:
          _navigatePrevious();
          break;
        case LogicalKeyboardKey.arrowRight:
          _navigateNext();
          break;
      }
    }
  }

  void _navigatePrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: AppMotion.fast,
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateNext() {
    if (_currentIndex < _totalImages - 1) {
      _pageController.nextPage(
        duration: AppMotion.fast,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  // Backdrop blur and dark overlay
                  GestureDetector(
                    onTap: _closeLightbox,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  
                  // Image viewer
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                            // Update route if GoRouter is available
                            try {
                              context.go('/gallery/$index');
                            } catch (e) {
                              // Ignore navigation errors in tests or when GoRouter isn't available
                            }
                          },
                          itemCount: _totalImages,
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: 'gallery-img-$index',
                              child: Center(
                                child: Image.asset(
                                  'assets/images/gallery_$index.jpg',
                                  fit: BoxFit.contain,
                                  semanticLabel: 'Gallery image ${index + 1} of $_totalImages',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  // Close button
                  Positioned(
                    top: 40,
                    right: 40,
                    child: _buildCloseButton(),
                  ),
                  
                  // Navigation arrows (desktop only)
                  if (MediaQuery.of(context).size.width >= 800) ...[
                    // Previous arrow
                    if (_currentIndex > 0)
                      Positioned(
                        left: 40,
                        top: 0,
                        bottom: 0,
                        child: _buildNavigationButton(
                          icon: Icons.arrow_back_ios,
                          onTap: _navigatePrevious,
                          semanticLabel: 'Previous image',
                        ),
                      ),
                    
                    // Next arrow
                    if (_currentIndex < _totalImages - 1)
                      Positioned(
                        right: 40,
                        top: 0,
                        bottom: 0,
                        child: _buildNavigationButton(
                          icon: Icons.arrow_forward_ios,
                          onTap: _navigateNext,
                          semanticLabel: 'Next image',
                        ),
                      ),
                  ],
                  
                  // Image counter and info
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: _buildImageInfo(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _closeLightbox,
        icon: const Icon(
          Icons.close,
          color: AppColors.textPrimary,
          size: 24,
        ),
        tooltip: 'Close gallery (ESC)',
        splashRadius: 24,
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onTap,
    required String semanticLabel,
  }) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 24,
          ),
          tooltip: semanticLabel,
          splashRadius: 24,
        ),
      ),
    );
  }

  Widget _buildImageInfo() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Semantics(
          liveRegion: true,
          label: 'Image ${_currentIndex + 1} of $_totalImages',
          child: Text(
            '${_currentIndex + 1} / $_totalImages',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
