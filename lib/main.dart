import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/navigation/presentation/screens/main_navigation_screen.dart';

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
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
