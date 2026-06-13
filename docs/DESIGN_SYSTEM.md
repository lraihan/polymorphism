# Polymorphism Design System

**Design language:** *Precision in Motion* — aesthetic theme *Deep Space Elegance*.
Observatory instruments, deep-water bioluminescence, precision watchmaking. Dark, confident, alive.

This document describes the design system **as implemented in code**. The single source of truth is
[`lib/core/theme/app_tokens.dart`](../lib/core/theme/app_tokens.dart):

> Every visual constant in the app must come from this file. If a value isn't here, it isn't part of the design system.

The portfolio is **dark only, by design** — there is deliberately no light mode
(`AppTheme.dark` in [`lib/core/theme/app_theme.dart`](../lib/core/theme/app_theme.dart) is the only theme).

---

## 1. Color Palette

All colors live in `AppColors` (`lib/core/theme/app_tokens.dart`).

### Backgrounds

| Token | Hex | Usage |
|---|---|---|
| `deepSpace` | `#080810` | Primary background. `scaffoldBackgroundColor` and `ColorScheme.surface`. Also used (with runtime alpha 0.5/0.7) for drop shadows under elevated cards. |
| `inkBlack` | `#0D0D1A` | Secondary background. |
| `surfaceCard` | `#111122` | Card surface; input field fill; resting `TechBadge` fill. |
| `surfaceMuted` | `#16162A` | Muted surface; tooltip and snackbar backgrounds; input hover fill. |

### Accent — Bioluminescent Teal

| Token | Hex (AARRGGBB) | Effective alpha | Usage |
|---|---|---|---|
| `accentPrimary` | `#FF00F5C4` | 100 % | The one true accent. `ColorScheme.primary`, focus borders, CTA outline/fill, scroll-rail fill, text cursor, the pulsing dot in `ALIVE.`, 30 % of particles. |
| `accentGlow` | `#8000F5C4` | 50.2 % | Glow halos: `VIEW` cursor ring border, current rail-dot box shadow, pulse target for the `ALIVE.` dot. |
| `accentSubtle` | `#2000F5C4` | 12.5 % | Subtle accent backgrounds: hovered `TechBadge` fill, cursor ring fill on link/view, CTA hover glow shadow, theme `focusColor`. |

### Secondary accent — Deep Violet (used sparingly)

| Token | Hex (AARRGGBB) | Effective alpha | Usage |
|---|---|---|---|
| `accentSecondary` | `#FF7B5CF0` | 100 % | `ColorScheme.secondary`; second stop of the teal→violet `GradientText` gradient. |
| `accentVioletGlow` | `#407B5CF0` | 25.1 % | Violet glow layer (e.g. `GlowOrb` color). |

### Text

| Token | Hex | Usage |
|---|---|---|
| `textPrimary` | `#F0F0FF` | Primary text, display/title styles, cursor dot, grid dots, 70 % of particles. |
| `textSecondary` | `#9090B0` | Secondary/subdued text — body copy, default icon color, badge labels. |
| `textMuted` | `#505070` | Muted text, placeholders, captions, mono eyebrow default, inactive rail-dot border. |
| `textAccent` | `#00F5C4` | Accent-colored text (same hue as `accentPrimary`): active mono markers, hovered badge labels, CTA label at rest, `VIEW` cursor label. |
| `textOnAccent` | `#06120E` | Dark text on accent fills — CTA primary label when the button fills teal; `ColorScheme.onPrimary`. |

### Glass / Border

| Token | Hex (AARRGGBB) | Effective alpha | Usage |
|---|---|---|---|
| `borderSubtle` | `#FF252540` | 100 % | Default borders everywhere: glass cards, badges, dividers, tooltip/snackbar outlines, input enabled border, rail track, scrollbar thumb. |
| `borderActive` | `#4000F5C4` | 25.1 % teal | Active/hover borders — `GlassCard(glowOnHover)` and hovered `TechBadge`. |
| `glassWhite` | `#0FFFFFFF` | ~5.9 % white | Base fill of glass surfaces (`GlassCard` multiplies this alpha per variant). |

