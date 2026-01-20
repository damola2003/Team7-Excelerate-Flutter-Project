import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/module.dart';
import '../models/lesson.dart';
import '../models/assignment.dart';
import '../models/discussion_thread.dart';

class ProgramService {
  static const String baseUrl = 'https://your-api-url.com/api';

  static Future<Map<String, dynamic>> getProgramDetails(
    String programId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/programs/$programId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load program details');
      }
    } catch (e) {
      return _getMockProgramData(programId);
    }
  }

  static Future<List<Module>> getModules(String programId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/programs/$programId/modules'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Module.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      return _getMockModules();
    }
  }

  static Future<List<Assignment>> getAssignments(String programId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/programs/$programId/assignments'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Assignment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load assignments');
      }
    } catch (e) {
      return _getMockAssignments();
    }
  }

  static Future<List<DiscussionThread>> getDiscussions(String programId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/programs/$programId/discussions'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DiscussionThread.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load discussions');
      }
    } catch (e) {
      return _getMockDiscussions();
    }
  }

  static Future<bool> submitAssignment(
    String assignmentId,
    String filePath,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> toggleLessonCompletion(
    String lessonId,
    bool isCompleted,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Mock Data
  static Map<String, dynamic> _getMockProgramData(String programId) {
    return {
      'id': programId,
      'title': 'Introduction to Flutter',
      'description':
          'Learn the basics of Flutter development and build beautiful cross-platform apps from scratch.',
      'instructor': 'Dr. Sarah Chen',
      'instructorBio': 'Senior Mobile Developer with 10+ years of experience',
      'instructorImageUrl': 'https://picsum.photos/seed/instructor/200',
      'thumbnailUrl': 'https://picsum.photos/seed/flutter/800/400',
      'category': 'Mobile Development',
      'difficulty': 'Beginner',
      'duration': '8 weeks',
      'schedule': 'Self-paced',
      'progress': 0.65,
      'isEnrolled': true,
      'learningObjectives': [
        'Understand Flutter architecture and widget tree',
        'Build responsive UIs with Flutter widgets',
        'Manage app state effectively',
        'Integrate with REST APIs and Firebase',
        'Deploy apps to iOS and Android',
      ],
    };
  }

  static List<Module> _getMockModules() {
    return [
      Module(
        id: 'm1',
        title: 'Module 1: Getting Started',
        lessons: [
          Lesson(
            id: 'l1',
            title: 'Introduction to Flutter',
            type: 'video',
            duration: '15 min',
            isCompleted: true,
          ),
          Lesson(
            id: 'l2',
            title: 'Setting up Development Environment',
            type: 'pdf',
            duration: '20 min',
            isCompleted: true,
          ),
          Lesson(
            id: 'l3',
            title: 'Quiz: Flutter Basics',
            type: 'quiz',
            duration: '10 min',
            isCompleted: false,
          ),
        ],
      ),
      Module(
        id: 'm2',
        title: 'Module 2: Widgets and Layouts',
        lessons: [
          Lesson(
            id: 'l4',
            title: 'Understanding Widgets',
            type: 'video',
            duration: '25 min',
            isCompleted: false,
          ),
          Lesson(
            id: 'l5',
            title: 'Layout Widgets',
            type: 'video',
            duration: '30 min',
            isCompleted: false,
          ),
        ],
      ),
    ];
  }

  static List<Assignment> _getMockAssignments() {
    return [
      Assignment(
        id: 'a1',
        title: 'Build a Counter App',
        description: 'Create a simple counter application using StatefulWidget',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        status: 'Pending',
        maxScore: 100,
      ),
      Assignment(
        id: 'a2',
        title: 'Layout Challenge',
        description: 'Recreate the provided UI design using Flutter widgets',
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Submitted',
        maxScore: 100,
      ),
      Assignment(
        id: 'a3',
        title: 'State Management Exercise',
        description: 'Implement state management in a todo list app',
        dueDate: DateTime.now().subtract(const Duration(days: 10)),
        status: 'Graded',
        score: 85,
        maxScore: 100,
      ),
    ];
  }

  static List<DiscussionThread> _getMockDiscussions() {
    return [
      DiscussionThread(
        id: 'd1',
        author: 'John Doe',
        authorRole: 'Student',
        question:
            'What is the difference between StatelessWidget and StatefulWidget?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        replies: 5,
        hasInstructorReply: true,
      ),
      DiscussionThread(
        id: 'd2',
        author: 'Jane Smith',
        authorRole: 'Student',
        question: 'How do I handle navigation between screens?',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        replies: 3,
        hasInstructorReply: false,
      ),
    ];
  }
}
