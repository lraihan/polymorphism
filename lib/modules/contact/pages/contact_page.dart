import 'package:flutter/material.dart';
import 'package:polymorphism/modules/contact/contact_section.dart';
import 'package:polymorphism/shared/page_scaffold.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, this.subject, this.message});

  final String? subject;
  final String? message;

  @override
  Widget build(BuildContext context) => const PageScaffold(body: SingleChildScrollView(child: ContactSection()));
}