### Semantic

| Token | Hex | Usage |
|---|---|---|
| `successGreen` | `#00C896` | Success states. |
| `warningAmber` | `#FFB347` | Warnings. |
| `errorRed` | `#FF5B5B` | Errors; `ColorScheme.error`; input error border and error text style. |

### Rule: the accent is sacred

Teal `#00F5C4` is the signal color of the entire site, and it stays a *signal*:

- It marks **interaction and life only** — hover/focus states, the active scroll position, the pulsing
  period in `ALIVE.`, a minority (30 %) of particles, the shooting star. It is never used for large
  fills, backgrounds, or body text.
- Violet `accentSecondary` is explicitly "used sparingly" (its own token comment) — in practice it
  appears as the second gradient stop and ambient glow only.
- Restraint is enforced structurally: the *only* low-opacity accent variants that exist are the three
  pre-baked tokens above (`accentGlow`, `accentSubtle`, `borderActive`). If you need teal at another
  strength, that is a design-system change, not a call-site decision.

### Note: fixed alpha encodings vs the original spec

The original spec described translucent accents in percentages ("50 % glow", "12.5 % subtle",
"25 % violet"). In code these are **baked into the 8-digit const hex literal (AARRGGBB)** rather than
computed at runtime with `withOpacity`/`withValues`. The hex alpha byte cannot represent the spec
percentages exactly, so the encoded values are the nearest byte:

| Token | Spec | Alpha byte | Actual |
|---|---|---|---|
| `accentGlow` | 50 % | `0x80` (128/255) | 50.2 % |
| `accentVioletGlow` | 25 % | `0x40` (64/255) | 25.1 % |
| `borderActive` | 25 % | `0x40` (64/255) | 25.1 % |
| `accentSubtle` | 12.5 % | `0x20` (32/255) | 12.5 % |
| `glassWhite` | — (glass base) | `0x0F` (15/255) | 5.9 % |

Benefit: all of these are compile-time `const` and usable in `const` decorations/shadows.
Runtime `.withValues(alpha: …)` is still used where the alpha is *dynamic* (animation-driven fades,
particle opacities, shadow strengths).

---

## 2. Typography

Three faces, three jobs (`AppTypography`, `lib/core/theme/app_typography.dart`):

- **Space Grotesk** — display: hero statements, section titles, card titles.
- **Inter** — body: descriptions, paragraphs, form fields. Also the theme-level fallback `fontFamily`, so un-styled text still lands on-palette.
- **JetBrains Mono** — utility: eyebrow labels, section numbers, badges.

Sizes come from `TypographyTokens`; letter-spacing tokens are **em fractions** multiplied by the font
size to produce logical px (`trackedTight = -0.02`, `trackedWide = 0.15`, `trackedNormal = 0`).

### Scale

