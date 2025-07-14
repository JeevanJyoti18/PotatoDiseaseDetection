import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PotatoDiseaseApp());
}

class PotatoDiseaseApp extends StatelessWidget {
  const PotatoDiseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Disease Detection',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFbe6a77),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFbe6a77),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const PotatoDiseaseDetector(),
    );
  }
} 