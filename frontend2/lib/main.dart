import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Access the backend URL from --dart-define=API_URL=...
  const String backendUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

  runApp(PotatoDiseaseApp(apiUrl: backendUrl));
}

class PotatoDiseaseApp extends StatelessWidget {
  final String apiUrl;

  const PotatoDiseaseApp({super.key, required this.apiUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Disease Detection',
      debugShowCheckedModeBanner: false,
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
      home: PotatoDiseaseDetector(apiUrl: apiUrl), // ✅ Pass to screen
    );
  }
}
