import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';

/// Non-web fallback — the embedded iframe prototype only runs on the web build.
class PrototypeView extends StatelessWidget {
  const PrototypeView({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.inkBlack,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Text(
              'The live, interactive prototype is available on the web version.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyM,
            ),
          ),
        ),
      );
}
