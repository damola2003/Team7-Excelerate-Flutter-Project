import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? profileImage;
  final String role;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authProvider;
  final List<String> enrolledCourses;
  final List<String> completedLessons;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.profileImage,
    this.role = 'student',
    this.isEmailVerified = false,
    required this.createdAt,
    required this.updatedAt,
    required this.authProvider,
    this.enrolledCourses = const [],
    this.completedLessons = const [],
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'profileImage': profileImage ?? '',
      'role': role,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'authProvider': authProvider,
      'enrolledCourses': enrolledCourses,
      'completedLessons': completedLessons,
    };
  }

  // Create from Firestore Document
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      profileImage: map['profileImage'],
      role: map['role'] ?? 'student',
      isEmailVerified: map['isEmailVerified'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      authProvider: map['authProvider'] ?? 'email',
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      completedLessons: List<String>.from(map['completedLessons'] ?? []),
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? profileImage,
    String? role,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authProvider,
    List<String>? enrolledCourses,
    List<String>? completedLessons,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authProvider: authProvider ?? this.authProvider,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }
}