# Architecture

**polymorphism** — Raihan Fadli's portfolio. A single-page Flutter web app built on the
"Precision in Motion / Deep Space Elegance" design language: one continuous scroll surface of
full-bleed "chapters", a custom cursor, scroll-driven typography, and a deliberately tiny
state-management footprint.

- Flutter 3.41.x / Dart 3.11.x, web-first (also renders fine on touch devices — hover-only
  features are gated off).
- `flutter analyze` is kept at **zero issues** under a strict ~150-rule lint set
  (package imports only, trailing commas, expression bodies, const everywhere).

---

## 1. Folder structure — why `core` / `data` / `shared` / `features`

```
lib/
├── main.dart                  # runApp(MaterialApp.router) — nothing else
├── core/                      # App-wide plumbing. No widgets that render content.
│   ├── constants/             #   strings.dart, assets.dart — every literal lives here
│   ├── router/                #   app_router.dart — GoRouter config
│   ├── services/              #   email_service.dart — EmailJS REST (keys via --dart-define)
│   ├── theme/                 #   app_tokens.dart (colors/spacing/radii/AppDurations/AppCurves),
│   │                          #   app_typography.dart, app_theme.dart
│   └── utils/                 #   responsive.dart (breakpoints), extensions.dart (reducedMotion,
│                              #   supportsHover, pageGutter, subProgress)
├── data/                      # Content layer — the only place real-world facts exist.
│   ├── models/                #   Project, CareerEvent, Skill (immutable value types)
│   └── portfolio_data.dart    #   PortfolioData: static lists of all 6 projects, career
│                              #   timeline, skills, social URLs. Single source of truth.
├── shared/                    # Reusable presentation — visual vocabulary, content-agnostic.
│   ├── animations/            #   scroll_reveal.dart
│   ├── painters/              #   particle_painter, grid_painter, glow_painter (CustomPainters)
│   └── widgets/               #   glass_card, custom_cursor, hover_card, cta_button,
│                              #   magnetic_button, tech_badge, section_header, section_rail,
│                              #   noise_overlay, gradient_text
└── features/                  # The actual page, one folder per "chapter".
    ├── shell/                 #   portfolio_shell.dart (root Stack + scroll), floating_nav.dart
    ├── intro/                 #   intro_screen.dart (preloader)
    ├── hero/                  #   hero_section.dart + hero_portrait.dart (mask reveal)
    ├── about/                 #   about_section.dart, skills_grid.dart
    ├── works/                 #   works_section.dart, project_card.dart, project_detail.dart
    ├── experience/            #   experience_section.dart (career timeline)
    ├── statement/             #   statement_section.dart (scroll-scrubbed typography)
    └── contact/               #   contact_section.dart, availability_badge.dart, portfolio_footer.dart
```

**The rationale is dependency direction.** Allowed imports flow one way:

```
features ──> shared ──> core
features ──> data  ──> (models only)
```

- **`core`** is leaf-level infrastructure: tokens, routing, utilities. It imports nothing from
  the other three layers, so changing a section can never break the theme.
- **`data`** isolates *content* from *presentation*. Rewriting copy, adding a project, or
  updating the career timeline touches `portfolio_data.dart` and nothing else; sections are
  templates that render whatever `PortfolioData` provides.
- **`shared`** holds the design system's widget vocabulary (glass, glow, badges, reveals).
  These widgets know about tokens but not about projects or sections — so the Works card and
  the Contact form can share the same `GlassCard` without coupling.
- **`features`** are vertical slices, one per page chapter. Each section is self-contained
  (its own animation controllers, its own layout) and exposes a single widget. The shell
  composes them; sections never import each other.

