import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({
    super.key,
    this.demo,
    this.category,
  });

  final String? demo;
  final String? category;

  @override
  Widget build(BuildContext context) {
    var displayText = 'Playground Page';
    if (demo != null || category != null) {
      final params = <String>[];
      if (demo != null) {
        params.add('Demo: $demo');
      }
      if (category != null) {
        params.add('Category: $category');
      }
      displayText += ' (${params.join(', ')})';
    }
    
    return Scaffold(
      body: Center(
        child: Text(displayText),
      ),
    );
  }
}
