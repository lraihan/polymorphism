# Project Context: Polymorphism Portfolio

## Executive Summary

`polymorphism` is a Flutter Web portfolio for Raihan Fadli, positioned around the identity of an "Ultimate Polymorphism" or visual engineer: someone who blends Flutter engineering, UI/UX design, animation, and product storytelling.

The app is a single-page, scroll-driven portfolio experience. It does not use route-based navigation for different pages. Instead, it composes multiple full-screen or long-form sections inside one `SingleChildScrollView`, then navigates between sections using a shared `ScrollController`, `GlobalKey`s, a glass navbar, and a vertical scroll progress indicator.

The current experience highlights:

- A cinematic loading flow with asset preloading and a curtain reveal.
- A desktop-only cursor reveal hero interaction that masks between foreground/background images.
- Responsive about, career timeline, works, standout typography, contact, and footer sections.
- Project showcases with image carousels and tilt effects.
- A contact form powered by EmailJS build-time environment variables with `mailto:` fallback.
- Static web deployment support, especially for Vercel-style hosting.

## Repository Metadata

- Repository: `lraihan/polymorphism`
- Current branch: `main`
- Default branch: `main`
- Primary platform: Flutter Web
- Supported platform folders present: Android, iOS, Linux, macOS, Web, Windows
- Dart SDK constraint: `^3.7.0`
- Version: `1.0.0+1`
- License: MIT

## Technology Stack

### Runtime And Framework

- Flutter: cross-platform UI framework, with this project primarily built as a web portfolio.
- Dart: app language and build-time environment variable integration through `String.fromEnvironment`.
- Material 3: enabled in the custom theme.
- GetX: dependency injection and reactive state for shell loading and timeline state.

### UI, Animation, And Visual Libraries

- `google_fonts`: Bebas Neue and Inconsolata typography through `AppTheme`.
- `visibility_detector`: triggers one-time scroll reveal animations.
- `grain`: wraps the finished home page in a grain filter.
- `auto_size_text`: responsive text fitting in the about section.
- `flutter_tilt`: tilt/parallax-like interaction for project screenshots.
- `lucide_icons_flutter`: Instagram icon in the footer.
- Flutter animation primitives: `AnimationController`, `Tween`, `CurvedAnimation`, `AnimatedBuilder`, `AnimatedContainer`, `PageView`, custom `CustomClipper`, and custom `ScrollPhysics`.

### Networking And External Integration

- `http`: posts contact form payloads to EmailJS.
- `url_launcher`: opens `mailto:` fallback and social links.
- `intl`: formats the Jakarta time display in the footer.

### Development And Quality

- `flutter_lints`: baseline Flutter lint set.
- `analysis_options.yaml`: strict analyzer/linter configuration with many style, correctness, and API rules enabled.
- No test files currently exist under `test/`.

## High-Level App Architecture

The application is organized around a simple layered structure:

```text
lib/
  main.dart
  core/
    constant.dart
    services/
    theme/
  data/
    models/
  modules/
    contact/
    home/
    standout/
    timeline/
    works/
  shared/
    animations/
    footer/
    widgets/
  shell/
    app_shell.dart
    controllers/
```

### Architectural Pattern

This is not a heavily abstracted clean architecture app. It is a focused portfolio app with:

- `shell/` for app lifecycle, loading state, and top-level Material app setup.
- `core/` for constants, theme tokens, and external services.
- `data/` for simple static domain models.
- `modules/` for portfolio sections.
- `shared/` for reusable UI primitives and cross-section components.

Most state is local widget state. GetX is used sparingly for app-shell loading state and timeline active state.

## App Entrypoint And Runtime Lifecycle

### Entrypoint

`lib/main.dart` performs three actions:

1. Calls `WidgetsFlutterBinding.ensureInitialized()`.
2. Locks preferred device orientation to portrait up/down.
3. Runs `AppShell`.

