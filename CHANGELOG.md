# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- **Experience timeline overflow on hover.** The tile wrapped the card in an
  `IntrinsicHeight` that measured the *collapsed* card once; hovering expanded
  the card via internal `setState` without re-measuring, so the row stayed
  short and the content overflowed. The tile is now a `Stack` where the card
  defines the height and the rail line follows it — so expansion is smooth and
  never overflows, with no `IntrinsicHeight`.
- **Hero reveal mask now follows the cursor everywhere.** It was driven by a
  MouseRegion inside the portrait that the scroll-view/text layer occluded, so
  it only fired on the bare side margins. The pointer is now fed from an
  ancestor MouseRegion (ancestors always receive hover), so the mask tracks
  across the whole hero.
- **Project detail no longer overflows.** The screenshot carousel used a fixed
  image height that overflowed the smaller interpolated box during the
  card→detail Hero flight; the image area is now `Expanded` inside a bounded
  height, so it fits any box (covered by new `ProjectDetailPage` smoke tests
  at short heights).
- "Scroll to explore" is centered across the full hero width.

### Changed

- **About fragment portrait now scatters at rest and unites on hover.** The six
  ink-drip pieces sit displaced and tilted by default; hovering slides and
  rotates them home in a staggered spring into the assembled face (touch
  devices, with no hover, still assemble on scroll-in). Fixed an opacity
  assertion from the spring curve overshooting past 1.
- **Toolkit reimagined as three immersive capability pillars** instead of a
  flat chip grid — Flutter Engineering, Product Design, and Motion & Craft,
  each a hover-reactive card with an icon tile that fills with its accent, a
  proficiency level, a tagline, the tools beneath it, a faint watermark, lift +
  glow, and an accent rail that draws in. Lives full-width below the bio.
  (Replaces the earlier focused-but-flat chip list; same visual-specialist
  scope — no Java/SQL/Material 3/GetX/Git/CI-CD/Vercel/Testing.)
- **Selected-project cards expand on hover** with a smooth animation — the
  tagline, a description snippet, and a "view project" cue slide in beneath the
  title while the image area shrinks to make room (replacing the full-image
  "VIEW PROJECT" veil with a subtle accent wash). The expand/collapse uses an
  `AnimatedSize` child-swap so the collapsed state never constrains a column to
  0 height (which overflows on desktop — a bug the same pattern would have hit
  in the experience cards, now also fixed).
- **Toolkit pillars repositioned** below the introduction, beside the fragment
  portrait, as a vertical stack of compact horizontal cards (icon tile + name +
  level + tagline + tools) instead of a full-width 3-across row.
- **Statement section elevated** from plain word-reveal into a crafted
  manifesto: giant pull-quote marks frame the verse, an `✦ ETHOS` eyebrow and a
  "WRITTEN IN DART" closing mark bracket it, the accent line is filled with the
  teal→violet gradient and glows, every word carries a soft shadow, and on
  desktop a spotlight follows the cursor so the verse reads as lit from within.
- **Experience timeline now reads oldest → most recent**, and each entry
  collapses to title/company/period, **expanding on hover** to reveal the
  description and highlight bullets (always expanded on touch / reduced motion).
- **Contact rebuilt as a balanced two-column layout** — invitation, availability,
  and direct links on the left; the form on the right (stacks on mobile).

### Added

