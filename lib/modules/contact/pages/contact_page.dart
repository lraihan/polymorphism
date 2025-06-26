import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({
    super.key,
    this.subject,
    this.message,
  });

  final String? subject;
  final String? message;

  @override
  Widget build(BuildContext context) {
    var displayText = 'Contact Page';
    if (subject != null || message != null) {
      final params = <String>[];
      if (subject != null) {
        params.add('Subject: $subject');
      }
      if (message != null) {
        params.add('Message: $message');
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