The orientation lock matters more for mobile/tablet contexts. For web desktop, layout still responds to screen width.

### Shell Lifecycle

`lib/shell/app_shell.dart` owns the top-level `MaterialApp` and the staged loading experience.

The shell creates or retrieves `AppShellController` using `Get.put(AppShellController())`, then renders one of three phases through `Obx`:

1. `AssetLoadingScreen` while `controller.isPreloading` is true.
2. `CurtainLoader` while `showCurtainLoader` is true and `isReady` is false.
3. The main app once `isReady` is true.

After the curtain completes, `AppShell` fades and subtly scales in the `HomePage`, wrapped in `GrainFiltered`.

### Loading Flow

`AppShellController` starts preloading in `onInit()`:

1. `AssetPreloader.preloadAssets()` loads declared image assets from the root bundle.
2. The controller waits a minimum 1500 ms for smoother perceived UX.
3. `isPreloading` becomes false.
4. `showCurtainLoader` becomes true.
5. `CurtainLoader` plays its logo/text/curtain animation.
6. `onCurtainComplete()` sets `isReady` to true.
7. `AppShell` starts its fade/scale animation into `HomePage`.

`AssetPreloader` is implemented as a singleton and marks itself preloaded even if an individual image fails, so the app does not permanently block on a missing asset.

## Main Page Composition

`lib/modules/home/pages/home_page.dart` is the single-page composition root. It creates:

- One shared `ScrollController`.
- Six section `GlobalKey`s.
- Six section titles: Hero, About, Timeline, Works, Stand Out, Contact.
- A debounced/timed navigation function for section jumps.
- A custom `HeroSnapScrollPhysics`.

The page is rendered as a `Stack`:

1. `SingleChildScrollView` containing the portfolio sections.
2. `GlassNavbar` positioned at the top.
3. `ScrollTimelineIndicator` positioned on the right side.

### Section Order

The scroll content is ordered as:

1. `CursorRevealHeroSection`
2. `AboutSection`
3. `TimelineSection`
4. `WorksSection`
5. `StandOutSection`
6. `ContactSection`
7. `Footer`

The navbar shows About, Timeline, Works, and Contact on wider screens. On small screens it shows a compact horizontal nav with About, Works, and Contact.

The hero's explore action currently scrolls to section index `3`, which is the Works section.

### Scroll Navigation

There are two navigation helpers:

- `_scrollToSection(index)`: used by the scroll timeline and hero/explore style navigation. It subtracts an 80 px offset when a section context is available.
- `_scrollToSectionFromNavbar(index)`: used by the navbar. It scrolls directly to the section top without the 80 px subtraction.

Both helpers:

- Guard invalid indexes.
- Cancel any previous navigation timer.
- Wait 250 ms before calculating the target.
- Prefer measuring the section via `RenderBox.localToGlobal`.
- Fall back to proportional scroll positions when a context is unavailable.
- Animate over 2000 ms with `Curves.easeInOutCubic`.

### Hero Snap Physics

`HeroSnapScrollPhysics` makes the first viewport snap either to the top of the hero or just after the hero when the scroll position is within the first viewport. The rest of the page falls back to the parent `BouncingScrollPhysics`.

## Core Layer

### `core/constant.dart`

Contains small responsive helper functions:

- `screenWidth(context)`
- `screenHeight(context)`
- `horizontalPadding(context)`
- `verticalPadding(context)`
- `cardHorizontalPadding(context)`
- `cardVerticalPadding(context)`

These helpers are used heavily in the visual sections to derive proportional spacing from viewport dimensions.

### `core/theme/app_theme.dart`

Defines the design system tokens:

- `AppColors.bgDark`: `#1A1F2B`
- `AppColors.glassSurface`: translucent white
- `AppColors.moonGlow`: warm secondary accent
- `AppColors.textPrimary`: near-white text
- `AppColors.accent`: blue accent
- `AppSpacing`: 4, 8, 16, 24, 32, 48, 64 scale
- `AppMotion`: fast, medium, slow durations