Naming notes: design tokens use `AppDurations`/`AppCurves` (the `App` prefix avoids colliding
with Flutter's own `Durations`), background is `AppColors.deepSpace` (#080810), accents are
teal `#00F5C4` and violet `#7B5CF0`.

---

## 2. Data flow

```
                         ┌────────────────────────────┐
                         │   data/portfolio_data.dart │
                         │  PortfolioData (static)    │
                         │  projects · career · skills│
                         │  socials · projectById(id) │
                         └──────────┬─────────────────┘
              compile-time reads    │
      ┌──────────────┬──────────────┼───────────────┬──────────────┐
      ▼              ▼              ▼               ▼              ▼
 WorksSection   AboutSection  ExperienceSection  FloatingNav   ContactSection
 ProjectDetail  (skills)      (timeline)         (social urls) (email via
 (via router                                                    EmailService)
  /work/:id)

──────────────────────────── runtime, scroll-driven ────────────────────────────

 ScrollController (_scroll, owned by PortfolioShell)
      │ _onScroll() listener
      ├─► _progress     : ValueNotifier<double>  (pixels / maxScrollExtent)
      │        └─► SectionRail (progress hairline)
      ├─► _navVisible   : ValueNotifier<bool>    (pixels > 0.8 × viewport)
      │        └─► FloatingNav (slide/fade in after the hero)
      ├─► _activeSection: ValueNotifier<int>     (GlobalKey hit-test, ~24 px throttle)
      │        ├─► FloatingNav (active link underline)
      │        └─► SectionRail (active dot/title)
      └─► StatementSection._onScroll  (its own listener on the same controller)
               └─► _progress: ValueNotifier<double> ─► per-word illumination

──────────────────────────── runtime, pointer-driven ───────────────────────────

 Listener(onPointerHover/Move) in PortfolioShell
      └─► CursorController.position : ValueNotifier<Offset>   (singleton)
 CursorTarget(MouseRegion onEnter/onExit) — sprinkled on every interactive widget
      └─► CursorController.intent   : ValueNotifier<CursorIntent> idle|link|view|text
 PortfolioShell (post-frame)
      └─► CursorController.visible  : ValueNotifier<bool>     (only on hover devices)
               all three ──► CustomCursorOverlay (topmost layer, IgnorePointer)
```

Key property: **scroll events fan out through `ValueNotifier`s, so nothing rebuilds the
scroll content itself.** The shell's build method runs once; only the leaf
`ValueListenableBuilder`s (nav links, rail, statement words, cursor) rebuild per event.

---

## 3. Widget tree overview

### Shell (`features/shell/portfolio_shell.dart`)

The root `Stack` defines the global z-order, bottom to top:

```
Scaffold (deepSpace background)
└── MouseRegion(cursor: none)            ← hover devices only; hides OS cursor
    └── Listener(onPointerHover/Move)    ← feeds CursorController.position;
        │                                  HitTestBehavior.translucent so hit-testing
        │                                  underneath is untouched
        └── Stack
            ├── [0] Scroll content        SmoothScrollWeb (Lenis, hover+motion only)
            │       └── SingleChildScrollView (HeroSnapScrollPhysics over Bouncing)
            │           └── Column
            │               ├── SizedBox(h: screen) → HeroSection      key[0]
            │               ├── AboutSection                            key[1]
            │               ├── WorksSection                            key[2]
            │               ├── ExperienceSection                       key[3]
            │               ├── StatementSection(scrollController)      key[4]
            │               ├── ContactSection                          key[5]
            │               └── PortfolioFooter
            ├── [1] FloatingNav           Positioned.fill; hidden during hero
            ├── [2] SectionRail           right-edge progress rail + section dots
            ├── [3] IntroScreen           Positioned.fill; only while !_introDone
            ├── [4] NoiseOverlay          film grain over EVERYTHING incl. intro
            └── [5] CustomCursorOverlay   topmost; IgnorePointer; hover devices only
```

`HeroSnapScrollPhysics` keeps the wheel glued to the hero: inside the first viewport-height,
a ballistic release spring-snaps to either `0` or `heroHeight` — the first chapter turn is
all-or-nothing.

Section navigation (`_scrollToSection`) measures the target's `RenderBox` via its `GlobalKey`
and animates with a distance-proportional duration (600–1800 ms, `AppCurves.travel`).

### FloatingNav (`features/shell/floating_nav.dart`)

```
ValueListenableBuilder(visible)
└── Stack
    ├── _MobileMenu (when open)        fullscreen scrim, staggered item reveals
    └── Align(topCenter)
        └── AnimatedSlide + AnimatedOpacity (in/out with AppCurves.enter/exit)
            └── ClipRRect(pill) → BackdropFilter(blur 20)   ← glassmorphism
                └── Row: logo (back-to-top) ·
                    desktop: _NavLink × 4 (ValueListenableBuilder(activeSection))
                             | divider | GitHub · LinkedIn | "SAY HELLO" pill
                    mobile:  hamburger ↔ close toggle
```

### IntroScreen (`features/intro/intro_screen.dart`)

```
GestureDetector(onTap: skip)
└── AnimatedBuilder(merge: _entrance, _clock, _outro)
    └── Opacity(1 − outro) → Transform.scale(1 + 0.04·outro)   ← dissolve into hero
        └── ColoredBox(deepSpace)
            └── Stack: Center(logo wipe → progress hairline → 000-100 counter)
                       bottom: skip hint
```

Three controllers: `_entrance` (logo wipe), `_clock` (engineered 1.6 s counter pacing),
`_outro` (dissolve). The counter shows `min(clock, realAssetProgress)` while
`precacheImage` decodes `AppAssets.preload` — it never claims 100 % before the page is
actually ready, and only runs long if assets genuinely lag. Tap anywhere skips.

### HeroSection (`features/hero/hero_section.dart`)

```
Stack(expand)
├── HeroPortrait        low-poly base + cursor-mask reveal of colour+work + scrim
├── ParticleField       faint drifting motes (IgnorePointer, above the portrait)
└── SafeArea → AnimatedBuilder(_entrance) → left-constrained Column:
        AvailabilityBadge (slides in) → kinetic statement (ClipRect width-factor
        wipes) → subtitle (fade-up) → CTA row (slide-up) → reveal + scroll hints
```

The hero content is left-constrained so the revealed face (centre-right) stays
clear; the whole column is wrapped in the fill-or-scroll
`ConstrainedBox(minHeight) + IntrinsicHeight` pattern so it never overflows a
short viewport.

The "ALIVE." period pulses teal on the `_loop` controller; the statement is wrapped in
`Semantics(header) + ExcludeSemantics` so screen readers get one clean string instead of
per-word fragments.

### Works / About / Experience / Contact

All follow the same pattern: `SectionHeader` + content wrapped in `ScrollReveal`s with
staggered `delay`s. WorksSection renders `ProjectCard`s (hover tilt via `HoverCard`,
`CursorTarget(intent: view)` → the cursor ring grows to 64 px with "VIEW" inside); tapping
pushes `/work/:id`. ContactSection submits through `EmailService` (EmailJS REST).

### StatementSection (`features/statement/statement_section.dart`)

```
Container(height: 1.0–1.6 × screen)
└── Column(spaceEvenly)
    └── per line: ValueListenableBuilder(_progress)
        └── Wrap of words — each Opacity + Transform.translate(24px → 0)
```

### ProjectDetailPage (`features/works/project_detail.dart`, route `/work/:id`)

Pushed *on top of* the shell via go_router's nested route, so the shell keeps its scroll
position and the card→detail `Hero` flight is preserved. Transition: fade + 4 % vertical
slide (`CustomTransitionPage`, `AppCurves.travel`). Unknown ids redirect to `/`.

---

## 4. Animation system

Three distinct mechanisms, never mixed within one effect:

### a) Entrance choreography (time-driven, plays once)

A single `AnimationController` paces a multi-element timeline; elements carve out their beat
with `subProgress(start, end)` (a 0–1 → 0–1 remap from `extensions.dart`).

- **Intro**: ~2.2 s — logo wipe, counter 000→100, dissolve.
- **Hero**: 1.2 s `_entrance`, started only when `play` flips true (i.e. after the intro
  dissolves): 100 ms badge → 200/400/600 ms line wipes → 800 ms subtitle → 950 ms CTAs →
  1100 ms scroll hint. `_beat(start, end)` = `AppCurves.dramatic.transform(subProgress(...))`.
- **Mobile menu**: one `_reveal` controller, each item's opacity/offset is an
  `_itemBeat(index)` slice offset by `index × 0.12`.

This is "one conductor, many instruments" — staggering by curve-slicing one controller
instead of spawning N controllers/timers.

### b) Scroll-driven (position-driven, scrubs both ways)

Progress is *computed from scroll position*, not from a clock, so reversing the scroll
reverses the animation.

- **ScrollReveal** (`shared/animations/scroll_reveal.dart`) is the hybrid bridge:
  `VisibilityDetector` fires once when ≥15 % of the child is visible, then a one-shot
  controller plays fade + 30 px slide (directions: up/down/left/right/scale/fade) with an
  optional stagger `delay`. Triggered-once-then-stays — it never un-reveals.
- **StatementSection** is fully scrubbed: a listener on the shell's `ScrollController`
  converts the section's RenderBox position into 0–1 progress, each word maps to a
  `subProgress` slice of it. Writes are debounced (`Δ > 0.002`) and flow through a
  `ValueNotifier` so only the words rebuild.
- **Shell scroll listener** drives nav visibility, the rail's progress hairline, and
  active-section detection (throttled to ~24 px steps because the GlobalKey hit-test
  walks 6 RenderBoxes).

### c) Continuous loops (ambient)

`repeat(reverse: true)` controllers and `Ticker`s for life-signs: the hero scroll-hint and
"ALIVE." dot pulse (1.6 s), background particles/glow painters, and the cursor ring — a raw
`Ticker` lerps the ring 18 % of the remaining gap per frame, which reads as ~100 ms of
organic lag behind the zero-lag inner dot.

### Reduced-motion policy

`context.reducedMotion` (`MediaQuery.disableAnimationsOf`) is checked at **every** animation
start site, not centrally:

- Entrance controllers jump to `value = 1` instead of `forward()`; loops never start.
- `ScrollReveal` sets itself revealed in `didChangeDependencies`.
- StatementSection renders every word fully shown (`shown: 1.0`).
- Lenis smooth scrolling is disabled (`useSmoothScroll = supportsHover && !reducedMotion`),
  falling back to native scrolling.
- The intro still **preloads assets** (that part is functional, not decorative) but skips the
  choreography.

Curves come exclusively from `AppCurves` (`enter`, `exit`, `travel`, `dramatic`) — there is
deliberately no linear curve in the system.

---

## 5. Responsive system

Defined in `core/utils/responsive.dart` + `core/utils/extensions.dart`:

- **Four breakpoints**: mobile < 768 · tablet 768–1023 · desktop 1024–1439 · wide ≥ 1440.
- **`context.responsive<T>(mobile:, tablet:, desktop:, wide:)`** picks a value with
  *fallback toward mobile* (mobile is the only required argument) — used for font sizes,
  spacing, grid columns, the statement scale factor, etc.
- **Semantic spacing**: `context.pageGutter` and `context.sectionSpacing` resolve per
  breakpoint so sections never hard-code horizontal padding.
- **Capability gating, not just width**: `context.supportsHover` (`kIsWeb && !isMobile`)
  gates the custom cursor, hover tilt, magnetic buttons, and Lenis smooth scroll. Touch
  devices get the native cursor/scroll and tap-first interactions; `FloatingNav` collapses
  to a hamburger + fullscreen menu on mobile.
- The hero statement additionally wraps in a `FittedBox(scaleDown)` so extreme viewports
  never clip the display type.

---

## 6. State management

**Plain `StatefulWidget` + `ValueNotifier` / `ValueListenableBuilder`. No GetX, no Riverpod,
no Bloc — deliberately.**

Why this is the right call here:

1. **The app has almost no state.** All content is compile-time static
   (`PortfolioData`); the only runtime state is scroll position, cursor position/intent,
   the intro flag, hover flags, and a contact-form submission. None of it is shared business
   state — it's presentation state with exactly one producer each.
2. **Hot paths need surgical rebuilds.** Scroll and pointer events fire every frame.
   `ValueNotifier` + `ValueListenableBuilder` rebuilds only the leaf that listens (a nav
   underline, the rail hairline, the statement words, the cursor) while the entire scroll
   content stays untouched. A reactive framework's observable graph adds overhead and
   indirection for zero benefit at this scale.
3. **No DI to mock.** There is one screen, one service (`EmailService`, a static method),
   and no tests that need to swap implementations. GetX-style service location would be
   dead weight, and its global mutable container invites exactly the coupling the
   `core/data/shared/features` layering exists to prevent.
4. **Lifecycle stays local and analyzable.** Each section owns and disposes its own
   controllers; the strict lint set can verify this. Framework magic (GetX's implicit
   `.obs` subscriptions, auto-dispose heuristics) would hide it.

Specific patterns:

- **Scroll fan-out**: `PortfolioShell` owns the single `ScrollController` and reduces its
  events into three `ValueNotifier`s (`_progress`, `_activeSection`, `_navVisible`).
  Consumers receive `ValueListenable` (read-only) — only the shell may write.
- **`CursorController` singleton** (`shared/widgets/custom_cursor.dart`): three static
  `ValueNotifier`s (`intent`, `position`, `visible`). A conscious exception to "no globals":
  the cursor is genuinely global (one per app), updated every pointer event, and consumed by
  deeply nested widgets — an `InheritedWidget` lookup on something this hot buys nothing.
  Widgets opt in declaratively via `CursorTarget(intent: ...)`.
- **Intro session flag**: `static bool _introSeen` on `_PortfolioShellState`. Static so it
  survives the shell being rebuilt on back-navigation from `/work/:id` (the intro must not
  replay within a session), but in-memory only so a fresh page load shows it again. No
  persistence layer for one bool.
- **go_router for deep links**: URL state is the one piece of state the browser owns.
  `/work/:id` is deep-linkable/shareable, unknown ids redirect home via the route's
  `redirect`, and the detail page is pushed on top of the shell so scroll position survives
  round trips. `errorBuilder` falls back to the shell.

---

## 7. Build & deploy notes

- GitHub Actions → Vercel on push to `main`.
- EmailJS keys are injected with `--dart-define` (see `.env.example`, `build_prod.sh`) —
  never committed.
- Flutter 3.41 removed the `--web-renderer` flag; do not re-add it to build scripts.
- Adding content = edit `lib/data/portfolio_data.dart` (+ assets under
  `assets/images/works/`). Adding a section = new folder under `lib/features/`, mount it in
  `portfolio_shell.dart`'s Column, add a `GlobalKey` + title + (optionally) a `NavItem`.
