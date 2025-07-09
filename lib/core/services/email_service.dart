import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for sending emails using EmailJS
/// EmailJS configuration:
/// 1. Sign up at https://www.emailjs.com/
/// 2. Create an email service (Gmail, Outlook, etc.)
/// 3. Create an email template
/// 4. Get your service ID, template ID, and public key
class EmailService {
  // TODO: Replace these with your actual EmailJS credentials
  // You can get these from your EmailJS dashboard
  static const String _serviceId = 'service_76vo6w8';
  static const String _templateId = 'template_yt7o10q';
  static const String _publicKey = 'K0ysWcHTWMK41N_TC';

  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Send email using EmailJS
  /// Returns true if successful, false otherwise

  static Future<bool> sendEmail({
    required String fromName,
    required String fromEmail,
    required String message,
    String? subject,
  }) async {
    return _sendEmailWithEmailJS(fromName: fromName, fromEmail: fromEmail, message: message, subject: subject);
  }

  /// Demo implementation that simulates sending email
  /// Replace this with the actual EmailJS implementation below
  static Future<bool> _sendEmailDemo({
    required String fromName,
    required String fromEmail,
    required String message,
    String? subject,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo, we'll return true (success)
    // In real implementation, this would be replaced by the EmailJS call
    return true;
  }

  /// Actual EmailJS implementation (use this when you have credentials)
  /// Uncomment and configure when you set up EmailJS
  static Future<bool> _sendEmailWithEmailJS({
    required String fromName,
    required String fromEmail,
    required String message,
    String? subject,
  }) async {
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
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email.trim());
  }
}