`AppTheme.darkTheme` configures:

- Material 3 dark color scheme.
- Bebas Neue for display/headline text.
- Inconsolata for titles, body, and labels.
- No splash/highlight visual effects.
- AppBar, ElevatedButton, and Card themes.

### `core/services/asset_preloader.dart`

Preloads the main image assets before showing the curtain loader. The asset list includes:

- Global imagery: avatar, logo, work background, foreground/background hero images, fragments, complete, paper.
- Works imagery: project 1 through project 6, with three images each.

The preloader uses `rootBundle.load()` rather than `precacheImage()`. It validates that bytes can be loaded, then allows the UI to proceed.

### `core/services/email_service.dart`

Wraps the EmailJS REST API.

Required compile-time variables:

- `EMAILJS_SERVICE_ID`
- `EMAILJS_TEMPLATE_ID`
- `EMAILJS_PUBLIC_KEY`

These are read through `String.fromEnvironment`, so they must be passed through `--dart-define` when running or building.

`sendEmail()` posts JSON to:

```text
https://api.emailjs.com/api/v1.0/email/send
```

The template params include sender name/email, destination email, subject, and message. The service returns `true` only for HTTP 200 responses. Missing configuration or exceptions return `false`.

`isValidEmail()` provides an email regex helper, although the contact section currently has its own validation regex as well.

## Data Layer

### `data/models/career_event.dart`

`CareerEvent` is an immutable model for timeline entries:

- `year`
- `title`
- `description`
- `icon`
- optional `company`
- optional `location`

`sampleEvents` is static in the model and currently includes:

- 2019 Intern Mobile Developer at Lontar Lab.
- 2020 Java Software Engineer at PT Collega Inti Pratama.
- 2022 Flutter Developer at PT Collega Inti Pratama.
- Current year Continuous Growth & Learning.

The model overrides equality, `hashCode`, and `toString()`.

## Portfolio Modules

### Home Hero

File: `lib/modules/home/cursor_reveal_hero_section.dart`

The hero is a full-viewport section with a dark visual style and layered imagery.

Desktop behavior:

- Uses `MouseRegion` to track cursor position.
- Shows `Foreground.jpg` as the base image.
- Reveals `Background.jpg` through a circular custom clip path around the cursor.
- Animates the reveal with pulse, breath, and elastic reveal controllers.
- Displays a cursor reveal indicator with a visibility icon.

Mobile/small-web behavior:

- Avoids the cursor reveal interaction.
- Uses a centered stacked copy layout optimized for narrow screens.

Important text/content:

- Main statement: "I BUILD THE QUIET SPACE- WHERE FUNCTION AND BEAUTY MEET."
- Supporting copy about designing and developing apps that tell stories and feel alive.
- Desktop bottom labels: UI UX Designer and Flutter Engineer.
- Scroll prompt at the bottom.

The custom `_LiquidBlobClipper` currently clips a circular reveal area with a breathing radius variation.

### About Section

File: `lib/modules/home/about_section.dart`

The about section is a full-screen responsive section with `ScrollReveal` animations.

Desktop/tablet layout:

- Left title column: `(About.)`
- Right content column with large auto-sized statement text.

Mobile layout:

- Centered title and copy.

Stats footer:

- 5+ Years Experience
- 10+ Projects Completed
- Millions of Codes Written
- Hundreds of Screen Designed
- Infinite coffee consumed

The stats are arranged in one row on desktop and two rows on mobile.

### Timeline Section

Files:

- `lib/modules/timeline/timeline_section.dart`
- `lib/modules/timeline/timeline_strip.dart`
- `lib/modules/timeline/timeline_controller.dart`

The timeline section renders a heading, subtitle, and `TimelineStrip`.

`TimelineController` uses GetX and owns:

