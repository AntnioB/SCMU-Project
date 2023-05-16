import 'package:flutter/material.dart';
import 'package:range_mate_app/Screens/Login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ranged Mate',
      theme: ThemeData(
        primaryColor: const Color(0xFF8FD5A6),
        scaffoldBackgroundColor: const Color(0xFF0C8346),
      ),
      home: const LoginScreen(),
    );
  }
}
