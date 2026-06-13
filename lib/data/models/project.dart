import 'package:flutter/material.dart';

/// How much bento real estate a project commands.
enum ProjectScale {
  /// Spans two grid columns — the spotlight cards.
  featured,

  /// Single-column card.
  standard,
}

/// Orientation of the project's screenshots.
enum ScreenshotKind { landscape, portrait }

/// A portfolio work entry. All content lives in `portfolio_data.dart`.
@immutable
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.category,
    required this.tagline,
    required this.description,
    required this.tech,
    required this.images,
    required this.scale,
    required this.screenshots,
    required this.accent,
  });

  /// URL slug — `/work/<id>`.
  final String id;
  final String title;

  /// Mono eyebrow tag on the card, e.g. `TABLET APP`.
  final String category;

  /// One-liner shown on cards.
  final String tagline;

  /// Full paragraph for the detail overlay.
  final String description;

  /// Tech stack badges (2–4 on cards, all in detail view).
  final List<String> tech;

  /// Screenshot asset paths (first one is the card visual).
  final List<String> images;

  final ProjectScale scale;
  final ScreenshotKind screenshots;

  /// Per-project accent for glows and generative card art.
  final Color accent;

  String get heroTag => 'project-$id';
}