- A list of `CareerEvent.sampleEvents`.
- `activeIndex` as `RxInt`.
- `isScrolling` as `RxBool`.
- Helpers for navigation and active/previous/next index.

`TimelineStrip` renders a vertical alternating timeline with centered dots and cards on alternating sides. It listens to the shared page `ScrollController` and calculates `_timelineProgress` based on whether timeline item centers have passed 75% of the viewport height. Active items and connecting lines turn accent blue.

The timeline itself is not independently scrollable. It uses `ListView.builder` with `shrinkWrap: true` and `NeverScrollableScrollPhysics` inside the main page scroll.

### Works Section

File: `lib/modules/works/works_section.dart`

The works section is the largest module and showcases six projects:

1. FE Touch
2. Panic Button
3. Core X
4. Digital Lending
5. Roast POS
6. Lelang Online

It has two major parts:

- A paper-textured header with horizontally translated oversized typography: "DESIGNED WITH LOGIC ..."
- Project showcase sections using work background imagery and screenshots.

The header listens to the shared page `ScrollController`, calculates section visibility/progress, measures the text width after layout, then translates the header text horizontally as the user scrolls through the section.

Project types:

- `ProjectType.desktop`
- `ProjectType.mobile`

Desktop project layout:

- Desktop projects show text in a left column and a large carousel on the right.
- Mobile projects show text plus three tilted phone screenshots side by side.

Mobile viewport layout:

- All projects use a stacked title/description plus centered carousel.
- Mobile project screenshots use a portrait-ratio carousel.

Image naming convention:

- Each project starts from a `projectN-1.png` image path.
- Companion images are derived with string replacement to `projectN-2.png` and `projectN-3.png`.

Carousel behavior:

- Uses `PageController` and `PageView.builder`.
- Page swiping is disabled through `NeverScrollableScrollPhysics`.
- Left/right chevron buttons move between images.
- Dot indicators can jump to a specific page.
- Screenshots are wrapped in `Tilt`.

### Stand Out Section

File: `lib/modules/standout/standout_section.dart`

A large typography-driven section with scroll reveal animations and oversized expressive text:

- `(A promises,)`
- `made of pixels,`
- `blossoms in`
- `the dart.`

It has a height of one viewport on mobile and 1.8 viewports on desktop. It accepts a `scrollController` and has a listener stub, but `_updateScrollProgress()` currently does not mutate any visible state.

### Contact Section

File: `lib/modules/contact/contact_section.dart`

The contact section renders a centered, constrained form with optional scroll reveal animation.

Fields:

- Name: required.
- Email: required and regex-validated.
- Message: required.

Submit flow:

1. Validate the form.
2. Set `_isSubmitting` to true.
3. Call `EmailService.sendEmail()` with name, email, message, and generated subject.
4. On success, reset form/controllers and show a success snackbar.
5. On failure or exception, open the user's email client through `mailto:` with prefilled subject/body.
6. If the email client cannot open, show a direct-email error snackbar.
7. Reset `_isSubmitting` when complete.

The fallback email address is `lraihan@hackermail.com`.

## Shared UI Components

### Glass Navbar

File: `lib/shared/widgets/glass_navbar.dart`

A fixed top navbar with:

- Blurred glass background using `BackdropFilter`.
- Logo button that navigates to the hero.
- Animated text nav items.
- Hover effect with background/border/shadow.
- Scrambled-letter hover animation that resolves back to the original label.

Responsive behavior:

- Under 800 px: compact horizontal scroll nav with About, Works, Contact.
- 800 px and up: full nav with About, Timeline, Works, Contact.

### Scroll Timeline Indicator

File: `lib/shared/scroll_timeline_indicator.dart`

A right-side vertical progress rail that listens to the page scroll controller and fills based on `pixels / maxScrollExtent`.

Although it accepts `sectionTitles` and `onSectionTap`, the current visual implementation only displays the progress rail. It does not render clickable section labels/dots.

