# Content Guide

How to change **what the portfolio says and shows** without touching any design
or layout code. Written for the site owner — no Flutter expertise assumed.

## The golden rule

All content lives in exactly **four places**:

| What | File |
|---|---|
| Projects, career timeline, skills, stats, social links | `lib/data/portfolio_data.dart` |
| Every piece of text (name, bio, headings, button labels) | `lib/core/constants/strings.dart` |
| Image file paths | `lib/core/constants/assets.dart` (+ files in `assets/images/`) |
| The scroll poem | `lib/features/statement/statement_section.dart` (the one design file you may touch) |

You should never need to edit anything inside `lib/features/` (except the poem),
`lib/shared/`, or `lib/core/theme/` (except the accent color, see section 6).

**After any change**, check yourself before pushing:

```bash
flutter analyze        # must print "No issues found!"
flutter run -d chrome  # preview locally
```

Two formatting rules the project's linter enforces — copy the snippets below
exactly and you'll be fine:

- Every multi-line list/constructor call ends with a **trailing comma** before
  the closing bracket.
- Strings use **single quotes** `'like this'` (double quotes only when the text
  itself contains an apostrophe).

---

## 1. Add a new project

A project needs two things: **3 screenshots** and **one Dart entry**.

### Step 1 — add the screenshots

Screenshots follow a strict naming convention:

```
assets/images/works/project<N>-1.png
assets/images/works/project<N>-2.png
assets/images/works/project<N>-3.png
```

`<N>` is the next unused number. The existing projects use 1–6, so your new
project is `project7-1.png`, `project7-2.png`, `project7-3.png`. Drop all
three files into `assets/images/works/`. (The number is just a folder label —
it does **not** control where the card appears on the page; list order does,
see Step 4.)

The folders are already declared in `pubspec.yaml` (`assets/images/` and
`assets/images/works/`), so you do **not** need to edit `pubspec.yaml` —
new files in those folders are picked up automatically.

For sizing and compression, see section 4.

### Step 2 — register the card image in the preloader

Open `lib/core/constants/assets.dart`. To keep first load fast, the intro
pre-decodes only what the first screen needs: the logo, the avatar, and each
project's **card image** (`project<N>-1.png`). The other two screenshots load
lazily when someone opens the project's detail page, so you do not register
them. The loop currently covers `1 <= 6`; bump the upper bound to your new
number:

```dart
  /// Assets the intro decodes before the curtain lifts — first-paint only.
  static List<String> get preload => [
    logo,
    avatar,
    for (var n = 1; n <= 7; n++) projectCover(n),   // was 6 — now 7
  ];
```

(If you skip this, the site still works, but your new project's card image may
pop in late instead of being instantly ready.)

### Step 3 — add the project entry

Open `lib/data/portfolio_data.dart` and add a new `Project(...)` inside the
`static final List<Project> projects = [ ... ];` list. Copy-paste this template
and edit every line:

```dart
    Project(
      id: 'my-new-app',                       // URL slug: site.com/work/my-new-app — lowercase, hyphens, unique
      title: 'My New App',                    // Card + detail title
      category: 'MOBILE APP',                 // Small uppercase tag on the card
      tagline: 'One short sentence shown on the card.',
      description:
          'The full paragraph shown in the project detail view. '
          'Two to four sentences about what the app does, who it was '
          'built for, and what makes it interesting.',
      tech: const ['Flutter', 'Firebase', 'REST APIs'],   // 2–4 badges
      images: AppAssets.projectImages(7),     // the <N> from Step 1
      scale: ProjectScale.standard,           // .featured = wide spotlight card, .standard = single-column
      screenshots: ScreenshotKind.portrait,   // .portrait for phone shots, .landscape for tablet/desktop shots
      accent: AppColors.accentPrimary,        // glow color — see options below
    ),
```

Accent color options (from `lib/core/theme/app_tokens.dart`):
`AppColors.accentPrimary` (teal), `AppColors.accentSecondary` (violet),
`AppColors.successGreen`, `AppColors.warningAmber`, `AppColors.errorRed`.

### Step 4 — order and the bento grid (important)

The **order of entries in the `projects` list = the order on the page**.

The desktop "bento" layout is designed around **exactly 6 projects** laid out
as: wide + small / small + wide / small + small + "Your project could be next"
tile. The projects at list positions **1 and 4** are the wide spotlight slots —
give those two `scale: ProjectScale.featured` and the other four
`ProjectScale.standard`.

So the easiest safe move is to **swap your new project in place of an old
one** (replace one of the six entries, matching its `scale`), keeping the list
at 6 entries.

If you instead want to *grow* the list to 7+: mobile and tablet layouts adapt
automatically, but the desktop grid in
`lib/features/works/works_section.dart` (`_bentoGrid`) hard-codes six card
slots — a 7th project won't appear on desktop until a developer adds a row
there. Ask for help with that one change.

