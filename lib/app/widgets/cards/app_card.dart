import 'package:flutter/material.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

class AppCard extends StatelessWidget {

  const AppCard({
    required this.child, super.key,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.border,
    this.boxShadow,
    this.hasShadow = true,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget card = Container(
      padding: padding ?? AppSpacing.m,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? theme.cardColor,
        borderRadius: borderRadius ?? AppBorderRadius.m,
        border: border,
        boxShadow:
            hasShadow
                ? boxShadow ??
                    [BoxShadow(color: theme.shadowColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
      ),
      child: child,
    );

    if (onTap != null) {
      card = InkWell(onTap: onTap, borderRadius: (borderRadius ?? AppBorderRadius.m) as BorderRadius?, child: card);
    }

    return card;
  }
}

class AppListTile extends StatelessWidget {

  const AppListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.dense = false,
    this.tileColor,
    this.shape,
  });
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final Color? tileColor;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) => ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding ?? AppSpacing.horizontalM,
      dense: dense,
      tileColor: tileColor,
      shape: shape ?? const RoundedRectangleBorder(borderRadius: AppBorderRadius.s),
    );
}
