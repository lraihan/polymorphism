import 'package:flutter/material.dart';

/// Model representing a career milestone or event
class CareerEvent {
  final int year;
  final String title;
  final String description;
  final IconData icon;
  final String? company;
  final String? location;

  const CareerEvent({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
    this.company,
    this.location,
  });

  /// Sample career events for demonstration
  static List<CareerEvent> get sampleEvents => [
    const CareerEvent(
      year: 2018,
      title: 'Frontend Developer',
      description:
          'Started career in web development with React and modern JavaScript frameworks. Built responsive UIs and collaborated with design teams.',
      icon: Icons.code,
      company: 'Tech Startup Inc.',
      location: 'San Francisco, CA',
    ),
    const CareerEvent(
      year: 2019,
      title: 'Mobile Developer',
      description:
          'Transitioned to mobile development with React Native. Delivered cross-platform apps with complex state management and API integrations.',
      icon: Icons.phone_android,
      company: 'Mobile Solutions LLC',
      location: 'Austin, TX',
    ),
    const CareerEvent(
      year: 2020,
      title: 'Flutter Specialist',
      description:
          'Specialized in Flutter development during remote work era. Created performant, beautiful apps with custom animations and widgets.',
      icon: Icons.flutter_dash,
      company: 'Digital Agency Co.',
      location: 'Remote',
    ),
    const CareerEvent(
      year: 2021,
      title: 'Senior Flutter Engineer',
      description:
          'Led Flutter architecture decisions and mentored junior developers. Implemented complex UI/UX patterns and state management solutions.',
      icon: Icons.architecture,
      company: 'Enterprise Tech Corp.',
      location: 'Seattle, WA',
    ),
    const CareerEvent(
      year: 2022,
      title: 'Technical Lead',
      description:
          'Managed cross-functional teams and drove technical strategy. Established best practices for Flutter development and CI/CD pipelines.',
      icon: Icons.groups,
      company: 'Innovation Labs',
      location: 'Portland, OR',
    ),
    const CareerEvent(
      year: 2023,
      title: 'Flutter Consultant',
      description:
          'Founded independent consultancy focusing on Flutter performance optimization and advanced UI patterns. Client work spans fintech to healthcare.',
      icon: Icons.business_center,
      company: 'Polymorphism Studios',
      location: 'Global',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareerEvent &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          title == other.title &&
          description == other.description &&
          icon == other.icon &&
          company == other.company &&
          location == other.location;

  @override
  int get hashCode =>
      year.hashCode ^ title.hashCode ^ description.hashCode ^ icon.hashCode ^ company.hashCode ^ location.hashCode;

  @override
  String toString() => 'CareerEvent(year: $year, title: $title, company: $company)';
}
