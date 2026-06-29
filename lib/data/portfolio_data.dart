// Long-form portfolio copy is wrapped across lines as adjacent string literals
// inside list elements (highlights); that is deliberate, not a missing comma.
// ignore_for_file: no_adjacent_strings_in_list

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/assets.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/data/models/career_event.dart';
import 'package:polymorphism/data/models/project.dart';
import 'package:polymorphism/data/models/skill.dart';

/// The portfolio's content database.
///
/// To add or change content, edit this file only — layout and design adapt
/// automatically. See `docs/CONTENT_GUIDE.md` for a walkthrough.
class PortfolioData {
  PortfolioData._();

  // ── Projects (spotlight order — variety-first) ─────────────────────────
  //
  // Per-project colors come from each product's own design language; ROAST and
  // FE Touch use real screenshots, ELSSA/ProFund/SIGAP use imagery rendered
  // from their live prototypes, Balai is presented as an editorial art panel.

  static final List<Project> projects = [
    const Project(
      id: 'roast-pos',
      name: 'ROAST POS',
      category: 'POS PLATFORM',
      platform: ProjectPlatform.pos,
      tagline: "Six products, one codebase — a restaurant's entire operating day.",
      shortDesc:
          'A multi-tenant SaaS platform for Indonesian F&B: a tablet POS, mobile '
          'companion, time-clock, web ordering, admin console, and terminal — all '
          'built from one Flutter monorepo over a single shared business-logic core.',
      fullDesc:
          "ROAST POS doesn't just record transactions; it models how a restaurant "
          'actually runs — from opening the doors in the morning to counting the cash '
          'drawer at night. It covers the full operational day, multi-station inventory '
          'down to individual ingredient lots, an owner-configurable menu and modifier '
          'system, dynamic payment methods from cash to QRIS, per-cashier cash '
          'reconciliation, configurable approval workflows, loyalty, attendance, and '
          'financial reporting — as one coherent, multi-tenant whole. The defining '
          'constraint: six products, one codebase, zero duplicated business logic.',
      tech: ['Flutter', 'Dart 3', 'GetX', 'Firebase', 'freezed', 'fl_chart'],
      images: AppAssets.roast,
      media: ProjectMedia.framedGallery,
      frame: ProjectFrame.tablet,
      dominantColor: Color(0xFF0E3B38),
      accentColor: Color(0xFFE0A33C),
      metrics: [
        ProjectMetric('6', 'Products'),
        ProjectMetric('680+', 'Passing tests'),
        ProjectMetric('1', 'Shared core'),
      ],
      highlights: [
        'A repository-pattern data layer is the only way to the database — business '
            'rules live in exactly one place and every product inherits them identically.',
        'A single toggle swaps the entire data layer between live Firebase and an '
            'in-memory mock — the full app develops, runs, and tests offline.',
        'An enforced operational state machine (Closed → Preparing → Open → Closing) '
            'gates real behavior, keeping the books clean by construction.',
        'Multi-station inventory tracked per location and per lot, with '
            'station-relative dish availability and expiry-to-waste disposal.',
      ],
      role: 'Architecture, system design & technical direction',
      year: '2025',
      status: 'Shipped',
      isFeatured: true,
    ),
    const Project(
      id: 'elssa',
      name: 'ELSSA',
      category: 'SCHOOL SAAS',
      platform: ProjectPlatform.crossPlatform,
      tagline: 'The platform that runs the school — and that parents open every morning.',
      shortDesc:
          'A school-management and parent-engagement platform for Indonesian high '
          'schools. Its wedge is the morning moment: a student taps in at the gate '
          "and the parent's phone lights up — attendance, grades, and tuition one tap away.",
      fullDesc:
          'A single school day runs on a dozen disconnected tools — announcements in '
          'WhatsApp, attendance on paper, tuition billed by hand. ELSSA is one connected '
          'platform that runs daily operations and gives every parent a live window into '
          "their child's day. It rides the systems schools already use — importing rosters "
          'from Dapodik and exporting grades to e-Rapor — so it complements government '
          'systems instead of fighting them. The signature moment is the morning hadir: '
          "when a student taps in at the gate, the parent's phone lights up, and opens "
          'into attendance, grades, the SPP balance, and announcements.',
      tech: ['Flutter', 'Firebase', 'Multi-role', 'Design System'],
      images: AppAssets.elssa,
      media: ProjectMedia.framedGallery,
      dominantColor: Color(0xFF1E4D3A),
      accentColor: Color(0xFFE8833A),
      metrics: [
        ProjectMetric('7', 'Roles'),
        ProjectMetric('4', 'Surfaces'),
        ProjectMetric('3', 'Capture methods'),
      ],
      highlights: [
        'Rides the systems schools already use — imports rosters from Dapodik, exports '
            'grades to e-Rapor (supporting both Kurikulum 2013 and Merdeka).',
        'The signature morning hadir: a gate tap-in fires an instant parent '
            'notification — the daily reassurance that earns a school its trust.',
        'Per-school isolated Firebase projects — the strongest privacy posture for '
            "children's attendance, grades, money, and biometrics.",
        'Seven roles prototyped at high fidelity, including the loading, empty, error '
            'and offline states products usually skip.',
      ],
      role: 'Solo founder — product, UX/UI, prototype, architecture',
      year: '2025–2026',
      status: 'Shipped',
      prototypeUrl: 'prototypes/elssa.html',
      isFeatured: true,
    ),
    const Project(
      id: 'profund-manager',
      name: 'ProFund Manager',
      category: 'FINANCE SAAS',
      platform: ProjectPlatform.web,
      tagline: 'Control project cost at the point of spend — before the money is gone.',
      shortDesc:
          'A B2B project-finance platform that tracks every rupiah across four states — '
          'budget, reserved, committed, actual — for real-time cost visibility. A dense '
          'web console plus a focused mobile companion, from one Flutter codebase.',
      fullDesc:
          'Project budgets in Indonesia are usually managed across disconnected '
          'spreadsheets and accounting software that only records costs after they '
          'happen. ProFund instead controls cost at the point of spend. Every rupiah '
          'moves through Budget → Reserved → Committed → Actual, with automatic relief '
          'at each transition, so exposure always reflects reality — not just what has '
          'been invoiced. Over-budget is a deliberate, record-first state: never '
          'blocked, but flagged loud, propagated up the work-breakdown tree, and forced '
          'to a director sign-off. Overruns become conscious decisions, not month-end surprises.',
      tech: ['Flutter', 'GetX', 'Firebase', 'freezed', 'Repository'],
      images: AppAssets.profund,
      media: ProjectMedia.framedGallery,
      frame: ProjectFrame.browser,
      dominantColor: Color(0xFF0E2A47),
      accentColor: Color(0xFF1FA89A),
      metrics: [
        ProjectMetric('4', 'State model'),
        ProjectMetric('~30', 'Reports'),
        ProjectMetric('7', 'Roles'),
      ],
      highlights: [
        'A four-state money model — Budget → Reserved → Committed → Actual — with '
            'pre-encumbrance first-class and automatic relief at every transition.',
        'Over-budget is record-first: never blocked, always flagged loud and escalated '
            'to a director — soft control over hard blocks.',
        'A flat Firestore schema with denormalized ancestor arrays turns arbitrary-depth '
            'WBS aggregation into a single transactional walk, not recursive reads.',
        'One codebase, two adaptive flavors — dense tables and Miller-column WBS on the '
            'console; drill-down and bottom sheets on mobile, at full parity.',
      ],
      role: 'Solo founder & builder — product, UX, architecture, build',
      year: '2026',
      status: 'Shipped',
      prototypeUrl: 'prototypes/profund.html',
    ),
    const Project(
      id: 'fitx',
      name: 'FitX',
      category: 'FITNESS APP',
      platform: ProjectPlatform.mobile,
      tagline: 'Turn everyday attendance into a habit — built around a daily streak.',
      shortDesc:
          'A mobile app for a multi-branch Indonesian gym that turns attendance into a habit '
          'and brings class booking, personal training, barber & nail appointments, retail, '
          'and membership into one connected, two-sided experience.',
      fullDesc:
          'Most gym apps bolt features onto a login screen and stop at booking. The harder, '
          'more valuable problem is retention — getting members to come back. FitX is built '
          'around a daily habit loop: scan in at the gym, watch a visit streak grow, book the '
          'next session. Everything else — progress, retail, membership — is arranged as '
          'satellites around that core, so the app earns a daily open rather than an occasional '
          'one. Members and personal trainers share a single app behind role-based access, with '
          'a separate admin application, so the two sides connect directly — a trainer-assigned '
          "workout surfaces in that member's progress log.",
      tech: ['Flutter', 'Firebase', 'Repository', 'Mock-data-first'],
      images: AppAssets.fitx,
      media: ProjectMedia.mockupGallery,
      dominantColor: Color(0xFF19220C),
      accentColor: Color(0xFFC6F23C),
      metrics: [
        ProjectMetric('2', 'Sides, one app'),
        ProjectMetric('2', 'Booking engines'),
        ProjectMetric('Multi', 'Branch'),
      ],
      highlights: [
        'Two-sided, one system — members and trainers share one app behind role-based access; '
            "a trainer's bookable hours become the very slots a member sees.",
        'One booking layer, two engines — every reservation is either seat-claiming (group '
            'classes, with capacity and waitlists) or provider-reservation (PT, barber, nails).',
        'Built around a daily habit loop — scan in, watch the streak grow, book the next '
            'session; progress, retail, and membership all orbit that core.',
        'Built for the Indonesian market — per-branch barcode check-in, QRIS and bank transfer, '
            'reserve-and-collect retail, and Bahasa Indonesia throughout.',
      ],
      role: 'Solo founder & builder — product, IA, system design, UX & art direction',
      year: '2026',
      status: 'Concept & product design',
      prototypeUrl: 'prototypes/fitx.html',
    ),
    const Project(
      id: 'sigap',
      name: 'SIGAP',
      category: 'EMERGENCY · B2G',
      platform: ProjectPlatform.crossPlatform,
      tagline: "Don't sell the panic button — prove and improve the response time.",
      shortDesc:
          'An emergency reporting and response platform for Indonesian fire & rescue '
          'services. A citizen reports in one tap with exact location; crews respond — '
          'every incident timestamped against the mandated 15-minute response standard.',
      fullDesc:
          'When someone calls for help, the most common reason a crew reaches the wrong '
          "place is that the caller can't describe their location. Meanwhile, every "
          'Indonesian fire service answers to a mandated 15-minute response time. A panic '
          'button on its own is a commodity that competes with a free national line. The '
          'defensible product is the operational layer that measures and improves a '
          "department's response time — so the response clock is the spine of the entire "
          'system, and the citizen app is one intake channel feeding it. That reframed it '
          'from "here\'s a panic button" to "prove and improve your mandated response time."',
      tech: ['Flutter', 'Firebase', 'Real-time', 'Offline-first'],
      images: AppAssets.sigap,
      media: ProjectMedia.framedGallery,
      dominantColor: Color(0xFF16202E),
      accentColor: Color(0xFFE23B3B),
      metrics: [
        ProjectMetric('15 min', 'Response standard'),
        ProjectMetric('3', 'Surfaces'),
        ProjectMetric('1-tap', 'Report'),
      ],
      highlights: [
        'Reframed from "a panic button" to the operational layer that measures and '
            'improves response time — something a fire-service director is accountable for.',
        'Three surfaces on one incident lifecycle: a citizen app, a field-hardened '
            'responder app, and a real-time command dashboard with a ticking response clock.',
        'A multi-tenant model where each department owns a coverage area and incidents '
            'route by location, with a co-brandable citizen app.',
        'Offline-first resilience — queued reports with an SMS fallback for the moments '
            'connectivity matters most.',
      ],
      role: 'Solo founder — product, research, UX, architecture',
      year: '2026',
      status: 'Concept & product design',
      prototypeUrl: 'prototypes/sigap.html',
    ),
    const Project(
      id: 'fe-touch',
      name: 'FE Touch',
      category: 'BANKING · CLIENT WORK',
      platform: ProjectPlatform.tablet,
      tagline: 'A modern teller workspace for everyday banking.',
      shortDesc:
          'A teller application built with PT Collega Inti Pratama — a fast, clean '
          'interface for everyday banking at the counter. Designed to feel effortless '
          'even during the rush-hour queue, with the rigor a banking product demands.',
      fullDesc:
          'FE Touch brings a fresh, modern interface to everyday banking tasks for bank '
          'tellers: cash transactions, account inquiry, and the daily reconciliation a '
          'teller closes their shift on. Built to feel fast, clean, and easy to use even '
          'at the counter during rush hour, it pairs a considered visual layer with the '
          'reliability and correctness a financial product depends on. This was client '
          'work — translating real banking workflows into an interface tellers reach for '
          'hundreds of times a day without friction.',
      tech: ['Flutter', 'REST APIs', 'Banking'],
      images: AppAssets.feTouch,
      media: ProjectMedia.framedGallery,
      frame: ProjectFrame.browser,
      dominantColor: Color(0xFF5E9C90),
      accentColor: Color(0xFF2F6F64),
      highlights: [
        'A teller-first workspace: cash transactions, inquiry, and end-of-shift '
            'reconciliation, all a tap or two away.',
        'A calm, modern interface layered over real banking workflows — fast to read '
            'and act on at a busy counter.',
        'Built with the correctness and reliability discipline a financial product '
            'demands, as client work for PT Collega Inti Pratama.',
      ],
      role: 'Flutter UI engineering · client work',
      year: '2022',
      status: 'Shipped',
    ),
    const Project(
      id: 'balai',
      name: 'Balai',
      category: 'AUCTION APP',
      platform: ProjectPlatform.mobile,
      tagline: "An auction app with a curator's eye — themed, timed drops, not an endless feed.",
      shortDesc:
          'A mobile auction platform reframed around curated drops: a curator assembles '
          'a themed sale of a few lots and runs it as a live, timed event. Auction-house '
          'proxy bidding with staggered closes and anti-snipe extensions.',
      fullDesc:
          'Most auction apps are endless marketplaces — infinite listings, no point of '
          'view. Balai is built on the opposite instinct: scarcity and taste. It centres '
          'on curated drops, where a curator assembles a themed sale of a handful of lots, '
          'sets the schedule, and the whole thing runs as a live, timed event with a real '
          'sense of occasion. Bidding follows an auction-house model — ascending proxy '
          'bidding with staggered closes and anti-snipe soft closes — and the design is '
          'editorial and image-forward, with a calm paper-toned browse and a dramatic '
          'dark "gallery spotlight" mode for the live moment.',
      tech: ['Flutter', 'Firebase', 'Cloud Functions', 'Real-time'],
      images: AppAssets.balai,
      media: ProjectMedia.mockupGallery,
      dominantColor: Color(0xFF14110F),
      accentColor: Color(0xFFC2A24E),
      metrics: [
        ProjectMetric('3', 'Roles'),
        ProjectMetric('Proxy', 'Bidding'),
        ProjectMetric('Live', 'Timed drops'),
      ],
      highlights: [
        'Reframed a generic auction concept into a curated, event-driven "drops" model '
            'built on scarcity and taste.',
        'An auction-house proxy-bidding engine with staggered closes and anti-snipe '
            'soft-close extensions.',
        'A three-role system — seller → curator → buyer — with the curator as the '
            'editorial layer that turns listings into a show.',
        'Server-side, transactional bid resolution via Cloud Functions keeps the proxy '
            'logic fair and race-condition-free.',
      ],
      role: 'Solo — product reframe, system design, visual language',
      year: '2026',
      status: 'Shipped',
      prototypeUrl: 'prototypes/balai.html',
    ),
  ];

