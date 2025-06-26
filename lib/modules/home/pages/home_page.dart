import 'package:flutter/material.dart';
import 'package:polymorphism/modules/home/hero_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.section});

  final String? section;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) => const HeroSection()));
}
