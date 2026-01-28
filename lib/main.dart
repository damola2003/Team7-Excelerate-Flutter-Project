import 'package:excelerate/onboarding_screen.dart';
import 'package:excelerate/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:excelerate/home_page.dart';
// import 'package:excelerate/forgot_password_page.dart';
// import 'package:excelerate/signup_page.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {'/onboarding': (context) => const OnboardingScreen()},
    );
  }
}