| Style | Face | Size | Weight | Line height | Tracking | Color | Use |
|---|---|---|---|---|---|---|---|
| `heroDisplay` | Space Grotesk | 96 | w700 | 0.98 | −0.02 em | `textPrimary` | Hero statement text. |
| `displayXL` | Space Grotesk | 72 | w700 | 1.02 | −0.02 em | `textPrimary` | Section titles, desktop. |
| `displayL` | Space Grotesk | 56 | w700 | 1.05 | −0.02 em | `textPrimary` | Section titles, tablet. |
| `displayM` | Space Grotesk | 40 | w700 | 1.1 | −0.02 em | `textPrimary` | Section titles, mobile. |
| `titleL` | Space Grotesk | 32 | w600 | 1.15 | −0.02 em | `textPrimary` | Card titles, subsection heads. |
| `titleM` | Space Grotesk | 24 | w600 | 1.2 | 0 | `textPrimary` | Project titles. |
| `titleS` | Space Grotesk | 18 | w600 | 1.3 | 0 | `textPrimary` | Labels; CTA labels (at 15 px via `copyWith`). |
| `bodyL` | Inter | 17 | w400 | 1.65 | 0 | `textSecondary` | Primary body copy, section subtitles. |
| `bodyM` | Inter | 15 | w400 | 1.6 | 0 | `textSecondary` | Secondary body copy, form fields. |
| `caption` | Inter | 13 | w400 | 1.5 | 0 | `textMuted` | Captions, meta info, tooltips, error text. |
| `mono` | JetBrains Mono | 12 | w500 | 1.4 | +0.15 em | `textMuted` | Eyebrow labels & section numbers — `02 / WORKS`. |
| `monoAccent` | JetBrains Mono | 12 | w500 | 1.4 | +0.15 em | `textAccent` | Accent variant of `mono` for active markers. |
| `badge` | JetBrains Mono | 11 | w500 | 1.3 | +0.08 em | `textSecondary` | Tech badges, meta chips, `VIEW` cursor label (9 px), rail tooltips. |

### Material `TextTheme` mapping (`AppTheme.dark`)

`displayLarge→heroDisplay`, `displayMedium→displayXL`, `displaySmall→displayL`,
`headlineLarge→displayM`, `headlineMedium→titleL`, `headlineSmall→titleM`,
`titleLarge→titleL`, `titleMedium→titleM`, `titleSmall→titleS`,
`bodyLarge→bodyL`, `bodyMedium→bodyM`, `bodySmall→caption`,
`labelLarge/labelMedium→mono`, `labelSmall→badge`.

### Responsive display sizing in practice

- `SectionHeader` titles: `displayM` (mobile) → `displayL` (tablet) → `displayXL` (desktop+).
- Hero statement font size: **52** (mobile) → **72** (tablet) → **96** (desktop) → **108** (wide),
  always with `trackedTight` recomputed against the actual size.

---

## 3. Spacing System

`Spacing` (`lib/core/theme/app_tokens.dart`) — a 4/8-based scale:

| Token | Value | Typical use |
|---|---|---|
| `xs` | 4 | Hairline gaps. |
| `sm` | 8 | Icon↔label gaps, chip inner vertical padding. |
| `md` | 16 | Default padding; input content padding; mobile page gutter. |
| `lg` | 24 | Button padding, CTA wrap spacing. |
| `xl` | 32 | Tablet page gutter. |
| `xxl` | 48 | Desktop page gutter. |
| `xxxl` | 64 | Large block separation. |
| `section` | 120 | Between major sections — desktop. |
| `sectionTablet` | 80 | Between major sections — tablet. |
| `sectionMobile` | 60 | Between major sections — mobile. |

Grid constants:

| Token | Value |
|---|---|
| `pageMaxWidth` | 1280 |
| `pageGutter` | 24 |
| `gridGap` | 20 |

Responsive helpers (`lib/core/utils/extensions.dart`):

- `context.pageGutter` → `Spacing.md` (16) mobile / `Spacing.xl` (32) tablet / `Spacing.xxl` (48) desktop+.
- `context.sectionSpacing` → 60 mobile / 80 tablet / 120 desktop+.

---

## 4. Radius, Duration & Curve Tokens

### Radii

| Token | Value | Typical use |
|---|---|---|
| `none` | 0 | — |
| `xs` | 4 | Scrollbar radius, cursor dot/I-beam corners. |
| `sm` | 8 | Tooltips. |
| `md` | 12 | Inputs, snackbars. |
| `lg` | 16 | Glass cards (default), hover-card shadow/clip radius. |
| `xl` | 24 | Large containers. |
| `pill` | 100 | Tech badges, CTA primary. |
| `circle` | 9999 | Fully round. |

### Durations — and why the class is `AppDurations`, not `Durations`