### Scroll Reveal

File: `lib/shared/animations/scroll_reveal.dart`

A reusable one-time reveal wrapper.

Behavior:

- Uses `VisibilityDetector`.
- Triggers when visible fraction exceeds 0.2.
- Supports delay, duration, and vertical offset.
- Animates opacity from 0 to 1.
- Animates vertical translation from offset to 0.
- Respects `MediaQuery.disableAnimationsOf(context)` by immediately showing content.

### Footer

File: `lib/shared/footer/footer.dart`

The footer displays:

- Copyright.
- Email address.
- Jakarta time, updated every second by converting UTC to GMT+7.
- Social links for GitHub, LinkedIn, and Instagram.
- Logo image.

Social icons use hover scale animation and `url_launcher`.

### Loaders

Active loaders:

- `AssetLoadingScreen`: shown during preloading.
- `CurtainLoader`: shown after preloading and before the app reveal.

Additional reusable loaders present but not currently used by `AppShell`:

- `ElegantLoader`
- `MinimalistLoader`

### Empty Shared File

`lib/shared/project_card.dart` exists but is currently empty. Works cards are implemented directly inside `WorksSection` rather than this shared file.

## Assets

Flutter declares these asset folders in `pubspec.yaml`:

```yaml
assets:
  - assets/images/
  - assets/images/works/
```

### Main Image Assets

`assets/images/` contains:

- `avatar.png`
- `logo.png`
- `Foreground.jpg`
- `Background.jpg`
- `Foreground-legacy.jpg`
- `Background-legacy.jpg`
- `Background--.jpg`
- `workBg.png`
- `paper.png`
- `fragment1.png` through `fragment6.png`
- `complete.png`
- `works/`

### Work Screenshots

`assets/images/works/` contains six project groups, three screenshots each:

- `project1-1.png`, `project1-2.png`, `project1-3.png`
- `project2-1.png`, `project2-2.png`, `project2-3.png`
- `project3-1.png`, `project3-2.png`, `project3-3.png`
- `project4-1.png`, `project4-2.png`, `project4-3.png`
- `project5-1.png`, `project5-2.png`, `project5-3.png`
- `project6-1.png`, `project6-2.png`, `project6-3.png`

`WorksSection` depends on the `-1`, `-2`, `-3` naming convention for carousel generation.

## Environment Variables

The project uses build-time environment variables for EmailJS credentials.

### Files

- `.env.example`: documents required variables.
- `.env.local`: expected for local development, not committed.
- `.env.production`: expected for production builds, not committed.
- `ENVIRONMENT_SETUP.md`: detailed setup instructions.

### Required Variables

```text
EMAILJS_SERVICE_ID
EMAILJS_TEMPLATE_ID
EMAILJS_PUBLIC_KEY
```

These must be passed as `--dart-define` values because Flutter embeds them at compile time.

### Development Script

`run_dev.sh`:

1. Loads `.env.local` if present.
2. Warns if `.env.local` is missing.
3. Runs Chrome with EmailJS values passed via `--dart-define`.

Command pattern:

```bash
flutter run -d chrome \
  --dart-define=EMAILJS_SERVICE_ID="$EMAILJS_SERVICE_ID" \
  --dart-define=EMAILJS_TEMPLATE_ID="$EMAILJS_TEMPLATE_ID" \
  --dart-define=EMAILJS_PUBLIC_KEY="$EMAILJS_PUBLIC_KEY"
```

### Production Script

`build_prod.sh`:

1. Loads `.env.production` if present.
2. Falls back to environment variables from the system or CI/CD.
3. Validates that all required EmailJS variables are set.
4. Builds Flutter Web in release mode with `--dart-define` values.
5. Outputs to `build/web/`.

If variables are missing, the script exits with code 1.

## Build, Analyze, And Test

### Install Dependencies

```bash
flutter pub get
```

