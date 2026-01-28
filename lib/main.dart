import 'package:excelerate/login_page.dart';
import 'package:flutter/material.dart';
import 'package:excelerate/home_page.dart';
import 'package:excelerate/forgot_password_page.dart';
import 'package:excelerate/signup_page.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Sphere',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      // Define routes for navigation
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