The original spec named this token class `Durations`. The implemented class is **`AppDurations`**
because Flutter's Material library already exports a `Durations` class (M3 duration constants), and
the collision would force `import … hide Durations` at **every call site** that imports both
`app_tokens.dart` and `material.dart` — i.e., essentially everywhere. The rename is documented in
the token file's doc comment.

| Token | Value | Feel |
|---|---|---|
| `instant` | 100 ms | Micro feedback (cursor dot morph, first stagger step). |
| `fast` | 200 ms | Hover transitions — scale, borders, underlines, badge/cursor states. |
| `normal` | 350 ms | Settles (tilt/magnet release), tooltip wait. |
| `slow` | 500 ms | Scroll-reveal default. |
| `sluggish` | 800 ms | Long ambient moves. |
| `dramatic` | 1200 ms | Hero entrance timeline. |
| `crawl` | 2000 ms | Slowest deliberate motion. |

### Curves — the only easing the app may use

`Curves.linear` is **intentionally absent**: per the design brief it is never used unless a
continuous loop (marquee, orbit) genuinely calls for it.

| Token | Value | Use |
|---|---|---|
| `enter` | `Curves.easeOutCubic` | Default enter — fast start, gentle settle. The workhorse for all hover/reveal motion. |
| `exit` | `Curves.easeInCubic` | Default exit — gentle start, fast finish. |
| `dramatic` | `Cubic(0.16, 1, 0.3, 1)` (easeOutExpo-like) | Emphasized hero/intro movement; every hero beat. |
| `spring` | `Curves.easeOutBack` | Springy settle — hover-card tilt release. |
| `travel` | `Curves.easeInOutCubic` | Both-ways travel — curtains, morphs. |

---

## 5. Component Library Index

Everything shared lives under `lib/shared/`. Conventions across the set: decorative layers are
wrapped in `IgnorePointer` + `RepaintBoundary`; hover effects use `MouseRegion(opaque: false)`;
hover/pointer effects are gated on `context.supportsHover` and disabled under `context.reducedMotion`.

### Widgets (`lib/shared/widgets/`)

#### `GlassCard` — `glass_card.dart`
Glassmorphism container — **the only sanctioned use of `BackdropFilter` outside the navigation
bar**, because backdrop blur is the most expensive effect in the app.

| Variant | Blur σ | Surface alpha (× `glassWhite`) | Shadow |
|---|---|---|---|
| `GlassCard.standard` | 20 | 1.0× | no |
| `GlassCard.elevated` | 28 | 1.4× | yes — `deepSpace` @ 50 %, blur 32, offset (0, 12) |
| `GlassCard.ghost` | 12 | 0.5× | no |

Props: `child`, `radius` (default `Radii.lg`), `padding`, `glowOnHover` (animates border
`borderSubtle → borderActive` over `fast`/`enter`).

#### `CustomCursor` — `custom_cursor.dart`
Four cooperating pieces:

- **`CursorIntent`** enum — `idle` (6 px dot + 32 px ring), `link` (ring grows to 48 px, fills
  `accentSubtle`), `view` (64 px ring, `accentGlow` border, `VIEW` label inside), `text` (dot
  stretches into a 2×18 px I-beam).
- **`CursorController`** — singleton of three static `ValueNotifier`s (`intent`, `position`,
  `visible`); no inherited lookup for something this hot.
- **`CursorTarget`** — declares the cursor shape for its subtree via `MouseRegion`
  (prop: `intent`, default `link`).
- **`CustomCursorOverlay`** — the renderer. Inner dot tracks with zero lag; outer ring closes ~18 %
  of the gap per frame via a `Ticker` (reads as ~100 ms organic lag at 60 fps). Mounted once,
  topmost in the shell `Stack`, inside `IgnorePointer`; the shell only mounts it on hover-capable
  devices and hides the system cursor.

