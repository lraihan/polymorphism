import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/services/email_service.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';
import 'package:polymorphism/core/theme/app_typography.dart';
import 'package:polymorphism/core/utils/download/download_file.dart';
import 'package:polymorphism/core/utils/extensions.dart';
import 'package:polymorphism/core/utils/responsive.dart';
import 'package:polymorphism/data/portfolio_data.dart';
import 'package:polymorphism/features/contact/availability_badge.dart';
import 'package:polymorphism/shared/animations/scroll_reveal.dart';
import 'package:polymorphism/shared/widgets/cta_button.dart';
import 'package:polymorphism/shared/widgets/custom_cursor.dart';
import 'package:polymorphism/shared/widgets/magnetic_button.dart';
import 'package:polymorphism/shared/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

/// 04 / CONTACT — never make the visitor hunt.
///
/// Form posts through EmailJS (keys injected via --dart-define) with a
/// mailto: fallback; success fires a confetti burst from the send button.
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  late final ConfettiController _confetti;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _submitting = true);

    var sent = false;
    try {
      sent = await EmailService.sendEmail(
        fromName: _name.text.trim(),
        fromEmail: _email.text.trim(),
        message: _message.text.trim(),
        subject: 'Portfolio Contact Form - ${_name.text.trim()}',
      );
    } on Exception {
      sent = false;
    }

    if (!mounted) {
      return;
    }
    if (sent) {
      _formKey.currentState!.reset();
      _name.clear();
      _email.clear();
      _message.clear();
      if (!context.reducedMotion) {
        _confetti.play();
      }
      _notify(AppStrings.contactSuccess, LucideIcons.checkCheck, AppColors.successGreen);
    } else {
      await _mailtoFallback();
    }
    if (mounted) {
      setState(() => _submitting = false);
    }
  }

  Future<void> _mailtoFallback() async {
    final subject = Uri.encodeComponent('Portfolio Inquiry');
    final body = Uri.encodeComponent(
      'Hi ${AppStrings.ownerName},\n\n'
      'Name: ${_name.text.trim()}\n'
      'Email: ${_email.text.trim()}\n\n'
      'Message:\n${_message.text.trim()}',
    );
    final uri = Uri.parse('mailto:${AppStrings.email}?subject=$subject&body=$body');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        if (mounted) {
          _notify(AppStrings.contactMailFallback, LucideIcons.mail, AppColors.accentPrimary);
        }
        return;
      }
      throw Exception('no mail client');
    } on Exception {
      if (mounted) {
        _notify(AppStrings.contactError, LucideIcons.circleAlert, AppColors.errorRed);
      }
    }
  }

  void _notify(String text, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: Spacing.sm),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.pageGutter, vertical: context.sectionSpacing),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Spacing.pageMaxWidth),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _intro(context),
                    const SizedBox(height: Spacing.xxl),
                    ScrollReveal(delay: AppDurations.instant, child: _form(context)),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: the invitation + direct ways to reach me.
                    Expanded(flex: 5, child: _intro(context)),
                    const SizedBox(width: Spacing.section),
                    // Right: the form.
                    Expanded(flex: 6, child: ScrollReveal(delay: AppDurations.instant, child: _form(context))),
                  ],
                ),
        ),
      ),
    );
  }

  /// Left/top block: header, availability, invite copy, and direct links.
  Widget _intro(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionHeader(eyebrow: AppStrings.contactEyebrow, title: AppStrings.contactTitle, trailingRule: false),
      const SizedBox(height: Spacing.lg),
      const ScrollReveal(child: AvailabilityBadge(label: AppStrings.contactAvailability)),
      const SizedBox(height: Spacing.lg),
      ScrollReveal(
        delay: AppDurations.instant,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(AppStrings.contactInvite, style: AppTypography.bodyL),
        ),
      ),
      const SizedBox(height: Spacing.xl),
      ScrollReveal(
        delay: AppDurations.fast,
        child: CtaButton.primary(
          label: AppStrings.ctaDownloadCv,
          icon: Icons.file_download_outlined,
          onTap: () => downloadFile(AppStrings.cvUrl, filename: 'Raihan_Fadli_CV.pdf'),
        ),
      ),
      const SizedBox(height: Spacing.lg),
      ScrollReveal(delay: AppDurations.normal, child: _directLinks(context)),
    ],
  );

  Widget _form(BuildContext context) => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _nameField()),
            const SizedBox(width: Spacing.md),
            Expanded(child: _emailField()),
          ],
        ),
        const SizedBox(height: Spacing.md),
        TextFormField(
          controller: _message,
          maxLines: 6,
          style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary),
          decoration: const InputDecoration(labelText: AppStrings.contactMessageLabel, alignLabelWithHint: true),
          validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.errMessageRequired : null,
        ),
        const SizedBox(height: Spacing.lg),
        Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _SendButton(submitting: _submitting, onTap: _submitting ? null : _submit),
              ConfettiWidget(
                confettiController: _confetti,
                blastDirection: -math.pi / 2,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.7,
                numberOfParticles: 12,
                maxBlastForce: 18,
                minBlastForce: 6,
                gravity: 0.25,
                colors: const [AppColors.accentPrimary, AppColors.accentSecondary, AppColors.textPrimary],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  TextFormField _nameField() => TextFormField(
    controller: _name,
    style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary),
    decoration: const InputDecoration(labelText: AppStrings.contactNameLabel),
    validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.errNameRequired : null,
  );

  TextFormField _emailField() => TextFormField(
    controller: _email,
    keyboardType: TextInputType.emailAddress,
    style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary),
    decoration: const InputDecoration(labelText: AppStrings.contactEmailLabel),
    validator: (v) {
      if (v == null || v.trim().isEmpty) {
        return AppStrings.errEmailRequired;
      }
      return EmailService.isValidEmail(v.trim()) ? null : AppStrings.errEmailInvalid;
    },
  );

  Widget _directLinks(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppStrings.contactDirect.toUpperCase(), style: AppTypography.mono),
      const SizedBox(height: Spacing.md),
      const _DirectLink(label: AppStrings.email, url: 'mailto:${AppStrings.email}'),
      const SizedBox(height: Spacing.sm),
      Wrap(
        spacing: Spacing.lg,
        runSpacing: Spacing.sm,
        children: [for (final social in PortfolioData.socials) _DirectLink(label: social.label, url: social.url)],
      ),
    ],
  );
}

