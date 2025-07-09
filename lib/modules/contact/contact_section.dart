import 'package:flutter/material.dart';
import 'package:polymorphism/core/services/email_service.dart';
import 'package:polymorphism/core/theme/app_theme.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key, this.enableAnimations = true});
  final bool enableAnimations;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message is required';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await EmailService.sendEmail(
        fromName: _nameController.text.trim(),
        fromEmail: _emailController.text.trim(),
        message: _messageController.text.trim(),
        subject: 'Portfolio Contact Form - ${_nameController.text.trim()}',
      );

      if (mounted) {
        if (success) {
          _formKey.currentState!.reset();
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(child: Text("Message sent successfully! I'll get back to you soon.")),
                ],
              ),
              backgroundColor: AppColors.accent,
            ),
          );
        } else {
          await _openEmailClient();
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        await _openEmailClient();
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _openEmailClient() async {
    try {
      final subject = Uri.encodeComponent('Portfolio Inquiry');
      final body = Uri.encodeComponent(
        'Hi Raihan,\n\n'
        'Name: ${_nameController.text.trim()}\n'
        'Email: ${_emailController.text.trim()}\n\n'
        'Message:\n${_messageController.text.trim()}\n\n'
        'Best regards,\n${_nameController.text.trim()}',
      );

      final mailtoUrl = 'mailto:lraihan@hackermail.com?subject=$subject&body=$body';
      final uri = Uri.parse(mailtoUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.email, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(child: Text('Email client opened with your message!')),
                ],
              ),
              backgroundColor: AppColors.accent,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception('Could not launch email client');
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Error: Please email me directly at lraihan@hackermail.com')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 800;
    final isMobile = screenWidth < 600;

    final horizontalPadding =
        isMobile
            ? 16.0
            : isWide
            ? 24.0
            : 20.0;
    final verticalPadding = isMobile ? 24.0 : 40.0;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 600 : double.infinity),
            child:
                widget.enableAnimations
                    ? ScrollReveal(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 1000),
                      child: _buildContent(theme),
                    )
                    : _buildContent(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Let's build something together.",
        style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
      const SizedBox(height: 16),

      Text(
        'Have a project in mind? Send me a message below or email me directly at lraihan@hackermail.com',
        style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary.withValues(alpha: .8)),
      ),
      const SizedBox(height: 32),

      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              validator: _validateName,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: .7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: .3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: .3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: .7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: .3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: .3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _messageController,
              validator: _validateMessage,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: .7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: .3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: .3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.6),
                ),
                child:
                    _isSubmitting
                        ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Sending...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 18),
                            SizedBox(width: 8),
                            Text('Send Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
