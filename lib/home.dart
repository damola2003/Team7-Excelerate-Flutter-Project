import 'package:excelerate/screens/learner/program_listing_screen.dart';
import 'package:flutter/material.dart';

import 'screens/learner/program_details_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEEEEE),
        title: const Text(
          'LearnSphere',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.notifications_outlined),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Welcome Text
            const Text(
              'Welcome back 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Continue your learning journey',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// Progress Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Your Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 8,
                    backgroundColor: Colors.grey,
                    color: Color(0xFF4F8EF7),
                  ),
                  SizedBox(height: 8),
                  Text('60% completed'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Courses Title
            const Text(
              'My Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// Course Cards
            Expanded(
              child: ListView(
                children: const [
                  CourseCard(
                    title: 'Flutter for Beginners',
                    subtitle: 'Build modern apps',
                  ),
                  CourseCard(
                    title: 'Data Structures',
                    subtitle: 'Master DSA fundamentals',
                  ),
                  CourseCard(
                    title: 'AI & Machine Learning',
                    subtitle: 'Start your AI journey',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ProgramBasic? programId;

  const CourseCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.programId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Handle course card tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProgramDetailsScreen(programId: programId?.id ?? ''),
            ),
          );
        },
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.play_circle_fill,
                color: Color(0xFF4F8EF7),
                size: 36,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // These are the different contents for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const ProgramListingScreen(),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFEEEEEE),
        selectedItemColor: const Color(0xFF4F8EF7),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
