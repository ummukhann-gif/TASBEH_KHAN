import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const TerraTasbihApp());
}

class TerraTasbihApp extends StatelessWidget {
  const TerraTasbihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terra Tasbih',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
