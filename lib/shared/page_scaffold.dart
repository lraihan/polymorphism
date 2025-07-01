import 'package:flutter/material.dart';
import 'navbar/navbar.dart';
import 'footer/footer.dart';

/// Reusable page scaffold with navbar and footer
class PageScaffold extends StatelessWidget {
  final Widget body;
  final bool showFooter;

  const PageScaffold({
    super.key,
    required this.body,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Navigation bar
          const Navbar(),
          
          // Main content
          Expanded(
            child: body,
          ),
          
          // Footer (if enabled)
          if (showFooter) const Footer(),
        ],
      ),
    );
  }
}
