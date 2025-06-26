import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polymorphism/core/router/app_router.dart';

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
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouter.instance,
  );
}
