import 'package:flutter/material.dart';

/// A single entry in the experience timeline.
@immutable
class CareerEvent {
  const CareerEvent({
    required this.year,
    required this.title,
    required this.description,
    this.company,
    this.location,
    this.period,
    this.highlights = const [],
  });

  final int year;
  final String title;
  final String description;
  final String? company;
  final String? location;

  /// Human-readable date range, e.g. `2020 — 2022`.
  final String? period;

  /// Bullet highlights revealed when the entry is expanded on hover.
  final List<String> highlights;
}
