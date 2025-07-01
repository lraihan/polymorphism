import 'package:flutter/material.dart';
import 'package:polymorphism/modules/playground/playground_shell.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key, this.demo, this.category});

  final String? demo;
  final String? category;

  @override
  Widget build(BuildContext context) => const PlaygroundShell();
}
