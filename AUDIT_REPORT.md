# AUDIT REPORT — Polymorphism Portfolio

> Phase 0 deliverable of the "Precision in Motion" redesign.
> Audit date: 2026-06-13 · Auditor: Claude (Senior Visual Engineer mode)

---

## 1. Environment & Platform

| Item | Finding |
|---|---|
| Flutter | 3.41.6 stable (engine 425cfb54d0) |
| Dart SDK | 3.11.4 — `pubspec.yaml` constraint `^3.7.0` |
| Primary target | **Web** (deployed to Vercel via GitHub Actions on push to `main`) |
| Secondary scaffolding | android/, ios/, linux/, macos/, windows/ — template defaults, never customized (android package is still `com.example.project_master_template`) |
| CI/CD | `.github/workflows/flutter_web.yml` → build with EmailJS `--dart-define`s → deploy `build/web` to Vercel |
| Lints | `flutter_lints` + ~160 hand-picked strict rules (`always_use_package_imports`, `prefer_expression_function_bodies`, `require_trailing_commas`, …) |
| Tests | **None.** No `test/` directory exists. |

## 2. Current Architecture

```
lib/
├── core/            constant.dart (% -of-screen padding helpers), services/ (asset_preloader, email_service), theme/
├── data/models/     career_event.dart (the only data model)
├── modules/         home (hero, about, skills, home_page), contact, standout, timeline, works
├── shared/          animations/scroll_reveal, footer, scroll_timeline_indicator, widgets/ (6 widgets)
└── shell/           app_shell (MaterialApp + 3-phase boot), controllers/app_shell_controller (GetX)
```

- **State management:** GetX — but only two trivial controllers (boot phases, timeline events list). Massive dependency for ~60 lines of state.
- **Routing:** none. Single page, `ScrollController` + `GlobalKey` anchor scrolling, custom hero snap physics, Lenis-style smooth scroll (`flutter_web_scroll`) on web.
- **Boot sequence:** AssetLoadingScreen (indeterminate bar + min 1.5 s) → CurtainLoader (logo + curtain split, ~4 s) → fade/scale into HomePage wrapped in `GrainFiltered` (package `grain`).
- **Theme:** dark-only Material 3. Bebas Neue (display) + Inconsolata (body) via google_fonts. Palette: bg `#1A1F2B`, accent blue `#4E9AF1`, moonGlow amber `#E6B980`. One stray hardcoded `fontFamily: 'Nunito'` in glass_navbar.

## 3. Screen & Component Inventory

| Section (scroll order) | File | Notable behavior |
|---|---|---|
| Hero | `cursor_reveal_hero_section.dart` | "I BUILD THE QUIET SPACE- / WHERE FUNCTION AND BEAUTY MEET." over a full-bleed photo; cursor-following circular mask reveals an alternate image (desktop web only) |
| About | `about_section.dart` | One-line bio + animated stat counters (5+ yrs, 10+ projects, ∞ coffee) |
| Skills | `skills_marquee_section.dart` | Two counter-scrolling marquee rows of 20 skill chips |
| Timeline | `timeline_section.dart` + `timeline_strip.dart` | Alternating left/right career cards, dots fill + line draws on scroll |
| Works | `works_section.dart` | 783 lines. Light "paper" header w/ horizontal kinetic text ("DESIGNED WITH LOGIC"), then 6 full-viewport project blocks with 3-image carousels + `flutter_tilt` |
| Stand Out | `standout_section.dart` | Scroll-scrubbed word-by-word poem: "(A promise,) made of pixels, blossoms in the dart." |
| Contact | `contact_section.dart` | Form → EmailJS (env-injected keys) with mailto: fallback. Material-default styling |
| Footer | `footer.dart` | © · email · **live Jakarta clock** (ticks every second) · GitHub/LinkedIn/Instagram |
| Chrome | `glass_navbar.dart` (blur navbar, text-scramble hover), `scroll_timeline_indicator.dart` (right-edge dot rail) | always-visible navbar (spec wants it hidden during hero) |

Shared widgets: `ScrollReveal` (visibility_detector, fade+rise once), `MagneticButton` (cursor-pull hover), `AmbientParticleLayer` (22-dot drift painter — **declared but mounted nowhere**), `AnimatedCounter`, `CurtainLoader`, `AssetLoadingScreen`.

## 4. Real Content Inventory (MUST be preserved)

This is a **live portfolio with real content** — not a template. The redesign prompt assumes placeholder content; that assumption is false. Real content supersedes placeholders everywhere it exists.

- **Owner:** Raihan (Raihan Fadli) — "visual engineer", Jakarta, Indonesia (GMT+7).
- **Bio:** "I'm Raihan, visual engineer. I use Flutter and Figma to craft digital anatomies…"
- **Projects (6, each with 3 real screenshots in `assets/images/works/`):**
  1. **FE Touch** — tablet app for bank tellers (PT Collega Inti Pratama) — landscape
  2. **Core X** — core banking replacement for Olibs 724 — landscape
  3. **Panic Button** — SOS app for Damkar Banten — portrait/mobile
  4. **Digital Lending** — end-to-end online loan platform — portrait/mobile
  5. **Lelang Online** — live auction platform — portrait/mobile
  6. **Roast POS** — restaurant ops: POS, inventory, dashboards — landscape
