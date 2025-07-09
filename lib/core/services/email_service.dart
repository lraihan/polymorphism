import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = String.fromEnvironment('EMAILJS_SERVICE_ID');
  static const String _templateId = String.fromEnvironment('EMAILJS_TEMPLATE_ID');
  static const String _publicKey = String.fromEnvironment('EMAILJS_PUBLIC_KEY');

  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Send email using EmailJS
  /// Returns true if successful, false otherwise

  static Future<bool> sendEmail({
    required String fromName,
    required String fromEmail,
    required String message,
    String? subject,
  }) async => _sendEmailWithEmailJS(fromName: fromName, fromEmail: fromEmail, message: message, subject: subject);

  static Future<bool> _sendEmailWithEmailJS({
    required String fromName,
    required String fromEmail,
    required String message,
    String? subject,
  }) async {
    // Validate that environment variables are set
    if (_serviceId.isEmpty || _templateId.isEmpty || _publicKey.isEmpty) {
      debugPrint(
        'EmailJS configuration missing. Please set EMAILJS_SERVICE_ID, EMAILJS_TEMPLATE_ID, and EMAILJS_PUBLIC_KEY environment variables.',
      );
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'from_name': fromName,
            'from_email': fromEmail,
            'to_email': 'lraihan@hackermail.com', // Your email
            'subject': subject ?? 'Portfolio Contact Form',
            'message': '$fromName at $fromEmail : $message',
          },
        }),
      );

      return response.statusCode == 200;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Error sending email: $e');
      return false;
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email.trim());
  }
}
