import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymorphism/core/constants/assets.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/extensions.dart';

/// Animated intro: logo mark wipes in, an engineered progress counter runs
/// 000 → 100 while the real assets decode into the image cache, then the
/// whole thing dissolves into the hero.
///
/// - Total duration ≈ 2.2 s (longer only if assets genuinely lag).
/// - Click/tap anywhere skips immediately.
/// - Reduced motion: assets still preload, everything else is instant.
class IntroScreen extends StatefulWidget {
  const IntroScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  late final AnimationController _entrance; // logo wipe + fade-in
  late final AnimationController _clock; // engineered counter pacing
  late final AnimationController _outro; // dissolve into hero

  int _assetsLoaded = 0;
  bool _done = false;

  final int _assetTotal = AppAssets.preload.length;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: AppDurations.sluggish);
    _clock = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _outro = AnimationController(vsync: this, duration: AppDurations.slow);

    _clock.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _maybeFinish();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preload();
      if (context.reducedMotion) {
        _entrance.value = 1;
        _clock.value = 1;
      } else {
        _entrance.forward();
        _clock.forward();
      }
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _clock.dispose();
    _outro.dispose();
    super.dispose();
  }

  void _preload() {
    for (final path in AppAssets.preload) {
      // onError swallows a missing/corrupt asset so the future still resolves
      // and the counter advances — a broken image must never hang the intro.
      unawaited(
        precacheImage(AssetImage(path), context, onError: (_, __) {}).then((_) {
          if (mounted) {
            setState(() => _assetsLoaded++);
            _maybeFinish();
          }
        }),
      );
    }
  }

  /// Counter shows the slower of (engineered clock, real asset progress) so
  /// it never claims 100 % before the page is actually ready.
  double get _progress {
    final real = _assetsLoaded / _assetTotal;
    return _clock.value < real ? _clock.value : real;
  }

  void _maybeFinish() {
    if (_done || !mounted) {
      return;
    }
    if (_progress >= 1) {
      _done = true;
      _outro.forward().whenComplete(widget.onFinished);
    }
  }

  void _skip() {
    if (_done) {
      return;
    }
    _done = true;
    _clock.stop();
    _outro.forward().whenComplete(widget.onFinished);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _skip,
    behavior: HitTestBehavior.opaque,
    child: AnimatedBuilder(
      animation: Listenable.merge([_entrance, _clock, _outro]),
      builder: (context, _) {
        final entrance = AppCurves.enter.transform(_entrance.value);
        final outro = AppCurves.travel.transform(_outro.value);
        final percent = (_progress * 100).round().clamp(0, 100);

        return Opacity(
          opacity: 1 - outro,
          child: Transform.scale(
            scale: 1 + outro * 0.04,
            child: ColoredBox(
              color: AppColors.deepSpace,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo mark — clean wipe reveal.
                        ClipRect(
                          child: Align(
                            widthFactor: entrance.clamp(0.001, 1.0),
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              AppAssets.logo,
                              height: 72,
                              color: AppColors.textPrimary,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text('R.', style: AppTypography.displayXL),
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),
                        // Progress hairline.
                        SizedBox(
                          width: 160,
                          child: Stack(
                            children: [
                              Container(height: 1.5, color: AppColors.borderSubtle),
                              FractionallySizedBox(
                                widthFactor: _progress.clamp(0.0, 1.0),
                                child: Container(height: 1.5, color: AppColors.accentPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        // Engineered counter — not a spinner.
                        Opacity(
                          opacity: entrance,
                          child: Text(
                            percent.toString().padLeft(3, '0'),
                            style: AppTypography.mono.copyWith(color: AppColors.textSecondary, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Spacing.xl,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Opacity(
                        opacity: entrance * 0.6,
                        child: Text(AppStrings.introSkipHint, style: AppTypography.mono),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
