import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.system, // Automatically switch between light and dark
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