The last known `flutter pub get` command completed successfully.

### Run Locally

Preferred project script:

```bash
./run_dev.sh
```

Manual run:

```bash
flutter run -d chrome \
  --dart-define=EMAILJS_SERVICE_ID="your_service_id" \
  --dart-define=EMAILJS_TEMPLATE_ID="your_template_id" \
  --dart-define=EMAILJS_PUBLIC_KEY="your_public_key"
```

### Analyze

```bash
flutter analyze
```

Analyzer settings are intentionally strict. When editing Dart files, expect style and lint rules around explicit return types, package imports, const usage, trailing commas, public API types, and async safety.

### Test

```bash
flutter test
```

No Dart test files currently exist in the workspace, so adding tests would require creating a `test/` structure.

### Build Web

Preferred project script:

```bash
./build_prod.sh
```

Manual release build:

```bash
flutter build web --release \
  --dart-define=EMAILJS_SERVICE_ID="your_service_id" \
  --dart-define=EMAILJS_TEMPLATE_ID="your_template_id" \
  --dart-define=EMAILJS_PUBLIC_KEY="your_public_key"
```

The VS Code workspace defines a CI-style task named `CI Pipeline - Test, Analyze, Build` that runs:

```bash
flutter test && flutter analyze && flutter build web --no-tree-shake-icons
```

## Web And Deployment Context

### Web Entrypoint

`web/index.html` contains:

- Flutter base href placeholder.
- SEO description and keywords.
- Open Graph and Twitter metadata.
- Theme color metadata.
- iOS web app metadata.
- SVG and PNG favicon links.
- Manifest link.
- `flutter_bootstrap.js` loader script.

### PWA Manifest

`web/manifest.json` defines:

- Name: `Polymorphism - Visual Engineer Portfolio`
- Short name: `Polymorphism`
- Display: `standalone`
- Start URL: `.`
- Dark background/theme colors.
- Portrait-primary orientation.
- Standard and maskable icons.

### Vercel Configuration

`vercel.json` is configured for static single-page app hosting:

- Rewrites every route to `/index.html`.
- Enables clean URLs.
- Disables trailing slash normalization.

This is appropriate for a Flutter Web single-page application where the client owns navigation.

### Web Icons

The project includes custom code-themed icon documentation and generation scripts:

- `WEB_ICONS.md`: explains icon design and generated files.
- `create_code_icons.sh`: creates `web/icons/code-icon.svg` and optionally converts SVG to PNG using ImageMagick.
- `generate_icons.dart`: Dart-based icon generation script that draws code brackets/slash with Canvas and writes PNGs to `web/icons/`.

Icon generation is auxiliary and not part of normal app startup.

## Platform Folders

Flutter platform folders are present:

- `android/`
- `ios/`
- `linux/`
- `macos/`
- `windows/`
- `web/`

The application code is platform-neutral Flutter/Dart, but the repository's documentation and scripts focus on web usage and deployment.

## Important User Flows

### First Load Flow

1. Browser loads Flutter Web app.
2. `main()` initializes Flutter and runs `AppShell`.
3. `AppShellController` preloads image assets.
4. `AssetLoadingScreen` displays loading text and progress indicator.
5. Curtain loader displays logo, accent line, and phrase.
6. Curtain opens left/right.
7. Main home page fades/scales in with grain filter.
8. User lands on hero section.

### Navigation Flow

1. User taps logo/nav item or section indicator callback.
2. `HomePage` maps item index to section key.
3. It calculates the target scroll offset from render position.
4. It animates the shared scroll controller to the target over 2 seconds.
5. The scroll progress rail and section-specific listeners update while scrolling.

### Hero Interaction Flow

Desktop:

1. User moves cursor over hero.
2. Mouse position updates local state.
3. Cursor reveal animation expands.
4. `ClipPath` reveals the background image through a circular area.
5. Pulse/breath animations make the reveal feel alive.
6. Leaving the hero reverses the reveal.