  static Project? projectById(String id) {
    for (final p in projects) {
      if (p.id == id) {
        return p;
      }
    }
    return null;
  }

  // ── Career timeline (oldest → most recent) ─────────────────────────────

  static const List<CareerEvent> careerEvents = [
    CareerEvent(
      year: 2019,
      title: 'Intern Mobile Developer',
      company: 'Lontar Lab.',
      location: 'Bandung, Indonesia',
      period: '2019 — 2020',
      description:
          'Where the journey began — building my first real mobile screens '
          'and falling for the craft of making interfaces feel right.',
      highlights: [
        'Shipped first production Flutter UI',
        'Learned mobile & layout fundamentals hands-on',
        'Discovered a love for motion and detail',
      ],
    ),
    CareerEvent(
      year: 2020,
      title: 'Software Engineer',
      company: 'PT Collega Inti Pratama',
      location: 'Jakarta, Indonesia',
      period: '2020 — 2022',
      description:
          'Worked across the banking stack and learned how robust products '
          'are really built — the foundation my visual work now stands on.',
      highlights: [
        'Maintained the Olibs 724 core-banking system',
        'Bridged backend logic to client-facing teams',
        'Grew the engineering rigor behind clean UI',
      ],
    ),
    CareerEvent(
      year: 2022,
      title: 'Flutter & Visual Engineer',
      company: 'PT Collega Inti Pratama',
      location: 'Jakarta, Indonesia',
      period: '2022 — Present',
      description:
          'Own the visual layer end to end — translating Figma into '
          'design-system-driven, animated Flutter interfaces that feel alive.',
      highlights: [
        'Lead Flutter UI for banking products',
        'Build design systems & motion from Figma to ship',
        'Craft micro-interactions and high-performance visuals',
      ],
    ),
  ];

