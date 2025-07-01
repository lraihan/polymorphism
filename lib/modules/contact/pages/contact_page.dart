import 'package:flutter/material.dart';
import '../contact_section.dart';
import '../../../shared/page_scaffold.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, this.subject, this.message});

  final String? subject;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      body: SingleChildScrollView(
        child: ContactSection(),
      ),
    );
  }
}
