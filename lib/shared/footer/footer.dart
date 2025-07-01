import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Global footer with copyright and social links
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) => Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        border: Border(top: BorderSide(color: AppColors.textPrimary.withValues(alpha: .1))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Copyright text
            Text(
              '© 2025 Raihan.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary.withValues(alpha: .7)),
            ),

            // Social icons
            const Row(
              children: [
                _SocialIcon(icon: Icons.code, tooltip: 'GitHub', url: 'https://github.com/lraihan'),
                SizedBox(width: 16),
                _SocialIcon(icon: Icons.work, tooltip: 'LinkedIn', url: 'https://linkedin.com/in/lraihan'),
                SizedBox(width: 16),
                _SocialIcon(icon: Icons.alternate_email, tooltip: 'X (Twitter)', url: 'https://x.com/lraihan'),
              ],
            ),
          ],
        ),
      ),
    );
}

class _SocialIcon extends StatefulWidget {

  const _SocialIcon({required this.icon, required this.tooltip, required this.url});
  final IconData icon;
  final String tooltip;
  final String url;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: AppMotion.fast, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.accent.withValues(alpha: .1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? AppColors.accent.withValues(alpha: .3) : AppColors.textPrimary.withValues(alpha: .2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _launchUrl,
              child: Tooltip(
                message: widget.tooltip,
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: _isHovered ? AppColors.accent : AppColors.textPrimary.withValues(alpha: .7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
}
