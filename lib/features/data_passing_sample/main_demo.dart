import 'package:flutter/material.dart';

import 'presentation/screens/friends_list_screen.dart';

/// Demo entry point for the data passing sample
/// Run this file to test the data passing functionality independently
void main() {
  runApp(const DataPassingDemoApp());
}

class DataPassingDemoApp extends StatelessWidget {
  const DataPassingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Passing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const FriendsListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
