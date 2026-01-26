

import 'package:excelerate/login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _buildSkipButton(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildOnboardingPage(
                      image: "assets/images/plant.png" ,
                      title: "Learn Anytime,",
                      highlighted: "Anywhere",
                      description:
                          "Access world-class courses and expert-led programs from the palm of your hand.",
                    ),
                    _buildOnboardingPage(
                      image: "assets/images/study.png",
                      title: "Build Skills,",
                      highlighted: "Grow Faster",
                      description:
                          "Learn practical skills that help you grow personally and professionally.",
                    ),
                    _buildOnboardingPage(
                      image: "assets/images/community.png",
                      title: "Join a",
                      highlighted: "Community",
                      description:
                          "Connect with learners and experts from around the world.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              _buildIndicators(),
              const SizedBox(height: 14),
              _buildBottomButton(context),
              const SizedBox(height: 54),
            ],
          ),
        ),
      ),
    );
  }

  /// SKIP BUTTON
  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _pageController.jumpToPage(2);
        },
        child: const Text(
          "Skip",
          style: TextStyle(
            color: Color(0xFF007A8A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// ONBOARDING PAGE BUILDER
  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String highlighted,
    required String description,
  }) {
    return Column(
      children: [
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 180,
            width: 180,
            color: const Color(0xFFE7E3D8),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1C),
            ),
            children: [
              TextSpan(text: "$title\n"),
              TextSpan(
                text: highlighted,
                style: const TextStyle(color: Color(0xFF007A8A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6E6E6E),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: _currentPage == index ? 24 : 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF007A8A)
                : const Color(0xFFBFDCDC),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  
  Widget _buildBottomButton(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage == 2) {
            // Navigate to login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
        
          backgroundColor: const Color(0xFF007A8A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _currentPage == 2 ? "Get Started" : "Next",
          style: const TextStyle(
            fontSize: 18,
            color: const Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
