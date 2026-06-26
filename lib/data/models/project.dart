import 'package:flutter/material.dart';

/// What kind of product a project is — drives the category dot and copy tone.
enum ProjectPlatform { mobile, web, tablet, pos, crossPlatform }

/// How the spotlight media panel renders a project.
enum ProjectMedia {
  /// Raw screenshots wrapped in a code-drawn device frame ([ProjectFrame]).
  framedGallery,

  /// Pre-framed phone mockups (rendered from the live prototype), presented
  /// directly with depth and ambient glow — no extra frame.
  mockupGallery,

  /// Generated editorial art — used when a project has no imagery yet.
  abstractArt,
}

/// The device chrome wrapping a [ProjectMedia.framedGallery] project.
enum ProjectFrame { browser, tablet, none }

/// A headline figure for a project — `680+` / `Passing tests`.
@immutable
class ProjectMetric {
  const ProjectMetric(this.value, this.label);

  final String value;
  final String label;
}

/// A portfolio work entry. All content lives in `portfolio_data.dart`.
@immutable
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.category,
    required this.platform,
    required this.tagline,
    required this.shortDesc,
    required this.fullDesc,
    required this.tech,
    required this.images,
    required this.media,
    required this.dominantColor,
    required this.accentColor,
    this.frame = ProjectFrame.none,
    this.highlights = const [],
    this.metrics = const [],
    this.role,
    this.year,
    this.status,
    this.githubUrl,
    this.liveUrl,
    this.prototypeUrl,
    this.isFeatured = false,
  });

  /// URL slug — `/work/<id>`.
  final String id;
  final String name;

  /// Mono eyebrow on the card — `POS PLATFORM`.
  final String category;
  final ProjectPlatform platform;

  /// One punchy line (≤ ~12 words).
  final String tagline;

  /// 2–3 sentences for the spotlight detail panel.
  final String shortDesc;

  /// Full paragraph(s) for the case-study overview.
  final String fullDesc;

  /// Tech stack, ordered by prominence.
  final List<String> tech;

  /// Ordered screenshot paths — `images.first` is the hero.
  final List<String> images;

  final ProjectMedia media;

  /// Frame for [ProjectMedia.framedGallery]; ignored otherwise.
  final ProjectFrame frame;

  /// Primary project color — drives the ambient section glow.
  final Color dominantColor;

  /// Secondary color — tags, metrics, the case-study CTA.
  final Color accentColor;

  /// Bullet-style achievements for the case study's "The Build".
  final List<String> highlights;

  /// 2–3 figures showcased on the card and case study.
  final List<ProjectMetric> metrics;

  /// Meta line: who/when/where it stands.
  final String? role;
  final String? year;
  final String? status;

  final String? githubUrl;
  final String? liveUrl;

  /// Served URL of a live HTML prototype (Flutter-web iframe), e.g.
  /// `prototypes/elssa.html` under `web/`. Null when there's no prototype.
  final String? prototypeUrl;

  /// Featured projects get slightly more vertical weight.
  final bool isFeatured;

  bool get hasPrototype => prototypeUrl != null;

  String get heroTag => 'project-$id';

  /// Portrait media (phone mockups) reads narrower than landscape frames.
  bool get isPortraitMedia => media == ProjectMedia.mockupGallery;

  bool get hasImages => images.isNotEmpty;
}