#### `HoverCard` — `hover_card.dart`
3D perspective tilt wrapper for cards. Tracks the pointer relative to center; applies a perspective
matrix (`setEntry(3, 2, 0.0008)`), max **±8°** on both axes (prop `maxAngle`); a specular radial
highlight (white @ 6 %) sweeps opposite the tilt; springs back to neutral over `normal` with
`AppCurves.spring`. Props: `child`, `maxAngle` (8), `lift` (hover drop shadow: `deepSpace` @ 70 %,
blur 40, offset (0, 20)), `onTap`. Inert on touch devices and under reduced motion (renders a plain
tappable).

#### `CtaButton` — `cta_button.dart`
Call-to-action buttons. Two variants:

- **`CtaButton.primary`** — accent pill outline; fills with `accentPrimary` on hover, label flips
  `textAccent → textOnAccent`, gains an `accentSubtle` glow shadow.
- **`CtaButton.ghost`** — text-only; a 1.5 px accent underline sweeps in from the left to the
  measured text width.

Both: scale 1.0 → 1.03 over `fast`/`enter`; optional `icon` slides in on hover; wrapped in
`MagneticButton` (magnetic on desktop) and `CursorTarget` (announces to the custom cursor);
`Semantics(button: true)`. Props: `label`, `onTap`, `icon`.

#### `MagneticButton` — `magnetic_button.dart`
Wrapper that gives its child a subtle magnetic pull toward the cursor (hover-capable devices only).
Props: `child`, `onTap`, `strength` (0–1, default 0.35), `maxOffset` (max translation, default
14 px). Settles back over `normal`/`enter`. Falls back to a plain tappable on touch and under
reduced motion.

#### `TechBadge` — `tech_badge.dart`
Mono-faced tech/stack chip — `FLUTTER`, `REST APIS`, … Pill (`Radii.pill`), `surfaceCard` fill,
`borderSubtle` border; label is `AppTypography.badge` upper-cased. On hover (if `interactive`,
default true): scales to 1.05, fill → `accentSubtle`, border → `borderActive`, text/icon →
accent. Props: `label`, `icon` (14 px, optional), `interactive` (disable for dense read-only
contexts like project cards).

#### `SectionHeader` — `section_header.dart`
Numbered section header: mono eyebrow (`02 / WORKS`, in `monoAccent`), display title with an
optional horizontal rule filling the remaining row, optional `bodyL` subtitle. Title style is
responsive (`displayM`/`displayL`/`displayXL`). Each row is its own `ScrollReveal`, staggered
eyebrow → title (+100 ms) → subtitle (+200 ms). Props: `eyebrow`, `title`, `subtitle?`,
`trailingRule` (default true). Title row is `Semantics(header: true)`.

#### `SectionRail` — `section_rail.dart`
Right-edge scroll progress rail, desktop/tablet only (`SizedBox.shrink()` on mobile). A 1.5 px
`borderSubtle` track (50 % of screen height, vertically centered), a teal fill mirroring scroll
progress (with `accentSubtle` glow), and one dot per section (8 px, growing to 10 px when hovered
or current; passed dots fill teal; current dot gets an `accentGlow` halo; tooltip shows the section
title). Listens to `ValueListenable`s owned by the shell — no scroll listeners of its own. Props:
`progress` (`ValueListenable<double>`), `activeSection` (`ValueListenable<int>`), `sectionTitles`,
`onSectionTap`.

#### `NoiseOverlay` — `noise_overlay.dart`
Film-grain overlay at ~3 % opacity (prop `opacity`, default 0.03). A 96×96 monochrome noise tile
(seeded RNG) is generated **once per session** (static cache) and tiled across the screen — one
texture upload, zero per-frame cost. Sits above all content inside `IgnorePointer`.

#### `GradientText` — `gradient_text.dart`
Text filled with the teal→violet accent gradient via `ShaderMask(srcIn)`. Props: `text`, `style`
(required), `gradient` (default `LinearGradient([accentPrimary, accentSecondary])`), `textAlign`.

### Painters (`lib/shared/painters/`)

