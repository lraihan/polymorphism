import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';

/// Numbered section header:
///
/// ```
/// 02 / WORKS
/// Selected Projects ───────────────────────────
/// optional subtitle
/// ```
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.eyebrow, required this.title, super.key, this.subtitle, this.trailingRule = true});

  /// Mono eyebrow — `02 / WORKS`.
  final String eyebrow;
  final String title;
  final String? subtitle;

  /// Draw the horizontal rule after the title.
  final bool trailingRule;

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.responsive(
      mobile: AppTypography.displayM,
      tablet: AppTypography.displayL,
      desktop: AppTypography.displayXL,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          child: Semantics(
            label: eyebrow,
            child: Text(eyebrow, style: AppTypography.monoAccent),
          ),
        ),
        const SizedBox(height: Spacing.md),
        ScrollReveal(
          delay: AppDurations.instant,
          child: Semantics(
            header: true,
            child: Row(
              children: [
                Flexible(child: Text(title, style: titleStyle)),
                if (trailingRule) ...[
                  const SizedBox(width: Spacing.lg),
                  const Expanded(
                    child: Divider(color: AppColors.borderSubtle),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: Spacing.md),
          ScrollReveal(
            delay: AppDurations.fast,
            child: Text(subtitle!, style: AppTypography.bodyL),
          ),
        ],
      ],
    );
  }
}