- **Career:** 2019 Intern Mobile Dev @ Lontar Lab (Bandung) → 2020 Java SE @ PT Collega Inti Pratama (Jakarta) → 2022 Flutter Developer @ Collega → present "Continuous Growth".
- **Skills:** Flutter, Dart, Java, Figma, GetX, REST APIs, UI/UX, Animation, Material 3, Firebase, Git, CI/CD, Vercel, Responsive, Accessibility, Performance, Testing, Architecture, State Mgmt.
- **Contact:** lraihan@hackermail.com · EmailJS integration (secrets via `--dart-define`) · github.com/lraihan · linkedin.com/in/raihan-fadli-dev · instagram.com/locio_raihan
- **Voice/copy worth keeping:** "This creation is a confession, written in dark and dart." · the Stand-Out poem · "My logic blossoms into experience."
- **Assets in active use:** avatar.png, logo.png, 18 project screenshots.

## 5. Technical Debt (severity-ranked)

| # | Severity | Issue |
|---|---|---|
| 1 | **High** | `setState` on every scroll tick in WorksSection, StandOutSection, TimelineStrip, ScrollTimelineIndicator → rebuilds whole subtrees ~60×/s while scrolling. No `RepaintBoundary` anywhere. |
| 2 | **High** | ~10 MB of dead assets shipped & preloaded: `Background--.jpg`, `*-legacy.jpg`, `fragment1-6.png`, `complete.png` are referenced only by the preloader (or nothing) yet downloaded by every visitor. `Background.jpg` alone is 4.1 MB. |
| 3 | **High** | No tests at all. |
| 4 | **Medium** | GetX imported for two trivial controllers; `stacked_card_carousel` is fully unused; `grain` (v0.0.1, abandoned) wraps the entire app. |
| 5 | **Medium** | Works section: 6 stacked full-viewport blocks = ~7 screens of scroll for 6 projects; light paper texture clashes with the dark identity; near-duplicate 200-line carousel classes (`_ProjectImageCarousel` vs `…Mobile`). |
| 6 | **Medium** | `web/index.html`: theme-color `#64FFDA` matches nothing in the app; no font preloading; OG image points at a generic Flutter icon. |
| 7 | **Low** | Navbar always visible over hero (spec: appear after hero); nav indices hardcoded (skips 3 & 5 in compact); `main.dart` forces portrait orientation **on a web app**; duplicated `_getResponsiveFontSize` helpers in 4 files; magic numbers (`cycle = 1600.0`) in marquee. |
| 8 | **Low** | `AppShellController.canShowApp`/`assetsPreloaded` unused; AssetPreloader "preloads" via `rootBundle.load` (bytes only — images are not decoded into the image cache, so the preload is half-effective). |

## 6. Keep / Refactor / Rebuild

### KEEP (move, don't touch semantics)
- All real content (§4) — extracted into typed data files under `lib/data/`.
- `EmailService` (EmailJS + env config + validation), `.env.example`, Vercel workflow.
- `MagneticButton` — already excellent; matches the new spec's micro-interaction bar.
- Jakarta live clock, social links, text-scramble hover idea, Stand-Out poem concept.
- Strict `analysis_options.yaml`.

### REFACTOR (re-theme / extend)
- `ScrollReveal` → add direction/scale variants, configurable offset, stagger-friendly API.
- Particle painter → rewrite to spec (60–80 desktop / 30 mobile, teal/white, shooting-star, `RepaintBoundary`, reduced-motion static frame) and actually mount it.
- Footer → re-theme into Contact section's footer.
- Scroll progress rail → restyle as mono-numbered section markers.

### REBUILD (new design system)
- Theme/tokens → "Deep Space Elegance": bg `#080810`, accent `#00F5C4`, violet `#7B5CF0`, Space Grotesk / Inter / JetBrains Mono.
- Boot → single intro screen: logo mark + engineered progress counter (drives real asset decode), skip-on-tap, ≤2.5 s.
- Hero → kinetic staggered type "BUILDING THINGS THAT FEEL ALIVE." + animated gradient field + dot grid + particles + status badge. (Generative background replaces the 4 MB photos → page weight drops ~9 MB.)
- Nav → floating glass pill, hidden during hero, active-section highlight, fullscreen mobile menu.
- About → gradient-framed avatar w/ viewfinder corner marks + bio + categorized skills grid (replaces marquee; real skills).
- Works → editorial bento grid (2 featured + 4 standard, real screenshots, category tags, tech badges, 3D hover tilt) + fullscreen project detail overlay with screenshot carousel.
- Experience → spec timeline (draw-down line, filling dots, slide-in cards) with real career data.
- Contact → dark custom inputs w/ teal focus ring, pulsing availability badge, animated send button + confetti success; EmailJS wiring preserved.
- Custom cursor (dot + lagging ring, contextual morphs), noise overlay, glass card system.

### DROP
- Packages: `get`, `grain`, `stacked_card_carousel`, `flutter_tilt` (replaced by custom matrix tilt). Add: `go_router`, `flutter_animate`, `confetti`.
- Dead assets (legacy backgrounds, fragments, complete.png) — removed from preload + pubspec; files moved out of shipped assets.
- Portrait-orientation lock in `main.dart`.

## 7. Risks & Constraints

- **EmailJS keys** come from `--dart-define`; local runs without them fall back to mailto: — acceptable, keep behavior.
- `--web-renderer` flag no longer exists in Flutter 3.41 (CanvasKit is the default); build scripts/docs must not cargo-cult it.
- Heavy use of `BackdropFilter` must be budgeted (one nav + sparing glass cards), it's the main jank source on low-end machines.
- Redesign happens in-place on `main`'s working tree; nothing is committed until explicitly requested, and git history preserves the old implementation.