Mobile:

1. Cursor reveal is disabled.
2. The hero displays static layered imagery and responsive centered copy.

### Timeline Progress Flow

1. User scrolls through the page.
2. `TimelineStrip` receives scroll updates through the shared controller.
3. It checks each timeline item's screen position.
4. Items whose centers have crossed 75% viewport height count as active.
5. `_timelineProgress` updates.
6. Dots/cards/connecting lines animate into accent styling.

### Works Carousel Flow

1. User reaches a project section.
2. Project screenshots render in a `PageView` controlled by buttons/dots.
3. User taps chevrons or dot indicators.
4. `PageController` animates to the selected screenshot.
5. Tilt effects apply to screenshot visuals.

### Contact Flow

1. User fills name, email, and message.
2. Form validators ensure all fields are present and email-like.
3. Submit button enters loading state.
4. App posts to EmailJS using compile-time credentials.
5. On HTTP 200, the form clears and a success snackbar appears.
6. On failure, the app opens a prefilled `mailto:` URL.
7. If no email client can open, a snackbar asks the user to email directly.

### Footer Link Flow

1. User hovers a social icon.
2. Icon scales and changes color.
3. User taps/clicks.
4. `url_launcher` opens the external social URL.

## Responsive Behavior

The app primarily uses viewport width breakpoints and proportional viewport sizing.

Common breakpoints:

- `< 600 px`: mobile/narrow behavior in contact, timeline, footer.
- `< 768 px`: mobile behavior in about, works, standout.
- `< 800 px`: compact navbar and non-desktop hero interaction.
- `< 1024 px`: tablet text scaling in several sections.
- `< 1200 px`: medium navbar spacing.
- `< 1440 px`: reduced hero display text scale.

Design choices:

- Several sections use full viewport height on desktop.
- Works and standout can exceed one viewport to support scroll-driven typography and long showcases.
- Text sizes often scale by breakpoint-specific multipliers.
- Mobile layouts are generally stacked and centered; desktop layouts use rows, alternating cards, and split text/media compositions.

## Styling And Visual Language

The portfolio's visual language is dark, cinematic, and code/design oriented:

- Dark blue-gray background.
- Near-white text.
- Blue accent for active/progress states.
- Warm `moonGlow` secondary tone in gradients/fallbacks.
- Glass nav and glass timeline cards.
- Oversized editorial typography.
- Paper/work background textures for the works section.
- Grain overlay after app readiness.
- Cursor reveal, scroll reveal, tilt, and long easing animations.

Typography combines:

- Bebas Neue for loud display/headline moments.
- Inconsolata for body/system text.
- Some direct font family usage in the navbar hover text.

## External Links And Contact Points

Primary email:

```text
lraihan@hackermail.com
```

Social links:

- GitHub: `https://github.com/lraihan`
- LinkedIn: `https://www.linkedin.com/in/raihan-fadli-dev/`
- Instagram: `https://www.instagram.com/locio_raihan/`

Contact form destination email is also `lraihan@hackermail.com`.

## Customization Map

Common customization points:

- Hero copy and images: `lib/modules/home/cursor_reveal_hero_section.dart`
- About copy and stats: `lib/modules/home/about_section.dart`
- Timeline content: `lib/data/models/career_event.dart`
- Project list/descriptions/images: `lib/modules/works/works_section.dart`
- Typography promise section: `lib/modules/standout/standout_section.dart`
- Contact copy and fallback address: `lib/modules/contact/contact_section.dart`
- EmailJS implementation: `lib/core/services/email_service.dart`
- Footer social links/time/email: `lib/shared/footer/footer.dart`
- Theme colors, spacing, typography: `lib/core/theme/app_theme.dart`
- Asset preload list: `lib/core/services/asset_preloader.dart`
- Web metadata and PWA config: `web/index.html`, `web/manifest.json`
- Vercel static routing: `vercel.json`

