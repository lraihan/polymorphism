import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isExpanded = false,
    this.padding,
    this.width,
    this.height,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.textStyle,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button;

    if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? theme.colorScheme.primary,
          side: BorderSide(color: backgroundColor ?? theme.colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusS)),
          padding: padding ?? AppSpacing.verticalM,
          minimumSize: Size(width ?? 0, height ?? AppSizes.buttonHeightM),
        ),
        child: _buildButtonChild(theme),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: textColor ?? theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.radiusS)),
          padding: padding ?? AppSpacing.verticalM,
          minimumSize: Size(width ?? 0, height ?? AppSizes.buttonHeightM),
          elevation: 2,
        ),
        child: _buildButtonChild(theme),
      );
    }

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildButtonChild(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? (textColor ?? theme.colorScheme.primary) : (textColor ?? theme.colorScheme.onPrimary),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppSizes.paddingS),
          AutoSizeText(text, style: textStyle ?? theme.textTheme.labelLarge),
        ],
      );
    }

    return AutoSizeText(text, style: textStyle ?? theme.textTheme.labelLarge);
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = AppSizes.iconM,
    this.tooltip,
    this.padding,
    this.isCircular = false,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: size),
      color: color ?? theme.colorScheme.onSurface,
      padding: padding ?? AppSpacing.s,
      tooltip: tooltip,
    );

    if (backgroundColor != null || isCircular) {
      button = DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : AppBorderRadius.s,
        ),
        child: button,
      );
    }

    return button;
  }
}
