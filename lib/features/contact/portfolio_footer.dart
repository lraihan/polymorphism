import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/assets.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:url_launcher/url_launcher.dart';

/// Footer: copyright · live Jakarta clock · socials · logo mark.
class PortfolioFooter extends StatefulWidget {
  const PortfolioFooter({super.key});

  @override
  State<PortfolioFooter> createState() => _PortfolioFooterState();
}

class _PortfolioFooterState extends State<PortfolioFooter> {
  Timer? _timer;
  String _jakartaTime = '';

  @override
  void initState() {
    super.initState();
    _tick();
    // Minute precision is plenty — 60× fewer rebuilds than per-second.
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    final jakarta = DateTime.now().toUtc().add(const Duration(hours: 7));
    // 12-hour clock with AM/PM — equivalent to DateFormat('h:mm a').
    final h12 = jakarta.hour % 12 == 0 ? 12 : jakarta.hour % 12;
    final minute = jakarta.minute.toString().padLeft(2, '0');
    final period = jakarta.hour < 12 ? 'AM' : 'PM';
    final next = '$h12:$minute $period';
    if (next != _jakartaTime && mounted) {
      setState(() => _jakartaTime = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final meta = AppTypography.caption.copyWith(color: AppColors.textSecondary);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.inkBlack,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.pageGutter, vertical: Spacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Spacing.pageMaxWidth),
            child: Column(
              children: [
                Wrap(
                  alignment: isMobile ? WrapAlignment.center : WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: Spacing.lg,
                  runSpacing: Spacing.md,
                  children: [
                    Text(AppStrings.footerCopyright, style: meta),
                    Text('Jakarta $_jakartaTime', style: meta),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppStrings.footerBuiltWith, style: meta),
                        const SizedBox(width: Spacing.xs),
                        const Icon(LucideIcons.heart, size: 12, color: AppColors.accentPrimary),
                      ],
                    ),
                    Wrap(
                      spacing: Spacing.md,
                      children: [
                        for (final social in PortfolioData.socials)
                          CursorTarget(
                            child: GestureDetector(
                              onTap: () => launchUrl(Uri.parse(social.url)),
                              child: Semantics(
                                link: true,
                                label: social.label,
                                child: Text(social.label.toUpperCase(), style: AppTypography.mono),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                Image.asset(
                  AppAssets.logo,
                  height: isMobile ? 36 : 48,
                  color: AppColors.textMuted,
                  errorBuilder: (context, error, stackTrace) =>
                      Text('R.', style: AppTypography.titleM.copyWith(color: AppColors.textMuted)),
                ),
                const SizedBox(height: Spacing.sm),
                Text(AppStrings.footerTagline, style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
