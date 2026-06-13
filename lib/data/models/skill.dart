import 'package:flutter/material.dart';

/// A toolkit entry — an icon chip inside a pillar.
@immutable
class Skill {
  const Skill(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// A named group of skills — rendered as one row block in the grid.
@immutable
class SkillCategory {
  const SkillCategory(this.name, this.skills);

  final String name;
  final List<Skill> skills;
}

/// A headline capability in the About toolkit — a rich, hover-reactive card
/// rather than a bare chip: a discipline with a tagline, a level, an accent,
/// and the tools beneath it.
@immutable
class ToolkitPillar {
  const ToolkitPillar({
    required this.name,
    required this.tagline,
    required this.level,
    required this.icon,
    required this.accent,
    required this.skills,
  });

  final String name;
  final String tagline;

  /// Short proficiency label, e.g. `SPECIALIST`.
  final String level;
  final IconData icon;
  final Color accent;
  final List<Skill> skills;
}
