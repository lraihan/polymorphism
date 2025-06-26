import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.section,
  });

  final String? section;

  @override
  Widget build(BuildContext context) {
    final displayText = section != null 
        ? 'Home Page (Section: $section)' 
        : 'Home Page';
    
    return Scaffold(
      body: Center(
        child: Text(displayText),
      ),
    );
  }
}
