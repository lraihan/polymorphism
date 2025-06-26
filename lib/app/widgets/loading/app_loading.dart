import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 50.0, this.color, this.message});
  final double size;
  final Color? color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingAnimationWidget.threeArchedCircle(color: color ?? theme.colorScheme.primary, size: size),
        if (message != null) ...[
          const SizedBox(height: AppSizes.paddingM),
          AutoSizeText(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(179)),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.message,
    this.backgroundColor,
  });
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      if (isLoading)
        ColoredBox(
          color: backgroundColor ?? Colors.black.withAlpha(77),
          child: Center(child: AppLoading(message: message)),
        ),
    ],
  );
}

class AppShimmer extends StatelessWidget {
  const AppShimmer({required this.child, required this.isLoading, super.key, this.baseColor, this.highlightColor});
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return _Shimmer(
      baseColor: baseColor ?? (isDark ? Colors.grey[700]! : Colors.grey[300]!),
      highlightColor: highlightColor ?? (isDark ? Colors.grey[500]! : Colors.grey[100]!),
      child: child,
    );
  }
}

class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child, required this.baseColor, required this.highlightColor});
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder:
        (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
                stops: [_animation.value - 0.3, _animation.value, _animation.value + 0.3],
              ).createShader(bounds),
          child: widget.child,
        ),
  );
}
