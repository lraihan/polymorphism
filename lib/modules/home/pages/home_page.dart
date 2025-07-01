import 'package:flutter/material.dart';
import 'package:polymorphism/modules/gallery/gallery_section.dart';
import 'package:polymorphism/modules/home/hero_section.dart';
import 'package:polymorphism/modules/home/projects_section.dart';
import 'package:polymorphism/modules/timeline/timeline_section.dart';
import 'package:polymorphism/modules/contact/contact_section.dart';
import '../../../shared/page_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.section});

  final String? section;

  @override
  Widget build(BuildContext context) => PageScaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height, child: const HeroSection()),
          const ProjectsSection(),
          const GallerySection(),
          const TimelineSection(),
          const ContactSection(),
        ],
      ),
    ),
  );
}
