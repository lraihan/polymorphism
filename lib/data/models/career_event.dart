import 'package:flutter/material.dart';

@immutable
class CareerEvent {
  const CareerEvent({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
    this.company,
    this.location,
  });
  final int year;
  final String title;
  final String description;
  final IconData icon;
  final String? company;
  final String? location;

  static List<CareerEvent> get sampleEvents => [
    const CareerEvent(
      year: 2019,
      title: 'Intern Mobile Developer',
      description:
          'Started career in mobile development as an intern. the focus was on assisting in the creation of mobile applications.',
      icon: Icons.code,
      company: 'Lontar Lab.',
      location: 'Bandung, Indonesia',
    ),
    const CareerEvent(
      year: 2020,
      title: 'Java Software Engineer',
      description:
          "Actively involved in the maintenance and development of Collega's Application Java Project Olibs Backend 724.",
      icon: Icons.code,
      company: 'PT Collega Inti Pratama',
      location: 'Jakarta, Indonesia',
    ),
    const CareerEvent(
      year: 2022,
      title: 'Flutter Developer',
      description:
          "Specialized in Flutter, my focus was creating new and innovative flutter applications that leverage the framework's capabilities for high performance and beautiful UI.",
      icon: Icons.code,
      company: 'PT Collega Inti Pratama',
      location: 'Jakarta, Indonesia',
    ),
    CareerEvent(
      year: DateTime.now().year,
      title: 'Continuous Growth & Learning',
      description:
          "The journey never stops. exploring cutting-edge design patterns, and building innovative digital experiences. Always learning, always growing, always pushing the boundaries of what's possible.",
      icon: Icons.auto_awesome,
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
