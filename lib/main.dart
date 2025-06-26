import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_master_template/app/core/navigation/app_router.dart';
import 'package:project_master_template/app/core/services/dependency_injection.dart';
import 'package:project_master_template/app/core/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      title: 'Project Master Template',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
}
