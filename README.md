# Polymorphism — Portfolio of Raihan Fadli

> **Precision in Motion.** A Flutter Web portfolio built on the "Deep Space Elegance" design language — generative backgrounds, kinetic typography, and a custom motion system, all rendered at 60 fps.

**Live:** `https://your-deployment-url.vercel.app` <!-- TODO: replace with production URL -->

Raihan Fadli is a visual engineer based in Jakarta, Indonesia, balancing engineering, art, and design. This repository is both his live portfolio and a reference implementation of a heavily animated, token-driven Flutter web app.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.41+ (web, CanvasKit renderer) |
| Language | Dart 3.11+ |
| Routing | [go_router](https://pub.dev/packages/go_router) — `/` and deep-linkable `/work/:id` |
| Typography | [google_fonts](https://pub.dev/packages/google_fonts) — Space Grotesk, Inter, JetBrains Mono |
| Smooth scrolling | [flutter_web_scroll](https://pub.dev/packages/flutter_web_scroll) (Lenis-style) |
| Icons | [lucide_icons_flutter](https://pub.dev/packages/lucide_icons_flutter) |
| Motion extras | [confetti](https://pub.dev/packages/confetti), custom painters & implicit animations |
| Visibility-driven reveals | [visibility_detector](https://pub.dev/packages/visibility_detector) |
| Contact form | [EmailJS](https://www.emailjs.com/) over [http](https://pub.dev/packages/http), keys injected via `--dart-define` |
| CI/CD | GitHub Actions → Vercel on push to `main` |

### Architecture at a Glance

```
lib/
├── core/        # design tokens (app_tokens, app_typography, app_theme),
│                # constants, router, responsive utils, email service
├── data/        # models + portfolio_data.dart — single source of ALL content
├── shared/      # painters (particles/grid/glow), glass cards, custom cursor,
│                # magnetic buttons, scroll-reveal animations
└── features/    # intro, hero, about, works, experience, statement, contact,
                 # shell (portfolio_shell + floating_nav)
```

---

## Quick Start

```bash
git clone https://github.com/lraihan/polymorphism.git
cd polymorphism
flutter pub get
flutter run -d chrome
```

The app runs fully without configuration — the contact form simply falls back to a `mailto:` link until EmailJS keys are provided (see [Configuration](#configuration)).

## Environment Requirements

| Requirement | Version |
|---|---|
| Flutter SDK | **3.41 or newer** (stable channel) |
| Dart SDK | **3.11 or newer** (ships with Flutter) |
| Browser | Any modern browser; Chrome recommended for development |

Verify with `flutter doctor` and `flutter --version`.

## Building for Web

```bash
# Debug / local
flutter run -d chrome

# Release build (output in build/web/)
flutter build web --release
```

> **Note:** the `--web-renderer` flag **no longer exists** in Flutter 3.41+. CanvasKit is the default renderer — do not copy older tutorials that pass `--web-renderer canvaskit`.

The `android/`, `ios/`, `linux/`, `macos/`, and `windows/` directories are untouched platform scaffolds. **Web is the only supported and deployed target.**

## Configuration

All personal content lives in exactly two places — edit these to make the portfolio yours:

| File | What it holds |
|---|---|
| `lib/data/portfolio_data.dart` | Projects (titles, descriptions, screenshots, tech stacks), career timeline, skills, social links |
| `lib/core/constants/strings.dart` | Site title, hero copy, section headings, bio, contact copy |

Project screenshots go in `assets/images/works/` (three per project) and are registered in `pubspec.yaml`.

Design tokens (colors, durations, curves, spacing) live in `lib/core/theme/app_tokens.dart`; typography in `lib/core/theme/app_typography.dart`.

### EmailJS (contact form)

The contact form sends real email through EmailJS. Credentials are injected at build time via `--dart-define` and are never committed:

```bash
cp .env.example .env.local   # then fill in your credentials
```

| Variable | Source |
|---|---|
| `EMAILJS_SERVICE_ID` | EmailJS dashboard → Services |
| `EMAILJS_TEMPLATE_ID` | EmailJS dashboard → Email Templates |
| `EMAILJS_PUBLIC_KEY` | EmailJS dashboard → Account → API Keys |

Run with the keys:

```bash
flutter run -d chrome \
  --dart-define=EMAILJS_SERVICE_ID="..." \
  --dart-define=EMAILJS_TEMPLATE_ID="..." \
  --dart-define=EMAILJS_PUBLIC_KEY="..."
```

Without keys, the form gracefully degrades to a `mailto:` fallback. Full walkthrough: [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md).

## Deployment

### Vercel via GitHub Actions (primary)

Every push to `main` triggers `.github/workflows/flutter_web.yml`, which builds the web bundle with the EmailJS `--dart-define`s and deploys `build/web` to Vercel. Required repository secrets:

- `EMAILJS_SERVICE_ID`, `EMAILJS_TEMPLATE_ID`, `EMAILJS_PUBLIC_KEY`
- `VERCEL_TOKEN`

### Manual production build

```bash
./build_prod.sh
```

The script loads `.env.production` (or system/CI environment variables), validates that all three EmailJS variables are set, and produces a release build in `build/web/`.

### Alternative hosts

- **Firebase Hosting** — `flutter build web --release`, then `firebase init hosting` (public dir: `build/web`) and `firebase deploy`.
- **GitHub Pages** — `flutter build web --release --base-href "/<repo-name>/"`, then publish `build/web` to the `gh-pages` branch.

## Contributing

This is a personal portfolio, but fixes and improvements are welcome:

1. Fork and create a feature branch from `main`.
2. Keep `flutter analyze` clean — the project enforces ~150 strict lint rules (package imports only, `require_trailing_commas`, `prefer_expression_function_bodies`, `prefer_const_constructors`, …). No warnings, no exceptions.
3. Respect the design system: use tokens from `app_tokens.dart` (`AppDurations`, `AppCurves`, color constants) rather than hardcoding values.
4. Keep content in `lib/data/portfolio_data.dart` / `lib/core/constants/strings.dart` — never inline copy inside widgets.
5. Open a pull request with a clear description of the change.

## Documentation

- [`docs/`](docs/) — design language, architecture notes, and development guides
- [`AUDIT_REPORT.md`](AUDIT_REPORT.md) — the pre-redesign audit (architecture, technical debt, keep/refactor/rebuild decisions)
- [`CHANGELOG.md`](CHANGELOG.md) — release history
- [`ENVIRONMENT_SETUP.md`](ENVIRONMENT_SETUP.md) — EmailJS environment variable setup

## Contact

- Email: [lraihan@hackermail.com](mailto:lraihan@hackermail.com)
- GitHub: [@lraihan](https://github.com/lraihan)
- LinkedIn: [Raihan Fadli](https://www.linkedin.com/in/raihan-fadli-dev/)
- Instagram: [@locio_raihan](https://www.instagram.com/locio_raihan/)

---

Built with Flutter Web ✦ Jakarta, Indonesia
