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

  // ── Projects (bento order) ─────────────────────────────────────────────

  static final List<Project> projects = [
    Project(
      id: 'fe-touch',
      title: 'FE Touch',
      category: 'TABLET APP',
      tagline: 'A modern teller workspace for everyday banking.',
      description:
          'A sleek, tablet-based app made for bank tellers — built with '
          'PT Collega Inti Pratama. FE Touch brings a fresh, modern interface '
          'to everyday banking tasks: something that feels fast, clean, and '
          'easy to use, even at the counter during rush hour.',
      tech: const ['Flutter', 'REST APIs', 'Tablet UI'],
      images: AppAssets.projectImages(1),
      scale: ProjectScale.featured,
      screenshots: ScreenshotKind.landscape,
      accent: AppColors.accentPrimary,
    ),
    Project(
      id: 'panic-button',
      title: 'Panic Button',
      category: 'MOBILE APP',
      tagline: 'Real-time SOS reporting for Damkar Banten.',
      description:
          'A simple yet essential SOS app built for Damkar Banten. Designed '
          'for quick, real-time emergency reporting and tracking, it helps '
          'firefighters receive, manage, and respond to incidents faster. '
          'Clean UI meets critical functionality — because in emergencies, '
          'every second (and every tap) counts.',
      tech: const ['Flutter', 'Real-time', 'Geo Tracking'],
      images: AppAssets.projectImages(3),
      scale: ProjectScale.standard,
      screenshots: ScreenshotKind.portrait,
      accent: AppColors.errorRed,
    ),
    Project(
      id: 'digital-lending',
      title: 'Digital Lending',
      category: 'MOBILE APP',
      tagline: 'The lending process, fully online.',
      description:
          'A seamless loan application platform that brings the lending '
          'process fully online — from registration to approval. Built to '
          'simplify and speed up credit access for users, while giving banks '
          'a smarter way to manage risk and workflow. Digital Lending makes '
          'borrowing feel less like paperwork and more like progress.',
      tech: const ['Flutter', 'Fintech', 'REST APIs'],
      images: AppAssets.projectImages(4),
      scale: ProjectScale.standard,
      screenshots: ScreenshotKind.portrait,
      accent: AppColors.accentSecondary,
    ),
    Project(
      id: 'core-x',
      title: 'Core X',
      category: 'CORE BANKING',
      tagline: 'The heart of banking operations, rebuilt.',
      description:
          'A modern core banking solution built to replace the aging '
          'Olibs 724 system. Designed to handle the heart of banking '
          'operations with a more scalable, efficient, and user-friendly '
          'approach, Core X brings a fresh layer of clarity and performance '
          'to complex processes — all while keeping the reliability banks '
          'depend on.',
      tech: const ['Flutter', 'Java', 'Banking Core'],
      images: AppAssets.projectImages(2),
      scale: ProjectScale.featured,
      screenshots: ScreenshotKind.landscape,
      accent: AppColors.accentPrimary,
    ),
    Project(
      id: 'lelang-online',
      title: 'Lelang Online',
      category: 'MOBILE APP',
      tagline: 'Live auctions, on your screen.',
      description:
          'A digital platform that brings the excitement of live auctions to '
          'your screen. Built to simplify the bidding process, manage '
          'listings, and ensure a fair, transparent experience for all '
          "users. Whether you're buying or selling, Lelang Online makes "
          'auctions feel accessible, fast, and just a little more fun.',
      tech: const ['Flutter', 'Live Bidding', 'Marketplace'],
      images: AppAssets.projectImages(5),
      scale: ProjectScale.standard,
      screenshots: ScreenshotKind.portrait,
      accent: AppColors.warningAmber,
    ),
    Project(
      id: 'roast-pos',
      title: 'Roast POS',
      category: 'POS PLATFORM',
      tagline: 'Restaurant operations, end to end.',
      description:
          'An all-in-one restaurant operations app built to handle everything '
          'from POS transactions to inventory, stock tracking, staff '
          'presence, and real-time dashboards. Designed for smooth day-to-day '
          "operations — whether you're managing the floor, the kitchen, or "
          'the cash flow. Roast POS brings structure, clarity, and speed to '
          'the hustle of running a restaurant.',
      tech: const ['Flutter', 'POS', 'Dashboards'],
      images: AppAssets.projectImages(6),
      scale: ProjectScale.standard,
      screenshots: ScreenshotKind.landscape,
      accent: AppColors.successGreen,
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
