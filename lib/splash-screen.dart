import 'package:excelerate/Onboarding-screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  late Timer _timer;
  @override
  void initState() {
    super.initState();

    // Timer updates progress
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.01; // increase by 1%
      });

      if (_progress >= 1.0) {
        _timer.cancel();
        // Navigate to next screen when progress reaches 100%
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }
@override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0EDF0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:Icon(Icons.school,
                        size: 40,
                        color: Color(0xFF007A8A),
                        ) ,
                        
            ),
            const SizedBox(height: 20,),
            const Text("Learn Sphere",
             style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: -1
             ),),
             const Text("EMPOWER YOUR MIND",
             style:TextStyle(
              fontSize: 14,
              color: Color(0xFF007A8A),
             )),
             const SizedBox(height: 70),
  
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      const Text(
                        "Initializing Core Modules...",
                        style: TextStyle(
                          color: Color.fromARGB(255, 91, 90, 90),
                          fontSize: 18,
                        ),
                      ),
                  const SizedBox(width: 78),
                    Text(
                      "${(_progress * 100).toInt()}%",
                      style: const TextStyle(
                        color: Color(0xFF007A8A),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
             const SizedBox(height: 12),
            SizedBox(
              width: 520,
             child: ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: LinearProgressIndicator(
                value: _progress,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42A5F5)),
                minHeight: 8,
              
                
              ),
             ),
        ),
             const SizedBox(height: 32),
             const Text("VERSION  2.4.0 • SECURED BY KNOWLEDGE",
             style: TextStyle(color: Colors.grey),)
          
          ],
        ),
      ),
    );
  }
}