#### `GridDotPainter` / `GridDotField` — `grid_painter.dart`
Subtle dot-grid background: 1 px-radius `textPrimary` dots on a 40 px pitch at 4 % opacity (props
`pitch`, `opacity`). Static — paints once; `GridDotField` is the convenience layer
(`IgnorePointer` + `RepaintBoundary`).

#### `GlowPainter` / `GlowOrb` — `glow_painter.dart`
Soft radial glow orb — behind the hero statement and on hover states. Pure paint (a
`RadialGradient` from `color` to transparent), **no blur filters**, so it costs almost nothing.
Props: `color` (required), `center` (default `Alignment(0, -0.2)`), `radiusFactor` (glow radius as
a fraction of the shorter side, default 0.6). `GlowOrb` is the non-interactive widget wrapper.

#### `ParticleField` — `particle_painter.dart`
Deep-space ambient particle field (stateful widget owning a private painter):

- **70 particles desktop / 30 mobile** by default (prop `count` overrides).
- Dots are 70 % white / 30 % teal, 0.5–1.5 px radius (1–3 px diameter), 15–40 % opacity, drifting
  at 0.2–0.8 px/frame in random directions; respawn at the opposite edge when out of frame.
- An occasional **shooting star** streaks across: teal gradient trail (≤ 60 % alpha) + white head,
  eased with `Curves.easeIn`, advancing `t += 0.02` per frame (~0.8 s per streak), then a random
  5–13 s cooldown (first possible streak after 6 s).
- **No connecting lines, ever.**
- One `AnimationController` ticker (60 s loop) drives everything; isolated in a `RepaintBoundary`;
  renders a single static frame under reduced motion. RNG is seeded (42) for determinism.

### Animations (`lib/shared/animations/`)

#### `ScrollReveal` — `scroll_reveal.dart`
Reveals its child when it first enters the viewport (via `visibility_detector`), then stays
revealed (one-shot). Defaults: **fade in + slide up 30 px over `AppDurations.slow` (500 ms) with
`AppCurves.enter`**, triggered when **15 %** of the child is visible. Honors reduced motion by
rendering immediately at full opacity.

Props: `child`, `delay` (stagger siblings; default zero), `duration` (default `slow`), `direction`
(`ScrollRevealDirection`: `up`/`down`/`left`/`right`/`scale`/`fade`; default `up`), `offset`
(start displacement in px, default 30), `visibleFraction` (default 0.15). The `scale` direction
grows 0.92 → 1.0 with the fade; `fade` is opacity only.

---

## 6. Animation Timing Reference

### Hero entrance choreography (`lib/features/hero/hero_section.dart`)

One `AnimationController` of `AppDurations.dramatic` (**1200 ms**) starts when the intro dissolves
(`play` flips true). Each element maps to a *beat* — a sub-window of the timeline, re-eased with
`AppCurves.dramatic` via `_beat(start, end)` (which uses `double.subProgress` from
`extensions.dart`):

| Beat start | Element | Window (ms) | Motion |
|---|---|---|---|
| 100 | Status/availability badge | 100 → 400 | Fades in, slides 32 px from the right. |
| 200 | Statement line 1 | 200 → 700 | Horizontal wipe from the left (`ClipRect` + `Align.widthFactor`). |
| 400 | Statement line 2 | 400 → 900 | Same wipe. |
| 600 | Statement line 3 (`ALIVE.`) | 600 → 1100 | Same wipe; the period then pulses forever. |
| 800 | Subtitle (role · location) | 800 → 1150 | Fades up 16 px. |
| 950 | CTAs | 950 → 1200 | Fade up 24 px. |
| 1100 | Scroll hint | 1100 → 1200 | Fade in. |

Continuous loops (start with the entrance, `repeat(reverse: true)` at **1600 ms**): the `ALIVE.`
period color-pulses `accentPrimary ↔ accentGlow` with a fading 24 px glow shadow, and the scroll
hint's gradient line breathes. Under reduced motion the entrance controller jumps to 1 and loops
never start. The hero background also leans toward the pointer (normalized −1..1 hover tracking).

