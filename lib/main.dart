import 'package:excelerate/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Sphere',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
