import 'package:flutter/material.dart';

class CaseStudiesPage extends StatelessWidget {
  const CaseStudiesPage({super.key, this.category});

  final String? category;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Case Studies Page'),
          if (category != null) ...[const SizedBox(height: 8), Text('Category: $category')],
        ],
      ),
    ),
  );
}