### Scroll reveal defaults

- 500 ms (`slow`), `easeOutCubic` (`enter`), fade + 30 px up-slide, fires once at 15 % visibility.
- Reduced motion: instantly visible.

### Stagger conventions (as used across features)

| Context | Stagger |
|---|---|
| `SectionHeader` internals | eyebrow at 0 → title +100 ms (`instant`) → subtitle +200 ms (`fast`). |
| Works grid cards | `order * 80 ms` per card. |
| About highlights | `i * 80 ms` per item. |
| Skills grid | `row * 60 ms` per row, `+ col * 40 ms` per cell within a row. |
| Contact section | form at `instant` (100 ms), direct links at `fast` (200 ms). |

Convention: sibling staggers are 40–100 ms apart, built from `AppDurations.instant`/`fast` or
small per-index multiples (40/60/80 ms); never longer.

### Micro-interaction timings

| Interaction | Duration / rate | Curve |
|---|---|---|
| Hover scale (CTA 1.03, badge 1.05), border/underline/fill transitions | `fast` (200 ms) | `enter` |
| Cursor ring size/intent morph | `fast` (200 ms); ring position lags 18 %/frame ≈ 100 ms | `enter` |
| Cursor dot/I-beam morph | `instant` (100 ms) | — |
| Tilt / magnetic spring-back | `normal` (350 ms) | `spring` (tilt) / `enter` (magnet) |
| Particle drift | 0.2–0.8 px/frame @ 60 fps, 60 s ticker loop | — |
| Shooting star | ~0.8 s streak, 5–13 s cooldown | `easeIn` |

---

## 7. Responsive Breakpoint Guide

Defined in `lib/core/utils/responsive.dart` as the `Breakpoint` enum + `ResponsiveContext`
extension on `BuildContext`.

| Breakpoint | Width range | Check |
|---|---|---|
| `mobile` | `< 768` | `context.isMobile` |
| `tablet` | `768 – 1023` | `context.isTablet` |
| `desktop` | `1024 – 1439` | `context.isDesktop` |
| `wide` | `≥ 1440` | `context.isWide` |

Also: `context.isDesktopOrWider` → `screenWidth >= 1024` (desktop and wide), plus raw
`context.screenWidth` / `context.screenHeight` (via `MediaQuery.sizeOf`).

### `context.responsive<T>(...)`

Picks the value for the current breakpoint, **falling back toward mobile** — only `mobile` is
required:

```dart
context.responsive(mobile: 40, desktop: 96)
// tablet gets 40 (falls back to mobile); wide gets 96 (falls back to desktop).
```

Resolution order per breakpoint: `wide → desktop → tablet → mobile`, `desktop → tablet → mobile`,
`tablet → mobile`, `mobile`.

### Capability gates (`lib/core/utils/extensions.dart`)

- `context.supportsHover` — `kIsWeb && !context.isMobile`. Gates the custom cursor, hover tilt,
  and magnetic effects.
- `context.reducedMotion` — `MediaQuery.disableAnimationsOf`. **Every non-essential animation must
  check this**; the shared components already do (particles freeze, reveals render instantly,
  tilt/magnet become plain tappables, hero entrance snaps to its end state).

### Responsive values in one place

| Value | Mobile | Tablet | Desktop | Wide |
|---|---|---|---|---|
| Page gutter (`context.pageGutter`) | 16 | 32 | 48 | 48 |
| Section spacing (`context.sectionSpacing`) | 60 | 80 | 120 | 120 |
| Section title style | `displayM` (40) | `displayL` (56) | `displayXL` (72) | `displayXL` (72) |
| Hero statement size | 52 | 72 | 96 | 108 |
| Particle count (default) | 30 | 70 | 70 | 70 |
| Custom cursor / tilt / magnetism | off | on (web) | on (web) | on (web) |
| Section rail | hidden | shown | shown | shown |
