import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    super.key,
    this.description,
    this.icon,
    this.imagePath,
    this.action,
    this.padding,
  });
  final String title;
  final String? description;
  final Widget? icon;
  final String? imagePath;
  final Widget? action;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? AppSpacing.l,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(imagePath!, height: 120, width: 120)
          else if (icon != null)
            icon!
          else
            Icon(Icons.inbox_outlined, size: 80, color: theme.colorScheme.onSurface.withAlpha(77)),
          const SizedBox(height: AppSizes.paddingL),
          AutoSizeText(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(179)),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: AppSizes.paddingS),
            AutoSizeText(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(128)),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: AppSizes.paddingL), action!],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.title,
    super.key,
    this.description,
    this.onRetry,
    this.retryText = 'Retry',
    this.icon,
    this.padding,
  });
  final String title;
  final String? description;
  final VoidCallback? onRetry;
  final String retryText;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? AppSpacing.l,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error.withAlpha(179)),
          const SizedBox(height: AppSizes.paddingL),
          AutoSizeText(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(179)),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: AppSizes.paddingS),
            AutoSizeText(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(128)),
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: AutoSizeText(retryText),
              style: ElevatedButton.styleFrom(padding: AppSpacing.m),
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message, this.padding});
  final String? message;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? AppSpacing.l,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            AutoSizeText(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(179)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
