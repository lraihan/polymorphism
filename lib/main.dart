import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polymorphism/core/router/app_router.dart';
import 'package:polymorphism/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const PolymorphismApp());
}

class PolymorphismApp extends StatelessWidget {
  const PolymorphismApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Polymorphism',
    theme: AppTheme.darkTheme,
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouter.instance,
  );
}
