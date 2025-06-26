import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    super.key,
    this.searchQuery,
    this.tag,
  });

  final String? searchQuery;
  final String? tag;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Gallery Page'),
              if (searchQuery != null) ...[
                const SizedBox(height: 8),
                Text('Search: $searchQuery'),
              ],
              if (tag != null) ...[
                const SizedBox(height: 8),
                Text('Tag: $tag'),
              ],
            ],
          ),
        ),
      );
}