class _DirectLink extends StatefulWidget {
  const _DirectLink({required this.label, required this.url});

  final String label;
  final String url;

  @override
  State<_DirectLink> createState() => _DirectLinkState();
}

class _DirectLinkState extends State<_DirectLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => CursorTarget(
    child: MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: Semantics(
          link: true,
          label: widget.label,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: AppTypography.bodyM.copyWith(color: _hovered ? AppColors.textAccent : AppColors.textPrimary),
              ),
              AnimatedContainer(
                duration: AppDurations.fast,
                curve: AppCurves.enter,
                height: 1,
                width: _hovered ? 64 : 24,
                color: _hovered ? AppColors.accentPrimary : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Send button: label gains a sliding arrow on hover, swaps to a progress
/// state while sending.
class _SendButton extends StatefulWidget {
  const _SendButton({required this.submitting, required this.onTap});

  final bool submitting;
  final VoidCallback? onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => CursorTarget(
    child: MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: MagneticButton(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.enter,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xl, vertical: Spacing.md),
          decoration: BoxDecoration(
            color: widget.submitting
                ? AppColors.accentPrimary.withValues(alpha: 0.5)
                : _hovered
                ? AppColors.accentPrimary
                : AppColors.accentSubtle,
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(color: AppColors.accentPrimary),
            boxShadow: _hovered && !widget.submitting
                ? const [BoxShadow(color: AppColors.accentSubtle, blurRadius: 28, spreadRadius: 4)]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.submitting) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textOnAccent),
                ),
                const SizedBox(width: Spacing.sm),
              ],
              Text(
                widget.submitting ? AppStrings.contactSending : AppStrings.contactSend,
                style: AppTypography.titleS.copyWith(
                  fontSize: 15,
                  color: _hovered || widget.submitting ? AppColors.textOnAccent : AppColors.textAccent,
                ),
              ),
              AnimatedContainer(
                duration: AppDurations.fast,
                curve: AppCurves.enter,
                width: _hovered && !widget.submitting ? 26 : 0,
                child: ClipRect(
                  child: Icon(
                    LucideIcons.arrowRight,
                    size: 16,
                    color: _hovered ? AppColors.textOnAccent : AppColors.textAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