When adding a new page section:

1. Create the section widget under `lib/modules/<section>/`.
2. Add it to the `Column` in `HomePage`.
3. Increase `_sectionKeys` length.
4. Add a title to `_sectionTitles`.
5. Update navbar indexes in `GlassNavbar` if it should be directly navigable.
6. Confirm scroll indicator and section offsets still match the desired order.

## Known Implementation Notes

- `lib/shared/project_card.dart` is empty; reusable project cards were never extracted from `WorksSection`.
- `StandOutSection._updateScrollProgress()` currently calculates visibility context but does not update state.
- `ScrollTimelineIndicator` accepts section titles and tap callbacks but currently renders only a progress rail.
- `EmailService.isValidEmail()` duplicates validation logic that also exists in `ContactSection`.
- `AssetPreloader` validates asset bytes with `rootBundle.load`; it does not use Flutter's image cache prewarming API.
- `generate_icons.dart` and `create_code_icons.sh` are utility scripts and should not be confused with app runtime code.
- `README.md` mentions `assets/fonts/`, but `pubspec.yaml` currently declares image asset folders only.
- No tests currently exist; behavior is validated manually or through Flutter analysis/build commands.

## Maintenance Guidance

### Adding Or Renaming Assets

When changing assets:

1. Put general images in `assets/images/` or project screenshots in `assets/images/works/`.
2. Ensure the path is covered by `pubspec.yaml`.
3. If the image is needed during first load, add it to `AssetPreloader._imageAssets`.
4. For works screenshots, preserve the `projectN-1`, `projectN-2`, `projectN-3` naming convention or update carousel generation.

### Changing Email Behavior

When changing contact/email behavior:

1. Keep compile-time variables in sync across `.env.example`, `ENVIRONMENT_SETUP.md`, `run_dev.sh`, and `build_prod.sh`.
2. Remember `String.fromEnvironment` values are fixed at compile/build time.
3. Preserve or intentionally replace the `mailto:` fallback for failed EmailJS submissions.

### Changing Navigation Or Sections

When modifying section order:

1. Update `_sectionKeys` count and `_sectionTitles` in `HomePage`.
2. Update navbar indexes in `GlassNavbar`.
3. Update hero `onExplorePressed` target if Works is no longer index 3.
4. Verify scroll-to-section offsets on both mobile and desktop.
5. Check timeline/works/standout listeners still receive the correct shared `ScrollController`.

### Working With Analyzer Rules

The analyzer configuration is strict. New Dart code should prefer:

- Package imports over relative imports.
- Explicit return types on public APIs.
- Const constructors and literals where possible.
- Trailing commas for formatted widget trees.
- Avoiding broad catches unless intentionally ignored with comments.
- Disposing controllers, timers, and listeners.
- Avoiding direct `print`; use `debugPrint` if needed.

### Suggested Verification Before Deployment

Run:

```bash
flutter pub get
flutter analyze
flutter test
flutter build web --release \
  --dart-define=EMAILJS_SERVICE_ID="..." \
  --dart-define=EMAILJS_TEMPLATE_ID="..." \
  --dart-define=EMAILJS_PUBLIC_KEY="..."
```

For the VS Code task, run `CI Pipeline - Test, Analyze, Build` when a full local CI pass is desired.

## Mental Model For Future Agents

Think of this repo as a handcrafted Flutter Web portfolio, not a CRUD app or route-heavy product shell. The most important code paths are visual composition and scroll interaction:

- `main.dart` starts `AppShell`.
- `AppShell` controls loading and readiness.
- `HomePage` owns the scroll controller and section composition.
- Modules render the portfolio content.
- Shared widgets provide animation, navigation, progress, loaders, and footer.
- Email and assets are the only significant service-like concerns.

Most changes should be made close to the relevant section widget. Avoid introducing broad abstractions unless a real cross-section reuse need appears.
