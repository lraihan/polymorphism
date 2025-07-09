import 'package:flutter/material.dart';

/// Model representing a project in the portfolio
@immutable
class Project {
  const Project({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.scope,
    this.description,
    this.projectUrl,
    this.imageUrl,
    this.technologies = const [],
  });

  final String title;
  final String subtitle;
  final String category;
  final String scope;
  final String? description;
  final String? projectUrl;
  final String? imageUrl;
  final List<String> technologies;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          subtitle == other.subtitle &&
          category == other.category &&
          scope == other.scope &&
          description == other.description &&
          projectUrl == other.projectUrl &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      title.hashCode ^
      subtitle.hashCode ^
      category.hashCode ^
      scope.hashCode ^
      description.hashCode ^
      projectUrl.hashCode ^
      imageUrl.hashCode;

  @override
  String toString() => 'Project(title: $title, category: $category)';
}

/// Sample projects for demonstration
const List<Project> sampleProjects = [
  Project(
    title: 'Flutter Portfolio',
    subtitle: 'Premium interactive web portfolio with cutting-edge animations',
    category: 'Digital Design',
    scope: 'Personal Project',
    description:
        'A modern portfolio website built with Flutter Web, featuring smooth animations, responsive design, and interactive elements.',
    technologies: ['Flutter', 'Dart', 'Web'],
  ),
  Project(
    title: 'Mobile Banking App',
    subtitle: 'Secure and intuitive financial management platform',
    category: 'Innovation',
    scope: 'Client Work',
    description:
        'A comprehensive mobile banking application with advanced security features and user-friendly interface.',
    technologies: ['Flutter', 'Firebase', 'REST API'],
  ),
  Project(
    title: 'E-Commerce Platform',
    subtitle: 'Modern marketplace with seamless shopping experience',
    category: 'Digital Art',
    scope: 'Commercial Project',
    description: 'Full-featured e-commerce platform with advanced filtering, payment integration, and admin dashboard.',
    technologies: ['Flutter', 'Node.js', 'MongoDB'],
  ),
  Project(
    title: 'Task Management System',
    subtitle: 'Collaborative workspace for team productivity',
    category: 'Personal',
    scope: 'Side Project',
    description: 'A collaborative task management application with real-time updates and team collaboration features.',
    technologies: ['Flutter', 'WebSocket', 'Cloud Functions'],
  ),
  Project(
    title: 'Open Source Widget Library',
    subtitle: 'Reusable UI components for Flutter developers',
    category: 'Open Source',
    scope: 'Community Contribution',
    description: 'A collection of beautiful and customizable Flutter widgets available for the community.',
    technologies: ['Flutter', 'Dart', 'GitHub Actions'],
  ),
  Project(
    title: 'Design System',
    subtitle: 'Comprehensive design language and component library',
    category: 'Typography',
    scope: 'Internal Tool',
    description:
        'A complete design system with typography, colors, components, and guidelines for consistent UI development.',
    technologies: ['Flutter', 'Figma', 'Design Tokens'],
  ),
];
