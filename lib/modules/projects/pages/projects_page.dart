import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key, this.searchQuery, this.category});

  final String? searchQuery;
  final String? category;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Projects Page'),
          if (searchQuery != null) ...[const SizedBox(height: 8), Text('Search: $searchQuery')],
          if (category != null) ...[const SizedBox(height: 8), Text('Category: $category')],
        ],
      ),
    ),
  );
}
