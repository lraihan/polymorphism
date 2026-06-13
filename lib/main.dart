import 'package:flutter/material.dart';
import 'package:polymorphism/core/constants/strings.dart';
import 'package:polymorphism/core/router/app_router.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PolymorphismApp());
}

/// "Precision in Motion" — Raihan's portfolio.
class PolymorphismApp extends StatelessWidget {
  const PolymorphismApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: AppStrings.siteTitle,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    routerConfig: AppRouter.router,
  );
}
