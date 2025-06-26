import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polymorphism/shell/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const AppShell());
}
