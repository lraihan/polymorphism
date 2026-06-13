# Performance Notes

How the "Precision in Motion" redesign stays at 60 fps on the web despite a
masked-reveal hero portrait, a particle field, glassmorphism, film grain, and
a custom cursor — and what to watch when changing any of it.

## Table of contents

1. [Particle system](#particle-system)
2. [RepaintBoundary placement](#repaintboundary-placement)
3. [Noise overlay: one-time 96×96 tile](#noise-overlay-one-time-9696-tile)
4. [BackdropFilter budget](#backdropfilter-budget)
5. [Scroll handling](#scroll-handling)
6. [Intro asset preloading](#intro-asset-preloading)
7. [Asset guidelines](#asset-guidelines)
8. [Web build flags](#web-build-flags)
9. [Measuring in DevTools](#measuring-in-devtools)
10. [Low-end device considerations](#low-end-device-considerations)

---

## Particle system

`lib/shared/painters/particle_painter.dart` — `ParticleField`.

- **Single ticker.** One `AnimationController` (a 60 s frame clock) drives the
  entire field: every particle position, respawn, and the occasional shooting
  star. There is exactly one listener and one `setState` per frame for the
  whole system — never one controller (or one `AnimatedBuilder`) per particle.
- **Particle counts.** 70 on desktop, 30 on mobile (resolved through
  `context.isMobile`; overridable via the `count` parameter). Dots are 1–3 px
  at 15–40 % opacity with 0.2–0.8 px/frame drift — cheap `drawCircle` calls,
  no blur, **no connecting lines, ever** (line meshes are O(n²) and the single
  biggest particle-field perf trap).
- **Isolated in a `RepaintBoundary`.** The field repaints every frame
  (`shouldRepaint => true`), so it must not invalidate anything else. The
  boundary inside `ParticleField` confines that repaint to its own layer.
- **Reduced motion → static frame.** `didChangeDependencies` checks
  `context.reducedMotion` and stops the ticker. Particles are still painted
  once — a static starfield — so the design survives with zero animation cost.
- **Respawn, don't allocate.** Particles that drift out of frame are mutated
  back in at an edge inside `paint()`; the list is allocated once per layout
  size. No per-frame list churn, no GC pressure.
- **`IgnorePointer`** wraps the whole field so it never participates in
  hit-testing.

The same single-ticker + reduced-motion pattern drives the hero portrait's
breathing/orbit controllers in `lib/features/hero/hero_portrait.dart`.

## RepaintBoundary placement

Rule of thumb applied throughout: **anything that repaints at a different
cadence than its neighbours gets its own boundary.** The hero layers:

| Layer | Cadence | Why a boundary |
| --- | --- | --- |
| `HeroPortrait` (base photo + cursor reveal + scrim) | per pointer move (reveal mask) | the whole portrait is wrapped in one `RepaintBoundary` so the mask follow-cost stays out of the page layer |
| `ParticleField` (faint motes over the portrait) | every frame | per-frame repaint stays in its own layer |
| `NoiseOverlay` (in the shell, above everything) | once | static tile; never repaints during scroll |

The reveal photo (`Background--.jpg`) loads lazily after the hero mounts, so it
never gates the intro; both 3840×2160 hero photos decode at a capped 2048 px
via a shared `ResizeImage` provider (`AppAssets.heroProvider`) so the pair
can't blow the 100 MB image cache. The `GridDotField`/`GlowOrb` painters remain
available as design-system primitives (`lib/shared/painters/`), tree-shaken
when unused.

Static layers (`NoiseOverlay` and the painter primitives) ship their own
`RepaintBoundary` + `IgnorePointer` inside their convenience widgets, so
callers can't forget. Without the boundaries, the per-frame particle/gradient
repaints would mark the shared layer dirty and force the grid, glow, and
noise to re-rasterize 60 times a second for no visual change.

**Two further isolation layers in the shell** (`portfolio_shell.dart`):

- Each of the six sections plus the footer is wrapped in a `RepaintBoundary`,
  so an animating section (e.g. the contact availability pulse) re-records only
  its own layer during a scroll frame, never its siblings — important because
  the page is one `SingleChildScrollView` with no sliver-level boundaries.
- The hero is wrapped in a `TickerMode` driven by a `_heroVisible` notifier
  (`scroll offset < viewport height`). When the hero scrolls offscreen, **all
  of its perpetual tickers mute at once** — the statement-dot colour loop, the
  gradient drift, the particle field, and the availability pulse — because
  `SingleTickerProviderStateMixin` subscribes to the inherited `TickerMode`.
  This restores idle frames for the rest of the page (the engine stops
  scheduling a frame every vsync once the hero is out of view).

The pulsing `.` on **ALIVE** animates only its glyph *colour* (a paint-only
change) with a constant drop-shadow; animating the shadow list would land in
the text layout path and re-shape the `FittedBox` paragraph every frame.

## Noise overlay: one-time 96×96 tile

`lib/shared/widgets/noise_overlay.dart` — the film grain is **not** a
per-frame random painter (the naive approach, which burns CPU generating
random pixels every frame and defeats raster caching).

Instead:

1. A 96×96 monochrome RGBA tile is generated **once per session** from a
   seeded `Random(7)` and decoded via `ui.decodeImageFromPixels`.
2. The decoded `ui.Image` is held in a `static` field shared across all
   `NoiseOverlay` instances (shell and detail pages reuse the same texture).
3. `_NoisePainter` tiles it with `paintImage(repeat: ImageRepeat.repeat,
   filterQuality: FilterQuality.none)` — one texture upload, zero per-frame
   cost. `shouldRepaint` only fires if the tile object changes (i.e. never
   after first decode).
4. Opacity (~3 %) is applied by a wrapping `Opacity` widget, and the whole
   thing sits in `IgnorePointer` + `RepaintBoundary` at the top of the shell
   stack.

If you ever want *animated* grain, swap between 2–3 pre-generated tiles on a
slow timer — do not regenerate pixels per frame.

## BackdropFilter budget

Backdrop blur is the most expensive effect in the app (it forces a readback
and re-filter of everything behind the layer). The budget is strict:

- **`FloatingNav`** (`lib/features/shell/floating_nav.dart`) — one pill, only
  visible after scrolling past the hero.
- **`GlassCard`** (`lib/shared/widgets/glass_card.dart`) — the *only other
  sanctioned use*, documented as such in the class doc comment. Blur sigma is
  variant-controlled: standard 20, elevated 28, ghost 12.

Everything else that looks glowy or soft (`GlowOrb`, hover glows, gradient
blobs) is **pure paint with radial-gradient shaders — no `ImageFilter` at
all**, which is why it costs almost nothing.

When adding UI: do not introduce new `BackdropFilter`s. Reuse `GlassCard`, and
avoid stacking many glass cards in one viewport (each is a separate saveLayer;
a bento grid of ~6 is fine, a list of 30 is not). Verify with:

```sh
grep -rn "BackdropFilter" lib/
# expected: glass_card.dart and floating_nav.dart only
```

## Scroll handling

`lib/features/shell/portfolio_shell.dart` — the shell listens to one
`ScrollController` and **never calls `setState` from the scroll listener**.

- **`ValueNotifier`s instead of setState storms.** `_progress` (rail fill),
  `_activeSection` (nav/rail highlight), and `_navVisible` are
  `ValueNotifier`s consumed by `ValueListenableBuilder`s deep inside
  `FloatingNav` and `SectionRail`. A scroll tick rebuilds a handful of leaf
  widgets, not the whole shell tree. (This replaced the v1 pattern of calling
  `setState` on every scroll notification — hundreds of full-shell rebuilds
  per second while flinging.)
- **24 px throttle on section hit-testing.** Determining the active section
  requires `GlobalKey` → `RenderBox` → `localToGlobal` walks over 6 sections,
  which is not free. `_onScroll` skips the measurement unless the offset has
  moved ≥ 24 px since the last measurement (`_lastMeasuredOffset`). Progress
  and nav visibility are trivial math, so they update every tick; the
  expensive hit-test runs ~40× less often during a fling with no perceptible
  lag in the highlight.
- `ValueNotifier` also deduplicates: assigning an unchanged value notifies no
  one, so listeners only fire when the section actually flips.
- Smooth (Lenis) scrolling is only enabled on hover-capable devices without
  reduced motion; touch devices get native physics.

## Intro asset preloading

`lib/features/intro/intro_screen.dart` — the intro is a *useful* loading
screen, not decoration:

- On the first post-frame callback, every path in `AppAssets.preload` is fed
  to **`precacheImage(AssetImage(path), context, onError: …)`**, decoding the
  first-paint images into Flutter's image cache while the counter runs. The
  `onError` callback swallows a missing/corrupt asset so one bad image can
  never hang the intro.
- **`preload` is first-paint only** — logo, avatar, and each project's *card*
  image (`project<N>-1.png`), 8 assets in total. The other two screenshots per
  project (12 images) are detail-route only; they load lazily when `/work/:id`
  opens, so they neither gate the intro nor pin texture memory for visitors who
  never open a detail page.
- The 000→100 counter displays `min(engineered 1.6 s clock, real asset
  progress)` — it never claims 100 % before those images are actually decoded,
  and it stretches past 2.2 s only if assets genuinely lag.
- Result: by the time the hero dissolves in, every works-grid card paints from
  cache with no decode jank mid-scroll and no pop-in.
- Reduced motion: assets still preload; the animations are skipped.
- The intro plays once per session (`_introSeen` static flag in the shell), so
  back-navigation never re-runs it.

If you add a project to the works grid, **add its card image to
`AppAssets.preload`** via `projectCover(N)` (`lib/core/constants/assets.dart`);
detail screenshots are intentionally left out and load on demand.

## Asset guidelines

Current state of `assets/images/works/` (18 screenshots, 3 per project,
~7.4 MB total — of which only the 6 card images are preloaded):

- **`project2-1.png` is ~2.0 MB and `project2-2.png` ~1.8 MB — compress both
  to < 500 KB.** Every preloaded card image is downloaded before the page is
  interactive, so an oversized card screenshot directly stretches the intro
  counter and first-load time.
- Recommended ceiling: **max 1600 px on the long edge**, < 500 KB per file.
  Cards render at far smaller logical sizes; anything beyond ~1600 px is
  wasted decode memory (a 2000×4000 PNG decodes to ~32 MB of raster memory
  regardless of file size).
- **Prefer WebP over PNG** for screenshots: lossy WebP at quality 80–85 is
  typically 5–10× smaller than PNG for UI screenshots with no visible loss,
  and is fully supported by Flutter web. Conversion example:

  ```sh
  cwebp -q 82 -resize 1600 0 project2-1.png -o project2-1.webp
  ```

  (Update `assets.dart`, `portfolio_data.dart`, and `pubspec.yaml` paths
  accordingly.)
- Consider `cacheWidth`/`cacheHeight` on `Image.asset` for thumbnails if
  source dimensions must stay large.

## Web build flags

- **`--web-renderer` no longer exists in Flutter 3.41.** Passing it fails the
  build. Renderer selection (CanvasKit/skwasm) is handled by the engine and,
  where applicable, at runtime via the web bootstrap configuration — do not
  re-add the flag to `build_prod.sh` or the GitHub Actions workflow.
- Standard production build:

  ```sh
  flutter build web --release \
    --dart-define=EMAILJS_SERVICE_ID=... \
    --dart-define=EMAILJS_TEMPLATE_ID=... \
    --dart-define=EMAILJS_PUBLIC_KEY=...
  ```

- `--wasm` is worth evaluating for paint-heavy pages like this one, but test
  the EmailJS `http` path and `url_launcher` behavior before adopting.
- Keep `--release` for any performance measurement; debug web builds are not
  representative (often 10× slower raster).

## Measuring in DevTools

Always measure in **profile or release mode** in Chrome, not debug.

1. **Frame chart (Performance view).** Target 60 fps (16.6 ms budget). UI
   thread spikes during scroll indicate layout/build storms — verify the
   shell's notifier pattern hasn't regressed to `setState`. With the page
   idle on the hero, frames should be raster-bound and well under budget; the
   only dirty layers should be the particle and gradient boundaries.
2. **Raster jank.** Long raster bars while glass cards enter the viewport
   point at `BackdropFilter` cost — check the blur sigma and how many cards
   are on screen. Use the *Highlight repaints* / repaint rainbow toggle to
   confirm the static layers (grid, glow, noise) are **not** flashing every
   frame; if they are, a `RepaintBoundary` was lost.
3. **Image cache (Memory / `debugImageOverheadAllowance`).** After the intro,
   the works screenshots should already be resident. Watch for entries whose
   decoded size vastly exceeds display size — that's the cue to resize/WebP
   the source. `PaintingBinding.instance.imageCache` stats (`currentSizeBytes`,
   default cap 100 MB) tell you if preloading everything still fits; it does
   today, but 4K screenshots would blow it.
4. **Timeline events.** Look for `precacheImage` decode work overlapping the
   intro window (good) versus decode spikes during scroll (bad — an asset is
   missing from `AppAssets.preload`).

## Low-end device considerations

- **Mobile already halves the particle count (30)**; if low-end Android
  browsers still jank, the next levers are: drop the shooting star, lower the
  particle tick rate, or pause the hero portrait's breathing/orbit controllers.
- **`prefers-reduced-motion` is the universal escape hatch** — every
  animated system (particles, gradient drift, intro, smooth scroll, scroll
  reveals) checks `context.reducedMotion` and degrades to a static frame.
  Users on weak hardware can enable it OS-side and get a fully static,
  fully functional page.
- Backdrop blur is disproportionately expensive on integrated/mobile GPUs.
  If targeting very low-end devices becomes a goal, gate `GlassCard`'s
  `BackdropFilter` behind a capability/mobile check and fall back to a more
  opaque solid surface — the design tokens already support it
  (`AppColors.glassWhite` at higher alpha).
- The custom cursor only mounts on hover-capable devices (`supportsHover`),
  and Lenis smooth scroll is likewise desktop-only — touch devices pay for
  neither.
- First load is network-bound on low-end connections: CanvasKit + fonts +
  ~7.4 MB of screenshots. The single highest-impact cheap win is the asset
  compression described above.