- **Living constellation in the poetic section.** Three drifting constellations
  of linked particles sit behind the verse; each roams its own slow path and
  gathers toward the cursor, linking to it — the manifesto comes alive as you
  move across it. Hand-rolled `CustomPainter` + `createTicker` physics
  (`ConstellationField`), fed the cursor by an ancestor `MouseRegion` (so the
  verse can't occlude it) and paused via a visibility-gated `TickerMode`
  offscreen. (An earlier standalone "Playground" section exploring this was
  folded into the poetic section instead.)
- **Masked-reveal hero portrait.** The hero now features the low-poly faceted
  self on near-black; a soft circular mask follows the cursor to reveal the
  colourful, smiling self surrounded by real work — a literal "look closer" of
  the polymorphism theme. Touch devices get an autonomous drifting reveal;
  reduced motion gets a static one. The 4 MB reveal photo loads lazily after
  the hero mounts so it never gates the intro (`hero_portrait.dart`).
- **Fragment portrait in About.** The six B&W "ink-drip" portrait fragments are
  composed as a deliberately fragmented face that assembles on scroll — each
  piece sliding in from a scattered offset in a stagger — and drifts by depth
  under the pointer (`fragment_portrait.dart`).

### Changed

- Hero background: the generative gradient-field / dot-grid / glow composition
  (`hero_background.dart`) is replaced by the portrait reveal, with a faint
  particle layer retained for atmosphere. About's placeholder avatar frame is
  replaced by the fragment collage.
- Intro preload now covers the first two screens (logo, 6 project covers, 6
  fragments); the 3840×2160 hero photos decode at a capped 2048 px via a shared
  `ResizeImage` provider so the pair doesn't blow the image cache.

## [2.0.0] - 2026-06-13

Complete "Precision in Motion" redesign — every screen rebuilt around the
Deep Space Elegance design language (deep-space `#080810` base, teal
`#00F5C4` / violet `#7B5CF0` accents, glassmorphism, kinetic typography).

### Added

- Design token system: `AppColors`, `Spacing`, `Radii`, `AppDurations`,
  `AppCurves` in `lib/core/theme/app_tokens.dart`, with a typography scale in
  `app_typography.dart` — no hard-coded colors, durations, or curves in
  feature code.
- Animated intro screen with logo wipe and engineered 000→100 counter that
  tracks real asset preloading (`precacheImage`); tap to skip; plays once per
  session.
- Kinetic hero: staggered headline reveal over a layered background (animated
  mesh-gradient field with pointer parallax, dot grid, particle field, glow
  orb) and hero snap scroll physics.
- Floating glass navigation pill that appears after scrolling past the hero,
  with active-section tracking and a vertical section progress rail.
- Works as a bento grid of glass cards plus per-project detail pages at
  `/work/:id` (all 6 real projects with 3 screenshots each).
- Experience section: interactive career timeline (Lontar Lab 2019, Collega
  2020/2022).
- Statement section with scroll-scrubbed text reveal.
- Contact section with EmailJS-backed form and confetti on successful send.
- Custom cursor overlay (dot + trailing ring) on hover-capable devices.
- Shared painter library: particle field (single ticker, reduced-motion
  static frame), dot grid, radial glow, and one-time-tiled film-grain noise
  overlay.
- Scroll reveal animation system (`ScrollReveal`) built on
  `visibility_detector`, honoring `prefers-reduced-motion` throughout.
- `go_router` routing (`/`, `/work/:id`) replacing imperative navigation.
- Lenis smooth scrolling on desktop via `flutter_web_scroll`.
- Categorized skills grid in the About section (languages, frameworks, tools,
  disciplines) with staggered reveal, replacing the old skills marquee.
- Test suite: token/responsive/data unit tests, per-section layout smoke tests
  across viewports, and a full-shell composition smoke test (49 tests).

### Changed

- Typography migrated to Space Grotesk (display), Inter (body), and
  JetBrains Mono (labels/numerals) via `google_fonts`.
- Color palette migrated to deep space `#080810` with teal `#00F5C4` primary
  and violet `#7B5CF0` secondary accents.
- All content centralized in `lib/data/portfolio_data.dart` as the single
  source of truth (projects, career events, skills, socials).
- Scroll-driven UI (progress rail, nav visibility, active section) rewritten
  from per-tick `setState` to `ValueNotifier`s with a 24 px throttle on
  section hit-testing.
- Asset preloading rebuilt to decode images into the image cache during the
  intro instead of half-effective ad-hoc loading.
- Web metadata (`index.html` title, description, theme color, icons)
  refreshed to match the new identity, replacing stale defaults.
- Lint setup tightened to ~150 strict rules (package imports only, required
  trailing commas, expression function bodies, const constructors);
  `flutter analyze` is clean.

### Removed

- GetX state management, `grain`, `flutter_tilt`, and
  `stacked_card_carousel` dependencies.
- ~17 MB of dead/unused assets.
- Portrait orientation lock.

### Fixed

- setState storms on every scroll tick causing full-tree rebuilds while
  scrolling.
- Half-effective asset preload that let works screenshots pop in during
  scroll.
- Stale web meta tags and icons from the template-era build.
- Experience timeline crash: the connector line's `Expanded` reported infinite
  intrinsic height under the page's unbounded scroll, tripping `IntrinsicHeight`
  — reworked into a `Positioned` line so only the dot contributes height.
- Hero overflow on short landscape viewports (e.g. 1024×600): now fills the
  viewport but scrolls instead of overflowing.
- Availability badge overflow on mobile: the label is flexible and wraps.
- Web-only hero crash (`_RenderLayoutBuilder does not support dry layout`):
  `MagneticButton` and `HoverCard` measured themselves with a `LayoutBuilder`,
  which cannot be dry-laid-out and so crashed the hero's `IntrinsicHeight` (and
  any size-measuring ancestor) on web, where the hover path is active. Both now
  read their size from `context.size`, keeping them intrinsic-safe. This crash
  also produced a cascade of spurious "RenderFlex overflowed" errors that
  cleared once the root cause was fixed. (The crash escaped widget tests
  because `kIsWeb` is false there, disabling the hover path entirely — a
  reminder that web-gated code needs a real browser render.)
- Floating nav overflow with real fonts: the desktop cluster (logo + 4 links +
  socials + Say Hello) exceeded the old 720 px cap once JetBrains Mono loaded.
  The pill cap is now 880 px and it collapses to the hamburger below 920 px,
  on its own breakpoint independent of the global mobile one. (Also browser-
  only: test fonts fall back to narrower metrics, hiding the overflow.)

### Performance (post-review hardening)

- Hero wrapped in a `TickerMode` keyed to visibility — the statement-dot loop,
  gradient drift, particle field, and availability pulse all mute when the hero
  scrolls offscreen, restoring idle frames.
- Each section isolated in a `RepaintBoundary`; pulsing `.` on **ALIVE**
  animates colour only (paint) instead of its shadow (which forces re-layout).
- Intro preload trimmed to first-paint assets (logo, avatar, 6 card images);
  the 12 detail-only screenshots load lazily on `/work/:id`, with `onError` so
  a broken image can't hang the intro.
- Custom cursor gated on a real mouse pointer (no stray cursor on touch
  tablets ≥ 768 px) and self-isolated in a `RepaintBoundary` with a ticker that
  idles once the ring converges.

## [1.0.0]

- Original portfolio release: GetX-based single-page Flutter web portfolio
  with the previous visual identity.

[2.0.0]: https://github.com/lraihan/polymorphism/releases/tag/v2.0.0
[1.0.0]: https://github.com/lraihan/polymorphism/releases/tag/v1.0.0
