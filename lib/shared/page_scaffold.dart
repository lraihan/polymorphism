import 'package:flutter/material.dart';
import 'package:polymorphism/shared/footer/footer.dart';
import 'package:polymorphism/shared/navbar/navbar.dart';

/// Reusable page scaffold with navbar and footer
class PageScaffold extends StatelessWidget {

  const PageScaffold({required this.body, super.key, this.showFooter = true});
  final Widget body;
  final bool showFooter;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Column(
        children: [
          // Navigation bar
          const Navbar(),

          // Main content
          Expanded(child: body),

          // Footer (if enabled)
          if (showFooter) const Footer(),
        ],
      ),
    );
}
