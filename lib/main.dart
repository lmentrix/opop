import 'package:flutter/material.dart';
import 'package:opop/core/routes/app_router.dart';
import 'package:opop/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:opop/features/discovery/provider/discovery_provider.dart';
import 'package:opop/features/profile/presentation/screens/profile_provider.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => ChatListProvider()),
        ChangeNotifierProvider(create: (context) => DiscoveryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Use MaterialApp.router for GoRouter
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router, // Only use routerConfig
      // Remove 'home' property when using GoRouter
    );
  }
}