---

## 2. Update personal info

Everything is in `lib/core/constants/strings.dart`. Find the line, change the
text between the quotes, done. The most useful ones:

```dart
  // ── Identity ───────────────────────────────────────────────────────────
  static const String ownerName = 'Raihan';                       // short name (nav, intro)
  static const String ownerFullName = 'Raihan Fadli';
  static const String role = 'Flutter & Visual Engineer';         // job title under the name
  static const String location = 'Based in Jakarta, Indonesia';
  static const String email = 'lraihan@hackermail.com';           // contact form fallback + "reach me directly"
  static const String siteTitle = 'Raihan — Flutter & Visual Engineer';

  // ── Hero ───────────────────────────────────────────────────────────────
  static const List<String> heroLines = ['BUILDING THINGS', 'THAT FEEL', 'ALIVE.'];  // the giant headline, one entry per line
  static const String statusAvailable = 'Available for work';     // the pulsing status pill

  // ── About ──────────────────────────────────────────────────────────────
  static const String aboutGreeting = "Hi, I'm Raihan.";
  static const String aboutBio = '...first bio paragraph...';
  static const String aboutBioSecond = '...second bio paragraph...';

  // ── Contact ────────────────────────────────────────────────────────────
  static const String contactAvailability = 'Currently available for freelance and full-time roles.';

  // ── Footer ─────────────────────────────────────────────────────────────
  static const String footerCopyright = '© 2026 Raihan';
```

Long paragraphs are split across lines like this — Dart glues adjacent strings
together (note: no commas between the pieces, single quotes, trailing `;`):

```dart
  static const String aboutBio =
      'First part of the sentence '
      'second part of the sentence.';
```