  // ── Toolkit — a visual specialist's pillars ────────────────────────────

  static const List<ToolkitPillar> toolkitPillars = [
    ToolkitPillar(
      name: 'Flutter Engineering',
      tagline:
          'Production Flutter with getx architecture and buttery smooth interfaces — '
          'custom-painted, pixel-exact, and built to scale.',
      level: 'SPECIALIST',
      icon: LucideIcons.smartphone,
      accent: AppColors.accentPrimary,
      skills: [
        Skill('Getx', LucideIcons.code),
        Skill('Firebase', Icons.local_fire_department),
        Skill('Custom Painters', LucideIcons.penTool),
        Skill('Performance', LucideIcons.gauge),
      ],
    ),
    ToolkitPillar(
      name: 'Product Design',
      tagline:
          'Figma-first design systems, prototypes, and interfaces that feel '
          'inevitable — where structure meets the beauty.',
      level: 'SPECIALIST',
      icon: LucideIcons.penTool,
      accent: AppColors.accentSecondary,
      skills: [
        Skill('Figma', LucideIcons.figma),
        Skill('UI / UX', LucideIcons.layoutDashboard),
        Skill('Design Systems', LucideIcons.layers),
        Skill('Prototyping', LucideIcons.frame),
      ],
    ),
    ToolkitPillar(
      name: 'Motion & Craft',
      tagline:
          'Micro-interactions and motion design that make products feel alive — '
          'every easing curve and transition intentional.',
      level: 'SPECIALIST',
      icon: LucideIcons.sparkles,
      accent: AppColors.accentPrimary,
      skills: [
        Skill('Animation', LucideIcons.sparkles),
        Skill('Micro-interactions', LucideIcons.pointer),
        Skill('Visual Design', LucideIcons.palette),
      ],
    ),
  ];

  // ── About stats ────────────────────────────────────────────────────────

  static const List<({String value, String label})> stats = [
    (value: '5+', label: 'Years\nExperience'),
    (value: '10+', label: 'Projects\nCompleted'),
    (value: 'Millions', label: 'of Lines\nWritten'),
    (value: 'Hundreds', label: 'of Screens\nDesigned'),
    (value: '∞', label: 'Coffee\nConsumed'),
  ];

  // ── Social links ───────────────────────────────────────────────────────

  static const List<({String label, String url})> socials = [
    (label: 'GitHub', url: 'https://github.com/lraihan'),
    (label: 'LinkedIn', url: 'https://www.linkedin.com/in/raihan-fadli-dev/'),
    (label: 'Instagram', url: 'https://www.instagram.com/locio_raihan/'),
  ];

  static const String githubUrl = 'https://github.com/lraihan';
  static const String linkedInUrl = 'https://www.linkedin.com/in/raihan-fadli-dev/';
}
