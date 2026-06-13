import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';

/// What the cursor is currently hovering — drives its shape.
enum CursorIntent {
  /// Default: 6 px dot + 32 px ring.
  idle,

  /// Links/buttons: ring grows to 48 px and fills with subtle accent.
  link,

  /// Project cards: ring grows to 64 px with "VIEW" inside.
  view,

  /// Body text: the dot stretches into a vertical I-beam.
  text,
}

/// Global cursor state. Widgets opt in via [CursorTarget]; the overlay in
/// the shell listens and renders. Kept as a singleton notifier so deeply
/// nested widgets don't need an inherited lookup for something this hot.
class CursorController {
  CursorController._();

  static final ValueNotifier<CursorIntent> intent = ValueNotifier(CursorIntent.idle);
  // Start offscreen so there is no (0,0) flash before the first mouse event.
  static final ValueNotifier<Offset> position = ValueNotifier(const Offset(-100, -100));
  static final ValueNotifier<bool> visible = ValueNotifier(false);
}

/// Declares the cursor shape for everything inside [child].
class CursorTarget extends StatelessWidget {
  const CursorTarget({required this.child, super.key, this.intent = CursorIntent.link});

  final Widget child;
  final CursorIntent intent;

  @override
  Widget build(BuildContext context) => MouseRegion(
    opaque: false,
    onEnter: (_) => CursorController.intent.value = intent,
    onExit: (_) => CursorController.intent.value = CursorIntent.idle,
    child: child,
  );
}

/// The rendered cursor: an instant inner dot and a spring-lagged outer ring.
///
/// Mount once, topmost in the shell `Stack`, inside an [IgnorePointer].
/// The shell is responsible for only mounting this on hover-capable devices
/// and for hiding the system cursor underneath it.
class CustomCursorOverlay extends StatefulWidget {
  const CustomCursorOverlay({super.key});

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Offset _ringPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Frame clock: each frame the ring closes ~18 % of the gap to the dot,
    // which reads as a ~100 ms organic lag at 60 fps. It stops the moment the
    // ring converges and re-arms on the next pointer move, so the engine can
    // idle between movements instead of pumping a frame every vsync.
    _ticker = createTicker(_onTick);
    CursorController.position.addListener(_wake);
  }

  void _onTick(Duration _) {
    final target = CursorController.position.value;
    final next = Offset.lerp(_ringPos, target, 0.18)!;
    if ((next - target).distanceSquared <= 0.05) {
      setState(() => _ringPos = target);
      _ticker.stop();
      return;
    }
    setState(() => _ringPos = next);
  }

  void _wake() {
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    CursorController.position.removeListener(_wake);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: IgnorePointer(
      child: ValueListenableBuilder<bool>(
        valueListenable: CursorController.visible,
        builder: (context, isVisible, _) {
          if (!isVisible) {
            return const SizedBox.shrink();
          }
          return ValueListenableBuilder<CursorIntent>(
            valueListenable: CursorController.intent,
            builder: (context, intent, _) => ValueListenableBuilder<Offset>(
              valueListenable: CursorController.position,
              builder: (context, dotPos, _) {
                final ringSize = switch (intent) {
                  CursorIntent.idle || CursorIntent.text => 32.0,
                  CursorIntent.link => 48.0,
                  CursorIntent.view => 64.0,
                };
                return Stack(
                  children: [
                    // Outer ring — lags behind with a soft spring.
                    Positioned(
                      left: _ringPos.dx - ringSize / 2,
                      top: _ringPos.dy - ringSize / 2,
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        curve: AppCurves.enter,
                        width: ringSize,
                        height: ringSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: intent == CursorIntent.idle || intent == CursorIntent.text
                              ? Colors.transparent
                              : AppColors.accentSubtle,
                          border: Border.all(
                            color: intent == CursorIntent.view
                                ? AppColors.accentGlow
                                : AppColors.textPrimary.withValues(alpha: 0.6),
                          ),
                        ),
                        child: AnimatedOpacity(
                          duration: AppDurations.fast,
                          opacity: intent == CursorIntent.view ? 1 : 0,
                          child: Text(
                            'VIEW',
                            style: AppTypography.badge.copyWith(color: AppColors.textAccent, fontSize: 9),
                          ),
                        ),
                      ),
                    ),
                    // Inner dot — zero lag.
                    Positioned(
                      left: dotPos.dx - (intent == CursorIntent.text ? 1 : 3),
                      top: dotPos.dy - (intent == CursorIntent.text ? 9 : 3),
                      child: AnimatedContainer(
                        duration: AppDurations.instant,
                        width: intent == CursorIntent.text ? 2 : 6,
                        height: intent == CursorIntent.text ? 18 : 6,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          borderRadius: BorderRadius.circular(Radii.xs),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    ),
  );
}
