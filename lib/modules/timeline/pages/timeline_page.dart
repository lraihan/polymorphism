import 'package:flutter/material.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({
    super.key,
    this.year,
    this.filter,
  });

  final String? year;
  final String? filter;

  @override
  Widget build(BuildContext context) {
    var displayText = 'Timeline Page';
    if (year != null || filter != null) {
      final params = <String>[];
      if (year != null) {
        params.add('Year: $year');
      }
      if (filter != null) {
        params.add('Filter: $filter');
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