Also update the **browser tab title and link previews** (search engines and
social shares don't read Dart): edit the `<title>`, `description`, `og:` and
`twitter:` meta tags in `web/index.html`, and `name`/`short_name`/
`description` in `web/manifest.json`.

---

## 3. Add an experience entry

Open `lib/data/portfolio_data.dart`, find
`static const List<CareerEvent> careerEvents = [ ... ];` and add an entry.
**The list is newest-first** — a new job goes at the **top**:

```dart
    CareerEvent(
      year: 2026,                              // used for ordering/markers on the timeline
      title: 'Senior Flutter Developer',       // role name (the big text)
      company: 'PT Example Indonesia',
      location: 'Jakarta, Indonesia',
      period: '2026 — Present',                // human-readable range, em dash: —
      description:
          'One or two sentences about what you did and shipped '
          'in this role.',
    ),
```

`company`, `location` and `period` are optional — you can leave any of them
out (for e.g. an education entry or a self-employed year), but `year`,
`title` and `description` are required.

Don't forget to also update the previous top entry's `period` from
`'2022 — Present'` to a closed range like `'2022 — 2026'`.

---

## 4. Replace photos

Both files live in `assets/images/`. **Keep the exact same file names** —
replace the file contents, not the names — and nothing else needs editing.

| File | Used in | Recommended export |
|---|---|---|
| `assets/images/avatar.png` | About section portrait | **4:5 portrait ratio** (the frame crops to 4:5), e.g. 1000 × 1250 px |
| `assets/images/logo.png` | Intro screen, floating nav, footer | Square with transparent background, 512 × 512 px |
| `assets/images/works/projectN-1..3.png` | Project cards + detail gallery | Phone shots ~1080 × 2340 px; tablet/landscape shots ~1600–2000 px wide |

Compression tip: PNGs straight out of a design tool or simulator are huge and
slow down first load. Run each image through **tinypng.com** (or `squoosh.app`)
before committing — it typically cuts 60–80 % of the file size with no visible
difference. Aim for **under ~300 KB per screenshot** and under ~150 KB for
avatar/logo.

After replacing files, do a hard refresh in the browser (Ctrl+Shift+R) — old
images are aggressively cached.

---

## 5. Update social links

One list controls them all. In `lib/data/portfolio_data.dart`:

```dart
  static const List<({String label, String url})> socials = [
    (label: 'GitHub', url: 'https://github.com/lraihan'),
    (label: 'LinkedIn', url: 'https://www.linkedin.com/in/raihan-fadli-dev/'),
    (label: 'Instagram', url: 'https://www.instagram.com/locio_raihan/'),
  ];
```

Add, remove, or reorder entries freely — `PortfolioData.socials` automatically
propagates to the **navigation menu, the contact section, and the footer**.
A new entry looks like:

```dart
    (label: 'Dribbble', url: 'https://dribbble.com/yourhandle'),
```

Two extra constants just below the list (`githubUrl`, `linkedInUrl`) are used
in a couple of standalone spots — keep them in sync if you change those URLs.

---

## 6. Change the accent color (teal → something else)

The accent is defined once in `lib/core/theme/app_tokens.dart`, but as **five
related constants** that must all use the *same* new RGB value. Colors are
written `Color(0xAARRGGBB)`: the first two hex digits after `0x` are
transparency (`FF` = solid, `80` = 50 %, `40` = 25 %, `20` = 12.5 %), the last
six are the color itself.

Say your new color is hot pink `FF2D78`. Change all five — **keep the first
two digits as they are, swap only the last six**:

```dart
  // Accent — Bioluminescent Teal
  static const Color accentPrimary = Color(0xFFFF2D78); // Primary accent
  static const Color accentGlow = Color(0x80FF2D78); // 50% accent (glow)
  static const Color accentSubtle = Color(0x20FF2D78); // 12.5% accent (subtle bg)
```

and further down in the same file:

```dart
  static const Color textAccent = Color(0xFFFF2D78); // Accent text
  ...
  static const Color borderActive = Color(0x40FF2D78); // Active borders (25% teal)
```

That single edit re-themes everything that uses the accent: the custom cursor
ring, hero background glow and particles, the "Available for work" pill, CTA
and magnetic buttons, gradient/section headings, the section rail, the
floating nav highlights, scroll-reveal accents, the illuminated line of the
statement poem, form focus borders, tech badges, the footer — plus every
project card that uses `accent: AppColors.accentPrimary` (currently FE Touch
and Core X).

Checklist while you're at it:

- `textOnAccent` (same file) is the dark text drawn **on top of** accent-filled
  buttons. If your new accent is dark, this may need to become a light color
  to stay readable.
- `web/index.html` — the `theme-color` and `msapplication-TileColor` meta tags
  and the inline `background-color` style are the page background (`#080810`).
  They only need touching if you change the *background*, but check them so
  the browser chrome still matches your new palette.
- `web/manifest.json` — same story: `background_color` and `theme_color` hold
  `#080810`.
- `web/favicon.svg` / `favicon.png` and `web/icons/` — if your logo/brand mark
  contains the old teal, re-export the icons in the new color.

---

## 7. Edit the statement poem

The scroll-illuminated poem lives in
`lib/features/statement/statement_section.dart`, in the `_lines` list:

```dart
  static const List<_Line> _lines = [
    _Line('(A promise,)', alignment: Alignment.centerLeft, size: 44, spacing: -1),
    _Line('made of pixels,', alignment: Alignment.centerRight, size: 124, accent: true, spacing: -4),
    _Line('blossoms in', alignment: Alignment.centerLeft, size: 104, spacing: 10),
    _Line('the dart.', alignment: Alignment.center, size: 140, spacing: -5),
  ];
```

Each `_Line` is one row of the poem, revealed word by word as you scroll:

- **text** — the words. Keep each line short (1–4 words reads best at this size).
- **alignment** — `Alignment.centerLeft`, `Alignment.center`, or
  `Alignment.centerRight`; the zig-zag between lines is part of the look.
- **size** — font size on the widest screens (everything scales down
  automatically on smaller devices). 40–60 for a quiet line, 100–140 for a
  shout.
- **accent: true** — paints that line in the accent color (use on exactly one
  line for the intended effect).
- **spacing** — letter-spacing; negative = tighter, positive = airier. When in
  doubt, copy a value from an existing line.

You can change the words, or add/remove whole `_Line(...)` rows — the
word-by-word reveal recalculates itself. Don't rename anything else in the
file.

---

## 8. Deploy an update

### The normal way (automatic)

Deployment is wired to git: **every push to the `main` branch** triggers
GitHub Actions (`.github/workflows/flutter_web.yml`), which builds the site
with the EmailJS keys stored in GitHub repository secrets and publishes it to
Vercel.

```bash
git add -A
git commit -m "content: update bio and add new project"
git push origin main
```

Then watch the **Actions** tab on the GitHub repository — green check
(~3–5 minutes) means the new version is live. Hard-refresh the site
(Ctrl+Shift+R) to bypass your browser cache.

Before pushing, always run:

```bash
flutter analyze
```

If it reports anything, the build will likely still pass but the project's
standard is a clean analyze — usually it's just a missing trailing comma.

### Manual build (fallback)

If you ever need to build locally (e.g. to deploy by hand or sanity-check the
production bundle):

```bash
# one-time: copy .env.example to .env.production and fill in the EmailJS keys
./build_prod.sh
```

That script loads `EMAILJS_SERVICE_ID`, `EMAILJS_TEMPLATE_ID` and
`EMAILJS_PUBLIC_KEY` from `.env.production` and runs `flutter build web
--release` with the matching `--dart-define` flags. The finished site lands in
`build/web/`, which you can deploy with `vercel build/web --prod` or upload to
any static host.

(Note: older guides mention a `--web-renderer` flag — it no longer exists in
current Flutter; don't add it.)

If the contact form ever stops sending, the EmailJS keys are the first thing
to check: GitHub repo → Settings → Secrets and variables → Actions.
