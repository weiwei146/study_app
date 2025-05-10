import 'package:flutter/material.dart';
import 'package:study_app/view/HomeScreen.dart';
import 'package:study_app/view/LoginScreen.dart';
import 'package:study_app/view/Navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLogin
          ? const Navigation(initialIndex: 0)
          : const LoginScreen(),
    );
  }
}
